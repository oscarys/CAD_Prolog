/* ============================================================
   MODULE: oedema
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 343-346
   AUTHORS: <your names>
   SYSTEM:  Cardiovascular / Renal / Hepatic

   DIAGNOSES TO ENCODE (from Churchill's):
   %   heart_failure                          frequency: common
   %   venous_insufficiency                   frequency: common
   %   hypoalbuminaemia                       frequency: common
   %   nephrotic_syndrome                     frequency: occasional
   %   lymphoedema                            frequency: occasional
   %   hypothyroidism                         frequency: occasional
   %   drug_induced_oedema                    frequency: occasional

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(oedema                        , Value)  -- type: yesno
   %   symptom(distribution                  , Value)  -- type: choice: bilateral|unilateral|generalised|facial
   %   symptom(dyspnoea                      , Value)  -- type: yesno
   %   symptom(orthopnoea                    , Value)  -- type: yesno
   %   symptom(proteinuria                   , Value)  -- type: yesno
   %   symptom(liver_disease                 , Value)  -- type: yesno
   %   symptom(cold_intolerance              , Value)  -- type: yesno
   %   symptom(drug_history                  , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(pitting_oedema                , Value)  -- type: yesno
   %   finding(jvp_elevated                  , Value)  -- type: yesno
   %   finding(ascites                       , Value)  -- type: yesno
   %   finding(pleural_effusion              , Value)  -- type: yesno
   %   finding(facial_oedema                 , Value)  -- type: yesno
   %   finding(bradycardia                   , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(oedema, [diagnose/2, frequency/2,
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

frequency(heart_failure                         ,  common).
frequency(venous_insufficiency                  ,  common).
frequency(hypoalbuminaemia                      ,  common).
frequency(nephrotic_syndrome                    ,  occasional).
frequency(lymphoedema                           ,  occasional).
frequency(hypothyroidism                        ,  occasional).
frequency(drug_induced_oedema                   ,  occasional).

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
