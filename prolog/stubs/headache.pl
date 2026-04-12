/* ============================================================
   MODULE: headache
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor  -  Elsevier 2010, p. 207-211
   AUTHORS: <your names>

   PRESENTATIONS TO ENCODE (from Churchill's, p. 207):

   ACUTE:
     common     -  Trauma, Systemic infection
     occasional -  Subarachnoid haemorrhage, Intracranial haemorrhage/infarction
     occasional -  Meningitis, Acute angle-closure glaucoma

   CHRONIC / RECURRENT:
     common     -  Tension headache, Migraine
     occasional -  Cluster headaches
     occasional -  Cervical spondylosis
     occasional -  Raised intracranial pressure (tumour, abscess, hydrocephalus)
     rare       -  Temporal arteritis, Carbon monoxide poisoning
     rare       -  Pre-eclampsia (in women of childbearing age)

   SYMPTOMS available (asserted by bridge for this presentation):
     symptom(headache, yes)
     symptom(onset, sudden | gradual | progressive)
     symptom(character, throbbing | tight_band | bursting | constant)
     symptom(location, unilateral | bilateral | occipital | frontal | temporal)
     symptom(neck_stiffness, yes | no)
     symptom(photophobia, yes | no)
     symptom(nausea_vomiting, yes | no)
     symptom(aura, yes | no)
     symptom(worse_morning, yes | no)
     symptom(worse_on_coughing, yes | no)
     symptom(fever, yes | no)
     symptom(jaw_claudication, yes | no)
     symptom(visual_disturbance, yes | no)
     symptom(preceding_trauma, yes | no)
     symptom(history_of_malignancy, yes | no)
     symptom(alcohol_or_drug_withdrawal, yes | no)
     patient_sex(female)   -  for pre-eclampsia check
     patient_age(Age)      -  temporal arteritis rare below 60

   FINDINGS available:
     finding(pyrexia, yes | no)
     finding(neck_stiffness_confirmed, yes | no)
     finding(papilloedema, yes | no)
     finding(focal_neurology, yes | no)
     finding(temporal_artery_tender, yes | no)
     finding(bp_elevated, yes | no)
     finding(petechial_rash, yes | no)
   ============================================================ */

:- module(headache, [diagnose/2, frequency/2,
                     suggest_test/2, explain_step/3,
                     exclude_if/2]).

:- encoding(utf8).

% Stubs declared as discontiguous so the file loads cleanly before rules are added.
% Remove these lines once your module is complete.
:- discontiguous diagnose/2.
:- discontiguous frequency/2.
:- discontiguous suggest_test/2.
:- discontiguous explain_step/3.
:- discontiguous exclude_if/2.


/* ------------------------------------------------------------
   SECTION 1  -  FREQUENCY TABLE
   ------------------------------------------------------------ */

% TODO: fill in frequency for every diagnosis you encode below.
%
% frequency(tension_headache,        common).
% frequency(migraine,                common).
% frequency(meningitis,              occasional).
% frequency(subarachnoid_haemorrhage, occasional).
% ...


/* ------------------------------------------------------------
   SECTION 2  -  DIAGNOSTIC RULES
   Hint: start with the most discriminating symptom at the top
   of each rule body  -  Prolog will check it first and fail fast
   if it is not present.
   ------------------------------------------------------------ */

% HINT  -  tension headache:
%   tight band character, bilateral, no neck stiffness, no fever
%
% diagnose(tension_headache, Frequency) :-
%     symptom(headache, yes),
%     symptom(character, tight_band),
%     symptom(location, bilateral),
%     \+ symptom(neck_stiffness, yes),
%     \+ symptom(fever, yes),
%     frequency(tension_headache, Frequency).

% HINT  -  subarachnoid haemorrhage:
%   sudden onset ("thunderclap"), worst headache of life
%
% diagnose(subarachnoid_haemorrhage, Frequency) :-
%     symptom(headache, yes),
%     symptom(onset, sudden),
%     symptom(neck_stiffness, yes),
%     frequency(subarachnoid_haemorrhage, Frequency).

% HINT  -  temporal arteritis: rare below age 60, temporal tenderness
%
% diagnose(temporal_arteritis, Frequency) :-
%     symptom(headache, yes),
%     symptom(location, temporal),
%     symptom(jaw_claudication, yes),
%     patient_age(Age), Age >= 60,
%     frequency(temporal_arteritis, Frequency).

% --- YOUR RULES GO HERE ---


/* ------------------------------------------------------------
   SECTION 3  -  INVESTIGATIONS
   Source: Churchill's p. 210-211
   General: FBC, ESR/CRP, U&Es, CT/MRI
   Specific: lumbar puncture, blood cultures, EEG, temporal artery biopsy
   ------------------------------------------------------------ */

% suggest_test(tension_headache,          clinical_diagnosis).
% suggest_test(migraine,                  clinical_diagnosis).
% suggest_test(migraine,                  ct_mri_head).
% suggest_test(subarachnoid_haemorrhage,  ct_head).
% suggest_test(subarachnoid_haemorrhage,  lumbar_puncture).
% suggest_test(meningitis,                ct_head).
% suggest_test(meningitis,                lumbar_puncture).
% suggest_test(meningitis,                blood_cultures).
% suggest_test(meningitis,                fbc).
% suggest_test(temporal_arteritis,        esr_crp).
% suggest_test(temporal_arteritis,        temporal_artery_biopsy).
% ...


/* ------------------------------------------------------------
   SECTION 4  -  PROOF TRACE
   ------------------------------------------------------------ */

% explain_step(tension_headache, character,
%     'Tight band-like sensation is the classic description of tension-type headache').
% explain_step(tension_headache, location,
%     'Bilateral distribution distinguishes tension headache from unilateral migraine').
% ...


/* ------------------------------------------------------------
   SECTION 5  -  EXCLUSION RULES
   ------------------------------------------------------------ */

% Hint: if papilloedema is found, tension headache and migraine
% should be reconsidered  -  could be raised ICP masquerading.
%
% exclude_if(tension_headache,
%            'Papilloedema indicates raised intracranial pressure  -  must rule out space-occupying lesion') :-
%     finding(papilloedema, yes).
