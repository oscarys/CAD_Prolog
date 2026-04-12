"""
session.py
----------
Manages per-request patient session state across the four exam-script phases.

Phase 1  -  Demographics   → age, sex, presentation
Phase 2  -  History        → symptom answers
Phase 3  -  Examination    → examination findings
Phase 4  -  (computed)     → diagnoses + proof traces returned by bridge

The session dict is stored in Flask's server-side session (filesystem or
Redis backend). This module provides a clean interface so app.py never
touches the raw dict directly.
"""

from flask import session


# ── Initialisation ────────────────────────────────────────────────────────────

def init_session():
    """Create a fresh empty session. Call at the start of a new consultation."""
    session["presentation"] = None
    session["age"] = None
    session["sex"] = None
    session["symptoms"] = {}
    session["findings"] = {}
    session["phase"] = 1               # which phase the user is currently on
    session["history_index"] = 0       # index into the current question list
    session["exam_index"] = 0


def clear_session():
    """Wipe all session data (e.g. on restart or logout)."""
    session.clear()


# ── Getters ───────────────────────────────────────────────────────────────────

def get_presentation() -> str | None:
    return session.get("presentation")

def get_phase() -> int:
    return session.get("phase", 1)

def get_history_index() -> int:
    return session.get("history_index", 0)

def get_exam_index() -> int:
    return session.get("exam_index", 0)

def get_full_session() -> dict:
    """Return the session dict as expected by CADBridge.query()."""
    return {
        "presentation": session.get("presentation"),
        "age":          session.get("age"),
        "sex":          session.get("sex"),
        "symptoms":     session.get("symptoms", {}),
        "findings":     session.get("findings", {}),
    }


# ── Setters ───────────────────────────────────────────────────────────────────

def set_demographics(presentation: str, age: int, sex: str):
    session["presentation"] = presentation
    session["age"] = age
    session["sex"] = sex
    session["phase"] = 2
    session["history_index"] = 0

def record_symptom(name: str, value):
    """Record one symptom answer and advance the history index."""
    session["symptoms"][name] = value
    session["history_index"] = session.get("history_index", 0) + 1

def record_finding(name: str, value):
    """Record one examination finding and advance the exam index."""
    session["findings"][name] = value
    session["exam_index"] = session.get("exam_index", 0) + 1

def advance_to_examination():
    session["phase"] = 3
    session["exam_index"] = 0

def advance_to_results():
    session["phase"] = 4
