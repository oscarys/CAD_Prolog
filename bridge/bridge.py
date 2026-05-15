"""
bridge.py
---------
PySwip interface between the Flask application and the Prolog knowledge base.

Responsibilities:
  - Load the Prolog KB once at startup (consult loader.pl)
  - Assert patient facts before each query
  - Collect diagnoses, proof traces, and investigations
  - Sort results by frequency (common → occasional → rare)
  - Retract all asserted facts after each query (keep KB stateless)
  - Surface detailed errors when Prolog rules have problems

Usage:
    from bridge import CADBridge
    bridge = CADBridge()                        # loads KB
    results = bridge.query(session_data)        # returns list of Result dicts
"""

import os
import threading
from dataclasses import dataclass, field
from typing import Optional
from pyswip import Prolog

# Frequency sort order: common diagnoses surface first
_FREQUENCY_ORDER = {"common": 0, "occasional": 1, "rare": 2}

# Path to the Prolog loader relative to this file
_LOADER_PATH = os.path.join(
    os.path.dirname(__file__), "..", "prolog", "loader.pl"
)


@dataclass
class ProofStep:
    """One step in the proof trace for a diagnosis."""
    symptom: str          # e.g. "chest_pain"
    rationale: str        # e.g. "Crushing chest pain is the hallmark..."


@dataclass
class DiagnosisResult:
    """All information for one differential diagnosis."""
    name: str                           # e.g. "myocardial_infarction"
    display_name: str                   # e.g. "Myocardial infarction"
    frequency: str                      # "common" | "occasional" | "rare"
    module: str = "chest_pain"          # Prolog module that produced this result
    proof: list[ProofStep] = field(default_factory=list)
    tests: list[str] = field(default_factory=list)
    excluded: bool = False
    exclusion_reason: Optional[str] = None


class BridgeError(Exception):
    """Raised when Prolog query fails unexpectedly."""
    pass


class CADBridge:
    """
    Thread-safe interface to the Prolog CAD knowledge base.

    PySwip wraps SWI-Prolog's C library, which is not thread-safe.
    We use a single lock around every Prolog operation.
    """

    def __init__(self):
        self._prolog = Prolog()
        self._lock = threading.Lock()
        self._load_kb()

    def _load_kb(self):
        """Consult the Prolog loader. Called once at startup."""
        loader = os.path.abspath(_LOADER_PATH)
        if not os.path.exists(loader):
            raise FileNotFoundError(
                f"Prolog loader not found at {loader}. "
                "Check that prolog/loader.pl exists."
            )
        with self._lock:
            list(self._prolog.query(f"consult('{loader}')"))

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def query(self, session: dict) -> list[DiagnosisResult]:
        """
        Run a full diagnostic query for the given session data.

        Parameters
        ----------
        session : dict
            {
              "presentation": "chest_pain",
              "age": 58,
              "sex": "male",
              "symptoms": {"chest_pain": "yes", "exertional": "yes", ...},
              "findings": {"ecg_changes": "yes", ...}
            }

        Returns
        -------
        list[DiagnosisResult]
            Sorted: common first, then occasional, then rare.
            Each result has proof steps and suggested tests attached.
        """
        with self._lock:
            try:
                module = session.get("presentation", "chest_pain")
                self._assert_facts(session)
                diagnoses = self._collect_diagnoses(module)
                diagnoses = self._apply_exclusions(diagnoses)
                for dx in diagnoses:
                    dx.proof = self._collect_proof(dx.name, dx.module)
                    dx.tests = self._collect_tests(dx.name, dx.module)
                return sorted(
                    diagnoses,
                    key=lambda d: _FREQUENCY_ORDER.get(d.frequency, 99)
                )
            finally:
                self._retract_facts()

    # ------------------------------------------------------------------
    # Internal: fact lifecycle
    # ------------------------------------------------------------------

    def _assert_facts(self, session: dict):
        """Assert all patient facts into the dynamic Prolog database."""
        age = session.get("age")
        sex = session.get("sex")
        if age is not None:
            list(self._prolog.query(f"assertz(patient_age({int(age)}))"))
        if sex is not None:
            list(self._prolog.query(f"assertz(patient_sex({sex}))"))

        for name, value in session.get("symptoms", {}).items():
            name_clean = _atom(name)
            value_clean = _atom_or_number(value)
            list(self._prolog.query(
                f"assertz(symptom({name_clean}, {value_clean}))"
            ))

        for name, value in session.get("findings", {}).items():
            name_clean = _atom(name)
            value_clean = _atom_or_number(value)
            list(self._prolog.query(
                f"assertz(finding({name_clean}, {value_clean}))"
            ))

    def _retract_facts(self):
        """Retract all dynamically asserted patient facts."""
        for pred in ("patient_age(_)", "patient_sex(_)",
                     "symptom(_, _)", "finding(_, _)"):
            try:
                list(self._prolog.query(f"retractall({pred})"))
            except Exception:
                pass  # retractall never fails

    # ------------------------------------------------------------------
    # Internal: queries
    # ------------------------------------------------------------------

    def _collect_diagnoses(self, module: str) -> list[DiagnosisResult]:
        """Run diagnose/2 and return all solutions."""
        results = []
        seen = set()
        try:
            for sol in self._prolog.query(f"{module}:diagnose(D, F)"):
                name = str(sol["D"])
                freq = str(sol["F"])
                if name not in seen:
                    seen.add(name)
                    results.append(DiagnosisResult(
                        name=name,
                        display_name=_display_name(name),
                        frequency=freq,
                        module=module,
                    ))
        except Exception as e:
            raise BridgeError(f"diagnose/2 query failed: {e}") from e
        return results

    def _apply_exclusions(
        self, diagnoses: list[DiagnosisResult]
    ) -> list[DiagnosisResult]:
        """
        Check exclude_if/2 for each diagnosis.
        Excluded diagnoses are kept in the list but flagged,
        so the UI can show them with a strikethrough and the reason.
        """
        for dx in diagnoses:
            try:
                solutions = list(self._prolog.query(
                    f"{dx.module}:exclude_if({dx.name}, Reason)"
                ))
                if solutions:
                    dx.excluded = True
                    dx.exclusion_reason = str(solutions[0]["Reason"])
            except Exception:
                pass  # exclude_if is optional; if it errors, skip
        return diagnoses

    def _collect_proof(self, diagnosis: str, module: str) -> list[ProofStep]:
        """Collect all explain_step/3 results for a diagnosis."""
        steps = []
        seen_symptoms = set()
        try:
            for sol in self._prolog.query(
                f"{module}:explain_step({diagnosis}, S, R)"
            ):
                symptom = str(sol["S"])
                rationale = str(sol["R"])
                if symptom not in seen_symptoms:
                    seen_symptoms.add(symptom)
                    steps.append(ProofStep(
                        symptom=_display_name(symptom),
                        rationale=rationale,
                    ))
        except Exception as e:
            raise BridgeError(
                f"explain_step/3 query failed for {diagnosis}: {e}"
            ) from e
        return steps

    def _collect_tests(self, diagnosis: str, module: str) -> list[str]:
        """Collect all suggest_test/2 results for a diagnosis."""
        tests = []
        try:
            for sol in self._prolog.query(f"{module}:suggest_test({diagnosis}, T)"):
                tests.append(_display_name(str(sol["T"])))
        except Exception:
            pass
        return tests


# ------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------

def _atom(s: str) -> str:
    """
    Make a safe Prolog atom from a Python string.
    Lowercase, underscores for spaces. Quoted if needed.
    """
    s = str(s).strip().lower().replace(" ", "_").replace("-", "_")
    # Quote if starts with uppercase or contains special chars
    if not s or not s[0].isalpha() and s[0] != "_":
        return f"'{s}'"
    return s


def _atom_or_number(v) -> str:
    """Return a Prolog integer if v is numeric, else an atom."""
    try:
        return str(int(v))
    except (ValueError, TypeError):
        try:
            return str(float(v))
        except (ValueError, TypeError):
            return _atom(str(v))


def _display_name(atom: str) -> str:
    """Convert a Prolog atom to a human-readable display string."""
    return atom.replace("_", " ").capitalize()
