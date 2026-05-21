/* ============================================================
   MODULE: weight_loss
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 483-490
   AUTHORS: <your names>
   SYSTEM:  Systemic, Endocrine, Oncological

   DIAGNOSES TO ENCODE (from Churchill's):
   %   malignancy                             frequency: common
   %   depression                             frequency: common
   %   diabetes_mellitus                      frequency: common
   %   hyperthyroidism                        frequency: common
   %   malabsorption                          frequency: occasional
   %   copd                                   frequency: occasional
   %   heart_failure                          frequency: occasional
   %   tb                                     frequency: occasional
   %   hiv                                    frequency: occasional

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(weight_loss                   , Value)  -- type: yesno
   %   symptom(anorexia                      , Value)  -- type: yesno
   %   symptom(dysphagia                     , Value)  -- type: yesno
   %   symptom(change_in_bowel_habit         , Value)  -- type: yesno
   %   symptom(polyuria                      , Value)  -- type: yesno
   %   symptom(heat_intolerance              , Value)  -- type: yesno
   %   symptom(palpitations                  , Value)  -- type: yesno
   %   symptom(low_mood                      , Value)  -- type: yesno
   %   symptom(chronic_cough                 , Value)  -- type: yesno
   %   symptom(night_sweats                  , Value)  -- type: yesno
   %   symptom(risk_factors_hiv              , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(lymphadenopathy               , Value)  -- type: yesno
   %   finding(thyroid_enlargement           , Value)  -- type: yesno
   %   finding(abdominal_mass                , Value)  -- type: yesno
   %   finding(cachexia                      , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(weight_loss, [diagnose/2, frequency/2,
                   suggest_test/2, explain_step/3,
                   exclude_if/2]).

:- encoding(utf8).

/* ------------------------------------------------------------
   SECTION 1 -- FREQUENCY TABLE
   One fact per diagnosis. Values: common | occasional | rare
   Source: Churchill's colour coding for this presentation.
   ------------------------------------------------------------ */

frequency(malignancy                            ,  common).
frequency(cardiac_failure                       ,  common).
frequency(cr_disease                            ,  common).
frequency(renal_failure                         ,  common).
frequency(liver_failure                         ,  common).
frequency(depression                            ,  common).
frequency(diabetes_mellitus                     ,  common).
frequency(at_illness                            ,  common).
frequency(substance_abuse                       ,  common).
frequency(hyperthyroidism                       ,  occasional).
frequency(malabsorption                         ,  occasional).
frequency(cotd                                  ,  occasional).
frequency(anorexia_nervosa                      ,  occasional).
frequency(tb                                    ,  occasional).
frequency(hiv                                   ,  occasional).
frequency(addisons_disease                      ,  rare).
frequency(helminth_infection                    ,  rare).
frequency(poor_nutrition                        ,  rare).

/* ------------------------------------------------------------
   SECTION 2 -- DIAGNOSTIC RULES
   One diagnose/2 clause per distinct clinical picture.
   Each rule must end with:  frequency(Diagnosis, Frequency).
   ------------------------------------------------------------ */

% --- Systemic_Disease ---

diagnose(malignancy, Frequency) :-
    symptom(weight_loss, yes),
    symptom(change_in_bowel_habit, yes),
    frequency(malignancy, Frequency).

diagnose(malignancy, Frequency) :-
    symptom(weight_loss, yes),
    symptom(haemoptysis, yes),
    frequency(malignancy, Frequency).

diagnose(malignancy, Frequency) :-
    symptom(weight_loss, yes),
    symptom(blood_or_mucus_in_stool, yes),
    frequency(malignancy, Frequency).

diagnose(malignancy, Frequency) :-
    symptom(weight_loss, yes),
    symptom(tenesmus, yes) ; true ),
    frequency(malignancy, Frequency).

diagnose(cardiac_failure, Frequency) :-
    symptom(weight_loss, yes),
    symptom(dyspnoea, yes),
    ( symptom(orthopnoea, yes) ; symptom(paroxysmal_nocturnal_dyspnoea, yes) ),
    finding(peripheral_oedema, yes),
    finding(elevated_jvp, yes),
    frequency(cardiac_failure, Frequency).

diagnose(cr_disease, Frequency) :-
    symptom(weight_loss, yes),
    symptom(dyspnoea, yes),
    \+ symptom(orthopnoea, yes),
    \+ symptom(paroxysmal_nocturnal_dyspnoea, yes),
    frequency(cr_disease, Frequency).

diagnose(cotd, Frequency) :-
    symptom(weight_loss, yes),
    symptom(chronic_cough, yes),
    symptom(smoking_history, yes),
    finding(tachypnoea, yes),
    finding(joint_tenderness, yes),
    frequency(cotd, Frequency).

diagnose(renal_failure, Frequency) :-
    symptom(weight_loss, yes),
    symptom(lethargy, yes),
    symptom(polyuria, yes), 
    symptom(oliguria, yes), 
    symptom(nocturia, yes), 
    symptom(haematuria, yes),
    symptom(frothy_urine, yes),
    frequency(renal_failure, Frequency).

diagnose(malabsorption, Frequency) :-
    symptom(weight_loss, yes),
    symptom(lethargy, yes),
    symptom(diarrhoea, yes),
    symptom(steatorrhoea, yes),
    symptom(abdominal_discomfort, yes),
    frequency(malabsorption, Frequency).

diagnose(liver_failure, Frequency) :-
    symptom(weight_loss, yes),
    finding(jaundice, yes),
    symptom(dark_urine, yes),
    symptom(pale_stools, yes),
    finding(ascites, yes),
    frequency(liver_failure, Frequency).

% --- Endocrine ---

diagnose(diabetes_mellitus, Frequency) :-
    symptom(weight_loss, yes),
    symptom(polyuria, yes),
    symptom(polydipsia, yes),
    frequency(diabetes_mellitus, Frequency).

diagnose(hyperthyroidism, Frequency) :-
    symptom(weight_loss, yes),
    symptom(voracious_appetite, yes),
    symptom(heat_intolerance, yes),
    symptom(palpitations, yes),
    finding(thyroid_enlargement, yes),
    frequency(hyperthyroidism, Frequency).

diagnose(addisons_disease, Frequency) :-
    symptom(weight_loss, yes),
    symptom(anorexia, yes),
    symptom(syncope, yes),
    finding(postural_hypotension, yes),
    finding(skin_pigmentation, yes),
    frequency(addisons_disease, Frequency).

% --- Infective ---

diagnose(tb, Frequency) :-
    symptom(weight_loss, yes),
    symptom(chronic_cough, yes),
    symptom(haemoptysis, yes),
    symptom(night_sweats, yes),
    frequency(tb, Frequency).

diagnose(hiv, Frequency) :-
    symptom(weight_loss, yes),
    symptom(risk_factors_hiv, yes),
    finding(lymphadenopathy, yes),
    frequency(hiv, Frequency).

diagnose(helminth_infection, Frequency) :-
    symptom(weight_loss, yes),
    symptom(perianal_itching, yes),
    symptom(worms_in_faeces, yes),
    symptom(foreign_travel, yes),
    frequency(helminth_infection, Frequency).

% --- Psychiatric ---

diagnose(depression, Frequency) :-
    symptom(weight_loss, yes),
    symptom(low_mood, yes),
    symptom(loss_of_appetite, yes),
    frequency(depression, Frequency).

diagnose(anorexia_nervosa, Frequency) :-
    symptom(weight_loss, yes),
    symptom(distorted_body_image, yes),
    finding(cachexia, yes),
    frequency(anorexia_nervosa, Frequency).


% --- Other ---

diagnose(substance_abuse, Frequency) :-
    symptom(weight_loss, yes),
    symptom(intravenous_drug_use, yes),
    frequency(substance_abuse, Frequency).

diagnose(poor_nutrition, Frequency) :-
    symptom(weight_loss, yes),
    symptom(decreased_dietary_intake, yes),
    \+ symptom(low_mood, yes),
    frequency(poor_nutrition, Frequency).

diagnose(at_illness, Frequency) :-
    symptom(weight_loss, yes),
    symptom(arthritis, yes),
    symptom(early_morning_joint_stiffness, yes),
    finding(joint_tenderness, yes),
    frequency(at_illness, Frequency).


/* ------------------------------------------------------------
   SECTION 3 -- INVESTIGATIONS
   One suggest_test/2 fact per (diagnosis, test) pair.
   Source: Churchill's General and Specific Investigations sections.
   ------------------------------------------------------------ */

suggest_test(malignancy, esr_crp).
suggest_test(malignancy, cxr).
suggest_test(malignancy, faecal_occult_blood).
suggest_test(malignancy, colonoscopy).
suggest_test(malignancy, gastroscopy).
suggest_test(malignancy, us_abdomen).

suggest_test(diabetes_mellitus, urine_dipstick).
suggest_test(diabetes_mellitus, blood_glucose).

suggest_test(renal_failure, urine_dipstick).
suggest_test(renal_failure, fbc).
suggest_test(renal_failure, u_and_es).
suggest_test(renal_failure, us_abdomen).

suggest_test(liver_failure, fbc).
suggest_test(liver_failure, lfts).
suggest_test(liver_failure, clotting_screen).

suggest_test(cardiac_failure, echocardiography).

suggest_test(cr_disease, cxr).
suggest_test(cotd, cxr).
suggest_test(tb, cxr).

suggest_test(addisons_disease, u_and_es).
suggest_test(addisons_disease, short_synacthen_test).

suggest_test(hyperthyroidism, tsh_and_free_t4).

suggest_test(malabsorption, fbc).
suggest_test(malabsorption, faecal_fat_estimation).

suggest_test(at_illness, fbc).
suggest_test(at_illness, esr_crp).
suggest_test(at_illness, ana_and_rf).
suggest_test(at_illness, joint_x_rays).

suggest_test(helminth_infection, stool_cultures).

suggest_test(hiv, hiv_antibodies).

/* ------------------------------------------------------------
   SECTION 4 -- PROOF TRACE
   One explain_step/3 clause per symptom/finding each rule depends on.
   ------------------------------------------------------------ */

% --- weight loss (General) ---
explain_step(_, weight_loss,
    'La pérdida de peso no intencionada es el síntoma cardinal que exige investigación sistémica para descartar malignidad o falla orgánica').

% --- Malignancy ---
explain_step(malignancy, change_in_bowel_habit,
    'El cambio en los hábitos intestinales sugiere fuertemente una alteración local por posible tumor o masa gastrointestinal').
explain_step(malignancy, haemoptysis,
    'La erosión de vasos sanguíneos en las vías respiratorias es un rasgo clásico del carcinoma bronquial').
explain_step(malignancy, blood_or_mucus_in_stool,
    'Sangre o moco mezclado con heces indica una posible lesión o neoplasia gastrointestinal baja').
explain_step(malignancy, tenesmus,
    'El tenesmo es una manifestación local de irritación o de una masa ocupante en el recto').

% --- Cardiac failure ---
explain_step(cardiac_failure, dyspnoea,
    'La dificultad respiratoria sugiere congestión pulmonar de líquidos secundaria a insuficiencia cardíaca izquierda').
explain_step(cardiac_failure, orthopnoea,
    'La disnea al acostarse es un síntoma cardinal de insuficiencia cardíaca por el retorno venoso aumentado').
explain_step(cardiac_failure, paroxysmal_nocturnal_dyspnoea,
    'El despertar abrupto por disnea refleja la redistribución patológica de líquidos al estar en decúbito').
explain_step(cardiac_failure, peripheral_oedema,
    'El edema periférico es un signo claro de sobrecarga de volumen y fallo del corazón derecho').
explain_step(cardiac_failure, elevated_jvp,
    'La elevación de la presión venosa yugular es un hallazgo directo de fallo cardíaco congestivo o derecho').

% --- CR disease / COPD ---
explain_step(cr_disease, dyspnoea,
    'La disnea en reposo o al esfuerzo sin síntomas de fallo cardíaco apunta a limitación primaria pulmonar').
explain_step(cotd, chronic_cough,
    'La tos crónica productiva es una de las características definitorias clínicas de la EPOC').
explain_step(cotd, smoking_history,
    'Un historial largo de tabaquismo es el factor predisponente absoluto para el desarrollo de EPOC o carcinoma bronquial').
explain_step(cotd, tachypnoea,
    'La respiración con los labios fruncidos y taquipnea refleja el aumento del esfuerzo para vencer la obstrucción de la vía aérea').
explain_step(cotd, decreased_breath_sounds,
    'La disminución uniforme del murmullo vesicular es característica de la hiperinsuflación y destrucción alveolar en EPOC').

% --- Renal failure ---
explain_step(renal_failure, lethargy,
    'El letargo y fatiga generalizada forman parte clave del síndrome urémico').
explain_step(renal_failure, polyuria,
    'La incapacidad de los túbulos renales dañados para concentrar la orina provoca diuresis abundante inicial').
explain_step(renal_failure, oliguria,
    'En estadios avanzados o daño agudo grave, la tasa de filtración glomerular cae drásticamente').
explain_step(renal_failure, nocturia,
    'La pérdida del ritmo diurno normal de orina es un indicador precoz de daño en la capacidad de concentración').
explain_step(renal_failure, haematuria,
    'La sangre en orina indica inflamación, daño directo en los glomérulos o vía urinaria').
explain_step(renal_failure, frothy_urine,
    'La orina espumosa sugiere fuertemente pérdida de proteínas significativas (proteinuria) por filtración glomerular defectuosa').

% --- Liver failure ---
explain_step(liver_failure, jaundice,
    'La incapacidad del hígado para procesar y excretar la bilirrubina provoca ictericia clínica').
explain_step(liver_failure, dark_urine,
    'Ocurre por el paso de bilirrubina conjugada directamente a la sangre y luego a la orina por obstrucción o daño hepatocelular').
explain_step(liver_failure, pale_stools,
    'Indica la falta de excreción biliar de pigmentos al tracto gastrointestinal').
explain_step(liver_failure, ascites,
    'Resulta de la hipertensión portal y la hipoalbuminemia causadas por enfermedad y cirrosis hepática severa').

% --- Psychiatric ---
explain_step(depression, low_mood,
    'El bajo estado de ánimo sostenido es el criterio diagnóstico cardinal de los trastornos depresivos mayores').
explain_step(depression, loss_of_appetite,
    'La anhedonia o pérdida general de interés frecuentemente se extiende al acto de alimentarse, causando déficit calórico').
explain_step(anorexia_nervosa, distorted_body_image,
    'La percepción psicológica de obesidad a pesar de encontrarse en bajo peso extremo es patognomónica').
explain_step(anorexia_nervosa, cachexia,
    'Manifestación física de desnutrición extrema autoinducida').

% --- Endocrine ---
explain_step(diabetes_mellitus, polyuria,
    'La hiperglucemia excede el umbral renal, provocando diuresis osmótica sostenida').
explain_step(diabetes_mellitus, polydipsia,
    'Es una respuesta compensatoria neurológica (sed excesiva) ante la severa deshidratación ocasionada por poliuria').
explain_step(hyperthyroidism, voracious_appetite,
    'La reducción de peso ocurre clásicamente a pesar del aumento paradójico en la ingesta por el alto requerimiento calórico').
explain_step(hyperthyroidism, heat_intolerance,
    'Es consecuencia directa de la hipertermogénesis causada por el metabolismo basal muy acelerado').
explain_step(hyperthyroidism, palpitations,
    'Las hormonas tiroideas aumentan drásticamente el tono simpático y la sensibilidad cardíaca a las catecolaminas').
explain_step(hyperthyroidism, thyroid_enlargement,
    'El bocio es el hallazgo anatómico primario de una glándula hiperactiva y/o autoinmune').
explain_step(addisons_disease, anorexia,
    'La deficiencia de cortisol se acompaña consistentemente de anorexia profunda, fatiga y náuseas').
explain_step(addisons_disease, syncope,
    'El déficit crónico de aldosterona induce depleción de volumen profunda, predisponiendo a desmayos').
explain_step(addisons_disease, postural_hypotension,
    'La incapacidad para retener sodio y agua resulta en hipovolemia que se exacerba con los cambios de postura').
explain_step(addisons_disease, skin_pigmentation,
    'Resulta del aumento compensatorio de ACTH de la pituitaria, que estimula los melanocitos de la piel').

% --- Infections ---
explain_step(tb, chronic_cough,
    'Señal de afectación cavitaria persistente o inflamación del parénquima pulmonar por micobacterias').
explain_step(tb, haemoptysis,
    'Indica destrucción tisular o rotura vascular en el pulmón por infección tuberculosa activa').
explain_step(tb, night_sweats,
    'Rasgo clásico sistémico de infecciones crónicas y profunda liberación de citocinas pirógenas inflamatorias').
explain_step(hiv, risk_factors_hiv,
    'El contacto sexual sin protección y las drogas intravenosas son las principales vías epidemiológicas de exposición viral').
explain_step(hiv, lymphadenopathy,
    'La inflamación generalizada persistente de los ganglios es un signo característico de inmunodeficiencia progresiva').
explain_step(helminth_infection, perianal_itching,
    'Síntoma local clásico inducido por los parásitos, especialmente en infecciones por Enterobius o ascaris al defecar').
explain_step(helminth_infection, worms_in_faeces,
    'Evidencia directa de carga parasitaria macroscópica visible por el paciente').
explain_step(helminth_infection, foreign_travel,
    'El historial de viajes a zonas endémicas es un riesgo epidemiológico vital para patologías raras en occidente').

% --- Gastrointestinal / Autoimmune ---
explain_step(malabsorption, diarrhoea,
    'La presencia excesiva de sustrato osmótico en el colon arrastra agua, modificando el hábito intestinal').
explain_step(malabsorption, steatorrhoea,
    'El hallazgo de heces grasas indica fracaso bioquímico en la digestión o absorción de lípidos entéricos').
explain_step(malabsorption, abdominal_discomfort,
    'Causado por la distensión, flatulencia y gas provenientes de la fermentación bacteriana de nutrientes no absorbidos').
explain_step(at_illness, arthritis,
    'La afectación simétrica articular es la manifestación de debut característica del tejido conectivo (ej. Artritis Reumatoide)').
explain_step(at_illness, early_morning_joint_stiffness,
    'El patrón matutino es un marcador cardinal de etiología inflamatoria por acumulo de edema intraarticular en reposo').
explain_step(at_illness, joint_tenderness,
    'Confirma clínicamente actividad de sinovitis inflamatoria').

% --- Other ---
explain_step(substance_abuse, intravenous_drug_use,
    'Indica riesgo por exposición a patógenos sanguíneos, estado de desnutrición concomitante y estilos de vida marginales').
explain_step(poor_nutrition, decreased_dietary_intake,
    'Es la causa pura de pérdida de peso por un desbalance energético sin factores orgánicos subyacentes activos').

/* ------------------------------------------------------------
   SECTION 5 -- EXCLUSION RULES  (optional but encouraged)
   ------------------------------------------------------------ */

exclude_if(diabetes_mellitus,
           'Niveles consistentes de glucosa < 11.1 mmol/L en sangre descartan diagnóstico de diabetes') :-
    finding(blood_glucose_elevated, no).

exclude_if(hyperthyroidism,
           'Pruebas de TSH y T4 libres en rangos de laboratorio normales excluyen patología tiroidea activa') :-
    finding(tsh_and_t4_abnormal, no).

exclude_if(addisons_disease,
           'Aumento normal de cortisol plasmático (Test de Synacthen) excluye insuficiencia suprarrenal primaria') :-
    finding(synacthen_test_abnormal, no).

exclude_if(hiv,
           'Ausencia confirmada de anticuerpos VIH fuera del periodo ventana excluye infección') :-
    finding(hiv_antibodies_positive, no).

exclude_if(cardiac_failure,
           'Ecocardiograma confirmando función sistólica/diastólica y estructura normal descarta falla de bomba') :-
    finding(echocardiography_abnormal, no).