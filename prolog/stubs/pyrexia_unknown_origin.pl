/* ============================================================
   MODULE: pyrexia_unknown_origin
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 374-377
   AUTHORS: <your names>
   SYSTEM:  Systemic / Infectious / Autoimmune

   DIAGNOSES TO ENCODE (from Churchill's):
   %   occult_infection                       frequency: common
   %   lymphoma                               frequency: occasional
   %   tb                                     frequency: occasional
   %   infective_endocarditis                 frequency: occasional
   %   sle                                    frequency: occasional
   %   drug_fever                             frequency: occasional
   %   malignancy_other                       frequency: occasional
   %   adult_still_disease                    frequency: rare
   %   factitious_fever                       frequency: rare

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(fever_duration_weeks          , Value)  -- type: number
   %   symptom(weight_loss                   , Value)  -- type: yesno
   %   symptom(night_sweats                  , Value)  -- type: yesno
   %   symptom(joint_pain                    , Value)  -- type: yesno
   %   symptom(rash                          , Value)  -- type: yesno
   %   symptom(cardiac_history               , Value)  -- type: yesno
   %   symptom(travel_history                , Value)  -- type: yesno
   %   symptom(drug_history                  , Value)  -- type: yesno
   %   symptom(immunosuppressed              , Value)  -- type: yesno
   %   symptom(lymphadenopathy               , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(lymphadenopathy_confirmed     , Value)  -- type: yesno
   %   finding(splenomegaly                  , Value)  -- type: yesno
   %   finding(hepatomegaly                  , Value)  -- type: yesno
   %   finding(heart_murmur                  , Value)  -- type: yesno
   %   finding(rash_present                  , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(pyrexia_unknown_origin, [diagnose/2, frequency/2,
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

frequency(occult_infection                      ,  common).
frequency(lymphoma                              ,  occasional).
frequency(tb                                    ,  occasional).
frequency(infective_endocarditis                ,  occasional).
frequency(sle                                   ,  occasional).
frequency(drug_fever                            ,  occasional).
frequency(malignancy_other                      ,  occasional).
frequency(adult_still_disease                   ,  rare).
frequency(factitious_fever                      ,  rare).

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
