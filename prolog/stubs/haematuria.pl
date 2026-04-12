/* ============================================================
   MODULE: haematuria
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 187-190
   AUTHORS: <your names>
   SYSTEM:  Urological / Renal

   DIAGNOSES TO ENCODE (from Churchill's):
   %   urinary_tract_infection                frequency: common
   %   renal_calculi                          frequency: common
   %   benign_prostatic_hypertrophy           frequency: common
   %   bladder_carcinoma                      frequency: occasional
   %   renal_carcinoma                        frequency: occasional
   %   glomerulonephritis                     frequency: occasional
   %   coagulation_disorder                   frequency: occasional

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(haematuria                    , Value)  -- type: yesno
   %   symptom(painless_haematuria           , Value)  -- type: yesno
   %   symptom(dysuria                       , Value)  -- type: yesno
   %   symptom(urinary_frequency             , Value)  -- type: yesno
   %   symptom(loin_pain                     , Value)  -- type: yesno
   %   symptom(clots_in_urine                , Value)  -- type: yesno
   %   symptom(weight_loss                   , Value)  -- type: yesno
   %   symptom(smoking_history               , Value)  -- type: yesno
   %   symptom(anticoagulant_use             , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(suprapubic_tenderness         , Value)  -- type: yesno
   %   finding(loin_tenderness               , Value)  -- type: yesno
   %   finding(enlarged_prostate             , Value)  -- type: yesno
   %   finding(abdominal_mass                , Value)  -- type: yesno
   %   finding(urine_dipstick_blood          , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(haematuria, [diagnose/2, frequency/2,
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

frequency(urinary_tract_infection               ,  common).
frequency(renal_calculi                         ,  common).
frequency(benign_prostatic_hypertrophy          ,  common).
frequency(bladder_carcinoma                     ,  occasional).
frequency(renal_carcinoma                       ,  occasional).
frequency(glomerulonephritis                    ,  occasional).
frequency(coagulation_disorder                  ,  occasional).

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
