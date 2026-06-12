/* ============================================================
   MODULE: syncope
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 427-430
   AUTHORS: <your names>
   SYSTEM:  Cardiovascular
   ============================================================ */

:- module(syncope, [diagnose/2, frequency/2,
                    suggest_test/2, explain_step/3,
                    exclude_if/2]).

:- encoding(utf8).

/* ------------------------------------------------------------
   SECCIÓN 1 -- TABLA DE FRECUENCIAS
   Fuente: código de color de Churchill p.427
   🟢 común  🟡 ocasional  🔴 raro
   ------------------------------------------------------------ */

% CARDIOVASCULAR — Vasovagal
frequency(situational_syncope,         common).     % 🟢
frequency(micturition_syncope,         occasional). % 🟡
frequency(cough_syncope,               occasional). % 🟡

% CARDIOVASCULAR — Orthostatic hypotension
frequency(orthostatic_hypotension,     common).     % 🟢
frequency(drug_induced_hypotension,    common).     % 🟢
frequency(hypovolaemic_syncope,        common).     % 🟢
frequency(autonomic_failure,           occasional). % 🟡

% CARDIOVASCULAR — Arrhythmia
frequency(svt_syncope,                 common).     % 🟢
frequency(ventricular_tachycardia_syncope, common). % 🟢
frequency(sick_sinus_syndrome,         occasional). % 🟡
frequency(stokes_adams,                rare).       % 🔴

% CARDIOVASCULAR — Structural
frequency(myocardial_infarction_syncope, common).   % 🟢
frequency(pulmonary_embolism_syncope,  common).     % 🟢
frequency(cardiac_outflow_obstruction, occasional). % 🟡

% NEUROLOGICAL
frequency(seizure,                     common).     % 🟢

% METABOLIC
frequency(hypoxia_syncope,             common).     % 🟢
frequency(hypoglycaemia_syncope,       occasional). % 🟡


/* ------------------------------------------------------------
   SECCIÓN 2 -- REGLAS DIAGNÓSTICAS
   ------------------------------------------------------------ */

% --- Síncope situacional (vasovagal) ---
% El "desmayo común": precipitado por dolor, emoción, posición
% prolongada. Pródromos de náusea y visión borrosa.
diagnose(situational_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(precipitating_factor, yes),
    symptom(prodrome, yes),
    \+ symptom(palpitations_preceding, yes),
    frequency(situational_syncope, Frequency).

% --- Síncope miccional ---
diagnose(micturition_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(syncope_during_micturition, yes),
    frequency(micturition_syncope, Frequency).

% --- Síncope por tos ---
diagnose(cough_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(syncope_during_coughing, yes),
    frequency(cough_syncope, Frequency).

% --- Hipotensión ortostática ---
% Caída de TA ≥20 mmHg al ponerse de pie, con mareo o síncope.
diagnose(orthostatic_hypotension, Frequency) :-
    symptom(syncope, yes),
    symptom(syncope_on_standing, yes),
    finding(postural_bp_drop, yes),
    frequency(orthostatic_hypotension, Frequency).

% --- Hipotensión por fármacos ---
diagnose(drug_induced_hypotension, Frequency) :-
    symptom(syncope, yes),
    symptom(syncope_on_standing, yes),
    symptom(antihypertensive_use, yes),
    frequency(drug_induced_hypotension, Frequency).

% --- Síncope hipovolémico ---
diagnose(hypovolaemic_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(recent_haemorrhage, yes),
    finding(postural_bp_drop, yes),
    frequency(hypovolaemic_syncope, Frequency).

% --- Fallo autonómico ---
diagnose(autonomic_failure, Frequency) :-
    symptom(syncope, yes),
    symptom(syncope_on_standing, yes),
    symptom(diabetes, yes),
    finding(postural_bp_drop, yes),
    frequency(autonomic_failure, Frequency).

% --- Síncope por TSV ---
diagnose(svt_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(palpitations_preceding, yes),
    symptom(sudden_onset, yes),
    \+ symptom(chest_pain, yes),
    finding(tachycardia_on_examination, yes),
    frequency(svt_syncope, Frequency).

% --- Síncope por TV ---
diagnose(ventricular_tachycardia_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(palpitations_preceding, yes),
    symptom(cardiac_history, yes),
    finding(ecg_abnormal, yes),
    frequency(ventricular_tachycardia_syncope, Frequency).

% --- Síndrome del seno enfermo ---
diagnose(sick_sinus_syndrome, Frequency) :-
    symptom(syncope, yes),
    symptom(palpitations_preceding, yes),
    finding(bradycardia_on_examination, yes),
    frequency(sick_sinus_syndrome, Frequency).

% --- Crisis de Stokes-Adams ---
% Bloqueo AV completo transitorio con asistolia breve.
diagnose(stokes_adams, Frequency) :-
    symptom(syncope, yes),
    symptom(no_prodrome, yes),
    finding(bradycardia_on_examination, yes),
    finding(ecg_abnormal, yes),
    frequency(stokes_adams, Frequency).

% --- IAM con síncope ---
diagnose(myocardial_infarction_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(chest_pain, yes),
    finding(ecg_abnormal, yes),
    frequency(myocardial_infarction_syncope, Frequency).

% --- TEP con síncope ---
diagnose(pulmonary_embolism_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(dyspnoea, yes),
    symptom(pleuritic_pain, yes),
    frequency(pulmonary_embolism_syncope, Frequency).

% --- Obstrucción del tracto de salida ---
% Estenosis aórtica o MCHO: síncope de esfuerzo.
diagnose(cardiac_outflow_obstruction, Frequency) :-
    symptom(syncope, yes),
    symptom(syncope_on_exertion, yes),
    finding(ejection_systolic_murmur, yes),
    frequency(cardiac_outflow_obstruction, Frequency).

% --- Crisis convulsiva ---
% No es síncope verdadero pero se presenta igual;
% pródromos de aura, movimientos tónicos/clónicos, fase posictal.
diagnose(seizure, Frequency) :-
    symptom(syncope, yes),
    symptom(convulsive_movements, yes),
    symptom(postictal_confusion, yes),
    frequency(seizure, Frequency).

diagnose(seizure, Frequency) :-
    symptom(syncope, yes),
    symptom(tongue_biting, yes),
    symptom(incontinence, yes),
    frequency(seizure, Frequency).

% --- Hipoxia ---
diagnose(hypoxia_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(dyspnoea, yes),
    finding(oxygen_saturation_low, yes),
    frequency(hypoxia_syncope, Frequency).

% --- Hipoglucemia ---
diagnose(hypoglycaemia_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(diabetes, yes),
    finding(blood_glucose_low, yes),
    frequency(hypoglycaemia_syncope, Frequency).

diagnose(hypoglycaemia_syncope, Frequency) :-
    symptom(syncope, yes),
    symptom(excess_alcohol, yes),
    finding(blood_glucose_low, yes),
    frequency(hypoglycaemia_syncope, Frequency).


/* ------------------------------------------------------------
   SECCIÓN 3 -- ESTUDIOS RECOMENDADOS
   Fuente: Churchill's p.429-430
   ------------------------------------------------------------ */

suggest_test(situational_syncope,             ecg).
suggest_test(situational_syncope,             tilt_table_test).
suggest_test(situational_syncope,             fbc).

suggest_test(micturition_syncope,             ecg).
suggest_test(micturition_syncope,             bp_lying_standing).

suggest_test(cough_syncope,                   ecg).
suggest_test(cough_syncope,                   cxr).

suggest_test(orthostatic_hypotension,         bp_lying_standing).
suggest_test(orthostatic_hypotension,         ecg).
suggest_test(orthostatic_hypotension,         fbc).
suggest_test(orthostatic_hypotension,         urea_and_electrolytes).

suggest_test(drug_induced_hypotension,        bp_lying_standing).
suggest_test(drug_induced_hypotension,        ecg).
suggest_test(drug_induced_hypotension,        medication_review).

suggest_test(hypovolaemic_syncope,            fbc).
suggest_test(hypovolaemic_syncope,            urea_and_electrolytes).
suggest_test(hypovolaemic_syncope,            bp_lying_standing).

suggest_test(autonomic_failure,               bp_lying_standing).
suggest_test(autonomic_failure,               autonomic_function_tests).
suggest_test(autonomic_failure,               ecg).

suggest_test(svt_syncope,                     ecg).
suggest_test(svt_syncope,                     ambulatory_ecg).
suggest_test(svt_syncope,                     echocardiography).
suggest_test(svt_syncope,                     electrophysiology_study).

suggest_test(ventricular_tachycardia_syncope, ecg).
suggest_test(ventricular_tachycardia_syncope, ambulatory_ecg).
suggest_test(ventricular_tachycardia_syncope, echocardiography).
suggest_test(ventricular_tachycardia_syncope, cardiac_mri).

suggest_test(sick_sinus_syndrome,             ecg).
suggest_test(sick_sinus_syndrome,             ambulatory_ecg).
suggest_test(sick_sinus_syndrome,             electrophysiology_study).

suggest_test(stokes_adams,                    ecg).
suggest_test(stokes_adams,                    ambulatory_ecg).
suggest_test(stokes_adams,                    electrophysiology_study).

suggest_test(myocardial_infarction_syncope,   ecg).
suggest_test(myocardial_infarction_syncope,   troponin).
suggest_test(myocardial_infarction_syncope,   echocardiography).

suggest_test(pulmonary_embolism_syncope,      ctpa).
suggest_test(pulmonary_embolism_syncope,      d_dimer).
suggest_test(pulmonary_embolism_syncope,      ecg).

suggest_test(cardiac_outflow_obstruction,     echocardiography).
suggest_test(cardiac_outflow_obstruction,     ecg).
suggest_test(cardiac_outflow_obstruction,     cardiac_mri).

suggest_test(seizure,                         eeg).
suggest_test(seizure,                         ct_mri_head).
suggest_test(seizure,                         urea_and_electrolytes).
suggest_test(seizure,                         blood_glucose).

suggest_test(hypoxia_syncope,                 abg).
suggest_test(hypoxia_syncope,                 cxr).
suggest_test(hypoxia_syncope,                 ecg).

suggest_test(hypoglycaemia_syncope,           blood_glucose).
suggest_test(hypoglycaemia_syncope,           fbc).
suggest_test(hypoglycaemia_syncope,           lfts).


/* ------------------------------------------------------------
   SECCIÓN 4 -- TRAZA DE DEMOSTRACIÓN
   ------------------------------------------------------------ */

% --- situational_syncope ---
explain_step(situational_syncope, syncope,
    'El síncope vasovagal situacional es la causa más frecuente de pérdida de conciencia transitoria en adultos jóvenes').
explain_step(situational_syncope, precipitating_factor,
    'Un desencadenante identificable  -  dolor, emoción, calor, posición prolongada  -  es característico del síncope vasovagal').
explain_step(situational_syncope, prodrome,
    'Los pródromos de náusea, sudoración y visión borrosa reflejan la activación vagal previa a la pérdida de conciencia').
explain_step(situational_syncope, palpitations_preceding,
    'La ausencia de palpitaciones previas diferencia el síncope vasovagal de las arritmias como causa del episodio').

% --- micturition_syncope ---
explain_step(micturition_syncope, syncope,
    'El síncope miccional ocurre típicamente al levantarse por la noche a orinar  -  por vasodilatación e hipotensión refleja').
explain_step(micturition_syncope, syncope_during_micturition,
    'La asociación directa con el acto de la micción es patognomónica  -  reflejos vagales durante el vaciado vesical').

% --- cough_syncope ---
explain_step(cough_syncope, syncope,
    'El síncope por tos resulta del aumento de la presión intratorácica que reduce el retorno venoso y el gasto cardíaco').
explain_step(cough_syncope, syncope_during_coughing,
    'La coincidencia exacta del síncope con los accesos de tos define este síndrome  -  más frecuente en pacientes con EPOC').

% --- orthostatic_hypotension ---
explain_step(orthostatic_hypotension, syncope,
    'La hipotensión ortostática produce síncope por caída del flujo cerebral al adoptar la posición erecta').
explain_step(orthostatic_hypotension, syncope_on_standing,
    'La relación temporal con ponerse de pie es la clave diagnóstica de la hipotensión ortostática').
explain_step(orthostatic_hypotension, postural_bp_drop,
    'Una caída ≥20 mmHg de la TA sistólica al ponerse de pie confirma la hipotensión ortostática').

% --- drug_induced_hypotension ---
explain_step(drug_induced_hypotension, syncope,
    'Los antihipertensivos pueden producir hipotensión excesiva con síncope, especialmente al iniciar o aumentar la dosis').
explain_step(drug_induced_hypotension, syncope_on_standing,
    'El síncope al incorporarse es el patrón típico de la hipotensión ortostática farmacológica').
explain_step(drug_induced_hypotension, antihypertensive_use,
    'El uso de antihipertensivos, diuréticos u opioides es la causa más frecuente de hipotensión ortostática en ancianos').

% --- hypovolaemic_syncope ---
explain_step(hypovolaemic_syncope, syncope,
    'La hipovolemia reduce el retorno venoso y el gasto cardíaco, precipitando síncope por hipoperfusión cerebral').
explain_step(hypovolaemic_syncope, recent_haemorrhage,
    'La hemorragia reciente es la causa más frecuente de hipovolemia aguda  -  siempre buscar una fuente de sangrado').
explain_step(hypovolaemic_syncope, postural_bp_drop,
    'La caída postural de TA confirma el déficit de volumen circulante como mecanismo del síncope').

% --- autonomic_failure ---
explain_step(autonomic_failure, syncope,
    'La neuropatía autonómica impide la vasoconstricción refleja al incorporarse, produciendo hipotensión ortostática y síncope').
explain_step(autonomic_failure, syncope_on_standing,
    'El síncope al adoptar la posición erecta es el síntoma cardinal del fallo autonómico').
explain_step(autonomic_failure, diabetes,
    'La diabetes mellitus es la causa más frecuente de neuropatía autonómica  -  afecta los reflejos barorreceptores').
explain_step(autonomic_failure, postural_bp_drop,
    'La caída postural de TA confirma el fallo de los mecanismos autonómicos de compensación vascular').

% --- svt_syncope ---
explain_step(svt_syncope, syncope,
    'La TSV puede producir síncope si la frecuencia es tan elevada que el gasto cardíaco cae por insuficiente llenado ventricular').
explain_step(svt_syncope, palpitations_preceding,
    'Las palpitaciones regulares a alta frecuencia que preceden al síncope orientan a TSV como causa arrítmica').
explain_step(svt_syncope, sudden_onset,
    'El inicio brusco "en un clic" es característico de la TSV por reentrada').
explain_step(svt_syncope, chest_pain,
    'La ausencia de dolor torácico diferencia la TSV del IAM como causa del síncope arrítmico').
explain_step(svt_syncope, tachycardia_on_examination,
    'La taquicardia regular a alta frecuencia en la exploración durante o tras el episodio confirma el origen supraventricular').

% --- ventricular_tachycardia_syncope ---
explain_step(ventricular_tachycardia_syncope, syncope,
    'La TV produce síncope por colapso hemodinámico brusco  -  emergencia cardíaca con riesgo de muerte súbita').
explain_step(ventricular_tachycardia_syncope, palpitations_preceding,
    'Las palpitaciones previas al síncope en un paciente con cardiopatía deben hacer sospechar TV hasta demostrar lo contrario').
explain_step(ventricular_tachycardia_syncope, cardiac_history,
    'La cardiopatía estructural previa es el sustrato más común para la TV sostenida y el síncope arrítmico grave').
explain_step(ventricular_tachycardia_syncope, ecg_abnormal,
    'El ECG anormal con complejos anchos o QT largo sugiere origen ventricular de la taquicardia').

% --- sick_sinus_syndrome ---
explain_step(sick_sinus_syndrome, syncope,
    'El síndrome del seno enfermo produce síncope por pausas sinusales prolongadas o alternancia de taqui-bradicardia').
explain_step(sick_sinus_syndrome, palpitations_preceding,
    'Las palpitaciones alternantes con bradicardia son típicas del síndrome taqui-bradi del seno enfermo').
explain_step(sick_sinus_syndrome, bradycardia_on_examination,
    'La bradicardia sinusal inapropiada o las pausas en el ECG confirman la disfunción del nodo sinusal').

% --- stokes_adams ---
explain_step(stokes_adams, syncope,
    'La crisis de Stokes-Adams resulta de asistolia transitoria por bloqueo AV completo  -  recuperación rápida y espontánea').
explain_step(stokes_adams, no_prodrome,
    'La ausencia de pródromos distingue la crisis de Stokes-Adams del síncope vasovagal  -  la pérdida es brusca sin aviso').
explain_step(stokes_adams, bradycardia_on_examination,
    'La bradicardia extrema o el pulso ausente durante el episodio refleja la asistolia por bloqueo AV completo').
explain_step(stokes_adams, ecg_abnormal,
    'El ECG con bloqueo AV de segundo o tercer grado confirma el sustrato arrítmico de las crisis de Stokes-Adams').

% --- myocardial_infarction_syncope ---
explain_step(myocardial_infarction_syncope, syncope,
    'El IAM puede producir síncope por arritmia, hipotensión o bloqueo AV agudo  -  siempre descartar en síncope con dolor torácico').
explain_step(myocardial_infarction_syncope, chest_pain,
    'El dolor torácico asociado al síncope es una combinación de alta gravedad que requiere descarte urgente de IAM').
explain_step(myocardial_infarction_syncope, ecg_abnormal,
    'Los cambios isquémicos en el ECG  -  elevación del ST, bloqueo de rama nuevo  -  confirman el IAM como causa del síncope').

% --- pulmonary_embolism_syncope ---
explain_step(pulmonary_embolism_syncope, syncope,
    'El TEP masivo produce síncope por obstrucción aguda del tracto de salida del ventrículo derecho e hipotensión grave').
explain_step(pulmonary_embolism_syncope, dyspnoea,
    'La disnea es el síntoma más frecuente del TEP  -  su asociación con síncope sugiere TEP masivo de alto riesgo').
explain_step(pulmonary_embolism_syncope, pleuritic_pain,
    'El dolor pleurítico refleja infarto pulmonar periférico  -  su presencia junto con síncope orienta a TEP').

% --- cardiac_outflow_obstruction ---
explain_step(cardiac_outflow_obstruction, syncope,
    'La obstrucción del tracto de salida  -  estenosis aórtica, MCHO  -  produce síncope de esfuerzo por incapacidad de aumentar el gasto cardíaco').
explain_step(cardiac_outflow_obstruction, syncope_on_exertion,
    'El síncope específicamente durante el esfuerzo es el patrón clásico de la obstrucción fija o dinámica del tracto de salida').
explain_step(cardiac_outflow_obstruction, ejection_systolic_murmur,
    'El soplo sistólico eyectivo irradiado a carótidas  -  estenosis aórtica  -  o mesosistólico  -  MCHO  -  confirma la obstrucción').

% --- seizure ---
explain_step(seizure, syncope,
    'La crisis convulsiva puede simular un síncope  -  la pérdida de conciencia brusca puede confundirse con síncope cardíaco').
explain_step(seizure, convulsive_movements,
    'Los movimientos tónico-clónicos durante el episodio orientan fuertemente hacia una crisis epiléptica').
explain_step(seizure, postictal_confusion,
    'La confusión posictal prolongada (>5 min) diferencia la crisis epiléptica del síncope  -  en el síncope la recuperación es rápida').
explain_step(seizure, tongue_biting,
    'El mordedura de lengua lateral es altamente específica de crisis convulsiva  -  no ocurre en el síncope verdadero').
explain_step(seizure, incontinence,
    'La incontinencia urinaria durante el episodio sugiere crisis epiléptica  -  aunque puede ocurrir en síncopes graves').

% --- hypoxia_syncope ---
explain_step(hypoxia_syncope, syncope,
    'La hipoxia grave produce síncope por disminución del aporte de oxígeno al cerebro').
explain_step(hypoxia_syncope, dyspnoea,
    'La disnea severa asociada al síncope orienta a hipoxia como mecanismo  -  buscar causa pulmonar subyacente').
explain_step(hypoxia_syncope, oxygen_saturation_low,
    'La saturación de oxígeno baja confirma la hipoxia como mecanismo del síncope  -  tratamiento con oxigenoterapia urgente').

% --- hypoglycaemia_syncope ---
explain_step(hypoglycaemia_syncope, syncope,
    'La hipoglucemia produce síncope por privación de glucosa al cerebro  -  habitualmente con pródromos de sudoración y temblor').
explain_step(hypoglycaemia_syncope, diabetes,
    'La diabetes insulinotratada es la causa más frecuente de hipoglucemia grave con síncope').
explain_step(hypoglycaemia_syncope, excess_alcohol,
    'El exceso de alcohol inhibe la gluconeogénesis hepática y puede producir hipoglucemia grave con síncope incluso en no diabéticos').
explain_step(hypoglycaemia_syncope, blood_glucose_low,
    'La glucemia baja confirmada (<2.5 mmol/L) establece la hipoglucemia como causa del síncope').


/* ------------------------------------------------------------
   SECCIÓN 5 -- REGLAS DE EXCLUSIÓN
   ------------------------------------------------------------ */

% Síncope de esfuerzo sin soplo excluye obstrucción de tracto de salida.
exclude_if(cardiac_outflow_obstruction,
           'Sin soplo sistólico eyectivo es improbable la obstrucción del tracto de salida') :-
    \+ finding(ejection_systolic_murmur, yes).

% Crisis de Stokes-Adams excluida sin bradicardia ni ECG anormal.
exclude_if(stokes_adams,
           'Sin bradicardia ni anomalía en ECG es improbable el bloqueo AV completo transitorio') :-
    \+ finding(bradycardia_on_examination, yes),
    \+ finding(ecg_abnormal, yes).

% TV excluida sin cardiopatía ni ECG anormal.
exclude_if(ventricular_tachycardia_syncope,
           'Sin cardiopatía estructural ni ECG anormal la TV es una causa improbable de síncope') :-
    \+ symptom(cardiac_history, yes),
    \+ finding(ecg_abnormal, yes).

% Hipoglucemia excluida sin glucemia baja.
exclude_if(hypoglycaemia_syncope,
           'Sin glucemia baja confirmada no se puede atribuir el síncope a hipoglucemia') :-
    \+ finding(blood_glucose_low, yes).

