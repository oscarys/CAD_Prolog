/* ============================================================
   MODULE: palpitations
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 351-353
   AUTHORS: <your names>
   SYSTEM:  Cardiovascular / Endocrine

   DIAGNOSES TO ENCODE (from Churchill's):
   %   sinus_tachycardia                      frequency: common
   %   atrial_fibrillation                    frequency: common
   %   ventricular_ectopics                   frequency: common
   %   anxiety                                frequency: common
   %   svt                                    frequency: occasional
   %   ventricular_tachycardia                frequency: occasional
   %   hyperthyroidism                        frequency: occasional
   %   anaemia                                frequency: occasional

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(palpitations                  , Value)  -- type: yesno
   %   symptom(character                     , Value)  -- type: choice: fast|irregular|missed_beats|pounding
   %   symptom(onset                         , Value)  -- type: choice: sudden|gradual
   %   symptom(syncope_with_palpitations     , Value)  -- type: yesno
   %   symptom(chest_pain                    , Value)  -- type: yesno
   %   symptom(dyspnoea                      , Value)  -- type: yesno
   %   symptom(thyroid_symptoms              , Value)  -- type: yesno
   %   symptom(caffeine_use                  , Value)  -- type: yesno
   %   symptom(anxiety                       , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(pulse_rate                    , Value)  -- type: number
   %   finding(pulse_rhythm                  , Value)  -- type: choice: regular|irregular
   %   finding(bp_elevated                   , Value)  -- type: yesno
   %   finding(tremor                        , Value)  -- type: yesno
   %   finding(thyroid_enlargement           , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(palpitations, [diagnose/2, frequency/2,
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

frequency(sinus_tachycardia                     ,  common).
frequency(atrial_fibrillation                   ,  common).
frequency(ventricular_ectopics                  ,  common).
frequency(anxiety                               ,  common).
frequency(svt                                   ,  occasional).
frequency(ventricular_tachycardia               ,  occasional).
frequency(hyperthyroidism                       ,  occasional).
frequency(anaemia                               ,  occasional).

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
