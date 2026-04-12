/* ============================================================
   MODULE: haematemesis
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 182-186
   AUTHORS: <your names>
   SYSTEM:  Gastrointestinal

   DIAGNOSES TO ENCODE (from Churchill's):
   %   peptic_ulcer                           frequency: common
   %   oesophagitis                           frequency: common
   %   oesophageal_varices                    frequency: occasional
   %   mallory_weiss_tear                     frequency: occasional
   %   gastric_carcinoma                      frequency: occasional
   %   vascular_malformation                  frequency: rare

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(haematemesis                  , Value)  -- type: yesno
   %   symptom(blood_character               , Value)  -- type: choice: fresh|coffee_grounds|mixed
   %   symptom(melaena                       , Value)  -- type: yesno
   %   symptom(abdominal_pain                , Value)  -- type: yesno
   %   symptom(alcohol_use                   , Value)  -- type: yesno
   %   symptom(nsaid_use                     , Value)  -- type: yesno
   %   symptom(previous_peptic_ulcer         , Value)  -- type: yesno
   %   symptom(liver_disease                 , Value)  -- type: yesno
   %   symptom(dysphagia                     , Value)  -- type: yesno
   %   symptom(weight_loss                   , Value)  -- type: yesno
   %   symptom(vomiting_preceded_bleed       , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(haemodynamic_instability      , Value)  -- type: yesno
   %   finding(epigastric_tenderness         , Value)  -- type: yesno
   %   finding(stigmata_of_liver_disease     , Value)  -- type: yesno
   %   finding(rectal_exam_melaena           , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(haematemesis, [diagnose/2, frequency/2,
                   suggest_test/2, explain_step/3,
                   exclude_if/2]).

% Stubs declared as discontiguous so the file loads cleanly before rules are added.
% Remove these lines once your module is complete.
:- discontiguous diagnose/2.
:- discontiguous frequency/2.
:- discontiguous suggest_test/2.
:- discontiguous explain_step/3.
:- discontiguous exclude_if/2.


/* ------------------------------------------------------------
   SECTION 1 -- FREQUENCY TABLE
   One fact per diagnosis. Values: common | occasional | rare
   Source: Churchill's colour coding for this presentation.
   ------------------------------------------------------------ */

frequency(peptic_ulcer                          ,  common).
frequency(oesophagitis                          ,  common).
frequency(oesophageal_varices                   ,  occasional).
frequency(mallory_weiss_tear                    ,  occasional).
frequency(gastric_carcinoma                     ,  occasional).
frequency(vascular_malformation                 ,  rare).

/* ------------------------------------------------------------
   SECTION 2 -- DIAGNOSTIC RULES
   One diagnose/2 clause per distinct clinical picture.
   Each rule must end with:  frequency(Diagnosis, Frequency).
   ------------------------------------------------------------ */

% TODO: write your diagnose/2 rules here.
% Pattern:
%   diagnose(<diagnosis_atom>, Frequency) :-
%       symptom(<atom>, yes),
%       ...,
%       frequency(<diagnosis_atom>, Frequency).


/* ------------------------------------------------------------
   SECTION 3 -- INVESTIGATIONS
   One suggest_test/2 fact per (diagnosis, test) pair.
   Source: Churchill's General and Specific Investigations sections.
   ------------------------------------------------------------ */

% TODO: add suggest_test/2 facts here.
% suggest_test(<diagnosis>, <test_atom>).


/* ------------------------------------------------------------
   SECTION 4 -- PROOF TRACE
   One explain_step/3 clause per symptom/finding each rule depends on.
   ------------------------------------------------------------ */

% TODO: add explain_step/3 clauses here.
% explain_step(<diagnosis>, <symptom_atom>,
%     'Rationale: why this finding points toward this diagnosis').


/* ------------------------------------------------------------
   SECTION 5 -- EXCLUSION RULES  (optional but encouraged)
   ------------------------------------------------------------ */

% TODO: add exclude_if/2 rules here.
% exclude_if(<diagnosis>, 'Reason string') :-
%     finding(<finding_atom>, <value>).
