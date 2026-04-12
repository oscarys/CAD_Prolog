/* ============================================================
   MODULE: chest_pain
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor  -  Elsevier 2010, p. 57-61
   AUTHORS: Teaching team (reference implementation)

   This is the WORKED EXAMPLE. Read every predicate carefully before
   writing your own module. The style, naming conventions and structure
   here are the standard for the whole knowledge base.
   ============================================================ */

:- module(chest_pain, [diagnose/2, frequency/2,
                        suggest_test/2, explain_step/3,
                        exclude_if/2]).

:- encoding(utf8).

/* ------------------------------------------------------------
   FREQUENCY TABLE
   Source: Churchill's colour coding (green=common, orange=occasional, red=rare)
   Define this first  -  diagnose/2 rules call frequency/2 at the end.
   ------------------------------------------------------------ */

frequency(angina,                common).
frequency(myocardial_infarction, common).
frequency(reflux_oesophagitis,   common).
frequency(costochondritis,       common).
frequency(pericarditis,          occasional).
frequency(aortic_dissection,     occasional).
frequency(oesophageal_spasm,     occasional).
frequency(peptic_ulcer,          occasional).
frequency(pneumonia,             occasional).
frequency(pneumothorax,          occasional).
frequency(pulmonary_embolism,    occasional).
frequency(herpes_zoster,         occasional).
frequency(depression,            occasional).
frequency(rib_metastasis,        rare).


/* ------------------------------------------------------------
   DIAGNOSTIC RULES
   Pattern:  diagnose(Diagnosis, Frequency) :- <symptom checks>, frequency(...).
   Each clause encodes one distinct clinical picture from Churchill's.
   ------------------------------------------------------------ */

% --- Cardiovascular ---

diagnose(angina, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, crushing),
    symptom(exertional, yes),
    % Angina episodes are typically brief (<20 min); use if-then to handle
    % cases where duration was not reported (symptom absent = don't exclude)
    ( symptom(pain_duration_minutes, D) -> D < 20 ; true ),
    frequency(angina, Frequency).

diagnose(myocardial_infarction, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, crushing),
    symptom(exertional, no),
    symptom(pain_duration_minutes, D),
    D >= 20,
    frequency(myocardial_infarction, Frequency).

diagnose(myocardial_infarction, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, crushing),
    symptom(radiation_to_arm, yes),
    symptom(sweating, yes),
    frequency(myocardial_infarction, Frequency).

diagnose(pericarditis, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_location, central),
    symptom(pleuritic, yes),
    symptom(relieved_by_sitting_forward, yes),
    frequency(pericarditis, Frequency).

diagnose(aortic_dissection, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, tearing),
    symptom(radiation_to_back, yes),
    frequency(aortic_dissection, Frequency).

% --- Gastrointestinal ---

diagnose(reflux_oesophagitis, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, burning),
    symptom(worse_on_bending_or_lying, yes),
    symptom(relieved_by_antacids, yes),
    frequency(reflux_oesophagitis, Frequency).

diagnose(oesophageal_spasm, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, crushing),
    symptom(exertional, no),
    symptom(relieved_by_gtn, yes),
    \+ symptom(relieved_by_antacids, yes),
    frequency(oesophageal_spasm, Frequency).

diagnose(peptic_ulcer, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, gnawing),
    symptom(pain_location, epigastric),
    frequency(peptic_ulcer, Frequency).

% --- Pulmonary ---

diagnose(pneumonia, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pleuritic, yes),
    symptom(cough, yes),
    symptom(fever, yes),
    frequency(pneumonia, Frequency).

diagnose(pneumothorax, Frequency) :-
    symptom(chest_pain, yes),
    symptom(sudden_onset, yes),
    symptom(dyspnoea, yes),
    finding(breath_sounds_reduced_unilateral, yes),
    frequency(pneumothorax, Frequency).

diagnose(pulmonary_embolism, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pleuritic, yes),
    symptom(dyspnoea, yes),
    ( symptom(haemoptysis, yes) ; finding(dvt_signs, yes) ),
    frequency(pulmonary_embolism, Frequency).

% --- Musculoskeletal ---

diagnose(costochondritis, Frequency) :-
    symptom(chest_pain, yes),
    symptom(worse_on_movement, yes),
    finding(chest_wall_tenderness, yes),
    \+ symptom(dyspnoea, yes),
    frequency(costochondritis, Frequency).

diagnose(herpes_zoster, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, burning),
    symptom(unilateral_dermatomal, yes),
    finding(vesicular_rash, yes),
    frequency(herpes_zoster, Frequency).

diagnose(rib_metastasis, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, constant),
    symptom(history_of_malignancy, yes),
    finding(localised_rib_tenderness, yes),
    frequency(rib_metastasis, Frequency).

% --- Psychological ---

diagnose(depression, Frequency) :-
    symptom(chest_pain, yes),
    symptom(low_mood, yes),
    symptom(pain_character, atypical),
    \+ finding(ecg_changes, yes),
    \+ symptom(pleuritic, yes),
    \+ symptom(exertional, yes),
    frequency(depression, Frequency).


/* ------------------------------------------------------------
   RECOMMENDED INVESTIGATIONS
   Source: Churchill's General and Specific Investigations sections, p. 59-61
   ------------------------------------------------------------ */

suggest_test(angina,                ecg).
suggest_test(angina,                fbc).
suggest_test(angina,                exercise_stress_test).
suggest_test(angina,                coronary_angiography).
suggest_test(angina,                echocardiogram).

suggest_test(myocardial_infarction, ecg).
suggest_test(myocardial_infarction, serum_troponin).
suggest_test(myocardial_infarction, fbc).
suggest_test(myocardial_infarction, cxr).
suggest_test(myocardial_infarction, echocardiogram).

suggest_test(pericarditis,          ecg).
suggest_test(pericarditis,          fbc).
suggest_test(pericarditis,          esr_crp).
suggest_test(pericarditis,          echocardiogram).

suggest_test(aortic_dissection,     ct_aortography).
suggest_test(aortic_dissection,     cxr).
suggest_test(aortic_dissection,     ecg).

suggest_test(reflux_oesophagitis,   upper_gi_endoscopy).
suggest_test(reflux_oesophagitis,   oesophageal_manometry).
suggest_test(reflux_oesophagitis,   barium_swallow).

suggest_test(oesophageal_spasm,     upper_gi_endoscopy).
suggest_test(oesophageal_spasm,     oesophageal_manometry).

suggest_test(peptic_ulcer,          upper_gi_endoscopy).
suggest_test(peptic_ulcer,          fbc).
suggest_test(peptic_ulcer,          h_pylori_breath_test).

suggest_test(pneumonia,             cxr).
suggest_test(pneumonia,             fbc).
suggest_test(pneumonia,             blood_cultures).
suggest_test(pneumonia,             sputum_culture).

suggest_test(pneumothorax,          cxr).
suggest_test(pneumothorax,          abg).

suggest_test(pulmonary_embolism,    d_dimer).
suggest_test(pulmonary_embolism,    vq_scan).
suggest_test(pulmonary_embolism,    ct_pulmonary_angiography).
suggest_test(pulmonary_embolism,    ecg).
suggest_test(pulmonary_embolism,    fbc).
suggest_test(pulmonary_embolism,    doppler_lower_limbs).

suggest_test(costochondritis,       cxr).

suggest_test(herpes_zoster,         clinical_diagnosis).
suggest_test(herpes_zoster,         viral_swab_pcr).

suggest_test(rib_metastasis,        cxr).
suggest_test(rib_metastasis,        bone_scan).
suggest_test(rib_metastasis,        ct_chest).

suggest_test(depression,            ecg).
suggest_test(depression,            fbc).
suggest_test(depression,            tfts).


/* ------------------------------------------------------------
   PROOF TRACE
   One explain_step/3 clause per symptom/finding that diagnose/2 depends on.
   Rationale text is quoted because it contains spaces.
   ------------------------------------------------------------ */

% --- angina ---
explain_step(angina, chest_pain,
    'El dolor torácico es el síntoma cardinal de la angina de pecho').
explain_step(angina, pain_character,
    'El carácter opresivo o constrictivo es característico de la isquemia miocárdica').
explain_step(angina, exertional,
    'La angina se precipita con el esfuerzo por el aumento de la demanda de oxígeno miocárdico  -  rasgo definitorio que distingue la angina estable del IAM').

% --- myocardial_infarction ---
explain_step(myocardial_infarction, chest_pain,
    'El dolor torácico opresivo intenso es el síntoma cardinal del infarto agudo de miocardio').
explain_step(myocardial_infarction, pain_character,
    'La calidad opresiva refleja la isquemia del miocardio').
explain_step(myocardial_infarction, exertional,
    'A diferencia de la angina, el IAM ocurre en reposo  -  isquemia persistente sin aumento de la demanda').
explain_step(myocardial_infarction, pain_duration_minutes,
    'El dolor de más de 20 minutos en reposo se trata como IAM hasta demostrar lo contrario').
explain_step(myocardial_infarction, radiation_to_arm,
    'La irradiación al brazo izquierdo por los dermatomas T1-T2 es un rasgo clásico del IAM').
explain_step(myocardial_infarction, sweating,
    'La diaforesis refleja la activación simpática en respuesta al dolor isquémico intenso').

% --- pericarditis ---
explain_step(pericarditis, chest_pain,
    'La inflamación pericárdica provoca dolor torácico central').
explain_step(pericarditis, pain_location,
    'La localización central refleja el compromiso pericárdico difuso').
explain_step(pericarditis, pleuritic,
    'La calidad pleurítica (que empeora en la inspiración) indica compromiso de la superficie pericárdica').
explain_step(pericarditis, relieved_by_sitting_forward,
    'La posición de inclinación hacia adelante reduce el contacto entre el pericardio inflamado y el diafragma  -  signo patognomónico').

% --- aortic_dissection ---
explain_step(aortic_dissection, chest_pain,
    'El dolor torácico desgarrador es un signo distintivo de la disección aórtica').
explain_step(aortic_dissection, pain_character,
    'La calidad desgarradora o cortante refleja las fuerzas de cizallamiento en la pared aórtica').
explain_step(aortic_dissection, radiation_to_back,
    'La irradiación posterior sigue el trayecto de la disección a lo largo de la aorta descendente').

% --- reflux_oesophagitis ---
explain_step(reflux_oesophagitis, chest_pain,
    'La irritación de la mucosa esofágica por reflujo ácido produce dolor retroesternal ardoroso').
explain_step(reflux_oesophagitis, pain_character,
    'El carácter ardoroso es característico de la irritación ácida de la mucosa esofágica').
explain_step(reflux_oesophagitis, worse_on_bending_or_lying,
    'Los cambios posturales aumentan la presión intraabdominal y favorecen el reflujo ácido hacia el esófago').
explain_step(reflux_oesophagitis, relieved_by_antacids,
    'El alivio con antiácidos confirma al ácido como agente causal').

% --- oesophageal_spasm ---
explain_step(oesophageal_spasm, chest_pain,
    'El espasmo del músculo liso esofágico causa dolor torácico retroesternal intenso indistinguible de la angina').
explain_step(oesophageal_spasm, pain_character,
    'El carácter opresivo refleja la contracción sostenida del músculo liso esofágico').
explain_step(oesophageal_spasm, relieved_by_gtn,
    'La nitroglicerina relaja el músculo liso  -  el alivio con GTN NO distingue el origen cardíaco del esofágico').

% --- peptic_ulcer ---
explain_step(peptic_ulcer, chest_pain,
    'La enfermedad ulcerosa péptica puede causar dolor torácico por dolor epigástrico referido o compromiso esofágico').
explain_step(peptic_ulcer, pain_character,
    'El carácter urente profundo o roedor es típico de la enfermedad ulcerosa péptica').
explain_step(peptic_ulcer, pain_location,
    'La localización epigástrica distingue la úlcera péptica de las causas cardíacas').

% --- pneumonia ---
explain_step(pneumonia, chest_pain,
    'El dolor torácico pleurítico aparece cuando la neumonía compromete la superficie pleural (pleuritis)').
explain_step(pneumonia, pleuritic,
    'La inflamación pleural causa dolor que empeora bruscamente en la inspiración').
explain_step(pneumonia, cough,
    'La tos productiva con esputo purulento es un rasgo cardinal de la neumonía bacteriana').
explain_step(pneumonia, fever,
    'La fiebre refleja la respuesta inflamatoria sistémica a la infección bacteriana').

% --- pneumothorax ---
explain_step(pneumothorax, chest_pain,
    'El dolor torácico pleurítico súbito es la presentación típica del neumotórax').
explain_step(pneumothorax, sudden_onset,
    'El inicio súbito refleja el evento agudo de entrada de aire al espacio pleural').
explain_step(pneumothorax, dyspnoea,
    'El colapso pulmonar reduce el volumen pulmonar ventilado efectivo y produce disnea').
explain_step(pneumothorax, breath_sounds_reduced_unilateral,
    'La abolición del murmullo vesicular en el lado afectado es el hallazgo exploratorio clave del neumotórax').

% --- pulmonary_embolism ---
explain_step(pulmonary_embolism, chest_pain,
    'El dolor torácico pleurítico resulta cuando la TEP periférica causa infarto pulmonar con afectación pleural').
explain_step(pulmonary_embolism, pleuritic,
    'El compromiso pleural está presente cuando el infarto se extiende hasta la superficie pleural').
explain_step(pulmonary_embolism, dyspnoea,
    'La disnea súbita es el síntoma más frecuente de la TEP  -  la discordancia V/Q reduce la oxigenación').
explain_step(pulmonary_embolism, haemoptysis,
    'El esputo hemoptoico indica infarto pulmonar, presente en aproximadamente el 30% de los casos de TEP').
explain_step(pulmonary_embolism, dvt_signs,
    'La TVP es el origen del trombo en la mayoría de los casos de TEP  -  edema y dolor unilateral en la pierna').

% --- costochondritis ---
explain_step(costochondritis, chest_pain,
    'La inflamación de la unión costocondral causa dolor localizado en la pared torácica').
explain_step(costochondritis, worse_on_movement,
    'El movimiento del tórax agrava la inflamación costocondral').
explain_step(costochondritis, chest_wall_tenderness,
    'El dolor reproducible a la palpación de las uniones costocondrales es el hallazgo diagnóstico clave').

% --- herpes_zoster ---
explain_step(herpes_zoster, chest_pain,
    'La reactivación del herpes zóster en dermatomas torácicos causa dolor intenso ardoroso en la pared torácica').
explain_step(herpes_zoster, pain_character,
    'La calidad ardorosa neuropática refleja el compromiso nervioso directo por el virus varicela-zóster').
explain_step(herpes_zoster, unilateral_dermatomal,
    'La distribución dermatomérica estrictamente unilateral es patognomónica  -  el virus se reactiva en un ganglio de la raíz dorsal').
explain_step(herpes_zoster, vesicular_rash,
    'El exantema vesicular en distribución dermatomérica confirma el herpes zóster  -  puede aparecer después del inicio del dolor').

% --- rib_metastasis ---
explain_step(rib_metastasis, chest_pain,
    'Los depósitos metastásicos en las costillas causan dolor óseo localizado y constante').
explain_step(rib_metastasis, pain_character,
    'El dolor constante e implacable distingue las metástasis óseas de la mayoría de otras causas de dolor torácico').
explain_step(rib_metastasis, history_of_malignancy,
    'La neoplasia primaria conocida (mama, pulmón, próstata, riñón, tiroides como las más frecuentes) es el factor de riesgo clave').
explain_step(rib_metastasis, localised_rib_tenderness,
    'El dolor puntual directamente sobre una costilla es muy sugestivo de lesión cortical').

% --- depression ---
explain_step(depression, chest_pain,
    'El dolor torácico es una manifestación somática reconocida de la depresión y la ansiedad').
explain_step(depression, low_mood,
    'El ánimo deprimido persistente, la anhedonia y las quejas somáticas son rasgos centrales de la depresión').
explain_step(depression, pain_character,
    'El dolor torácico atípico sin patrón claro y con estudios normales sugiere una causa funcional o psicológica').


/* ------------------------------------------------------------
   EXCLUSION RULES
   Hard clinical exclusions  -  remove a diagnosis despite matching symptoms.
   ------------------------------------------------------------ */

exclude_if(myocardial_infarction,
           'ECGs seriados sin cambios y troponina negativa a las 12 horas  -  IAM excluido') :-
    finding(ecg_changes, no),
    finding(troponin_at_12h, negative).

exclude_if(pulmonary_embolism,
           'Dímero D negativo con baja probabilidad preprueba  -  TEP eficazmente excluida') :-
    finding(d_dimer, negative),
    \+ finding(dvt_signs, yes).

exclude_if(aortic_dissection,
           'Los pulsos simétricos en las cuatro extremidades hacen improbable la disección') :-
    finding(pulse_asymmetry, no).

exclude_if(depression,
           'Anomalía cardíaca objetiva encontrada  -  debe excluirse primero causa orgánica') :-
    ( finding(ecg_changes, yes) ; finding(troponin_elevated, yes) ).
