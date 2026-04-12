/* ============================================================
   MODULE: weight_loss
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 483-490
   AUTHORS: <your names>
   SYSTEM:  Systemic / Endocrine / Oncological

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

frequency(malignancy                            ,  common).
frequency(depression                            ,  common).
frequency(diabetes_mellitus                     ,  common).
frequency(hyperthyroidism                       ,  common).
frequency(malabsorption                         ,  occasional).
frequency(copd                                  ,  occasional).
frequency(heart_failure                         ,  occasional).
frequency(tb                                    ,  occasional).
frequency(hiv                                   ,  occasional).

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
