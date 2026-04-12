"""
app.py
------
Flask application for the CAD exam-script system.

Routes:
  GET  /                     → presentation selection (intake Phase 1)
  POST /intake               → save demographics, redirect to history
  GET  /history              → display next history question (Phase 2)
  POST /history              → save answer, advance or move to examination
  GET  /examination          → display next examination question (Phase 3)
  POST /examination          → save finding, advance or move to results
  GET  /results              → run Prolog query, display diagnoses (Phase 4)
  POST /restart              → clear session, back to start

The question definitions (HISTORY_QUESTIONS and EXAM_QUESTIONS) encode
Churchill's exam script for each presentation. These are the hooks
students connect their Prolog rules to  -  atom names here must match
the symptom/2 and finding/2 atoms in the .pl files.
"""

import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from flask import Flask, render_template, request, redirect, url_for, session
from flask_session import Session
from bridge.bridge import CADBridge, BridgeError
import bridge.session as sess

app = Flask(__name__)
app.secret_key = "cad-dev-secret-change-in-production"
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Initialise the Prolog bridge once at startup
bridge = CADBridge()


# ══════════════════════════════════════════════════════════════════════════════
# QUESTION DEFINITIONS
# Each entry: {"symptom": <atom>, "question": <display text>, "type": <ui type>}
# type: "yesno" | "scale" | "choice" | "number"
# For "choice": add "options": [("atom_value", "Display text"), ...]
# ══════════════════════════════════════════════════════════════════════════════

HISTORY_QUESTIONS = {

    "chest_pain": [
        {"symptom": "chest_pain",             "question": "Does the patient have chest pain?",                                   "type": "yesno"},
        {"symptom": "pain_character",         "question": "How does the patient describe the pain?",                             "type": "choice",
         "options": [("crushing","Crushing / tight"), ("burning","Burning"), ("tearing","Tearing / ripping"), ("gnawing","Gnawing / aching"), ("constant","Constant / dull"), ("atypical","Difficult to describe")]},
        {"symptom": "pain_location",          "question": "Where is the pain located?",                                          "type": "choice",
         "options": [("central","Central / retrosternal"), ("left_sided","Left-sided"), ("epigastric","Epigastric"), ("right_sided","Right-sided")]},
        {"symptom": "exertional",             "question": "Is the pain brought on by exertion?",                                 "type": "yesno"},
        {"symptom": "pain_duration_minutes",  "question": "How long does each episode last (minutes)?",                          "type": "number"},
        {"symptom": "radiation_to_arm",       "question": "Does the pain radiate to the arm (especially left)?",                 "type": "yesno"},
        {"symptom": "radiation_to_back",      "question": "Does the pain radiate through to the back?",                          "type": "yesno"},
        {"symptom": "pleuritic",              "question": "Is the pain worse on breathing in (pleuritic)?",                      "type": "yesno"},
        {"symptom": "dyspnoea",               "question": "Is the patient breathless?",                                          "type": "yesno"},
        {"symptom": "sweating",               "question": "Is the patient sweating excessively?",                                "type": "yesno"},
        {"symptom": "haemoptysis",            "question": "Has the patient coughed up blood?",                                   "type": "yesno"},
        {"symptom": "cough",                  "question": "Does the patient have a cough?",                                      "type": "yesno"},
        {"symptom": "fever",                  "question": "Does the patient have a fever?",                                      "type": "yesno"},
        {"symptom": "worse_on_bending_or_lying", "question": "Is the pain worse on bending over or lying down?",                "type": "yesno"},
        {"symptom": "relieved_by_antacids",   "question": "Is the pain relieved by antacids?",                                   "type": "yesno"},
        {"symptom": "relieved_by_gtn",        "question": "Is the pain relieved by GTN (glyceryl trinitrate) spray?",            "type": "yesno"},
        {"symptom": "relieved_by_sitting_forward", "question": "Is the pain relieved by sitting forward?",                      "type": "yesno"},
        {"symptom": "worse_on_movement",      "question": "Is the pain worse on movement or pressing the chest?",                "type": "yesno"},
        {"symptom": "sudden_onset",           "question": "Was the onset sudden (within seconds)?",                              "type": "yesno"},
        {"symptom": "unilateral_dermatomal",  "question": "Is the pain restricted to one side in a band-like distribution?",    "type": "yesno"},
        {"symptom": "low_mood",               "question": "Has the patient been experiencing low mood or depression?",           "type": "yesno"},
        {"symptom": "history_of_malignancy",  "question": "Does the patient have a known malignancy?",                          "type": "yesno"},
    ],

    "headache": [
        {"symptom": "headache",               "question": "Does the patient have a headache?",                                   "type": "yesno"},
        {"symptom": "onset",                  "question": "How did the headache start?",                                         "type": "choice",
         "options": [("sudden","Sudden  -  'worst ever', thunderclap"), ("gradual","Gradual over hours"), ("progressive","Progressive over days/weeks")]},
        {"symptom": "character",              "question": "How does the patient describe the headache character?",               "type": "choice",
         "options": [("throbbing","Throbbing / pulsating"), ("tight_band","Tight band / pressure"), ("bursting","Bursting / explosive"), ("constant","Constant dull ache")]},
        {"symptom": "location",               "question": "Where is the headache?",                                              "type": "choice",
         "options": [("unilateral","Unilateral"), ("bilateral","Bilateral"), ("occipital","Occipital / back of head"), ("frontal","Frontal"), ("temporal","Temporal")]},
        {"symptom": "neck_stiffness",         "question": "Does the patient have neck stiffness?",                               "type": "yesno"},
        {"symptom": "photophobia",            "question": "Is the patient sensitive to light (photophobia)?",                    "type": "yesno"},
        {"symptom": "nausea_vomiting",        "question": "Is the headache associated with nausea or vomiting?",                 "type": "yesno"},
        {"symptom": "aura",                   "question": "Was the headache preceded by an aura (e.g. visual disturbance, tingling)?", "type": "yesno"},
        {"symptom": "worse_morning",          "question": "Is the headache worse in the morning?",                               "type": "yesno"},
        {"symptom": "worse_on_coughing",      "question": "Is the headache worse on coughing or straining?",                     "type": "yesno"},
        {"symptom": "fever",                  "question": "Does the patient have a fever?",                                      "type": "yesno"},
        {"symptom": "jaw_claudication",       "question": "Does the patient experience pain in the jaw on chewing (jaw claudication)?", "type": "yesno"},
        {"symptom": "visual_disturbance",     "question": "Does the patient have visual disturbance or loss?",                   "type": "yesno"},
        {"symptom": "preceding_trauma",       "question": "Was there any preceding head trauma?",                                "type": "yesno"},
        {"symptom": "history_of_malignancy",  "question": "Does the patient have a known malignancy?",                          "type": "yesno"},
    ],

    "abdominal_pain": [
        {"symptom": "abdominal_pain",         "question": "Does the patient have abdominal pain?",                               "type": "yesno"},
        {"symptom": "onset",                  "question": "How did the pain start?",                                             "type": "choice",
         "options": [("sudden","Sudden onset"), ("gradual","Gradual onset"), ("colicky","Colicky  -  comes and goes")]},
        {"symptom": "pain_location",          "question": "Where is the pain?",                                                  "type": "choice",
         "options": [("rif","Right iliac fossa"), ("lif","Left iliac fossa"), ("epigastric","Epigastric"), ("central","Central / periumbilical"), ("rif","Right upper quadrant"), ("generalised","Generalised")]},
        {"symptom": "nausea_vomiting",        "question": "Is the patient nauseated or vomiting?",                               "type": "yesno"},
        {"symptom": "fever",                  "question": "Does the patient have a fever?",                                      "type": "yesno"},
        {"symptom": "diarrhoea",              "question": "Does the patient have diarrhoea?",                                    "type": "yesno"},
        {"symptom": "constipation",           "question": "Is the patient constipated?",                                         "type": "yesno"},
        {"symptom": "pr_bleeding",            "question": "Has the patient noticed blood in the stool?",                         "type": "yesno"},
        {"symptom": "jaundice",               "question": "Is the patient jaundiced?",                                           "type": "yesno"},
        {"symptom": "haematuria",             "question": "Has the patient noticed blood in the urine?",                         "type": "yesno"},
        {"symptom": "loin_to_groin_radiation","question": "Does the pain radiate from the loin to the groin?",                   "type": "yesno"},
        {"symptom": "last_menstrual_period",  "question": "In female patients: any chance of pregnancy (missed period)?",        "type": "yesno"},
        {"symptom": "previous_surgery",       "question": "Has the patient had previous abdominal surgery?",                     "type": "yesno"},
    ],

    # --- Stubs for remaining 15 presentations ---
    # Students: expand these question lists following the chest_pain and
    # headache examples above. Use symptom atoms that match your .pl file.

    "dyspnoea":               [],
    "cough_haemoptysis":      [],
    "stridor":                [],
    "jaundice":               [],
    "haematemesis":           [],
    "diarrhoea":              [],
    "convulsions":            [],
    "coma_confusion":         [],
    "pyrexia_unknown_origin": [],
    "weight_loss":            [],
    "shock":                  [],
    "haematuria":             [],
    "polyuria_thirst":        [],
    "oedema":                 [],
    "palpitations":           [],
    "syncope":                [],
}


EXAM_QUESTIONS = {

    "chest_pain": [
        {"finding": "pulse_asymmetry",              "question": "Are pulses symmetric in all four limbs?",          "type": "yesno", "inverted": True},
        {"finding": "jvp_elevated",                 "question": "Is the JVP elevated?",                             "type": "yesno"},
        {"finding": "chest_wall_tenderness",        "question": "Is there localised chest wall tenderness on palpation?", "type": "yesno"},
        {"finding": "breath_sounds_reduced_unilateral", "question": "Are breath sounds reduced on one side?",       "type": "yesno"},
        {"finding": "dvt_signs",                    "question": "Are there signs of DVT (swollen, tender leg)?",    "type": "yesno"},
        {"finding": "vesicular_rash",               "question": "Is there a vesicular rash in a dermatomal distribution?", "type": "yesno"},
        {"finding": "localised_rib_tenderness",     "question": "Is there point tenderness directly over a rib?",  "type": "yesno"},
        {"finding": "ecg_changes",                  "question": "Does the ECG show ischaemic changes?",             "type": "yesno"},
        {"finding": "troponin_elevated",             "question": "Is serum troponin elevated?",                     "type": "yesno"},
        {"finding": "troponin_at_12h",               "question": "Troponin at 12 hours post-onset?",                "type": "choice",
         "options": [("positive","Positive"), ("negative","Negative"), ("not_done","Not yet done")]},
        {"finding": "d_dimer",                      "question": "D-dimer result?",                                  "type": "choice",
         "options": [("positive","Elevated"), ("negative","Normal"), ("not_done","Not done")]},
    ],

    "headache": [
        {"finding": "pyrexia",                      "question": "Is the patient pyrexial?",                         "type": "yesno"},
        {"finding": "neck_stiffness_confirmed",     "question": "Is neck stiffness confirmed on examination?",      "type": "yesno"},
        {"finding": "papilloedema",                 "question": "Is papilloedema present on fundoscopy?",           "type": "yesno"},
        {"finding": "focal_neurology",              "question": "Is there focal neurological deficit?",             "type": "yesno"},
        {"finding": "temporal_artery_tender",       "question": "Is the superficial temporal artery tender?",      "type": "yesno"},
        {"finding": "bp_elevated",                  "question": "Is blood pressure significantly elevated (>180/110)?", "type": "yesno"},
        {"finding": "petechial_rash",               "question": "Is there a petechial/purpuric rash?",             "type": "yesno"},
    ],

    # Stubs for remaining presentations
    "abdominal_pain":         [],
    "dyspnoea":               [],
    "cough_haemoptysis":      [],
    "stridor":                [],
    "jaundice":               [],
    "haematemesis":           [],
    "diarrhoea":              [],
    "convulsions":            [],
    "coma_confusion":         [],
    "pyrexia_unknown_origin": [],
    "weight_loss":            [],
    "shock":                  [],
    "haematuria":             [],
    "polyuria_thirst":        [],
    "oedema":                 [],
    "palpitations":           [],
    "syncope":                [],
}

# Human-readable display names for presentations
PRESENTATION_LABELS = {
    "chest_pain":             "Chest pain",
    "headache":               "Headache",
    "abdominal_pain":         "Abdominal pain",
    "dyspnoea":               "Dyspnoea",
    "cough_haemoptysis":      "Cough / haemoptysis",
    "stridor":                "Stridor",
    "jaundice":               "Jaundice",
    "haematemesis":           "Haematemesis",
    "diarrhoea":              "Diarrhoea",
    "convulsions":            "Convulsions",
    "coma_confusion":         "Coma / confusion",
    "pyrexia_unknown_origin": "Pyrexia of unknown origin",
    "weight_loss":            "Weight loss",
    "shock":                  "Shock",
    "haematuria":             "Haematuria",
    "polyuria_thirst":        "Polyuria / thirst",
    "oedema":                 "Oedema",
    "palpitations":           "Palpitations",
    "syncope":                "Syncope",
}


# ══════════════════════════════════════════════════════════════════════════════
# ROUTES
# ══════════════════════════════════════════════════════════════════════════════

@app.route("/")
def index():
    """Phase 1: Presentation selection and patient demographics."""
    sess.init_session()
    return render_template(
        "intake.html",
        presentations=PRESENTATION_LABELS,
    )


@app.route("/intake", methods=["POST"])
def intake():
    """Save demographics, start history phase."""
    presentation = request.form.get("presentation")
    age = request.form.get("age", type=int)
    sex = request.form.get("sex")

    if not presentation or not age or not sex:
        return redirect(url_for("index"))

    sess.set_demographics(presentation, age, sex)
    return redirect(url_for("history"))


@app.route("/history")
def history():
    """Phase 2: Display the next symptom question."""
    presentation = sess.get_presentation()
    if not presentation:
        return redirect(url_for("index"))

    questions = HISTORY_QUESTIONS.get(presentation, [])
    idx = sess.get_history_index()

    if idx >= len(questions):
        sess.advance_to_examination()
        return redirect(url_for("examination"))

    question = questions[idx]
    progress = {
        "current": idx + 1,
        "total": len(questions),
        "pct": int((idx / max(len(questions), 1)) * 100),
    }
    return render_template(
        "history.html",
        question=question,
        progress=progress,
        presentation_label=PRESENTATION_LABELS.get(presentation, presentation),
    )


@app.route("/history", methods=["POST"])
def history_post():
    """Save one symptom answer, advance."""
    presentation = sess.get_presentation()
    questions = HISTORY_QUESTIONS.get(presentation, [])
    idx = sess.get_history_index()

    if idx < len(questions):
        symptom_name = questions[idx]["symptom"]
        value = request.form.get("answer", "no")
        sess.record_symptom(symptom_name, value)

    return redirect(url_for("history"))


@app.route("/examination")
def examination():
    """Phase 3: Display the next examination finding question."""
    presentation = sess.get_presentation()
    if not presentation:
        return redirect(url_for("index"))

    questions = EXAM_QUESTIONS.get(presentation, [])
    idx = sess.get_exam_index()

    if idx >= len(questions):
        sess.advance_to_results()
        return redirect(url_for("results"))

    question = questions[idx]
    progress = {
        "current": idx + 1,
        "total": len(questions),
        "pct": int((idx / max(len(questions), 1)) * 100),
    }
    return render_template(
        "examination.html",
        question=question,
        progress=progress,
        presentation_label=PRESENTATION_LABELS.get(presentation, presentation),
    )


@app.route("/examination", methods=["POST"])
def examination_post():
    """Save one finding, advance."""
    presentation = sess.get_presentation()
    questions = EXAM_QUESTIONS.get(presentation, [])
    idx = sess.get_exam_index()

    if idx < len(questions):
        finding_name = questions[idx]["finding"]
        value = request.form.get("answer", "no")
        sess.record_finding(finding_name, value)

    return redirect(url_for("examination"))


@app.route("/results")
def results():
    """Phase 4: Run Prolog query, display results and proof trace."""
    presentation = sess.get_presentation()
    if not presentation:
        return redirect(url_for("index"))

    session_data = sess.get_full_session()
    error = None
    diagnoses = []

    try:
        diagnoses = bridge.query(session_data)
    except BridgeError as e:
        error = str(e)
    except Exception as e:
        error = f"Unexpected error: {e}"

    return render_template(
        "results.html",
        diagnoses=diagnoses,
        presentation_label=PRESENTATION_LABELS.get(presentation, presentation),
        session_data=session_data,
        error=error,
    )


@app.route("/restart", methods=["POST"])
def restart():
    sess.clear_session()
    return redirect(url_for("index"))


# ══════════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    app.run(debug=True, port=5000)
