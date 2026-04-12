/* ============================================================
   MODULE: abdominal_pain
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 3-8
   AUTHORS: <your names>
   SYSTEM:  Gastrointestinal / Urological / Gynaecological

   DIAGNOSES TO ENCODE (from Churchill's):
   %   appendicitis                           frequency: common
   %   peptic_ulcer                           frequency: common
   %   biliary_colic                          frequency: common
   %   intestinal_obstruction                 frequency: occasional
   %   ureteric_colic                         frequency: occasional
   %   acute_pancreatitis                     frequency: occasional
   %   mesenteric_adenitis                    frequency: occasional
   %   ectopic_pregnancy                      frequency: occasional
   %   diverticulitis                         frequency: occasional
   %   aortic_aneurysm                        frequency: rare

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(abdominal_pain                , Value)  -- type: yesno
   %   symptom(onset                         , Value)  -- type: choice: sudden|gradual|colicky
   %   symptom(pain_location                 , Value)  -- type: choice: rif|lif|epigastric|central|ruq|generalised
   %   symptom(nausea_vomiting               , Value)  -- type: yesno
   %   symptom(fever                         , Value)  -- type: yesno
   %   symptom(diarrhoea                     , Value)  -- type: yesno
   %   symptom(constipation                  , Value)  -- type: yesno
   %   symptom(pr_bleeding                   , Value)  -- type: yesno
   %   symptom(jaundice                      , Value)  -- type: yesno
   %   symptom(haematuria                    , Value)  -- type: yesno
   %   symptom(loin_to_groin_radiation       , Value)  -- type: yesno
   %   symptom(last_menstrual_period         , Value)  -- type: yesno
   %   symptom(previous_surgery              , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(guarding                      , Value)  -- type: yesno
   %   finding(rigidity                      , Value)  -- type: yesno
   %   finding(rebound_tenderness            , Value)  -- type: yesno
   %   finding(bowel_sounds                  , Value)  -- type: choice: normal|absent|tinkling
   %   finding(pulsatile_mass                , Value)  -- type: yesno
   %   finding(hernial_orifice_tender        , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(abdominal_pain, [diagnose/2, frequency/2,
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

frequency(appendicitis                          ,  common).
frequency(peptic_ulcer                          ,  common).
frequency(biliary_colic                         ,  common).
frequency(intestinal_obstruction                ,  occasional).
frequency(ureteric_colic                        ,  occasional).
frequency(acute_pancreatitis                    ,  occasional).
frequency(mesenteric_adenitis                   ,  occasional).
frequency(ectopic_pregnancy                     ,  occasional).
frequency(diverticulitis                        ,  occasional).
frequency(aortic_aneurysm                       ,  rare).

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
