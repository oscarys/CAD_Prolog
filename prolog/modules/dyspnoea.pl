/* ============================================================
   MODULE: dyspnoea
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 109-114
   AUTHORS: <your names>
   SYSTEM:  Respiratory / Cardiovascular

   DIAGNOSES TO ENCODE (from Churchill's):
   %   asthma                                 frequency: common
   %   copd                                   frequency: common
   %   heart_failure                          frequency: common
   %   pneumonia                              frequency: common
   %   pulmonary_embolism                     frequency: occasional
   %   pneumothorax                           frequency: occasional
   %   pleural_effusion                       frequency: occasional
   %   anaemia                                frequency: common
   %   pulmonary_fibrosis                     frequency: rare
   %   lung_cancer                            frequency: occasional

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(dyspnoea                      , Value)  -- type: yesno
   %   symptom(onset                         , Value)  -- type: choice: sudden|gradual|progressive
   %   symptom(worse_on_exertion             , Value)  -- type: yesno
   %   symptom(orthopnoea                    , Value)  -- type: yesno
   %   symptom(paroxysmal_nocturnal_dyspnoea , Value)  -- type: yesno
   %   symptom(wheeze                        , Value)  -- type: yesno
   %   symptom(cough                         , Value)  -- type: yesno
   %   symptom(haemoptysis                   , Value)  -- type: yesno
   %   symptom(chest_pain                    , Value)  -- type: yesno
   %   symptom(fever                         , Value)  -- type: yesno
   %   symptom(leg_swelling                  , Value)  -- type: yesno
   %   symptom(weight_loss                   , Value)  -- type: yesno
   %   symptom(smoking_history               , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(wheeze_on_auscultation        , Value)  -- type: yesno
   %   finding(crepitations                  , Value)  -- type: yesno
   %   finding(reduced_air_entry             , Value)  -- type: yesno
   %   finding(peripheral_oedema             , Value)  -- type: yesno
   %   finding(jvp_elevated                  , Value)  -- type: yesno
   %   finding(tracheal_deviation            , Value)  -- type: yesno
   %   finding(dullness_to_percussion        , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(dyspnoea, [diagnose/2, frequency/2,
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

frequency(asthma                                ,  common).
frequency(copd                                  ,  common).
frequency(heart_failure                         ,  common).
frequency(pneumonia                             ,  common).
frequency(pulmonary_embolism                    ,  occasional).
frequency(pneumothorax                          ,  occasional).
frequency(pleural_effusion                      ,  occasional).
frequency(anaemia                               ,  common).
frequency(pulmonary_fibrosis                    ,  rare).
frequency(lung_cancer                           ,  occasional).

/* ------------------------------------------------------------
   SECTION 2 -- DIAGNOSTIC RULES
   One diagnose/2 clause per distinct clinical picture.
   Each rule must end with:  frequency(Diagnosis, Frequency).
   ------------------------------------------------------------ */

% --- Respiratory ---

diagnose(asthma, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(wheeze, yes),
    finding(wheeze_on_auscultation, yes),
    frequency(asthma, Frequency).

diagnose(asthma, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    symptom(wheeze, yes),
    frequency(asthma, Frequency).


diagnose(copd, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, progressive),
    symptom(smoking_history, yes),
    finding(reduced_air_entry, yes),
    frequency(copd, Frequency).

diagnose(copd, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(cough, yes),
    symptom(smoking_history, yes),
    finding(reduced_air_entry, yes),
    frequency(copd, Frequency).


diagnose(pneumonia, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(cough, yes),
    symptom(fever, yes),
    finding(crepitations, yes),
    frequency(pneumonia, Frequency).

diagnose(pneumonia, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(fever, yes),
    symptom(chest_pain, yes),
    finding(crepitations, yes),
    frequency(pneumonia, Frequency).


diagnose(pneumothorax, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    symptom(chest_pain, yes),
    finding(reduced_air_entry, yes),
    frequency(pneumothorax, Frequency).

diagnose(pneumothorax, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    finding(reduced_air_entry, yes),
    finding(tracheal_deviation, yes),
    frequency(pneumothorax, Frequency).


diagnose(pleural_effusion, Frequency) :-
    symptom(dyspnoea, yes),
    finding(reduced_air_entry, yes),
    finding(dullness_to_percussion, yes),
    frequency(pleural_effusion, Frequency).

diagnose(pleural_effusion, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(chest_pain, yes),
    finding(dullness_to_percussion, yes),
    frequency(pleural_effusion, Frequency).


diagnose(pulmonary_fibrosis, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, progressive),
    finding(crepitations, yes),
    \+ symptom(fever, yes),
    frequency(pulmonary_fibrosis, Frequency).

diagnose(pulmonary_fibrosis, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, progressive),
    symptom(cough, yes),
    finding(crepitations, yes),
    \+ symptom(smoking_history, yes),
    frequency(pulmonary_fibrosis, Frequency).


% --- Cardiovascular / vascular ---

diagnose(heart_failure, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(orthopnoea, yes),
    finding(peripheral_oedema, yes),
    frequency(heart_failure, Frequency).

diagnose(heart_failure, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(paroxysmal_nocturnal_dyspnoea, yes),
    finding(jvp_elevated, yes),
    frequency(heart_failure, Frequency).

diagnose(heart_failure, Frequency) :-
    symptom(dyspnoea, yes),
    finding(crepitations, yes),
    finding(peripheral_oedema, yes),
    frequency(heart_failure, Frequency).


diagnose(pulmonary_embolism, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    symptom(chest_pain, yes),
    symptom(haemoptysis, yes),
    frequency(pulmonary_embolism, Frequency).

diagnose(pulmonary_embolism, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    symptom(chest_pain, yes),
    symptom(leg_swelling, yes),
    frequency(pulmonary_embolism, Frequency).


% --- Haematological / malignancy ---

diagnose(anaemia, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(worse_on_exertion, yes),
    \+ symptom(wheeze, yes),
    \+ symptom(fever, yes),
    frequency(anaemia, Frequency).

diagnose(anaemia, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, progressive),
    \+ finding(reduced_air_entry, yes),
    \+ finding(crepitations, yes),
    frequency(anaemia, Frequency).


diagnose(lung_cancer, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(cough, yes),
    symptom(haemoptysis, yes),
    symptom(weight_loss, yes),
    frequency(lung_cancer, Frequency).

diagnose(lung_cancer, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(smoking_history, yes),
    symptom(weight_loss, yes),
    frequency(lung_cancer, Frequency).

diagnose(lung_cancer, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(haemoptysis, yes),
    symptom(smoking_history, yes),
    frequency(lung_cancer, Frequency).

    
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
