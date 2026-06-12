/* ============================================================
   MODULE: convulsions
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 80-83
   AUTHORS: Melissa Itzel Ayala Rodríguez
   SYSTEM:  Neurological
   ------------------------------------------------------------ */

:- module(convulsions, [diagnose/2, frequency/2,
                       suggest_test/2, explain_step/3,
                       exclude_if/2]).
 
:- encoding(utf8). 

/* ------------------------------------------------------------
   SECTION 1 -- FREQUENCY TABLE
   ------------------------------------------------------------ */

frequency(epilepsy                              ,  common).
frequency(febrile_convulsion                    ,  common).
frequency(hypoglycaemia                         ,  common).
frequency(hyponatraemia                         ,  occasional).
frequency(meningitis                            ,  occasional).
frequency(intracranial_tumour                   ,  occasional).
frequency(alcohol_withdrawal                    ,  occasional).
frequency(stroke                                ,  occasional).
frequency(eclampsia                             ,  occasional).

/* ------------------------------------------------------------
   SECTION 2 -- DIAGNOSTIC RULES
   ------------------------------------------------------------ */

% --- Epilepsy ---
diagnose(epilepsy, Frequency) :-
   symptom(convulsion, yes),
   symptom(aura, yes),
   symptom(postictal_confusion, yes),
   frequency(epilepsy, Frequency).

diagnose(epilepsy, Frequency) :-
   symptom(convulsion, yes),
   symptom(tongue_biting, yes),
   symptom(incontinence, yes),
   \+ symptom(fever, yes),
   frequency(epilepsy, Frequency).

% --- Febrile convulsion ---
diagnose(febrile_convulsion, Frequency) :-
   symptom(convulsion, yes),
   symptom(fever, yes),
   finding(pyrexia, yes),
   \+ finding(neck_stiffness, yes),
   \+ finding(papilloedema, yes),
   frequency(febrile_convulsion, Frequency).

% --- Hypoglycaemia ---
diagnose(hypoglycaemia, Frequency) :-
    symptom(convulsion, yes),
    symptom(diabetes, yes),
    finding(blood_glucose_low, yes),
    frequency(hypoglycaemia, Frequency).
 
% --- Hyponatraemia ---
diagnose(hyponatraemia, Frequency) :-
    symptom(convulsion, yes),
    finding(sodium_abnormal, yes),
    \+ finding(neck_stiffness, yes),
    \+ symptom(fever, yes),           
    frequency(hyponatraemia, Frequency).
 
% --- Meningitis ---
diagnose(meningitis, Frequency) :-
    symptom(convulsion, yes),
    symptom(fever, yes),
    finding(neck_stiffness, yes),
    finding(pyrexia, yes),
    frequency(meningitis, Frequency).
 
% --- Intracranial tumour ---
diagnose(intracranial_tumour, Frequency) :-
    symptom(convulsion, yes),
    symptom(focal_onset, yes),
    finding(papilloedema, yes),
    \+ symptom(fever, yes),
    frequency(intracranial_tumour, Frequency).
 
diagnose(intracranial_tumour, Frequency) :-
    symptom(convulsion, yes),
    symptom(focal_onset, yes),
    finding(focal_neurology, yes),
    \+ symptom(fever, yes),
    \+ finding(blood_glucose_low, yes),
    \+ finding(sodium_abnormal, yes),
    frequency(intracranial_tumour, Frequency).
 
% --- Alcohol withdrawal ---
diagnose(alcohol_withdrawal, Frequency) :-
    symptom(convulsion, yes),
    symptom(alcohol_use, yes),
    \+ finding(neck_stiffness, yes),
    \+ finding(papilloedema, yes),
    frequency(alcohol_withdrawal, Frequency).
 
% --- Stroke ---
diagnose(stroke, Frequency) :-
    symptom(convulsion, yes),
    symptom(focal_onset, yes),
    finding(focal_neurology, yes),
    \+ symptom(fever, yes),
    \+ finding(blood_glucose_low, yes),
    \+ finding(sodium_abnormal, yes),
    \+ finding(papilloedema, yes),
    frequency(stroke, Frequency).
 
% --- Eclampsia ---
diagnose(eclampsia, Frequency) :-
    symptom(convulsion, yes),
    symptom(pregnancy, yes),
    frequency(eclampsia, Frequency).

/* ------------------------------------------------------------
   SECTION 3 -- INVESTIGATIONS
   One suggest_test/2 fact per (diagnosis, test) pair.
   Source: Churchill's General and Specific Investigations sections.
   ------------------------------------------------------------ */

% Epilepsy
suggest_test(epilepsy,            eeg).
suggest_test(epilepsy,            ct_or_mri_head).
suggest_test(epilepsy,            fbc).
suggest_test(epilepsy,            blood_glucose).
suggest_test(epilepsy,            urea_and_electrolytes).
suggest_test(epilepsy,            serum_calcium).

% Febrile convulsion
suggest_test(febrile_convulsion,  fbc).
suggest_test(febrile_convulsion,  blood_glucose).
suggest_test(febrile_convulsion,  urea_and_electrolytes).
suggest_test(febrile_convulsion,  lumbar_puncture).
suggest_test(febrile_convulsion,  ct_or_mri_head).

% Hypoglycaemia
suggest_test(hypoglycaemia,       bm_stix).
suggest_test(hypoglycaemia,       blood_glucose).
suggest_test(hypoglycaemia,       fbc).
suggest_test(hypoglycaemia,       urea_and_electrolytes).

% Hyponatraemia
suggest_test(hyponatraemia,       urea_and_electrolytes).
suggest_test(hyponatraemia,       serum_calcium).
suggest_test(hyponatraemia,       fbc).
suggest_test(hyponatraemia,       ct_or_mri_head).

% Meningitis
suggest_test(meningitis,          lumbar_puncture).
suggest_test(meningitis,          fbc).
suggest_test(meningitis,          blood_glucose).
suggest_test(meningitis,          ct_or_mri_head).
suggest_test(meningitis,          urea_and_electrolytes).

% Intracranial tumour
suggest_test(intracranial_tumour, ct_or_mri_head).
suggest_test(intracranial_tumour, fbc).
suggest_test(intracranial_tumour, urea_and_electrolytes).
suggest_test(intracranial_tumour, serum_calcium).
suggest_test(intracranial_tumour, blood_glucose).

% Alcohol withdrawal
suggest_test(alcohol_withdrawal,  fbc).
suggest_test(alcohol_withdrawal,  urea_and_electrolytes).
suggest_test(alcohol_withdrawal,  blood_glucose).
suggest_test(alcohol_withdrawal,  serum_calcium).
suggest_test(alcohol_withdrawal,  ct_or_mri_head).
 
% Stroke
suggest_test(stroke,              ct_or_mri_head).
suggest_test(stroke,              fbc).
suggest_test(stroke,              blood_glucose).
suggest_test(stroke,              urea_and_electrolytes).
suggest_test(stroke,              abg).
 
% Eclampsia
suggest_test(eclampsia,           urea_and_electrolytes).
suggest_test(eclampsia,           fbc).
suggest_test(eclampsia,           blood_glucose).
suggest_test(eclampsia,           ct_or_mri_head).

/* ------------------------------------------------------------
   SECTION 4 -- PROOF TRACE
   One explain_step/3 clause per symptom/finding each rule depends on.
   ------------------------------------------------------------ */

% --- epilepsy ---
explain_step(epilepsy, convulsion,
    'La convulsión es el síntoma cardinal de la epilepsia, resultado de una descarga neuronal sincrónica anormal en la corteza cerebral').
explain_step(epilepsy, aura,
    'El aura precede a la convulsión y representa actividad ictal focal antes de la generalización; es un marcador altamente específico de epilepsia').
explain_step(epilepsy, postictal_confusion,
    'La confusión postictal refleja el agotamiento neuronal tras la descarga epiléptica y es característica de las crisis tonicoclónicas generalizadas').
explain_step(epilepsy, tongue_biting,
    'El mordisqueo lateral de la lengua durante la fase tónica es un signo muy específico de crisis epiléptica generalizada').
explain_step(epilepsy, incontinence,
    'La incontinencia urinaria resulta de la relajación esfinteriana involuntaria durante la fase clónica de la crisis epiléptica').
explain_step(epilepsy, fever,
    'La ausencia de fiebre distingue la epilepsia idiopática de las convulsiones febriles o de origen infeccioso').

% --- febrile_convulsion ---
explain_step(febrile_convulsion, convulsion,
    'La convulsión febril es la causa más frecuente de crisis convulsiva en niños entre 6 meses y 5 años; el cerebro en desarrollo es especialmente susceptible a la fiebre').
explain_step(febrile_convulsion, fever,
    'El ascenso rápido de la temperatura corporal desencadena hiperexcitabilidad neuronal en el cerebro infantil en desarrollo').
explain_step(febrile_convulsion, pyrexia,
    'La pirexia objetivada en la exploración confirma que la fiebre es la causa del episodio convulsivo').
explain_step(febrile_convulsion, neck_stiffness,
    'La ausencia de rigidez de nuca descarta meningitis como causa; su presencia obligaría a punción lumbar urgente').
explain_step(febrile_convulsion, papilloedema,
    'La ausencia de papiledema descarta hipertensión intracraneal por lesión ocupante de espacio').

% --- hypoglycaemia ---
explain_step(hypoglycaemia, convulsion,
    'La hipoglucemia grave priva al cerebro de glucosa, su principal sustrato energético, desencadenando actividad convulsiva').
explain_step(hypoglycaemia, diabetes,
    'La diabetes tratada con insulina o sulfonilureas es el principal factor de riesgo de hipoglucemia grave; el BM stix es la prueba de cribado inmediata').
explain_step(hypoglycaemia, blood_glucose_low,
    'La glucemia baja confirmada en el momento de la convulsión establece la causa metabólica del episodio y permite tratamiento inmediato con glucosa').

% --- hyponatraemia ---
explain_step(hyponatraemia, convulsion,
    'La hiponatremia grave causa edema cerebral por entrada de agua al espacio intracelular, desencadenando convulsiones cuando el sodio cae por debajo de 120 mEq/L').
explain_step(hyponatraemia, sodium_abnormal,
    'El sodio sérico anormal en los U&Es es el hallazgo diagnóstico definitivo de la hiponatremia como causa metabólica de la convulsión').
explain_step(hyponatraemia, neck_stiffness,
    'La ausencia de rigidez de nuca descarta meningitis como causa alternativa de la convulsión').
explain_step(hyponatraemia, fever,
    'La ausencia de fiebre hace menos probable una causa infecciosa del SNC').

% --- meningitis ---
explain_step(meningitis, convulsion,
    'La irritación cortical directa por la inflamación meníngea puede desencadenar convulsiones; la WCC elevada en el FBC apoya el origen infeccioso').
explain_step(meningitis, fever,
    'La fiebre refleja la respuesta inflamatoria sistémica a la infección bacteriana o vírica del SNC').
explain_step(meningitis, neck_stiffness,
    'La rigidez de nuca indica irritación meníngea y es el signo exploratorio más importante de la meningitis; la punción lumbar confirma el diagnóstico').
explain_step(meningitis, pyrexia,
    'La pirexia objetivada junto con la rigidez de nuca refuerza el diagnóstico de meningitis infecciosa').

% --- intracranial_tumour ---
explain_step(intracranial_tumour, convulsion,
    'Las lesiones ocupantes de espacio irritan la corteza cerebral circundante generando focos epileptógenos; el CT/MRI muestra alteraciones de densidad').
explain_step(intracranial_tumour, focal_onset,
    'El inicio focal de la convulsión localiza la lesión cortical subyacente y es característico de patología estructural como tumores').
explain_step(intracranial_tumour, papilloedema,
    'El papiledema indica hipertensión intracraneal por efecto masa; el CT/MRI confirma la lesión ocupante de espacio').
explain_step(intracranial_tumour, focal_neurology,
    'Los déficits neurológicos focales persistentes apuntan a una lesión estructural; el deterioro progresivo sugiere tumor más que ictus').
explain_step(intracranial_tumour, fever,
    'La ausencia de fiebre hace improbable una causa infecciosa del SNC como meningitis o encefalitis').
explain_step(intracranial_tumour, blood_glucose_low,
    'La glucemia normal descarta hipoglucemia como causa de los déficits neurológicos focales').
explain_step(intracranial_tumour, sodium_abnormal,
    'El sodio normal en los U&Es descarta hiponatremia como causa metabólica de la convulsión focal').

% --- alcohol_withdrawal ---
explain_step(alcohol_withdrawal, convulsion,
    'La abstinencia alcohólica provoca hiperexcitabilidad del SNC por suprarregulación de receptores NMDA y supresión GABAérgica tras el cese brusco del alcohol').
explain_step(alcohol_withdrawal, alcohol_use,
    'El consumo crónico de alcohol seguido de reducción o cese brusco es la causa directa; debe documentarse mediante historia clínica y analítica hepática').
explain_step(alcohol_withdrawal, neck_stiffness,
    'La ausencia de rigidez de nuca descarta meningitis como causa alternativa de la convulsión').
explain_step(alcohol_withdrawal, papilloedema,
    'La ausencia de papiledema descarta lesión ocupante de espacio como causa de la convulsión').

% --- stroke ---
explain_step(stroke, convulsion,
    'El infarto o la hemorragia cerebral pueden irritar la corteza motora generando convulsiones focales; el CT muestra cambios de densidad isquémica o hemorrágica').
explain_step(stroke, focal_onset,
    'El inicio focal refleja el territorio cortical afectado por el accidente cerebrovascular').
explain_step(stroke, focal_neurology,
    'Los déficits neurológicos focales persistentes diferencian el ictus de causas metabólicas; el CT/MRI confirma el tipo de lesión vascular').
explain_step(stroke, fever,
    'La ausencia de fiebre hace improbable una causa infecciosa del SNC').
explain_step(stroke, blood_glucose_low,
    'La glucemia normal en el BM stix descarta hipoglucemia como causa de los síntomas neurológicos focales').
explain_step(stroke, sodium_abnormal,
    'El sodio normal en los U&Es descarta hiponatremia como causa metabólica de la convulsión').
explain_step(stroke, papilloedema,
    'La ausencia de papiledema diferencia el ictus agudo del tumor intracraneal, que produce hipertensión intracraneal crónica').

% --- eclampsia ---
explain_step(eclampsia, convulsion,
    'Las convulsiones en la eclampsia resultan del vasoespasmo cerebral y el edema secundarios a la hipertensión grave del embarazo').
explain_step(eclampsia, pregnancy,
    'La eclampsia ocurre exclusivamente durante el embarazo o el puerperio inmediato; la proteinuria y la hipertensión confirman la preeclampsia subyacente').


/* ------------------------------------------------------------
   SECTION 5 -- EXCLUSION RULES  (optional but encouraged)
   ------------------------------------------------------------ */
exclude_if(febrile_convulsion,
           'La rigidez de nuca indica meningitis -- no atribuir la convulsión a causa febril simple sin descartar infección del SNC mediante punción lumbar') :-
    finding(neck_stiffness, yes).

exclude_if(febrile_convulsion,
           'El papiledema indica hipertensión intracraneal -- debe descartarse lesión ocupante de espacio antes de asumir convulsión febril simple') :-
    finding(papilloedema, yes).

exclude_if(stroke,
           'Glucemia baja detectada -- tratar hipoglucemia antes de diagnosticar ictus') :-
    finding(blood_glucose_low, yes).

exclude_if(alcohol_withdrawal,
           'La rigidez de nuca sugiere meningitis -- no asumir abstinencia alcohólica sin descartar infección del SNC') :-
    finding(neck_stiffness, yes).

exclude_if(intracranial_tumour,
           'La fiebre sugiere causa infecciosa -- descartar meningitis o encefalitis antes que tumor') :-
    symptom(fever, yes).