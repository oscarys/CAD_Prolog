/* ============================================================
   MODULE: syncope
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 427-430
   AUTHORS: <your names>
   SYSTEM:  Cardiovascular / Neurological

   DIAGNOSES TO ENCODE (from Churchill's):
   %   vasovagal_syncope                      frequency: common
   %   postural_hypotension                   frequency: common
   %   cardiac_arrhythmia                     frequency: occasional
   %   aortic_stenosis                        frequency: occasional
   %   epilepsy                               frequency: occasional
   %   tia                                    frequency: occasional
   %   hypertrophic_cardiomyopathy            frequency: rare

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(syncope                       , Value)  -- type: yesno
   %   symptom(prodrome                      , Value)  -- type: yesno
   %   symptom(onset                         , Value)  -- type: choice: exertional|postural|spontaneous|standing
   %   symptom(convulsive_movements          , Value)  -- type: yesno
   %   symptom(postictal_confusion           , Value)  -- type: yesno
   %   symptom(chest_pain                    , Value)  -- type: yesno
   %   symptom(cardiac_history               , Value)  -- type: yesno
   %   symptom(antihypertensive_use          , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(bp_postural_drop              , Value)  -- type: yesno
   %   finding(murmur                        , Value)  -- type: yesno
   %   finding(pulse_rhythm                  , Value)  -- type: choice: regular|irregular
   %   finding(ecg_changes                   , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(syncope, [diagnose/2, frequency/2,
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

frequency(vasovagal_syncope                     ,  common).
frequency(postural_hypotension                  ,  common).
frequency(cardiac_arrhythmia                    ,  occasional).
frequency(aortic_stenosis                       ,  occasional).
frequency(epilepsy                              ,  occasional).
frequency(tia                                   ,  occasional).
frequency(hypertrophic_cardiomyopathy           ,  rare).

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
