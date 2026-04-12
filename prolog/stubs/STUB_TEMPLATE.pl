/* ============================================================
   MODULE: <your_presentation_name>
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor  -  Elsevier 2010, p. <PAGE>
   AUTHORS: <your names>

   INSTRUCTIONS:
   1. Replace <your_presentation_name> with the atom for your presentation
      e.g.  headache, dyspnoea, abdominal_pain
   2. Replace <PAGE> with the Churchill's page number
   3. Fill in every section. Do not delete section headers.
   4. When done: run  pytest tests/test_kb.py   -  all checks must pass.
   5. See prolog/modules/chest_pain.pl for a fully worked example.
   ============================================================ */

:- module(<your_presentation_name>, [diagnose/2, frequency/2,
                                      suggest_test/2, explain_step/3,
                                      exclude_if/2]).

:- encoding(utf8).


/* ------------------------------------------------------------
   SECTION 1  -  FREQUENCY TABLE
   Fill this in first. One fact per diagnosis you will encode.
   Values: common | occasional | rare
   Source: Churchill's colour coding for your presentation.
   ------------------------------------------------------------ */

% frequency(<diagnosis_atom>,  <common|occasional|rare>).
%
% frequency(TODO_diagnosis_1,  common).
% frequency(TODO_diagnosis_2,  occasional).
% frequency(TODO_diagnosis_3,  rare).


/* ------------------------------------------------------------
   SECTION 2  -  DIAGNOSTIC RULES
   One diagnose/2 clause per distinct clinical picture.
   Each clause must end with:  frequency(Diagnosis, Frequency).
   Use symptom/2 and finding/2 calls to match the patient's data.
   ------------------------------------------------------------ */

% diagnose(TODO_diagnosis_1, Frequency) :-
%     symptom(<symptom_atom>, yes),
%     ...,
%     frequency(TODO_diagnosis_1, Frequency).
%
% diagnose(TODO_diagnosis_2, Frequency) :-
%     symptom(<symptom_atom>, yes),
%     ...,
%     frequency(TODO_diagnosis_2, Frequency).


/* ------------------------------------------------------------
   SECTION 3  -  INVESTIGATIONS
   One suggest_test/2 fact per (diagnosis, test) pair.
   Source: Churchill's General Investigations and Specific
           Investigations sections for your presentation.
   ------------------------------------------------------------ */

% suggest_test(TODO_diagnosis_1,  ecg).
% suggest_test(TODO_diagnosis_1,  fbc).
% suggest_test(TODO_diagnosis_2,  cxr).
% ...


/* ------------------------------------------------------------
   SECTION 4  -  PROOF TRACE
   One explain_step/3 clause for EVERY symptom/finding that any
   of your diagnose/2 rules depends on.
   Rationale should be a human-readable sentence (use single quotes).
   ------------------------------------------------------------ */

% explain_step(TODO_diagnosis_1, <symptom_atom>,
%     'Rationale: why this finding points toward this diagnosis').
%
% explain_step(TODO_diagnosis_2, <symptom_atom>,
%     'Rationale text here').


/* ------------------------------------------------------------
   SECTION 5  -  EXCLUSION RULES  (optional but encouraged)
   Encode hard clinical exclusions using findings.
   The body should check one or more finding/2 facts.
   ------------------------------------------------------------ */

% exclude_if(TODO_diagnosis_1, 'Reason as human-readable text') :-
%     finding(<finding_atom>, <value>).
