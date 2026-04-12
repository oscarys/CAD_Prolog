/* ============================================================
   MODULE: convulsions
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 80-83
   AUTHORS: <your names>
   SYSTEM:  Neurological

   DIAGNOSES TO ENCODE (from Churchill's):
   %   epilepsy                               frequency: common
   %   febrile_convulsion                     frequency: common
   %   hypoglycaemia                          frequency: common
   %   hyponatraemia                          frequency: occasional
   %   meningitis                             frequency: occasional
   %   intracranial_tumour                    frequency: occasional
   %   alcohol_withdrawal                     frequency: occasional
   %   stroke                                 frequency: occasional
   %   eclampsia                              frequency: occasional

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(convulsion                    , Value)  -- type: yesno
   %   symptom(fever                         , Value)  -- type: yesno
   %   symptom(aura                          , Value)  -- type: yesno
   %   symptom(postictal_confusion           , Value)  -- type: yesno
   %   symptom(incontinence                  , Value)  -- type: yesno
   %   symptom(tongue_biting                 , Value)  -- type: yesno
   %   symptom(focal_onset                   , Value)  -- type: yesno
   %   symptom(diabetes                      , Value)  -- type: yesno
   %   symptom(alcohol_use                   , Value)  -- type: yesno
   %   symptom(drug_use                      , Value)  -- type: yesno
   %   symptom(known_epilepsy                , Value)  -- type: yesno
   %   symptom(pregnancy                     , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(pyrexia                       , Value)  -- type: yesno
   %   finding(focal_neurology               , Value)  -- type: yesno
   %   finding(neck_stiffness                , Value)  -- type: yesno
   %   finding(papilloedema                  , Value)  -- type: yesno
   %   finding(blood_glucose_low             , Value)  -- type: yesno
   %   finding(blood_glucose_high            , Value)  -- type: yesno
   %   finding(sodium_abnormal               , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(convulsions, [diagnose/2, frequency/2,
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
   SECTION 1 -- FREQUENCY TABLE
   One fact per diagnosis. Values: common | occasional | rare
   Source: Churchill's colour coding for this presentation.
   ------------------------------------------------------------ */

frequency(epilepsy                              ,  common).
frequency(febrile_convulsion                    ,  common).
frequency(hypoglycaemia                         ,  common).
frequency(hyponatraemia                         ,  occasional).
frequency(meningitis                            ,  occasional).
frequency(intracranial_tumour                   ,  occasional).
frequency(alcohol_withdrawal                    ,  occasional).
frequency(stroke                                ,  occasional).
frequency(eclampsia                             ,  occasional).

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
