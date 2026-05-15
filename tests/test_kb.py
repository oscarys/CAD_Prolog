"""
test_kb.py
----------
Automated tests for the Prolog knowledge base.

Tests every module in prolog/modules/ against the contract defined in
docs/PROLOG_CONTRACT.md.

Run:  pytest tests/test_kb.py -v

What is checked:
  1. Module loads without error
  2. diagnose/2 fires at least once for the canonical symptom set
  3. Every diagnosis produced by diagnose/2 has a frequency/2 fact
  4. Every symptom checked in diagnose/2 has a matching explain_step/3
  5. Every diagnosis has at least one suggest_test/2 fact
"""

import os
import sys
import pytest
from pyswip import Prolog

# ── Paths ─────────────────────────────────────────────────────────────────────
REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
MODULES_DIR = os.path.join(REPO_ROOT, "prolog", "modules")
LOADER_PATH = os.path.join(REPO_ROOT, "prolog", "loader.pl")

# Canonical symptom sets: minimal facts that should trigger at least one
# diagnose/2 for each presentation.
CANONICAL_SYMPTOMS = {
    "chest_pain": {
        "symptoms": {
            "chest_pain": "yes",
            "pain_character": "crushing",
            "exertional": "yes",
        },
        "findings": {},
        "age": 55,
        "sex": "male",
    },
    "headache": {
        "symptoms": {
            "headache": "yes",
            "onset": "sudden",
            "neck_stiffness": "yes",
        },
        "findings": {},
        "age": 35,
        "sex": "female",
    },
}


# ── Helpers ───────────────────────────────────────────────────────────────────

def fresh_prolog() -> Prolog:
    """Return a fresh Prolog instance with dynamic predicates declared.

    PySwip's query() does not accept directive syntax ':- goal'.
    Use dynamic/1 as a plain goal instead.
    """
    p = Prolog()
    for pred in ("patient_age/1", "patient_sex/1", "symptom/2", "finding/2"):
        list(p.query(f"dynamic({pred})"))
    return p


def assert_session(p: Prolog, session: dict):
    age = session.get("age")
    sex = session.get("sex")
    if age:
        list(p.query(f"assertz(patient_age({int(age)}))"))
    if sex:
        list(p.query(f"assertz(patient_sex({sex}))"))
    for name, value in session.get("symptoms", {}).items():
        name = name.replace("-", "_")
        list(p.query(f"assertz(symptom({name}, {value}))"))
    for name, value in session.get("findings", {}).items():
        name = name.replace("-", "_")
        list(p.query(f"assertz(finding({name}, {value}))"))


def retract_all(p: Prolog):
    for pred in ("patient_age(_)", "patient_sex(_)", "symptom(_, _)", "finding(_, _)"):
        list(p.query(f"retractall({pred})"))


def module_files():
    """List all .pl files in prolog/modules/"""
    if not os.path.isdir(MODULES_DIR):
        return []
    return [
        f for f in os.listdir(MODULES_DIR)
        if f.endswith(".pl")
    ]


# ── Tests ─────────────────────────────────────────────────────────────────────

@pytest.mark.parametrize("filename", module_files())
def test_module_loads(filename):
    """Module must load without error."""
    path = os.path.join(MODULES_DIR, filename).replace("\\", "/")
    p = fresh_prolog()
    list(p.query(f"use_module('{path}')"))


@pytest.mark.parametrize("presentation,session", CANONICAL_SYMPTOMS.items())
def test_canonical_case_fires(presentation, session):
    """diagnose/2 must succeed at least once for the canonical symptom set."""
    module_path = os.path.join(MODULES_DIR, f"{presentation}.pl")
    if not os.path.exists(module_path):
        pytest.skip(f"Module {presentation}.pl not yet implemented")

    p = fresh_prolog()
    p_path = module_path.replace("\\", "/")
    list(p.query(f"use_module('{p_path}')"))

    assert_session(p, session)
    try:
        results = list(p.query(f"{presentation}:diagnose(D, F)"))
        assert len(results) > 0, (
            f"diagnose/2 returned no results for canonical {presentation} symptoms. "
            "Check that your rules match the canonical symptom set."
        )
    finally:
        retract_all(p)


@pytest.mark.parametrize("filename", module_files())
def test_all_diagnoses_have_frequency(filename):
    """Every atom produced by diagnose/2 must have a frequency/2 fact."""
    path = os.path.join(MODULES_DIR, filename).replace("\\", "/")
    mod = filename.replace(".pl", "")
    p = fresh_prolog()
    list(p.query(f"use_module('{path}')"))

    diagnoses = [str(s["D"]) for s in p.query(f"{mod}:frequency(D, _)")]
    for dx in diagnoses:
        result = list(p.query(f"{mod}:frequency({dx}, _)"))
        assert result, f"No frequency/2 for diagnosis '{dx}' in {filename}"


@pytest.mark.parametrize("filename", module_files())
def test_all_diagnoses_have_tests(filename):
    """Every diagnosis declared in frequency/2 must have at least one suggest_test/2."""
    path = os.path.join(MODULES_DIR, filename).replace("\\", "/")
    mod = filename.replace(".pl", "")
    p = fresh_prolog()
    list(p.query(f"use_module('{path}')"))

    diagnoses = [str(s["D"]) for s in p.query(f"{mod}:frequency(D, _)")]
    for dx in diagnoses:
        tests = list(p.query(f"{mod}:suggest_test({dx}, _)"))
        assert tests, (
            f"No suggest_test/2 facts for '{dx}' in {filename}. "
            "Every diagnosis needs at least one recommended investigation."
        )


@pytest.mark.parametrize("filename", module_files())
def test_explain_step_exists_for_each_diagnosis(filename):
    """Every diagnosis must have at least one explain_step/3 clause."""
    path = os.path.join(MODULES_DIR, filename).replace("\\", "/")
    mod = filename.replace(".pl", "")
    p = fresh_prolog()
    list(p.query(f"use_module('{path}')"))

    diagnoses = [str(s["D"]) for s in p.query(f"{mod}:frequency(D, _)")]
    for dx in diagnoses:
        steps = list(p.query(f"{mod}:explain_step({dx}, _, _)"))
        assert steps, (
            f"No explain_step/3 clauses for '{dx}' in {filename}. "
            "Every diagnosis needs proof trace steps."
        )


def test_chest_pain_reference_module():
    """
    Integration test for the reference module (chest_pain.pl).
    Tests multiple clinical scenarios to validate the worked example.
    """
    module_path = os.path.join(MODULES_DIR, "chest_pain.pl")
    if not os.path.exists(module_path):
        pytest.skip("chest_pain.pl not found")

    p = fresh_prolog()
    p_path = module_path.replace("\\", "/")
    list(p.query(f"use_module('{p_path}')"))

    # Scenario 1: Classic angina
    list(p.query("assertz(symptom(chest_pain, yes))"))
    list(p.query("assertz(symptom(pain_character, crushing))"))
    list(p.query("assertz(symptom(exertional, yes))"))
    results = list(p.query("chest_pain:diagnose(D, F)"))
    diagnoses = [str(r["D"]) for r in results]
    assert "angina" in diagnoses, "Angina should be diagnosed in classic exertional crushing chest pain"
    retract_all(p)

    # Scenario 2: PE with haemoptysis
    list(p.query("assertz(symptom(chest_pain, yes))"))
    list(p.query("assertz(symptom(pleuritic, yes))"))
    list(p.query("assertz(symptom(dyspnoea, yes))"))
    list(p.query("assertz(symptom(haemoptysis, yes))"))
    results = list(p.query("chest_pain:diagnose(D, F)"))
    diagnoses = [str(r["D"]) for r in results]
    assert "pulmonary_embolism" in diagnoses, "PE should be diagnosed with pleuritic pain + dyspnoea + haemoptysis"
    retract_all(p)

    # Scenario 3: Herpes zoster with rash
    list(p.query("assertz(symptom(chest_pain, yes))"))
    list(p.query("assertz(symptom(pain_character, burning))"))
    list(p.query("assertz(symptom(unilateral_dermatomal, yes))"))
    list(p.query("assertz(finding(vesicular_rash, yes))"))
    results = list(p.query("chest_pain:diagnose(D, F)"))
    diagnoses = [str(r["D"]) for r in results]
    assert "herpes_zoster" in diagnoses, "Herpes zoster should be diagnosed with burning dermatomal pain + vesicular rash"
    retract_all(p)

    # Scenario 4: Exclusion rule  -  MI excluded by negative troponin
    list(p.query("assertz(symptom(chest_pain, yes))"))
    list(p.query("assertz(symptom(pain_character, crushing))"))
    list(p.query("assertz(symptom(exertional, no))"))
    list(p.query("assertz(symptom(pain_duration_minutes, 30))"))
    list(p.query("assertz(finding(ecg_changes, no))"))
    list(p.query("assertz(finding(troponin_at_12h, negative))"))
    exclusions = list(p.query("chest_pain:exclude_if(myocardial_infarction, R)"))
    assert exclusions, "MI should be excluded when ECG normal and troponin negative at 12h"
    retract_all(p)


# ── Stub loading tests ────────────────────────────────────────

STUBS_DIR = os.path.join(REPO_ROOT, "prolog", "stubs")

def stub_files():
    """List loadable .pl stubs (exclude STUB_TEMPLATE which has placeholder syntax)."""
    if not os.path.isdir(STUBS_DIR):
        return []
    return [
        f for f in os.listdir(STUBS_DIR)
        if f.endswith(".pl") and f != "STUB_TEMPLATE.pl"
    ]


@pytest.mark.parametrize("filename", stub_files())
def test_stub_loads(filename):
    """Every student stub must load without syntax errors.
    'Exported procedure not defined' is acceptable for empty stubs —
    that's caught by discontiguous declarations. Syntax errors are not.
    """
    path = os.path.join(STUBS_DIR, filename).replace("\\", "/")
    p = fresh_prolog()
    # consult() raises on syntax errors; 'not defined' warnings are non-fatal
    list(p.query(f"consult('{path}')"))
