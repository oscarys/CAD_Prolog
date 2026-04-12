/* ============================================================
   MODULE: diarrhoea
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 95-100
   AUTHORS: <your names>
   SYSTEM:  Gastrointestinal

   DIAGNOSES TO ENCODE (from Churchill's):
   %   gastroenteritis                        frequency: common
   %   irritable_bowel_syndrome               frequency: common
   %   inflammatory_bowel_disease             frequency: occasional
   %   colorectal_carcinoma                   frequency: occasional
   %   coeliac_disease                        frequency: occasional
   %   infective_colitis                      frequency: common
   %   hyperthyroidism                        frequency: occasional
   %   malabsorption                          frequency: occasional

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(diarrhoea                     , Value)  -- type: yesno
   %   symptom(onset                         , Value)  -- type: choice: acute|chronic
   %   symptom(blood_in_stool                , Value)  -- type: yesno
   %   symptom(mucus_in_stool                , Value)  -- type: yesno
   %   symptom(abdominal_pain                , Value)  -- type: yesno
   %   symptom(weight_loss                   , Value)  -- type: yesno
   %   symptom(fever                         , Value)  -- type: yesno
   %   symptom(recent_travel                 , Value)  -- type: yesno
   %   symptom(recent_antibiotics            , Value)  -- type: yesno
   %   symptom(nocturnal_diarrhoea           , Value)  -- type: yesno
   %   symptom(steatorrhoea                  , Value)  -- type: yesno
   %   symptom(family_history_bowel_cancer   , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(abdominal_tenderness          , Value)  -- type: yesno
   %   finding(abdominal_mass                , Value)  -- type: yesno
   %   finding(perianal_disease              , Value)  -- type: yesno
   %   finding(thyroid_enlargement           , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(diarrhoea, [diagnose/2, frequency/2,
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

frequency(gastroenteritis                       ,  common).
frequency(irritable_bowel_syndrome              ,  common).
frequency(inflammatory_bowel_disease            ,  occasional).
frequency(colorectal_carcinoma                  ,  occasional).
frequency(coeliac_disease                       ,  occasional).
frequency(infective_colitis                     ,  common).
frequency(hyperthyroidism                       ,  occasional).
frequency(malabsorption                         ,  occasional).

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
