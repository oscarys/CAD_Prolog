"""
conftest.py
-----------
Pytest configuration for the CAD project.

Creates the flask_session/ directory that Flask-Session needs
so tests don't fail with a FileNotFoundError on first run.
"""

import os
import pytest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))


def pytest_configure(config):
    """Create directories needed by the application before any tests run."""
    session_dir = os.path.join(REPO_ROOT, "frontend", "flask_session")
    os.makedirs(session_dir, exist_ok=True)
