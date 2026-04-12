/* ============================================================
   MODULE: stridor
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 420-423
   AUTHORS: <your names>
   SYSTEM:  Respiratory / ENT

   DIAGNOSES TO ENCODE (from Churchill's):
   %   croup                                  frequency: common
   %   epiglottitis                           frequency: occasional
   %   inhaled_foreign_body                   frequency: occasional
   %   anaphylaxis                            frequency: occasional
   %   laryngeal_carcinoma                    frequency: occasional
   %   vocal_cord_palsy                       frequency: rare
   %   tracheal_compression                   frequency: rare

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(stridor                       , Value)  -- type: yesno
   %   symptom(onset                         , Value)  -- type: choice: sudden|gradual
   %   symptom(age_group                     , Value)  -- type: choice: infant|child|adult
   %   symptom(fever                         , Value)  -- type: yesno
   %   symptom(drooling                      , Value)  -- type: yesno
   %   symptom(dysphonia                     , Value)  -- type: yesno
   %   symptom(dysphagia                     , Value)  -- type: yesno
   %   symptom(history_of_malignancy         , Value)  -- type: yesno
   %   symptom(choking_episode               , Value)  -- type: yesno
   %   symptom(known_allergy                 , Value)  -- type: yesno
   %   symptom(urticaria                     , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(pyrexia                       , Value)  -- type: yesno
   %   finding(stridor_type                  , Value)  -- type: choice: inspiratory|expiratory|biphasic
   %   finding(toxic_appearance              , Value)  -- type: yesno
   %   finding(sat_o2_low                    , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(stridor, [diagnose/2, frequency/2,
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

frequency(croup                                 ,  common).
frequency(epiglottitis                          ,  occasional).
frequency(inhaled_foreign_body                  ,  occasional).
frequency(anaphylaxis                           ,  occasional).
frequency(laryngeal_carcinoma                   ,  occasional).
frequency(vocal_cord_palsy                      ,  rare).
frequency(tracheal_compression                  ,  rare).

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
