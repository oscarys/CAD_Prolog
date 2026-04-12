/* ============================================================
   MODULE: shock
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 406-409
   AUTHORS: <your names>
   SYSTEM:  Cardiovascular / Sepsis

   DIAGNOSES TO ENCODE (from Churchill's):
   %   hypovolaemic_shock                     frequency: common
   %   septic_shock                           frequency: common
   %   cardiogenic_shock                      frequency: occasional
   %   anaphylactic_shock                     frequency: occasional
   %   neurogenic_shock                       frequency: rare
   %   obstructive_shock                      frequency: rare

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(preceding_haemorrhage         , Value)  -- type: yesno
   %   symptom(fever                         , Value)  -- type: yesno
   %   symptom(history_of_mi                 , Value)  -- type: yesno
   %   symptom(exposure_to_allergen          , Value)  -- type: yesno
   %   symptom(spinal_injury                 , Value)  -- type: yesno
   %   symptom(known_infection_source        , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(bp_systolic                   , Value)  -- type: number
   %   finding(pulse_rate                    , Value)  -- type: number
   %   finding(capillary_refill              , Value)  -- type: choice: normal|delayed
   %   finding(jvp_elevated                  , Value)  -- type: yesno
   %   finding(jvp_absent                    , Value)  -- type: yesno
   %   finding(wheeze                        , Value)  -- type: yesno
   %   finding(urticaria                     , Value)  -- type: yesno
   %   finding(cold_peripheries              , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(shock, [diagnose/2, frequency/2,
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

frequency(hypovolaemic_shock                    ,  common).
frequency(septic_shock                          ,  common).
frequency(cardiogenic_shock                     ,  occasional).
frequency(anaphylactic_shock                    ,  occasional).
frequency(neurogenic_shock                      ,  rare).
frequency(obstructive_shock                     ,  rare).

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
