import sys
import os

# ── Paths must be set BEFORE any imports ─────────────────────────────────────
project_home = '/home/oyanez/CAD_Prolog'
frontend_dir  = '/home/oyanez/CAD_Prolog/frontend'
venv_site     = '/home/oyanez/CAD_Prolog/venv/lib/python3.12/site-packages'

for p in (venv_site, project_home, frontend_dir):
    if p not in sys.path:
        sys.path.insert(0, p)

# ── SWI-Prolog ────────────────────────────────────────────────────────────────
_swipl_lib = '/home/oyanez/swipl-install/lib/swipl/lib/x86_64-linux'
os.environ['LIBSWIPL_PATH'] = _swipl_lib + '/libswipl.so'
os.environ['LD_LIBRARY_PATH'] = _swipl_lib
os.environ['SWI_HOME_DIR']    = '/home/oyanez/swipl-install/lib/swipl'

# ── Flask session ─────────────────────────────────────────────────────────────
_session_dir = '/tmp/flask_session_oyanez'
os.makedirs(_session_dir, exist_ok=True)
os.environ['FLASK_SESSION_DIR'] = _session_dir

# ── Secret key ────────────────────────────────────────────────────────────────
os.environ['SECRET_KEY'] = 'ca0fd8f866f9583f934b8aad54079ae3715b818e239ab2153c8a494ab005404a'

# ── Import ────────────────────────────────────────────────────────────────────
# frontend_dir is on sys.path so app.py is importable as 'app'
import importlib.util, types

spec = importlib.util.spec_from_file_location(
    'app', '/home/oyanez/CAD_Prolog/frontend/app.py'
)
mod = importlib.util.module_from_spec(spec)
sys.modules['app'] = mod
spec.loader.exec_module(mod)
application = mod.app
