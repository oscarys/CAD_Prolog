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
    'Chest pain is the cardinal symptom of angina pectoris').
explain_step(angina, pain_character,
    'Crushing or tight character is characteristic of myocardial ischaemia').
explain_step(angina, exertional,
    'Angina is precipitated by exertion due to increased myocardial oxygen demand  -  a defining feature distinguishing stable angina from MI').

% --- myocardial_infarction ---
explain_step(myocardial_infarction, chest_pain,
    'Severe crushing chest pain is the cardinal symptom of MI').
explain_step(myocardial_infarction, pain_character,
    'Crushing quality reflects ischaemia of the myocardium').
explain_step(myocardial_infarction, exertional,
    'Unlike angina, MI occurs at rest  -  ongoing ischaemia despite absence of demand increase').
explain_step(myocardial_infarction, pain_duration_minutes,
    'Pain lasting 20+ minutes at rest is treated as MI until proven otherwise').
explain_step(myocardial_infarction, radiation_to_arm,
    'Radiation to left arm via dermatomes T1-T2 is a classic feature of MI').
explain_step(myocardial_infarction, sweating,
    'Diaphoresis reflects sympathetic activation in response to severe ischaemic pain').

% --- pericarditis ---
explain_step(pericarditis, chest_pain,
    'Pericardial inflammation causes central chest pain').
explain_step(pericarditis, pain_location,
    'Central location reflects diffuse pericardial involvement').
explain_step(pericarditis, pleuritic,
    'Pleuritic quality (worse on inspiration) indicates pericardial surface involvement').
explain_step(pericarditis, relieved_by_sitting_forward,
    'Leaning forward reduces contact between inflamed pericardium and diaphragm  -  a pathognomonic feature').

% --- aortic_dissection ---
explain_step(aortic_dissection, chest_pain,
    'Tearing chest pain is a hallmark of aortic dissection').
explain_step(aortic_dissection, pain_character,
    'Tearing or ripping quality reflects shearing forces in the aortic wall').
explain_step(aortic_dissection, radiation_to_back,
    'Posterior radiation follows the path of the dissection along the descending aorta').

% --- reflux_oesophagitis ---
explain_step(reflux_oesophagitis, chest_pain,
    'Oesophageal mucosa irritation from acid reflux causes retrosternal burning pain').
explain_step(reflux_oesophagitis, pain_character,
    'Burning character is characteristic of acid irritation of oesophageal mucosa').
explain_step(reflux_oesophagitis, worse_on_bending_or_lying,
    'Postural changes increase intra-abdominal pressure and promote acid reflux into the oesophagus').
explain_step(reflux_oesophagitis, relieved_by_antacids,
    'Relief by antacids confirms acid as the causative agent').

% --- oesophageal_spasm ---
explain_step(oesophageal_spasm, chest_pain,
    'Oesophageal smooth muscle spasm causes severe retrosternal chest pain indistinguishable from angina').
explain_step(oesophageal_spasm, pain_character,
    'Crushing character reflects sustained oesophageal smooth muscle contraction').
explain_step(oesophageal_spasm, relieved_by_gtn,
    'GTN relaxes smooth muscle  -  relief by GTN does NOT distinguish cardiac from oesophageal origin').

% --- peptic_ulcer ---
explain_step(peptic_ulcer, chest_pain,
    'Peptic ulcer disease can cause chest pain via referred epigastric pain or oesophageal involvement').
explain_step(peptic_ulcer, pain_character,
    'Gnawing or deep burning character is typical of peptic ulcer disease').
explain_step(peptic_ulcer, pain_location,
    'Epigastric location distinguishes peptic ulcer from cardiac causes').

% --- pneumonia ---
explain_step(pneumonia, chest_pain,
    'Pleuritic chest pain arises when pneumonia involves the pleural surface (pleuritis)').
explain_step(pneumonia, pleuritic,
    'Pleural inflammation causes pain that is sharply worse on inspiration').
explain_step(pneumonia, cough,
    'Productive cough with purulent sputum is a cardinal feature of bacterial pneumonia').
explain_step(pneumonia, fever,
    'Fever reflects the systemic inflammatory response to bacterial infection').

% --- pneumothorax ---
explain_step(pneumothorax, chest_pain,
    'Sudden pleuritic chest pain is the typical presentation of pneumothorax').
explain_step(pneumothorax, sudden_onset,
    'Sudden onset reflects the acute event of pleural air entry').
explain_step(pneumothorax, dyspnoea,
    'Lung collapse reduces effective ventilated lung volume causing dyspnoea').
explain_step(pneumothorax, breath_sounds_reduced_unilateral,
    'Absent breath sounds on the affected side is the key examination finding in pneumothorax').

% --- pulmonary_embolism ---
explain_step(pulmonary_embolism, chest_pain,
    'Pleuritic chest pain results when peripheral PE causes pulmonary infarction involving the pleura').
explain_step(pulmonary_embolism, pleuritic,
    'Pleural involvement is present when infarction extends to the pleural surface').
explain_step(pulmonary_embolism, dyspnoea,
    'Sudden dyspnoea is the most common symptom of PE  -  V/Q mismatch reduces oxygenation').
explain_step(pulmonary_embolism, haemoptysis,
    'Blood-stained sputum indicates pulmonary infarction, present in approximately 30% of PE cases').
explain_step(pulmonary_embolism, dvt_signs,
    'DVT is the source of thrombus in the majority of PE cases  -  unilateral leg swelling and tenderness').

% --- costochondritis ---
explain_step(costochondritis, chest_pain,
    'Costochondral junction inflammation causes localised chest wall pain').
explain_step(costochondritis, worse_on_movement,
    'Movement of the thorax aggravates costochondral inflammation').
explain_step(costochondritis, chest_wall_tenderness,
    'Reproducible tenderness on palpation of the costochondral junctions is the key diagnostic finding').

% --- herpes_zoster ---
explain_step(herpes_zoster, chest_pain,
    'Herpes zoster (shingles) reactivation in thoracic dermatomes causes severe burning chest wall pain').
explain_step(herpes_zoster, pain_character,
    'Burning neuropathic quality reflects direct nerve involvement by varicella-zoster virus').
explain_step(herpes_zoster, unilateral_dermatomal,
    'Strictly unilateral dermatomal distribution is pathognomonic  -  the virus reactivates in one dorsal root ganglion').
explain_step(herpes_zoster, vesicular_rash,
    'Vesicular rash in a dermatomal distribution confirms herpes zoster  -  may appear after pain onset').

% --- rib_metastasis ---
explain_step(rib_metastasis, chest_pain,
    'Metastatic deposits in the ribs cause localised, constant bone pain').
explain_step(rib_metastasis, pain_character,
    'Constant unrelenting pain distinguishes bony metastasis from most other chest pain causes').
explain_step(rib_metastasis, history_of_malignancy,
    'Known primary malignancy (breast, lung, prostate, kidney, thyroid most common) is the key risk factor').
explain_step(rib_metastasis, localised_rib_tenderness,
    'Point tenderness directly over a rib is highly suspicious for a cortical lesion').

% --- depression ---
explain_step(depression, chest_pain,
    'Chest pain is a recognised somatic manifestation of depression and anxiety').
explain_step(depression, low_mood,
    'Persistent low mood, anhedonia, and somatic complaints are core features of depression').
explain_step(depression, pain_character,
    'Atypical chest pain with no clear pattern and normal investigations suggests a functional or psychological cause').


/* ------------------------------------------------------------
   EXCLUSION RULES
   Hard clinical exclusions  -  remove a diagnosis despite matching symptoms.
   ------------------------------------------------------------ */

exclude_if(myocardial_infarction,
           'Serial ECGs show no changes and troponin negative at 12 hours  -  MI excluded') :-
    finding(ecg_changes, no),
    finding(troponin_at_12h, negative).

exclude_if(pulmonary_embolism,
           'D-dimer negative with low pre-test probability  -  PE effectively excluded') :-
    finding(d_dimer, negative),
    \+ finding(dvt_signs, yes).

exclude_if(aortic_dissection,
           'Symmetric pulses in all four limbs make dissection unlikely') :-
    finding(pulse_asymmetry, no).

exclude_if(depression,
           'Objective cardiac abnormality found  -  organic cause must be excluded first') :-
    ( finding(ecg_changes, yes) ; finding(troponin_elevated, yes) ).
