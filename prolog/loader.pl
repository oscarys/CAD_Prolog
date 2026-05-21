/* ============================================================
   loader.pl
   Master entry point. Consulted by the bridge at startup.
   Declares all dynamic predicates and loads all modules.

   NOTE: use_module/2 with an empty import list [] loads each
   module into its own namespace without importing predicate
   names into 'user'. The bridge calls all predicates with
   explicit module qualification, e.g. chest_pain:diagnose(D,F).
   ============================================================ */

% Dynamic predicates asserted/retracted by the bridge at query time.
% Never define these in your module  -  they are managed externally.
:- dynamic patient_age/1.
:- dynamic patient_sex/1.
:- dynamic symptom/2.
:- dynamic finding/2.

% Load the worked example module
:- use_module('modules/chest_pain', []).

% Load student modules (uncomment as each is completed)
% :- use_module('modules/dyspnoea',               []).
% :- use_module('modules/cough_haemoptysis',       []).
% :- use_module('modules/stridor',                 []).
:- use_module('modules/abdominal_pain',          []).
% :- use_module('modules/jaundice',                []).
% :- use_module('modules/haematemesis',            []).
% :- use_module('modules/diarrhoea',               []).
:- use_module('modules/headache',                []).
% :- use_module('modules/convulsions',             []).
% :- use_module('modules/coma_confusion',          []).
% :- use_module('modules/pyrexia_unknown_origin',  []).
:- use_module('modules/weight_loss',             []).
:- use_module('modules/shock',                   []).
% :- use_module('modules/haematuria',              []).
% :- use_module('modules/polyuria_thirst',         []).
% :- use_module('modules/oedema',                  []).
% :- use_module('modules/palpitations',            []).
% :- use_module('modules/syncope',                 []).
