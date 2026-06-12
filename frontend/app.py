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

    "dyspnoea": [
    {"symptom": "dyspnoea", "question": "¿El paciente presenta disnea?", "type": "yesno"},
    {"symptom": "onset", "question": "¿Cómo fue el inicio de la disnea?", "type": "choice",
     "options": [("sudden", "Súbito"), ("gradual", "Gradual"), ("progressive", "Progresivo")]},
    {"symptom": "wheeze", "question": "¿El paciente presenta sibilancias?", "type": "yesno"},
    {"symptom": "cough", "question": "¿El paciente presenta tos?", "type": "yesno"},
    {"symptom": "haemoptysis", "question": "¿El paciente ha expectorado sangre?", "type": "yesno"},
    {"symptom": "chest_pain", "question": "¿El paciente presenta dolor torácico?", "type": "yesno"},
    {"symptom": "fever", "question": "¿El paciente presenta fiebre?", "type": "yesno"},
    {"symptom": "orthopnoea", "question": "¿La disnea empeora al acostarse?", "type": "yesno"},
    {"symptom": "paroxysmal_nocturnal_dyspnoea", "question": "¿El paciente despierta por disnea durante la noche?", "type": "yesno"},
    {"symptom": "leg_swelling", "question": "¿El paciente presenta edema de piernas?", "type": "yesno"},
    {"symptom": "weight_loss", "question": "¿El paciente ha perdido peso recientemente?", "type": "yesno"},
    {"symptom": "smoking_history", "question": "¿El paciente tiene antecedente de tabaquismo?", "type": "yesno"},
    {"symptom": "worse_on_exertion", "question": "¿La disnea empeora con el esfuerzo físico?", "type": "yesno"}
],

    "cough_haemoptysis":      [],
    "stridor":                [],
    "jaundice":               [],
    "haematemesis":           [],
    "diarrhoea":              [],

    "convulsions":            [
        {"symptom": "convulsion",         "question": "¿El paciente ha presentado una convulsión?", "type": "yesno"},
        {"symptom": "fever",              "question": "¿El paciente tiene fiebre?", "type": "yesno"},
        {"symptom": "aura",               "question": "¿El paciente tuvo aura antes de la convulsión (p. ej. sensación extraña, alteración visual)?", "type": "yesno"},
        {"symptom": "postictal_confusion","question": "¿El paciente presentó confusión o somnolencia después de la convulsión?", "type": "yesno"},
        {"symptom": "tongue_biting",      "question": "¿El paciente se mordió la lengua durante la convulsión?", "type": "yesno"},
        {"symptom": "incontinence",       "question": "¿El paciente tuvo pérdida de control de esfínteres durante la convulsión?", "type": "yesno"},
        {"symptom": "focal_onset",        "question": "¿La convulsión inició en una parte del cuerpo antes de generalizarse?", "type": "yesno"},
        {"symptom": "diabetes",           "question": "¿El paciente tiene antecedente de diabetes?", "type": "yesno"},
        {"symptom": "alcohol_use",        "question": "¿El paciente consume alcohol de forma crónica o redujo su consumo recientemente?", "type": "yesno"},
        {"symptom": "drug_use",           "question": "¿El paciente consume drogas?", "type": "yesno"},
        {"symptom": "pregnancy",          "question": "¿La paciente está embarazada?", "type": "yesno"},
    ],

    "coma_confusion":         [],
    "pyrexia_unknown_origin": [],

    "weight_loss": [
        {"symptom": "weight_loss",                  "question": "¿El paciente ha tenido una pérdida de peso involuntaria?", "type": "yesno"},
        {"symptom": "change_in_bowel_habit",        "question": "¿El paciente ha notado algún cambio en su hábito intestinal (frecuencia o consistencia)?", "type": "yesno"},
        {"symptom": "haemoptysis",                  "question": "¿El paciente ha tosido sangre?", "type": "yesno"},
        {"symptom": "blood_or_mucus_in_stool",      "question": "¿El paciente ha notado presencia de sangre o moco en sus heces?", "type": "yesno"},
        {"symptom": "tenesmus",                     "question": "¿Siente ganas frecuentes de defecar aunque el intestino esté vacío?", "type": "yesno"},
        {"symptom": "dyspnoea",                     "question": "¿Siente falta de aire o dificultad para respirar?", "type": "yesno"},
        {"symptom": "orthopnoea",                   "question": "¿Necesita usar varias almohadas para respirar mejor al estar acostado?", "type": "yesno"},
        {"symptom": "paroxysmal_nocturnal_dyspnoea", "question": "¿Se despierta bruscamente por la noche con sensación de ahogo?", "type": "yesno"},
        {"symptom": "chronic_cough",                "question": "¿Tiene tos de larga duración o crónica?", "type": "yesno"},
        {"symptom": "smoking_history",              "question": "¿Tiene el paciente historial de tabaquismo?", "type": "yesno"},
        {"symptom": "lethargy",                     "question": "¿Siente cansancio extremo, fatiga o falta de energía?", "type": "yesno"},
        {"symptom": "polyuria",                     "question": "¿Ha notado un aumento excesivo en la cantidad de orina?", "type": "yesno"},
        {"symptom": "oliguria",                     "question": "¿Ha notado una disminución marcada en la cantidad de orina?", "type": "yesno"},
        {"symptom": "nocturia",                     "question": "¿Tiene que levantarse varias veces por la noche para orinar?", "type": "yesno"},
        {"symptom": "haematuria",                   "question": "¿Ha observado sangre en su orina?", "type": "yesno"},
        {"symptom": "frothy_urine",                 "question": "¿Nota que su orina es muy espumosa?", "type": "yesno"},
        {"symptom": "diarrhoea",                    "question": "¿Presenta evacuaciones líquidas o frecuentes?", "type": "yesno"},
        {"symptom": "steatorrhoea",                 "question": "¿Sus heces son grasosas, pálidas o difíciles de eliminar con el agua?", "type": "yesno"},
        {"symptom": "abdominal_discomfort",         "question": "¿Siente molestias, dolor o distensión en el abdomen?", "type": "yesno"},
        {"symptom": "dark_urine",                   "question": "¿Su orina es de un color muy oscuro?", "type": "yesno"},
        {"symptom": "pale_stools",                  "question": "¿Sus heces son de color muy claro o blanquecinas?", "type": "yesno"},
        {"symptom": "polydipsia",                   "question": "¿Siente una sed excesiva e insaciable?", "type": "yesno"},
        {"symptom": "voracious_appetite",           "question": "¿Tiene un apetito aumentado o voraz a pesar de perder peso?", "type": "yesno"},
        {"symptom": "heat_intolerance",             "question": "¿Siente que tolera muy mal el calor o suda más de lo normal?", "type": "yesno"},
        {"symptom": "palpitations",                 "question": "¿Siente latidos rápidos o fuertes en el pecho (palpitaciones)?", "type": "yesno"},
        {"symptom": "anorexia",                     "question": "¿Ha perdido el apetito por completo?", "type": "yesno"},
        {"symptom": "syncope",                      "question": "¿Ha tenido desmayos o pérdidas bruscas del conocimiento?", "type": "yesno"},
        {"symptom": "night_sweats",                 "question": "¿Sufre de sudoración intensa durante la noche?", "type": "yesno"},
        {"symptom": "risk_factors_hiv",             "question": "¿Existen factores de riesgo para VIH (contacto sin protección, drogas IV)?", "type": "yesno"},
        {"symptom": "perianal_itching",             "question": "¿Siente picazón intensa en la zona del ano?", "type": "yesno"},
        {"symptom": "worms_in_faeces",              "question": "¿Ha observado parásitos o 'gusanos' en sus heces?", "type": "yesno"},
        {"symptom": "foreign_travel",               "question": "¿Ha viajado recientemente al extranjero (zonas tropicales)?", "type": "yesno"},
        {"symptom": "low_mood",                     "question": "¿Se ha sentido triste, deprimido o con el ánimo bajo constantemente?", "type": "yesno"},
        {"symptom": "loss_of_appetite",             "question": "¿Ha perdido el interés por comer o disfrutar la comida?", "type": "yesno"},
        {"symptom": "distorted_body_image",         "question": "¿Se percibe a sí mismo con exceso de peso a pesar de estar delgado?", "type": "yesno"},
        {"symptom": "intravenous_drug_use",         "question": "¿Existe historial de uso de drogas por vía intravenosa?", "type": "yesno"},
        {"symptom": "decreased_dietary_intake",     "question": "¿Ha disminuido su ingesta de comida (por falta de recursos o voluntad)?", "type": "yesno"},
        {"symptom": "arthritis",                    "question": "¿Padece inflamación o dolor en las articulaciones?", "type": "yesno"},
        {"symptom": "early_morning_joint_stiffness","question": "¿Siente rigidez en las articulaciones al despertar que dura más de 30 min?", "type": "yesno"},
    ],

    "shock": [
        {"symptom": "shock",                              "question": "¿El paciente se encuentra en choque?",                                   "type": "yesno"},
        {"symptom": "tachycardia",                        "question": "¿El paciente presenta taquicardia?",                                   "type": "yesno"},
        {"symptom": "preceding_trauma",                   "question": "¿El paciente se presenta con trauma?",                                   "type": "yesno"},
        {"symptom": "thermal_injury",                     "question": "¿Se presentan lesiones por quemadura?",                                   "type": "yesno"},
        {"symptom": "vomiting",                           "question": "¿El paciente tiene vómito?",                                   "type": "yesno"},
        {"symptom": "diarrhoea",                          "question": "¿El paciente tiene diarrea?",                                   "type": "yesno"},
        {"symptom": "intestinal_obstruction",             "question": "¿El paciente tiene obstrucción intestinal?",                                   "type": "yesno"},
        {"symptom": "chest_pain",                         "question": "¿El paciente presenta dolor torácico?",                                   "type": "yesno"},
        {"symptom": "infection_presence",                 "question": "¿Hay presencia de infección?",                                   "type": "yesno"},
        {"symptom": "allergy_exposure",                   "question": "¿El paciente estuvo expuesto a alérgenos?",                                   "type": "yesno"},
        {"symptom": "acute_paralysis",                    "question": "¿El paciente tiene parálisis aguda?",                                   "type": "yesno"},
        {"symptom": "dyspnoea",                           "question": "¿El paciente tiene disnea?",                                   "type": "yesno"},
    ],

    "haematuria": [
        {"symptom":"haematuria",                "question":"¿El paciente presenta sangre en la orina?", "type":"yesno"},
        {"symptom":"haematuria_location",       "question":"¿En qué parte del flujo se encuentra presente la sangre?", "type":"choice",
         "options":[("initial", "Comienzo"),("entire", "Todo el flujo"),("end", "Fin")]},
        {"symptom":"loin_pain",                 "question":"¿El paciente presenta dolor lumbar?", "type":"yesno"},
        {"symptom":"weight_loss",               "question":"¿El paciente ha presentado pérdida de peso sin cambios en sus hábitos?", "type":"yesno"},
        {"symptom":"dysuria",                   "question":"¿El paciente presenta dolor al realizar la micción?", "type":"yesno"},
        {"symptom":"urinary_frequency",         "question":"¿El paciente presenta aumento en la necesidad de realizar la micción?", "type":"yesno"},
        {"symptom":"history_polycystic_kidney", "question":"¿El paciente presenta historial familiar de riñón poliquístico?", "type":"yesno"},
        {"symptom":"urinary_difficulty",        "question":"¿El paciente presenta dificultad para realizar la micción?", "type":"yesno"},
        {"symptom":"poor_stream",               "question":"¿El paciente presenta poco flujo urinario?", "type":"yesno"},
        {"symptom":"ureteric_colic",            "question":"¿El paciente presenta dolor en la ingle o genitales?", "type":"yesno"},
        {"symptom":"bone_tenderness",           "question":"¿El paciente presenta dolor en los huesos?", "type":"yesno"},
        {"symptom":"anticoagulant_use",         "question":"¿El paciente usa o ha utilizado anticoagulantes?", "type":"yesno"},
        {"symptom":"smoking_history",           "question":"¿El paciente tiene o ha tenido hábitos de fumar?", "type":"yesno"},
        {"symptom":"age_over_40",               "question":"¿El paciente tiene más de 40 años?", "type":"yesno"},
        {"symptom":"trip_abroad",               "question":"¿El paciente ha realizado viajes recientes al extranjero?", "type":"yesno"},
        {"symptom":"renal_biopsy",              "question":"¿El paciente se ha realizado una biopsia renal?", "type":"yesno"},
        {"symptom":"pelvic_fractures",          "question":"¿El paciente presenta o ha presentado fracturas pélvicas?", "type":"yesno"},
    ],
    "polyuria_thirst":        [],
    "oedema":                 [],
    "palpitations": [
        {"symptom": "palpitations",          "question": "¿Siente latidos rápidos, fuertes o irregulares en el pecho?",              "type": "yesno"},
        {"symptom": "regular_rhythm",        "question": "¿Los latidos son regulares (ritmo constante)?",                             "type": "yesno"},
        {"symptom": "irregular_rhythm",      "question": "¿Los latidos son irregulares (ritmo variable o saltos)?",                   "type": "yesno"},
        {"symptom": "missed_beats",          "question": "¿Siente que el corazón 'se salta' latidos?",                               "type": "yesno"},
        {"symptom": "sudden_onset",          "question": "¿Las palpitaciones inician de forma súbita ('en un clic')?",                "type": "yesno"},
        {"symptom": "sudden_termination",    "question": "¿Las palpitaciones terminan de forma súbita?",                             "type": "yesno"},
        {"symptom": "syncope",               "question": "¿Ha perdido el conocimiento durante las palpitaciones?",                   "type": "yesno"},
        {"symptom": "dyspnoea",              "question": "¿Tiene dificultad para respirar durante los episodios?",                   "type": "yesno"},
        {"symptom": "chest_pain",            "question": "¿Tiene dolor en el pecho durante los episodios?",                          "type": "yesno"},
        {"symptom": "anxiety",               "question": "¿Está usted ansioso o bajo estrés emocional importante?",                  "type": "yesno"},
        {"symptom": "excess_caffeine",       "question": "¿Consume grandes cantidades de café, té o bebidas energéticas?",           "type": "yesno"},
        {"symptom": "smoking",               "question": "¿Fuma usted actualmente?",                                                  "type": "yesno"},
        {"symptom": "excess_alcohol",        "question": "¿Consume alcohol en exceso?",                                               "type": "yesno"},
        {"symptom": "cardiac_history",       "question": "¿Tiene antecedentes de enfermedad cardíaca (valvulopatía, IAM, HTA)?",     "type": "yesno"},
    ],
    "syncope": [
        {"symptom": "syncope",                   "question": "¿Ha perdido el conocimiento de forma transitoria?",                   "type": "yesno"},
        {"symptom": "prodrome",                   "question": "¿Hubo pródromos (náusea, sudoración, visión borrosa)?",              "type": "yesno"},
        {"symptom": "no_prodrome",                "question": "¿La pérdida fue completamente brusca sin aviso previo?",             "type": "yesno"},
        {"symptom": "precipitating_factor",       "question": "¿Hubo desencadenante claro (dolor, emoción, calor)?",               "type": "yesno"},
        {"symptom": "syncope_on_standing",        "question": "¿El síncope ocurrió al ponerse de pie?",                            "type": "yesno"},
        {"symptom": "syncope_on_exertion",        "question": "¿El síncope ocurrió durante el esfuerzo físico?",                   "type": "yesno"},
        {"symptom": "syncope_during_micturition", "question": "¿El síncope ocurrió durante o tras orinar?",                        "type": "yesno"},
        {"symptom": "syncope_during_coughing",    "question": "¿El síncope ocurrió durante un acceso de tos?",                     "type": "yesno"},
        {"symptom": "palpitations_preceding",     "question": "¿Hubo palpitaciones justo antes del episodio?",                     "type": "yesno"},
        {"symptom": "convulsive_movements",       "question": "¿Tuvo movimientos convulsivos durante el episodio?",                "type": "yesno"},
        {"symptom": "postictal_confusion",        "question": "¿Estuvo confuso más de 5 minutos tras el episodio?",                "type": "yesno"},
        {"symptom": "tongue_biting",              "question": "¿Se mordió la lengua lateral durante el episodio?",                 "type": "yesno"},
        {"symptom": "incontinence",               "question": "¿Tuvo pérdida de orina o heces durante el episodio?",               "type": "yesno"},
        {"symptom": "chest_pain",                 "question": "¿Tuvo dolor torácico antes o durante el episodio?",                 "type": "yesno"},
        {"symptom": "dyspnoea",                   "question": "¿Tuvo dificultad respiratoria antes o durante el episodio?",        "type": "yesno"},
        {"symptom": "pleuritic_pain",             "question": "¿Tiene dolor que empeora al respirar profundo?",                    "type": "yesno"},
        {"symptom": "antihypertensive_use",       "question": "¿Toma antihipertensivos, diuréticos u opioides?",                  "type": "yesno"},
        {"symptom": "recent_haemorrhage",         "question": "¿Ha tenido sangrado importante recientemente?",                     "type": "yesno"},
        {"symptom": "diabetes",                   "question": "¿Padece diabetes mellitus?",                                        "type": "yesno"},
        {"symptom": "excess_alcohol",             "question": "¿Consumió alcohol en exceso recientemente?",                        "type": "yesno"},
        {"symptom": "cardiac_history",            "question": "¿Tiene antecedentes de cardiopatía estructural?",                   "type": "yesno"},
    ],
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
    "abdominal_pain": [
        {"finding": "guarding",               "question": "¿Hay defensa muscular abdominal?",                        "type": "yesno"},
        {"finding": "rigidity",               "question": "¿Hay rigidez abdominal (vientre en tabla)?",              "type": "yesno"},
        {"finding": "rebound_tenderness",     "question": "¿Hay signo de Blumberg (dolor a la descompresión)?",      "type": "yesno"},
        {"finding": "bowel_sounds",           "question": "¿Cómo son los ruidos hidroaéreos?",                       "type": "choice",
         "options": [("normal","Normales"), ("absent","Ausentes"), ("tinkling","Metálicos / tintineo")]},
        {"finding": "pulsatile_mass",         "question": "¿Se palpa masa pulsátil abdominal?",                      "type": "yesno"},
        {"finding": "hernial_orifice_tender", "question": "¿Hay orificio herniario doloroso?",                       "type": "yesno"},
    ],

    "dyspnoea": [
    {"finding": "wheeze_on_auscultation", "question": "¿Se auscultan sibilancias?",                     "type": "yesno"},
    {"finding": "crepitations",           "question": "¿Se auscultan crepitaciones?",                   "type": "yesno"},
    {"finding": "reduced_air_entry",      "question": "¿Existe disminución de la entrada de aire?",     "type": "yesno"},
    {"finding": "peripheral_oedema",      "question": "¿Existe edema periférico?",                      "type": "yesno"},
    {"finding": "jvp_elevated",           "question": "¿La presión venosa yugular está elevada?",       "type": "yesno"},
    {"finding": "tracheal_deviation",     "question": "¿Existe desviación traqueal?",                   "type": "yesno"},
    {"finding": "dullness_to_percussion", "question": "¿Existe matidez a la percusión?",                "type": "yesno"}
],

    "cough_haemoptysis":      [],
    "stridor":                [],
    "jaundice":               [],
    "haematemesis":           [],
    "diarrhoea":              [],

    "convulsions":            [
        {"finding": "pyrexia",            "question": "¿El paciente tiene fiebre?", "type": "yesno"},
        {"finding": "neck_stiffness",     "question": "¿Hay rigidez de nuca?", "type": "yesno"},
        {"finding": "papilloedema",       "question": "¿Hay papiledema en el fondo de ojo?", "type": "yesno"},
        {"finding": "focal_neurology",    "question": "¿Hay déficit neurológico focal persistente tras la convulsión?", "type": "yesno"},
        {"finding": "blood_glucose_low",  "question": "¿Muestra glucemia baja (hipoglucemia)?", "type": "yesno"},
        {"finding": "blood_glucose_high", "question": "¿Muestra glucemia elevada (hiperglucemia)?", "type": "yesno"},
        {"finding": "sodium_abnormal",    "question": "¿Muestra niveles anormales de sodio?", "type": "yesno"},
    ],

    "coma_confusion":         [],
    "pyrexia_unknown_origin": [],

    "weight_loss": [
        {"finding": "peripheral_oedema",            "question": "¿Hay presencia de hinchazón (edema) en piernas o tobillos?", "type": "yesno"},
        {"finding": "elevated_jvp",                 "question": "¿Se observa la vena yugular del cuello elevada o pulsátil?", "type": "yesno"},
        {"finding": "tachypnoea",                   "question": "¿La frecuencia respiratoria es superior a lo normal (taquipnea)?", "type": "yesno"},
        {"finding": "joint_tenderness",             "question": "¿Hay dolor o sensibilidad a la palpación en las articulaciones?", "type": "yesno"},
        {"finding": "jaundice",                     "question": "¿La piel o los ojos (escleras) tienen una coloración amarillenta?", "type": "yesno"},
        {"finding": "ascites",                      "question": "¿Hay presencia de líquido en el abdomen (ascitis)?", "type": "yesno"},
        {"finding": "thyroid_enlargement",          "question": "¿Se palpa un aumento de tamaño en la glándula tiroides?", "type": "yesno"},
        {"finding": "postural_hypotension",         "question": "¿Cae la presión arterial significativamente al ponerse de pie?", "type": "yesno"},
        {"finding": "skin_pigmentation",            "question": "¿Se observa una pigmentación oscura inusual en piel o mucosas?", "type": "yesno"},
        {"finding": "lymphadenopathy",              "question": "¿Se palpan ganglios linfáticos aumentados de tamaño?", "type": "yesno"},
        {"finding": "cachexia",                     "question": "¿El paciente presenta un estado de desnutrición extrema (caquexia)?", "type": "yesno"},
        {"finding": "blood_glucose_elevated",       "question": "¿Los niveles de glucosa en sangre son superiores a 11.1 mmol/L?", "type": "yesno"},
        {"finding": "tsh_and_t4_abnormal",          "question": "¿Son anormales los resultados de TSH o T4 libre?", "type": "yesno"},
        {"finding": "synacthen_test_abnormal",      "question": "¿Es anormal el resultado de la prueba de Synacthen?", "type": "yesno"},
        {"finding": "hiv_antibodies_positive",      "question": "¿Es positivo el resultado de anticuerpos para VIH?", "type": "yesno"},
        {"finding": "echocardiography_abnormal",    "question": "¿Muestra el ecocardiograma alguna anomalía estructural o funcional?", "type": "yesno"},
    ],

    "shock": [
        {"finding": "clammy_skin",                                  "question": "¿La piel se encuentra fría y sudorosa al tacto?",                  "type": "yesno"},
        {"finding": "jvp_low",                                      "question": "¿La presión venosa yugular está baja?",                  "type": "yesno"},
        {"finding": "jvp_elevated",                                 "question": "¿La presión venosa yugular está elevada?",                  "type": "yesno"},
        {"finding": "ecg_mi_changes",                               "question": "¿Se presentan cambios electrocardiográficos confirmantes de infarto?",                  "type": "yesno"},
        {"finding": "new_cardiac_murmur",                           "question": "¿Existe un soplo cardíaco de nueva aparición?",                  "type": "yesno"},
        {"finding": "ecg_arrhythmia",                               "question": "¿Se identifica arritmia en el ECG?",                  "type": "yesno"},
        {"finding": "warm_skin",                                    "question": "¿La piel se encuentra caliente al tacto?",                  "type": "yesno"},
        {"finding": "pyrexia",                                      "question": "¿El paciente tiene fiebre?",                  "type": "yesno"},
        {"finding": "urticaria",                                    "question": "¿El paciente presenta signos de urticaria?",                  "type": "yesno"},
        {"finding": "angioedema",                                   "question": "¿El paciente tiene signos de angioedema?",                  "type": "yesno"},
        {"finding": "bronchospasm",                                 "question": "¿Se identifica broncoespasmo?",                  "type": "yesno"},
        {"finding": "wheeze",                                       "question": "¿Se producen sibilancias audibles?",                  "type": "yesno"},
        {"finding": "cyanosis",                                     "question": "¿El paciente presenta cianosis?",                  "type": "yesno"},
        {"finding": "unilateral_absent_breath_sounds",              "question": "¿Los ruidos respiratorios están disminuidos a un lado?",                  "type": "yesno"},
        {"finding": "pulsus_paradoxus",                             "question": "¿Se presenta pulso paradójico en el paciente?",                  "type": "yesno"},
        {"finding": "muffled_heart_sounds",                         "question": "¿Los ruidos cardíacos se presentan amortiguados?",                  "type": "yesno"},
        {"finding": "ecg_alternans",                                "question": "¿Existen complejos QRS alternantes en el ECG?",                  "type": "yesno"},
    ],
    "haematuria":             [
        {"finding":"renal_mass",                "question":"¿Se detecta una masa renal al palpar al paciente?","type":"yesno"},
        {"finding":"abdominal_murmur",          "question":"¿El paciente presenta soplo abdominal?","type":"yesno"},
        {"finding":"suprapubic_tenderness",     "question":"¿El paciente presenta sensibilidad suprapúbica?","type":"yesno"},
        {"finding":"enlarged_prostate",         "question":"¿En la exploración rectal hay presencia de agrandamiento prostático?","type":"yesno"},
        {"finding":"enlargement_type",          "question":"¿Cómo se presenta el tipo de agrandamiento?", "type":"choice",
         "options":[("smooth", "Suave"),("hard", "Duro y rugoso")]},
        {"finding":"urethra_mass",              "question":"¿Al palpar a lo largo de la uretra hay presencia de masas?", "type":"yesno"},
        {"finding":"history_of_tuberculosis",   "question":"¿El paciente presenta antecedentes de tuberculosis en otra parte del cuerpo?", "type":"yesno"},
        {"finding":"evidence_malaria",          "question":"¿Existe evidencia de malaria?", "type":"yesno"}
    ],

    "polyuria_thirst":        [],
    "oedema":                 [],
    "palpitations": [
        {"finding": "irregularly_irregular_pulse", "question": "¿El pulso es irregularmente irregular a la palpación?", "type": "yesno"},
        {"finding": "ecg_abnormal",                "question": "¿El ECG muestra anomalía del ritmo o conducción?",      "type": "yesno"},
        {"finding": "tachycardia_on_examination",  "question": "¿Hay taquicardia en la exploración (FC >100 lpm)?",     "type": "yesno"},
        {"finding": "bradycardia_on_examination",  "question": "¿Hay bradicardia en la exploración (FC <60 lpm)?",      "type": "yesno"},
        {"finding": "heart_murmur",                "question": "¿Se ausculta algún soplo cardíaco?",                    "type": "yesno"},
    ],
    "syncope": [
        {"finding": "postural_bp_drop",            "question": "¿Hay caída de TA ≥20 mmHg al ponerse de pie?",                      "type": "yesno"},
        {"finding": "ecg_abnormal",                "question": "¿El ECG muestra anomalías (bloqueo AV, QT largo, isquemia)?",        "type": "yesno"},
        {"finding": "bradycardia_on_examination",  "question": "¿Hay bradicardia o pausas en la exploración?",                      "type": "yesno"},
        {"finding": "tachycardia_on_examination",  "question": "¿Hay taquicardia en la exploración?",                               "type": "yesno"},
        {"finding": "ejection_systolic_murmur",   "question": "¿Se ausculta soplo sistólico eyectivo irradiado a carótidas?",       "type": "yesno"},
        {"finding": "oxygen_saturation_low",       "question": "¿La saturación de oxígeno es baja (<94%)?",                         "type": "yesno"},
        {"finding": "blood_glucose_low",           "question": "¿La glucemia capilar es baja (<3.5 mmol/L)?",                       "type": "yesno"},
    ],
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
    """Phase 2: Display all symptom questions on one page."""
    presentation = sess.get_presentation()
    if not presentation:
        return redirect(url_for("index"))

    questions = HISTORY_QUESTIONS.get(presentation, [])
    if not questions:
        sess.advance_to_examination()
        return redirect(url_for("examination"))

    return render_template(
        "history.html",
        questions=questions,
        presentation_label=PRESENTATION_LABELS.get(presentation, presentation),
    )


@app.route("/history", methods=["POST"])
def history_post():
    """Save all symptom answers at once, advance to examination."""
    presentation = sess.get_presentation()
    questions = HISTORY_QUESTIONS.get(presentation, [])

    for q in questions:
        name = q["symptom"]
        value = request.form.get(name, "no")
        sess.record_symptom(name, value)

    sess.advance_to_examination()
    return redirect(url_for("examination"))


@app.route("/examination")
def examination():
    """Phase 3: Display all examination findings on one page."""
    presentation = sess.get_presentation()
    if not presentation:
        return redirect(url_for("index"))

    questions = EXAM_QUESTIONS.get(presentation, [])
    if not questions:
        sess.advance_to_results()
        return redirect(url_for("results"))

    return render_template(
        "examination.html",
        questions=questions,
        presentation_label=PRESENTATION_LABELS.get(presentation, presentation),
    )


@app.route("/examination", methods=["POST"])
def examination_post():
    """Save all examination findings at once, advance to results."""
    presentation = sess.get_presentation()
    questions = EXAM_QUESTIONS.get(presentation, [])

    for q in questions:
        name = q["finding"]
        value = request.form.get(name, "no")
        if q.get("inverted") and value in ("yes", "no"):
            value = "no" if value == "yes" else "yes"
        sess.record_finding(name, value)

    sess.advance_to_results()
    return redirect(url_for("results"))



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
