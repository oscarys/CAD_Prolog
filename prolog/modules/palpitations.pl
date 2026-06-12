/* ============================================================
   MODULE: palpitations
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 351-353
   AUTHORS: <your names>
   SYSTEM:  Cardiovascular
   ============================================================ */

:- module(palpitations, [diagnose/2, frequency/2,
                          suggest_test/2, explain_step/3,
                          exclude_if/2]).

:- encoding(utf8).

/* ------------------------------------------------------------
   SECCIÓN 1 -- TABLA DE FRECUENCIAS
   Fuente: código de color de Churchill p.351
   🟢 común  🟡 ocasional  🔴 raro
   ------------------------------------------------------------ */

% SINUS TACHYCARDIA
frequency(anxiety_sinus_tachycardia,   common).     % 🟢
frequency(caffeine_tachycardia,        common).     % 🟢
frequency(nicotine_tachycardia,        common).     % 🟢
frequency(alcohol_tachycardia,         common).     % 🟢

% CARDIAC ARRHYTHMIA
frequency(ventricular_ectopics,        common).     % 🟢
frequency(atrial_ectopics,             common).     % 🟢
frequency(atrial_fibrillation,         common).     % 🟢
frequency(svt,                         occasional). % 🟡
frequency(ventricular_tachycardia,     rare).       % 🔴


/* ------------------------------------------------------------
   SECCIÓN 2 -- REGLAS DIAGNÓSTICAS
   ------------------------------------------------------------ */

% --- Taquicardia sinusal por ansiedad ---
diagnose(anxiety_sinus_tachycardia, Frequency) :-
    symptom(palpitations, yes),
    symptom(anxiety, yes),
    symptom(regular_rhythm, yes),
    \+ symptom(syncope, yes),
    frequency(anxiety_sinus_tachycardia, Frequency).

% --- Taquicardia sinusal por cafeína ---
diagnose(caffeine_tachycardia, Frequency) :-
    symptom(palpitations, yes),
    symptom(excess_caffeine, yes),
    symptom(regular_rhythm, yes),
    frequency(caffeine_tachycardia, Frequency).

% --- Taquicardia sinusal por nicotina ---
diagnose(nicotine_tachycardia, Frequency) :-
    symptom(palpitations, yes),
    symptom(smoking, yes),
    symptom(regular_rhythm, yes),
    frequency(nicotine_tachycardia, Frequency).

% --- Taquicardia sinusal por alcohol ---
diagnose(alcohol_tachycardia, Frequency) :-
    symptom(palpitations, yes),
    symptom(excess_alcohol, yes),
    symptom(regular_rhythm, yes),
    frequency(alcohol_tachycardia, Frequency).

% --- Extrasístoles ventriculares ---
% Irregulares, sensación de "latido que se salta",
% benignas en corazón estructuralmente normal.
diagnose(ventricular_ectopics, Frequency) :-
    symptom(palpitations, yes),
    symptom(irregular_rhythm, yes),
    symptom(missed_beats, yes),
    \+ symptom(syncope, yes),
    frequency(ventricular_ectopics, Frequency).

% --- Extrasístoles auriculares ---
diagnose(atrial_ectopics, Frequency) :-
    symptom(palpitations, yes),
    symptom(irregular_rhythm, yes),
    symptom(missed_beats, yes),
    \+ symptom(chest_pain, yes),
    frequency(atrial_ectopics, Frequency).

% --- Fibrilación auricular ---
% Irregularmente irregular, puede asociarse a disnea,
% mareo y antecedente de valvulopatía o HTA.
diagnose(atrial_fibrillation, Frequency) :-
    symptom(palpitations, yes),
    symptom(irregular_rhythm, yes),
    finding(irregularly_irregular_pulse, yes),
    frequency(atrial_fibrillation, Frequency).

diagnose(atrial_fibrillation, Frequency) :-
    symptom(palpitations, yes),
    symptom(irregular_rhythm, yes),
    symptom(dyspnoea, yes),
    symptom(cardiac_history, yes),
    frequency(atrial_fibrillation, Frequency).

% --- Taquicardia supraventricular ---
% Inicio y fin bruscos, regular, frecuencia alta,
% más frecuente en jóvenes con vía accesoria.
diagnose(svt, Frequency) :-
    symptom(palpitations, yes),
    symptom(sudden_onset, yes),
    symptom(sudden_termination, yes),
    symptom(regular_rhythm, yes),
    frequency(svt, Frequency).

diagnose(svt, Frequency) :-
    symptom(palpitations, yes),
    symptom(sudden_onset, yes),
    symptom(dyspnoea, yes),
    symptom(regular_rhythm, yes),
    \+ symptom(syncope, yes),
    frequency(svt, Frequency).

% --- Taquicardia ventricular ---
% Grave: inicio súbito, puede causar síncope,
% asociada a cardiopatía estructural.
diagnose(ventricular_tachycardia, Frequency) :-
    symptom(palpitations, yes),
    symptom(sudden_onset, yes),
    symptom(syncope, yes),
    symptom(cardiac_history, yes),
    frequency(ventricular_tachycardia, Frequency).

diagnose(ventricular_tachycardia, Frequency) :-
    symptom(palpitations, yes),
    symptom(sudden_onset, yes),
    symptom(chest_pain, yes),
    finding(ecg_abnormal, yes),
    frequency(ventricular_tachycardia, Frequency).


/* ------------------------------------------------------------
   SECCIÓN 3 -- ESTUDIOS RECOMENDADOS
   Fuente: Churchill's p.352-353
   ------------------------------------------------------------ */

suggest_test(anxiety_sinus_tachycardia,  ecg).
suggest_test(anxiety_sinus_tachycardia,  tfts).
suggest_test(anxiety_sinus_tachycardia,  fbc).

suggest_test(caffeine_tachycardia,       ecg).
suggest_test(caffeine_tachycardia,       ambulatory_ecg).

suggest_test(nicotine_tachycardia,       ecg).
suggest_test(nicotine_tachycardia,       ambulatory_ecg).

suggest_test(alcohol_tachycardia,        ecg).
suggest_test(alcohol_tachycardia,        lfts).
suggest_test(alcohol_tachycardia,        fbc).

suggest_test(ventricular_ectopics,       ecg).
suggest_test(ventricular_ectopics,       ambulatory_ecg).
suggest_test(ventricular_ectopics,       echocardiography).

suggest_test(atrial_ectopics,            ecg).
suggest_test(atrial_ectopics,            ambulatory_ecg).

suggest_test(atrial_fibrillation,        ecg).
suggest_test(atrial_fibrillation,        ambulatory_ecg).
suggest_test(atrial_fibrillation,        echocardiography).
suggest_test(atrial_fibrillation,        tfts).
suggest_test(atrial_fibrillation,        fbc).

suggest_test(svt,                        ecg).
suggest_test(svt,                        ambulatory_ecg).
suggest_test(svt,                        echocardiography).
suggest_test(svt,                        electrophysiology_study).

suggest_test(ventricular_tachycardia,    ecg).
suggest_test(ventricular_tachycardia,    ambulatory_ecg).
suggest_test(ventricular_tachycardia,    echocardiography).
suggest_test(ventricular_tachycardia,    cardiac_mri).


/* ------------------------------------------------------------
   SECCIÓN 4 -- TRAZA DE DEMOSTRACIÓN
   ------------------------------------------------------------ */

% --- anxiety_sinus_tachycardia ---
explain_step(anxiety_sinus_tachycardia, palpitations,
    'Las palpitaciones son la conciencia del latido cardíaco  -  en la ansiedad la activación simpática aumenta la frecuencia sinusal').
explain_step(anxiety_sinus_tachycardia, anxiety,
    'La ansiedad y el estrés emocional elevan las catecolaminas y producen taquicardia sinusal refleja').
explain_step(anxiety_sinus_tachycardia, regular_rhythm,
    'La taquicardia sinusal es regular  -  ritmo regular descarta arritmias ectópicas como causa principal').
explain_step(anxiety_sinus_tachycardia, syncope,
    'La ausencia de síncope apoya una causa benigna como la taquicardia sinusal  -  el síncope sugiere arritmia grave').

% --- caffeine_tachycardia ---
explain_step(caffeine_tachycardia, palpitations,
    'Las palpitaciones son el síntoma de presentación de la taquicardia inducida por cafeína').
explain_step(caffeine_tachycardia, excess_caffeine,
    'La cafeína bloquea los receptores de adenosina y aumenta la frecuencia cardíaca  -  consumo excesivo es un precipitante conocido de arritmias').
explain_step(caffeine_tachycardia, regular_rhythm,
    'El ritmo regular indica taquicardia sinusal  -  la cafeína no suele producir arritmias irregulares a dosis habituales').

% --- nicotine_tachycardia ---
explain_step(nicotine_tachycardia, palpitations,
    'Las palpitaciones reflejan la taquicardia sinusal producida por la nicotina').
explain_step(nicotine_tachycardia, smoking,
    'La nicotina estimula los receptores nicotínicos en el ganglio cardíaco y eleva la frecuencia sinusal').
explain_step(nicotine_tachycardia, regular_rhythm,
    'Ritmo regular compatible con taquicardia sinusal inducida por nicotina').

% --- alcohol_tachycardia ---
explain_step(alcohol_tachycardia, palpitations,
    'El alcohol produce palpitaciones por taquicardia sinusal refleja  -  el "holiday heart" es la FA precipitada por ingesta aguda de alcohol').
explain_step(alcohol_tachycardia, excess_alcohol,
    'La ingesta excesiva de alcohol es precipitante conocido de taquicardia sinusal y fibrilación auricular paroxística').
explain_step(alcohol_tachycardia, regular_rhythm,
    'Ritmo regular orienta a taquicardia sinusal antes que a FA  -  aunque el alcohol también puede precipitar FA').

% --- ventricular_ectopics ---
explain_step(ventricular_ectopics, palpitations,
    'Los latidos ectópicos se perciben como una sensación de "latido que se salta" o golpe fuerte en el pecho').
explain_step(ventricular_ectopics, irregular_rhythm,
    'Las extrasístoles producen irregularidad en el ritmo por latidos prematuros seguidos de pausa compensadora').
explain_step(ventricular_ectopics, missed_beats,
    'La sensación de "latido que falta" refleja la pausa postextrasistólica  -  el latido siguiente es más fuerte por mayor llenado ventricular').
explain_step(ventricular_ectopics, syncope,
    'La ausencia de síncope apoya el diagnóstico benigno de extrasistolia ventricular aislada en corazón sano').

% --- atrial_ectopics ---
explain_step(atrial_ectopics, palpitations,
    'Las extrasístoles auriculares producen palpitaciones irregulares percibidas como latidos extra o que se saltan').
explain_step(atrial_ectopics, irregular_rhythm,
    'La irregularidad refleja los latidos prematuros de origen auricular que interrumpen el ritmo sinusal normal').
explain_step(atrial_ectopics, missed_beats,
    'La pausa postextrasistólica se percibe como un "hueco" en el ritmo  -  típico de extrasistolia auricular').
explain_step(atrial_ectopics, chest_pain,
    'La ausencia de dolor torácico hace menos probable la isquemia como causa subyacente de las extrasístoles').

% --- atrial_fibrillation ---
explain_step(atrial_fibrillation, palpitations,
    'La fibrilación auricular produce palpitaciones irregulares y frecuentes por activación caótica de las aurículas').
explain_step(atrial_fibrillation, irregular_rhythm,
    'El ritmo irregularmente irregular es patognomónico de la FA  -  ninguna otra arritmia común produce este patrón').
explain_step(atrial_fibrillation, irregularly_irregular_pulse,
    'El pulso irregularmente irregular a la palpación confirma la FA  -  puede coexistir con déficit de pulso').
explain_step(atrial_fibrillation, dyspnoea,
    'La disnea en la FA refleja reducción del gasto cardíaco por pérdida de la contribución auricular al llenado ventricular').
explain_step(atrial_fibrillation, cardiac_history,
    'El antecedente cardíaco  -  valvulopatía, HTA, cardiopatía isquémica  -  es el principal factor predisponente de FA').

% --- svt ---
explain_step(svt, palpitations,
    'La TSV produce palpitaciones regulares de inicio y fin bruscos  -  frecuencia 150-250 lpm característica').
explain_step(svt, sudden_onset,
    'El inicio brusco "en un clic" es característico de la TSV por reentrada  -  contrasta con el inicio gradual de la taquicardia sinusal').
explain_step(svt, sudden_termination,
    'La terminación brusca es patognomónica de la TSV por reentrada  -  a veces se autolimita con maniobras vagales').
explain_step(svt, regular_rhythm,
    'El ritmo perfectamente regular a alta frecuencia diferencia la TSV de la FA y las extrasístoles').
explain_step(svt, dyspnoea,
    'La disnea acompaña a la TSV por la alta frecuencia cardíaca que reduce el llenado ventricular y el gasto cardíaco').
explain_step(svt, syncope,
    'La ausencia de síncope en la TSV típica la distingue de la taquicardia ventricular  -  el síncope sugiere TV o bloqueo').

% --- ventricular_tachycardia ---
explain_step(ventricular_tachycardia, palpitations,
    'La TV produce palpitaciones de inicio brusco con grave compromiso hemodinámico  -  emergencia cardíaca').
explain_step(ventricular_tachycardia, sudden_onset,
    'El inicio súbito con colapso hemodinámico inmediato es característico de la taquicardia ventricular sostenida').
explain_step(ventricular_tachycardia, syncope,
    'El síncope en el contexto de palpitaciones indica compromiso hemodinámico grave  -  signo de alarma de TV').
explain_step(ventricular_tachycardia, cardiac_history,
    'La cardiopatía estructural previa  -  IAM, miocardiopatía  -  es el substrato más común para la taquicardia ventricular').
explain_step(ventricular_tachycardia, chest_pain,
    'El dolor torácico durante la TV puede reflejar isquemia miocárdica desencadenada o coexistente con la arritmia').
explain_step(ventricular_tachycardia, ecg_abnormal,
    'El ECG anormal durante el episodio  -  complejos anchos, disociación AV  -  confirma el origen ventricular de la taquicardia').


/* ------------------------------------------------------------
   SECCIÓN 5 -- REGLAS DE EXCLUSIÓN
   ------------------------------------------------------------ */

% La taquicardia ventricular queda excluida si el ECG es normal
% durante el episodio y no hay cardiopatía de base.
exclude_if(ventricular_tachycardia,
           'ECG normal durante el episodio y sin cardiopatía estructural hacen la TV muy improbable') :-
    \+ finding(ecg_abnormal, yes),
    \+ symptom(cardiac_history, yes).

% La FA queda excluida si el ritmo es regular.
exclude_if(atrial_fibrillation,
           'Ritmo regular durante las palpitaciones excluye fibrilación auricular') :-
    symptom(regular_rhythm, yes).

% La TSV queda excluida si no hay inicio y fin bruscos.
exclude_if(svt,
           'Sin inicio ni terminación bruscos es improbable una taquicardia por reentrada') :-
    \+ symptom(sudden_onset, yes),
    \+ symptom(sudden_termination, yes).

