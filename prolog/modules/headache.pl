/* ============================================================
   MODULE: headache
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 207-211
   AUTHORS: <your names>
   SYSTEM:  Neurológico
   ============================================================ */

:- module(headache, [diagnose/2, frequency/2,
                     suggest_test/2, explain_step/3,
                     exclude_if/2]).

:- encoding(utf8).

/* ------------------------------------------------------------
   SECCIÓN 1 -- TABLA DE FRECUENCIAS
   Fuente: código de color de Churchill p.207
   🟢 común  🟡 ocasional  🔴 raro
   ------------------------------------------------------------ */

% AGUDA
frequency(subarachnoid_haemorrhage,    occasional). % 🟡
frequency(intracranial_haemorrhage,    occasional). % 🟡
frequency(systemic_infection,          common).     % 🟢
frequency(meningitis,                  occasional). % 🟡
frequency(acute_angle_closure_glaucoma,occasional). % 🟡

% CRÓNICA / RECURRENTE
frequency(tension_headache,            common).     % 🟢
frequency(migraine,                    common).     % 🟢
frequency(cluster_headache,            common).     % 🟢
frequency(cervical_spondylosis,        common).     % 🟢
frequency(raised_intracranial_pressure,occasional). % 🟡
frequency(temporal_arteritis,          occasional). % 🟡
frequency(severe_hypertension,         occasional). % 🟡
frequency(carbon_monoxide_poisoning,   rare).       % 🔴


/* ------------------------------------------------------------
   SECCIÓN 2 -- REGLAS DIAGNÓSTICAS
   ------------------------------------------------------------ */

% --- Hemorragia subaracnoidea ---
% Cefalea "en trueno": inicio súbito, la peor de su vida,
% rigidez de nuca, fotofobia. Emergencia neurovascular.
diagnose(subarachnoid_haemorrhage, Frequency) :-
    symptom(headache, yes),
    symptom(onset, sudden),
    symptom(neck_stiffness, yes),
    frequency(subarachnoid_haemorrhage, Frequency).

diagnose(subarachnoid_haemorrhage, Frequency) :-
    symptom(headache, yes),
    symptom(onset, sudden),
    symptom(photophobia, yes),
    symptom(nausea_vomiting, yes),
    \+ symptom(fever, yes),
    frequency(subarachnoid_haemorrhage, Frequency).

% --- Hemorragia / infarto intracraneal ---
% Inicio súbito con déficit neurológico focal.
diagnose(intracranial_haemorrhage, Frequency) :-
    symptom(headache, yes),
    symptom(onset, sudden),
    finding(focal_neurology, yes),
    frequency(intracranial_haemorrhage, Frequency).

% --- Infección sistémica ---
% Cefalea difusa con fiebre, inicio gradual,
% sin signos meníngeos ni déficit focal.
diagnose(systemic_infection, Frequency) :-
    symptom(headache, yes),
    symptom(fever, yes),
    symptom(onset, gradual),
    \+ symptom(neck_stiffness, yes),
    \+ finding(neck_stiffness_confirmed, yes),
    \+ finding(focal_neurology, yes),
    frequency(systemic_infection, Frequency).

% --- Meningitis ---
% Cefalea con fiebre, rigidez de nuca, fotofobia,
% posible exantema petequial en meningitis meningocócica.
diagnose(meningitis, Frequency) :-
    symptom(headache, yes),
    symptom(fever, yes),
    symptom(neck_stiffness, yes),
    finding(neck_stiffness_confirmed, yes),
    frequency(meningitis, Frequency).

diagnose(meningitis, Frequency) :-
    symptom(headache, yes),
    symptom(fever, yes),
    finding(petechial_rash, yes),
    frequency(meningitis, Frequency).

% --- Glaucoma agudo de ángulo cerrado ---
% Cefalea ocular aguda con trastorno visual,
% náusea, ojo rojo. Urgencia oftalmológica.
diagnose(acute_angle_closure_glaucoma, Frequency) :-
    symptom(headache, yes),
    symptom(onset, sudden),
    symptom(visual_disturbance, yes),
    symptom(nausea_vomiting, yes),
    \+ symptom(neck_stiffness, yes),
    frequency(acute_angle_closure_glaucoma, Frequency).

% --- Cefalea tensional ---
% Carácter opresivo en banda, bilateral, sin náusea ni aura,
% sin hallazgos neurológicos. La más frecuente de todas.
diagnose(tension_headache, Frequency) :-
    symptom(headache, yes),
    symptom(character, tight_band),
    symptom(location, bilateral),
    \+ symptom(neck_stiffness, yes),
    \+ symptom(fever, yes),
    \+ symptom(aura, yes),
    frequency(tension_headache, Frequency).

% --- Migraña ---
% Pulsátil, unilateral, con náusea/fotofobia, posible aura visual.
% Puede durar 4-72 horas.
diagnose(migraine, Frequency) :-
    symptom(headache, yes),
    symptom(character, throbbing),
    symptom(location, unilateral),
    symptom(nausea_vomiting, yes),
    frequency(migraine, Frequency).

diagnose(migraine, Frequency) :-
    symptom(headache, yes),
    symptom(aura, yes),
    symptom(photophobia, yes),
    symptom(nausea_vomiting, yes),
    frequency(migraine, Frequency).

% --- Cefalea en racimos ---
% Dolor retroorbitario unilateral severo, episódico,
% con lagrimeo y congestión nasal ipsilateral.
diagnose(cluster_headache, Frequency) :-
    symptom(headache, yes),
    symptom(character, throbbing),
    symptom(location, unilateral),
    symptom(visual_disturbance, yes),
    \+ symptom(aura, yes),
    \+ symptom(nausea_vomiting, yes),
    frequency(cluster_headache, Frequency).

% --- Cervical spondylosis ---
% Cefalea occipital crónica irradiada desde el cuello,
% empeora con movimientos cervicales.
diagnose(cervical_spondylosis, Frequency) :-
    symptom(headache, yes),
    symptom(location, occipital),
    symptom(onset, progressive),
    \+ symptom(fever, yes),
    \+ symptom(neck_stiffness, yes),
    frequency(cervical_spondylosis, Frequency).

% --- Hipertensión intracraneal ---
% Cefalea progresiva, peor por la mañana, empeora con la tos,
% papiledema. Sugiere lesión expansiva.
diagnose(raised_intracranial_pressure, Frequency) :-
    symptom(headache, yes),
    symptom(onset, progressive),
    symptom(worse_morning, yes),
    finding(papilloedema, yes),
    frequency(raised_intracranial_pressure, Frequency).

diagnose(raised_intracranial_pressure, Frequency) :-
    symptom(headache, yes),
    symptom(onset, progressive),
    symptom(worse_on_coughing, yes),
    finding(papilloedema, yes),
    frequency(raised_intracranial_pressure, Frequency).

diagnose(raised_intracranial_pressure, Frequency) :-
    symptom(headache, yes),
    symptom(onset, progressive),
    symptom(history_of_malignancy, yes),
    finding(focal_neurology, yes),
    frequency(raised_intracranial_pressure, Frequency).

% --- Arteritis temporal ---
% Cefalea temporal en >60 años, claudicación mandibular,
% arteria temporal dolorosa. Urgencia: riesgo de ceguera.
diagnose(temporal_arteritis, Frequency) :-
    symptom(headache, yes),
    symptom(location, temporal),
    symptom(jaw_claudication, yes),
    patient_age(Age), Age >= 60,
    frequency(temporal_arteritis, Frequency).

diagnose(temporal_arteritis, Frequency) :-
    symptom(headache, yes),
    symptom(location, temporal),
    finding(temporal_artery_tender, yes),
    patient_age(Age), Age >= 60,
    frequency(temporal_arteritis, Frequency).

% --- Hipertensión severa ---
% Cefalea occipital o difusa con TA muy elevada.
diagnose(severe_hypertension, Frequency) :-
    symptom(headache, yes),
    finding(bp_elevated, yes),
    \+ finding(focal_neurology, yes),
    \+ finding(papilloedema, yes),
    frequency(severe_hypertension, Frequency).

% --- Intoxicación por monóxido de carbono ---
% Cefalea difusa con historia de posible exposición,
% varios miembros del hogar afectados.
diagnose(carbon_monoxide_poisoning, Frequency) :-
    symptom(headache, yes),
    symptom(character, constant),
    symptom(nausea_vomiting, yes),
    \+ symptom(fever, yes),
    \+ symptom(neck_stiffness, yes),
    frequency(carbon_monoxide_poisoning, Frequency).


/* ------------------------------------------------------------
   SECCIÓN 3 -- ESTUDIOS RECOMENDADOS
   Fuente: Churchill's p.209-211
   ------------------------------------------------------------ */

suggest_test(subarachnoid_haemorrhage,    ct_head).
suggest_test(subarachnoid_haemorrhage,    lumbar_puncture).
suggest_test(subarachnoid_haemorrhage,    ct_angiography).
suggest_test(subarachnoid_haemorrhage,    fbc).

suggest_test(intracranial_haemorrhage,    ct_head).
suggest_test(intracranial_haemorrhage,    mri_head).
suggest_test(intracranial_haemorrhage,    fbc).

suggest_test(systemic_infection,          fbc).
suggest_test(systemic_infection,          esr_crp).
suggest_test(systemic_infection,          blood_cultures).

suggest_test(meningitis,                  ct_head).
suggest_test(meningitis,                  lumbar_puncture).
suggest_test(meningitis,                  blood_cultures).
suggest_test(meningitis,                  fbc).
suggest_test(meningitis,                  esr_crp).

suggest_test(acute_angle_closure_glaucoma, intraocular_pressure).
suggest_test(acute_angle_closure_glaucoma, slit_lamp_examination).

suggest_test(tension_headache,            clinical_diagnosis).
suggest_test(tension_headache,            fbc).

suggest_test(migraine,                    clinical_diagnosis).
suggest_test(migraine,                    ct_mri_head).

suggest_test(cluster_headache,            clinical_diagnosis).
suggest_test(cluster_headache,            mri_head).

suggest_test(cervical_spondylosis,        cervical_spine_xray).
suggest_test(cervical_spondylosis,        mri_cervical_spine).

suggest_test(raised_intracranial_pressure, ct_mri_head).
suggest_test(raised_intracranial_pressure, lumbar_puncture).
suggest_test(raised_intracranial_pressure, fbc).

suggest_test(temporal_arteritis,          esr_crp).
suggest_test(temporal_arteritis,          fbc).
suggest_test(temporal_arteritis,          temporal_artery_biopsy).

suggest_test(severe_hypertension,         bp_monitoring).
suggest_test(severe_hypertension,         uande).
suggest_test(severe_hypertension,         ecg).
suggest_test(severe_hypertension,         ct_head).

suggest_test(carbon_monoxide_poisoning,   carboxyhaemoglobin_level).
suggest_test(carbon_monoxide_poisoning,   abg).


/* ------------------------------------------------------------
   SECCIÓN 4 -- TRAZA DE DEMOSTRACIÓN
   ------------------------------------------------------------ */

% --- subarachnoid_haemorrhage ---
explain_step(subarachnoid_haemorrhage, headache,
    'La cefalea es el síntoma cardinal de la hemorragia subaracnoidea  -  descrita clásicamente como la peor cefalea de su vida').
explain_step(subarachnoid_haemorrhage, onset,
    'El inicio súbito en trueno refleja la explosión de sangre en el espacio subaracnoideo por ruptura de un aneurisma').
explain_step(subarachnoid_haemorrhage, neck_stiffness,
    'La rigidez de nuca resulta de la irritación meníngea por la sangre en el LCR  -  se desarrolla horas después del evento').
explain_step(subarachnoid_haemorrhage, photophobia,
    'La fotofobia refleja la irritación meníngea  -  signo de meningismo junto con la rigidez de nuca').
explain_step(subarachnoid_haemorrhage, nausea_vomiting,
    'La náusea y el vómito acompañan al inicio súbito por el aumento brusco de la presión intracraneal').

% --- intracranial_haemorrhage ---
explain_step(intracranial_haemorrhage, headache,
    'La cefalea de inicio súbito e intenso puede indicar hemorragia intracerebral por ruptura de vasos perforantes').
explain_step(intracranial_haemorrhage, onset,
    'El inicio súbito distingue la hemorragia intracraneal de otras causas progresivas de cefalea').
explain_step(intracranial_haemorrhage, focal_neurology,
    'El déficit neurológico focal indica lesión del parénquima cerebral  -  localiza el sitio de la hemorragia').

% --- systemic_infection ---
explain_step(systemic_infection, headache,
    'La cefalea difusa es un síntoma muy frecuente de infecciones sistémicas por el efecto de las citocinas proinflamatorias').
explain_step(systemic_infection, fever,
    'La fiebre indica respuesta inflamatoria sistémica a la infección  -  acompaña habitualmente la cefalea en este contexto').
explain_step(systemic_infection, onset,
    'El inicio gradual en horas es característico de las infecciones sistémicas  -  contrasta con el inicio súbito de la HSA').
explain_step(systemic_infection, neck_stiffness,
    'La ausencia de rigidez de nuca diferencia la infección sistémica de la meningitis  -  no hay irritación meníngea').
explain_step(systemic_infection, focal_neurology,
    'La ausencia de déficit neurológico focal confirma que no hay afectación del parénquima cerebral').

% --- meningitis ---
explain_step(meningitis, headache,
    'La cefalea intensa es el síntoma cardinal de la meningitis por inflamación de las meninges').
explain_step(meningitis, fever,
    'La fiebre refleja la respuesta inflamatoria a la infección bacteriana o viral de las meninges').
explain_step(meningitis, neck_stiffness,
    'La rigidez de nuca (meningismo) resulta de la inflamación de las meninges espinales  -  signo diagnóstico clave').
explain_step(meningitis, neck_stiffness_confirmed,
    'La confirmación de la rigidez de nuca en la exploración física aumenta la especificidad para meningitis').
explain_step(meningitis, petechial_rash,
    'El exantema petequial o purpúrico es patognomónico de la meningitis meningocócica  -  emergencia médica').

% --- acute_angle_closure_glaucoma ---
explain_step(acute_angle_closure_glaucoma, headache,
    'La cefalea intensa de localización ocular y periorbital es característica del glaucoma agudo de ángulo cerrado').
explain_step(acute_angle_closure_glaucoma, onset,
    'El inicio súbito refleja el aumento brusco de la presión intraocular por cierre del ángulo de drenaje').
explain_step(acute_angle_closure_glaucoma, visual_disturbance,
    'Los halos de colores alrededor de las luces y la visión borrosa resultan de la córnea edematosa por la hipertensión ocular').
explain_step(acute_angle_closure_glaucoma, nausea_vomiting,
    'La náusea y el vómito acompañan al dolor ocular intenso por estimulación vagal refleja').
explain_step(acute_angle_closure_glaucoma, neck_stiffness,
    'La ausencia de rigidez de nuca diferencia el glaucoma de la meningitis y la HSA').

% --- tension_headache ---
explain_step(tension_headache, headache,
    'La cefalea tensional es la forma más frecuente de cefalea  -  dolor de presión o tensión sin características migrañosas').
explain_step(tension_headache, character,
    'El carácter opresivo en banda alrededor de la cabeza es el descriptor clásico de la cefalea de tipo tensional').
explain_step(tension_headache, location,
    'La distribución bilateral distingue la cefalea tensional de la migraña, que es típicamente unilateral').
explain_step(tension_headache, neck_stiffness,
    'La ausencia de rigidez de nuca descarta meningitis y HSA como causa de la cefalea').
explain_step(tension_headache, fever,
    'La ausencia de fiebre excluye causas infecciosas como meningitis o infección sistémica').
explain_step(tension_headache, aura,
    'La ausencia de aura diferencia la cefalea tensional de la migraña con aura').

% --- migraine ---
explain_step(migraine, headache,
    'La migraña es una cefalea episódica recurrente con características clínicas específicas que la diferencian de otras cefaleas').
explain_step(migraine, character,
    'El carácter pulsátil refleja la vasodilatación de los vasos intracraneales durante la fase de cefalea migrañosa').
explain_step(migraine, location,
    'La localización unilateral (hemicránea) es característica de la migraña  -  puede alternar de lado entre episodios').
explain_step(migraine, nausea_vomiting,
    'La náusea y el vómito son síntomas acompañantes muy frecuentes de la migraña  -  parte de los criterios diagnósticos IHS').
explain_step(migraine, aura,
    'El aura precede a la cefalea en la migraña con aura  -  refleja la depresión cortical propagada de Leão').
explain_step(migraine, photophobia,
    'La fotofobia refleja la hipersensibilidad sensorial durante la fase de cefalea migrañosa').

% --- cluster_headache ---
explain_step(cluster_headache, headache,
    'La cefalea en racimos es el dolor de cabeza primario más intenso conocido  -  dolor retroorbitario devastador de inicio súbito').
explain_step(cluster_headache, character,
    'El carácter pulsátil intenso y retroorbitario diferencia la cefalea en racimos de otras cefaleas primarias').
explain_step(cluster_headache, location,
    'La localización estrictamente unilateral y retroorbitaria es característica definitoria de la cefalea en racimos').
explain_step(cluster_headache, visual_disturbance,
    'El ojo rojo e inyectado con lagrimeo ipsilateral resulta de la activación autonómica parasimpática  -  no es aura visual').
explain_step(cluster_headache, aura,
    'La ausencia de aura diferencia la cefalea en racimos de la migraña con aura').
explain_step(cluster_headache, nausea_vomiting,
    'La ausencia de náusea es un elemento diferenciador de la cefalea en racimos frente a la migraña').

% --- cervical_spondylosis ---
explain_step(cervical_spondylosis, headache,
    'La cefalea cervicogénica por espondiloartrosis cervical se origina en las articulaciones y nervios cervicales superiores').
explain_step(cervical_spondylosis, location,
    'La localización occipital refleja el origen en la columna cervical alta con irradiación hacia el occipucio').
explain_step(cervical_spondylosis, onset,
    'El inicio progresivo y crónico es típico de la espondiloartrosis cervical  -  empeora con los movimientos del cuello').
explain_step(cervical_spondylosis, neck_stiffness,
    'La ausencia de rigidez de nuca meníngea diferencia la espondiloartrosis de la meningitis').
explain_step(cervical_spondylosis, fever,
    'La ausencia de fiebre descarta causa infecciosa en esta cefalea de presentación crónica').

% --- raised_intracranial_pressure ---
explain_step(raised_intracranial_pressure, headache,
    'La hipertensión intracraneal causa cefalea por distensión de las estructuras sensibles al dolor  -  duramadre y vasos intracraneales').
explain_step(raised_intracranial_pressure, onset,
    'El inicio progresivo en días o semanas es el patrón temporal característico de las lesiones expansivas intracraneales').
explain_step(raised_intracranial_pressure, worse_morning,
    'El empeoramiento matutino de la cefalea refleja la acumulación de CO2 durante el sueño que aumenta la PIC').
explain_step(raised_intracranial_pressure, worse_on_coughing,
    'El empeoramiento con la tos o el Valsalva aumenta la presión intracraneal transitoriamente  -  signo de lesión expansiva').
explain_step(raised_intracranial_pressure, papilloedema,
    'El papiledema en la fundoscopia es el signo más específico de hipertensión intracraneal crónica').
explain_step(raised_intracranial_pressure, history_of_malignancy,
    'El antecedente de neoplasia conocida hace muy probable la metástasis cerebral como causa de la hipertensión intracraneal').
explain_step(raised_intracranial_pressure, focal_neurology,
    'El déficit neurológico focal indica afectación directa del parénquima cerebral por la lesión causal').

% --- temporal_arteritis ---
explain_step(temporal_arteritis, headache,
    'La cefalea temporal es el síntoma más frecuente de la arteritis de células gigantes  -  presente en >90% de los casos').
explain_step(temporal_arteritis, location,
    'La localización temporal corresponde a la inflamación de la arteria temporal superficial y sus ramas').
explain_step(temporal_arteritis, jaw_claudication,
    'La claudicación mandibular (dolor al masticar) es altamente específica de arteritis temporal  -  por isquemia de los músculos masticadores').
explain_step(temporal_arteritis, temporal_artery_tender,
    'La sensibilidad a la palpación de la arteria temporal confirma su inflamación  -  puede haber ausencia de pulso ipsilateral').

% --- severe_hypertension ---
explain_step(severe_hypertension, headache,
    'La cefalea hipertensiva ocurre con presiones muy elevadas (>180/110)  -  mecanismo por distensión de los vasos cerebrales').
explain_step(severe_hypertension, bp_elevated,
    'La presión arterial muy elevada confirmada en la exploración es el hallazgo diagnóstico definitorio').
explain_step(severe_hypertension, focal_neurology,
    'La ausencia de déficit neurológico focal diferencia la cefalea hipertensiva simple de la encefalopatía hipertensiva').
explain_step(severe_hypertension, papilloedema,
    'La ausencia de papiledema diferencia la cefalea hipertensiva de la encefalopatía hipertensiva grave').

% --- carbon_monoxide_poisoning ---
explain_step(carbon_monoxide_poisoning, headache,
    'La cefalea es el síntoma más frecuente de intoxicación por CO  -  por hipoxia tisular cerebral').
explain_step(carbon_monoxide_poisoning, character,
    'El carácter constante y opresivo difuso es típico de la intoxicación por CO  -  puede afectar a varios convivientes simultáneamente').
explain_step(carbon_monoxide_poisoning, nausea_vomiting,
    'La náusea y el vómito por hipoxia acompañan a la cefalea  -  clave diagnóstica: síntomas similares en varios miembros del hogar').
explain_step(carbon_monoxide_poisoning, fever,
    'La ausencia de fiebre diferencia la intoxicación por CO de las causas infecciosas de cefalea con náusea').
explain_step(carbon_monoxide_poisoning, neck_stiffness,
    'La ausencia de rigidez de nuca diferencia la intoxicación por CO de la meningitis y la HSA').


/* ------------------------------------------------------------
   SECCIÓN 5 -- REGLAS DE EXCLUSIÓN
   ------------------------------------------------------------ */

% La cefalea tensional y la migraña quedan excluidas cuando
% hay papiledema  -  debe descartarse primero hipertensión intracraneal.
exclude_if(tension_headache,
           'El papiledema indica hipertensión intracraneal  -  debe descartarse lesión expansiva antes de aceptar cefalea tensional') :-
    finding(papilloedema, yes).

exclude_if(migraine,
           'El papiledema indica hipertensión intracraneal  -  debe descartarse lesión expansiva antes de aceptar migraña') :-
    finding(papilloedema, yes).

% La arteritis temporal es muy improbable por debajo de 50 años.
exclude_if(temporal_arteritis,
           'La arteritis temporal es excepcional por debajo de los 50 años') :-
    patient_age(Age), Age < 50.

% La hipertensión severa no puede explicar la cefalea si no hay TA elevada.
exclude_if(severe_hypertension,
           'No hay hipertensión arterial objetiva  -  la presión arterial elevada es requisito indispensable') :-
    \+ finding(bp_elevated, yes).

