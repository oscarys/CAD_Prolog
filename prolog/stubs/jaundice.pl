/* ============================================================
   MODULE: jaundice
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 240-249
   AUTHORS: <your names>
   SYSTEM:  Hepatobiliary / Haematological

   DIAGNOSES TO ENCODE (from Churchill's):
   %   gallstones                             frequency: common
   %   hepatitis                              frequency: common
   %   alcoholic_liver_disease                frequency: common
   %   drug_induced_jaundice                  frequency: occasional
   %   primary_biliary_cholangitis            frequency: occasional
   %   pancreatic_carcinoma                   frequency: occasional
   %   haemolysis                             frequency: occasional
   %   biliary_stricture                      frequency: rare

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(jaundice                      , Value)  -- type: yesno
   %   symptom(dark_urine                    , Value)  -- type: yesno
   %   symptom(pale_stools                   , Value)  -- type: yesno
   %   symptom(right_upper_quadrant_pain     , Value)  -- type: yesno
   %   symptom(fever                         , Value)  -- type: yesno
   %   symptom(weight_loss                   , Value)  -- type: yesno
   %   symptom(pruritus                      , Value)  -- type: yesno
   %   symptom(alcohol_use                   , Value)  -- type: yesno
   %   symptom(drug_history                  , Value)  -- type: yesno
   %   symptom(travel_history                , Value)  -- type: yesno
   %   symptom(nausea_vomiting               , Value)  -- type: yesno
   %   symptom(family_history_liver          , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(hepatomegaly                  , Value)  -- type: yesno
   %   finding(splenomegaly                  , Value)  -- type: yesno
   %   finding(gallbladder_palpable          , Value)  -- type: yesno
   %   finding(stigmata_of_liver_disease     , Value)  -- type: yesno
   %   finding(lymphadenopathy               , Value)  -- type: yesno
   %   finding(urine_bilirubin               , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(jaundice, [diagnose/2, frequency/2,
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

frequency(gallstones                            ,  common).
frequency(hepatitis                             ,  common).
frequency(alcoholic_liver_disease               ,  common).
frequency(drug_induced_jaundice                 ,  occasional).
frequency(primary_biliary_cholangitis           ,  occasional).
frequency(pancreatic_carcinoma                  ,  occasional).
frequency(haemolysis                            ,  occasional).
frequency(biliary_stricture                     ,  rare).

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
