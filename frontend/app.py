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
        {"symptom": "chest_pain",             "question": "¿El paciente tiene dolor torácico?",                                   "type": "yesno"},
        {"symptom": "pain_character",         "question": "¿Cómo describe el paciente el dolor?",                             "type": "choice",
         "options": [("crushing","Opresivo / constrictivo"), ("burning","Ardoroso"), ("tearing","Desgarrador"), ("gnawing","Urente / sordo"), ("constant","Constante / sordo"), ("atypical","Difícil de describir")]},
        {"symptom": "pain_location",          "question": "¿Dónde se localiza el dolor?",                                          "type": "choice",
         "options": [("central","Central / retroesternal"), ("left_sided","Lado izquierdo"), ("epigastric","Epigástrico"), ("right_sided","Lado derecho")]},
        {"symptom": "exertional",             "question": "¿El dolor se desencadena con el esfuerzo?",                                 "type": "yesno"},
        {"symptom": "pain_duration_minutes",  "question": "¿Cuánto tiempo dura cada episodio (minutos)?",                          "type": "number"},
        {"symptom": "radiation_to_arm",       "question": "¿El dolor irradia al brazo (especialmente izquierdo)?",                 "type": "yesno"},
        {"symptom": "radiation_to_back",      "question": "¿El dolor irradia hacia la espalda?",                          "type": "yesno"},
        {"symptom": "pleuritic",              "question": "¿El dolor empeora al inspirar (pleurítico)?",                      "type": "yesno"},
        {"symptom": "dyspnoea",               "question": "¿El paciente tiene disnea?",                                          "type": "yesno"},
        {"symptom": "sweating",               "question": "¿El paciente suda en exceso?",                                "type": "yesno"},
        {"symptom": "haemoptysis",            "question": "¿El paciente ha expectorado sangre?",                                   "type": "yesno"},
        {"symptom": "cough",                  "question": "¿El paciente tiene tos?",                                      "type": "yesno"},
        {"symptom": "fever",                  "question": "¿El paciente tiene fiebre?",                                      "type": "yesno"},
        {"symptom": "worse_on_bending_or_lying", "question": "¿El dolor empeora al inclinarse o acostarse?",                "type": "yesno"},
        {"symptom": "relieved_by_antacids",   "question": "¿El dolor cede con antiácidos?",                                   "type": "yesno"},
        {"symptom": "relieved_by_gtn",        "question": "¿El dolor cede con nitroglicerina (GTN) sublingual?",            "type": "yesno"},
        {"symptom": "relieved_by_sitting_forward", "question": "¿El dolor cede al inclinarse hacia adelante?",                      "type": "yesno"},
        {"symptom": "worse_on_movement",      "question": "¿El dolor empeora con el movimiento o la palpación del tórax?",                "type": "yesno"},
        {"symptom": "sudden_onset",           "question": "¿El inicio fue súbito (en segundos)?",                              "type": "yesno"},
        {"symptom": "unilateral_dermatomal",  "question": "¿El dolor se limita a un lado en distribución en banda?",    "type": "yesno"},
        {"symptom": "low_mood",               "question": "¿El paciente ha presentado ánimo deprimido o depresión?",           "type": "yesno"},
        {"symptom": "history_of_malignancy",  "question": "¿El paciente tiene antecedente de neoplasia conocida?",                          "type": "yesno"},
    ],

    "headache": [
        {"symptom": "headache",               "question": "¿El paciente tiene cefalea?",                                   "type": "yesno"},
        {"symptom": "onset",                  "question": "¿Cómo inició la cefalea?",                                         "type": "choice",
         "options": [("sudden","Súbita — la peor de su vida, en trueno"), ("gradual","Gradual en horas"), ("progressive","Progresiva en días/semanas")]},
        {"symptom": "character",              "question": "¿Cómo describe el paciente el carácter de la cefalea?",               "type": "choice",
         "options": [("throbbing","Pulsátil"), ("tight_band","Opresiva en banda"), ("bursting","Explosiva"), ("constant","Dolor sordo constante")]},
        {"symptom": "location",               "question": "¿Dónde se localiza la cefalea?",                                              "type": "choice",
         "options": [("unilateral","Unilateral"), ("bilateral","Bilateral"), ("occipital","Occipital"), ("frontal","Frontal"), ("temporal","Temporal")]},
        {"symptom": "neck_stiffness",         "question": "¿El paciente tiene rigidez de nuca?",                               "type": "yesno"},
        {"symptom": "photophobia",            "question": "¿El paciente tiene fotofobia?",                    "type": "yesno"},
        {"symptom": "nausea_vomiting",        "question": "¿La cefalea se acompaña de náusea o vómito?",                 "type": "yesno"},
        {"symptom": "aura",                   "question": "¿La cefalea fue precedida por aura (p. ej. alteraciones visuales, parestesias)?", "type": "yesno"},
        {"symptom": "worse_morning",          "question": "¿La cefalea empeora por la mañana?",                               "type": "yesno"},
        {"symptom": "worse_on_coughing",      "question": "¿La cefalea empeora al toser o hacer maniobra de Valsalva?",                     "type": "yesno"},
        {"symptom": "fever",                  "question": "¿El paciente tiene fiebre?",                                      "type": "yesno"},
        {"symptom": "jaw_claudication",       "question": "¿El paciente tiene dolor mandibular al masticar (claudicación mandibular)?", "type": "yesno"},
        {"symptom": "visual_disturbance",     "question": "¿El paciente tiene alteraciones o pérdida visual?",                   "type": "yesno"},
        {"symptom": "preceding_trauma",       "question": "¿Hubo traumatismo craneal previo?",                                "type": "yesno"},
        {"symptom": "history_of_malignancy",  "question": "¿El paciente tiene antecedente de neoplasia conocida?",                          "type": "yesno"},
    ],

    "abdominal_pain": [
        {"symptom": "abdominal_pain",         "question": "¿El paciente tiene dolor abdominal?",                               "type": "yesno"},
        {"symptom": "onset",                  "question": "¿Cómo inició el dolor?",                                             "type": "choice",
         "options": [("sudden","Inicio súbito"), ("gradual","Inicio gradual"), ("colicky","Cólico — intermitente")]},
        {"symptom": "pain_location",          "question": "¿Dónde se localiza el dolor?",                                                  "type": "choice",
         "options": [("rif","Fosa ilíaca derecha"), ("lif","Fosa ilíaca izquierda"), ("epigastric","Epigástrico"), ("central","Central / periumbilical"), ("rif","Cuadrante superior derecho"), ("generalised","Generalizado")]},
        {"symptom": "nausea_vomiting",        "question": "¿El paciente tiene náusea o vómito?",                               "type": "yesno"},
        {"symptom": "fever",                  "question": "¿El paciente tiene fiebre?",                                      "type": "yesno"},
        {"symptom": "diarrhoea",              "question": "¿El paciente tiene diarrea?",                                    "type": "yesno"},
        {"symptom": "constipation",           "question": "¿El paciente está estreñido?",                                         "type": "yesno"},
        {"symptom": "pr_bleeding",            "question": "¿El paciente ha notado sangre en las heces?",                         "type": "yesno"},
        {"symptom": "jaundice",               "question": "¿El paciente tiene ictericia?",                                           "type": "yesno"},
        {"symptom": "haematuria",             "question": "¿El paciente ha notado sangre en la orina?",                         "type": "yesno"},
        {"symptom": "loin_to_groin_radiation","question": "¿El dolor irradia del flanco a la ingle?",                   "type": "yesno"},
        {"symptom": "last_menstrual_period",  "question": "En pacientes femeninas: ¿posibilidad de embarazo (amenorrea)?",        "type": "yesno"},
        {"symptom": "previous_surgery",       "question": "¿El paciente ha tenido cirugía abdominal previa?",                     "type": "yesno"},
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
        {"finding": "pulse_asymmetry",              "question": "¿Hay asimetría de pulsos entre las extremidades?",                  "type": "yesno"},
        {"finding": "jvp_elevated",                 "question": "¿La presión venosa yugular está elevada?",                             "type": "yesno"},
        {"finding": "chest_wall_tenderness",        "question": "¿Hay dolor localizado en la pared torácica a la palpación?", "type": "yesno"},
        {"finding": "breath_sounds_reduced_unilateral", "question": "¿Los ruidos respiratorios están disminuidos en un lado?",       "type": "yesno"},
        {"finding": "dvt_signs",                    "question": "¿Hay signos de trombosis venosa profunda (pierna inflamada y dolorosa)?",    "type": "yesno"},
        {"finding": "vesicular_rash",               "question": "¿Hay exantema vesicular en distribución dermatomérica?", "type": "yesno"},
        {"finding": "localised_rib_tenderness",     "question": "¿Hay dolor puntual directamente sobre una costilla?",  "type": "yesno"},
        {"finding": "ecg_changes",                  "question": "¿El ECG muestra cambios isquémicos?",             "type": "yesno"},
        {"finding": "troponin_elevated",             "question": "¿La troponina sérica está elevada?",                     "type": "yesno"},
        {"finding": "troponin_at_12h",               "question": "¿Troponina a las 12 horas del inicio?",                "type": "choice",
         "options": [("positive","Positiva"), ("negative","Negativa"), ("not_done","Aún no disponible")]},
        {"finding": "d_dimer",                      "question": "¿Resultado de dímero D?",                                  "type": "choice",
         "options": [("positive","Elevada"), ("negative","Normal"), ("not_done","No realizado")]},
    ],

    "headache": [
        {"finding": "pyrexia",                      "question": "¿El paciente tiene fiebre?",                         "type": "yesno"},
        {"finding": "neck_stiffness_confirmed",     "question": "¿Se confirma rigidez de nuca en la exploración?",      "type": "yesno"},
        {"finding": "papilloedema",                 "question": "¿Hay papiledema en el fondo de ojo?",           "type": "yesno"},
        {"finding": "focal_neurology",              "question": "¿Hay déficit neurológico focal?",             "type": "yesno"},
        {"finding": "temporal_artery_tender",       "question": "¿La arteria temporal superficial es dolorosa a la palpación?",      "type": "yesno"},
        {"finding": "bp_elevated",                  "question": "¿La presión arterial está significativamente elevada (>180/110)?", "type": "yesno"},
        {"finding": "petechial_rash",               "question": "¿Hay exantema petequial o purpúrico?",             "type": "yesno"},
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
    "chest_pain":             "Dolor torácico",
    "headache":               "Cefalea",
    "abdominal_pain":         "Dolor abdominal",
    "dyspnoea":               "Disnea",
    "cough_haemoptysis":      "Tos / hemoptisis",
    "stridor":                "Estridor",
    "jaundice":               "Ictericia",
    "haematemesis":           "Hematemesis",
    "diarrhoea":              "Diarrea",
    "convulsions":            "Convulsiones",
    "coma_confusion":         "Coma / confusión",
    "pyrexia_unknown_origin": "Fiebre de origen desconocido",
    "weight_loss":            "Pérdida de peso",
    "shock":                  "Choque",
    "haematuria":             "Hematuria",
    "polyuria_thirst":        "Poliuria / sed",
    "oedema":                 "Edema",
    "palpitations":           "Palpitaciones",
    "syncope":                "Síncope",
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
        # If the question is logically inverted, flip yes/no
        if questions[idx].get("inverted") and value in ("yes", "no"):
            value = "no" if value == "yes" else "yes"
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
