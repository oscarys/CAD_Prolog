/* ============================================================
   MODULE: cough_haemoptysis
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 84-90, 191-195
   AUTHORS: Rodrigo Loredo Villada
   SYSTEM:  Respiratory

   DIAGNOSES TO ENCODE (from Churchill's):
   %   copd                                   frequency: common
   %   asthma                                 frequency: common
   %   respiratory_tract_infection            frequency: common
   %   gord                                   frequency: common
   %   ace_inhibitor_cough                    frequency: common
   %   bronchiectasis                         frequency: occasional
   %   lung_cancer                            frequency: occasional
   %   tb                                     frequency: occasional
   %   pulmonary_oedema                       frequency: occasional
   %   pulmonary_embolism                     frequency: occasional

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(cough                         , Value)  -- type: yesno
   %   symptom(haemoptysis                   , Value)  -- type: yesno
   %   symptom(sputum_character              , Value)  -- type: choice: purulent|mucoid|bloodstained|frothy|none
   %   symptom(onset                         , Value)  -- type: choice: acute|chronic
   %   symptom(smoking_history               , Value)  -- type: yesno
   %   symptom(weight_loss                   , Value)  -- type: yesno
   %   symptom(dyspnoea                      , Value)  -- type: yesno
   %   symptom(wheeze                        , Value)  -- type: yesno
   %   symptom(fever                         , Value)  -- type: yesno
   %   symptom(taking_ace_inhibitor          , Value)  -- type: yesno
   %   symptom(reflux_symptoms               , Value)  -- type: yesno
   %   symptom(night_sweats                  , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(wheeze_on_auscultation        , Value)  -- type: yesno
   %   finding(crepitations                  , Value)  -- type: yesno
   %   finding(clubbing                      , Value)  -- type: yesno
   %   finding(jvp_elevated                  , Value)  -- type: yesno
   %   finding(supraclavicular_lymphadenopathy, Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(cough_haemoptysis, [diagnose/2, frequency/2,
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

frequency(copd                                  ,  common).
frequency(asthma                                ,  common).
frequency(respiratory_tract_infection           ,  common).
frequency(gord                                  ,  common).
frequency(ace_inhibitor_cough                   ,  common).
frequency(bronchiectasis                        ,  occasional).
frequency(lung_cancer                           ,  occasional).
frequency(tb                                    ,  occasional).
frequency(pulmonary_oedema                      ,  occasional).
frequency(pulmonary_embolism                    ,  occasional).

frequency(pneumonia                             , common).
frequency(chronic_bronchitis                    , common).
frequency(goodpastures_syndrome                 , rare).
frequency(wegeners_granulomatosis               , rare).
frequency(mitral_stenosis                       , rare).
frequency(hereditary_haemorrhagic_telangiectasia, rare).
frequency(coagulation_disorders                 , occasional).

/* ------------------------------------------------------------
   SECTION 2 -- DIAGNOSTIC RULES
   One diagnose/2 clause per distinct clinical picture.
   Each rule must end with:  frequency(Diagnosis, Frequency).
   ------------------------------------------------------------ */

% TODO: write your diagnose/2 rules here.
% Pattern:

diagnose(copd, Frequency) :-
   symptom(cough, yes), 
   symptom(onset, chronic),
   symptom(sputum_character, mucoid),
   symptom(smoking_history, yes),
   symptom(cyanosis, yes),
   finding(wheeze_on_auscultation, yes),
   finding(reduced_air_entry, yes),
   frequency(copd, Frequency).


diagnose(asthma, Frequency) :-
   symptom(cough, yes),
   symptom(onset, acute),
   symptom(wheeze, yes),
   symptom(dyspnoea, yes),
   finding(wheeze_on_auscultation, yes),
   frequency(asthma, Frequency).


diagnose(respiratory_tract_infection, Frequency) :-
   symptom(cough, yes),
   symptom(onset, acute),
   symptom(fever, yes),
   finding(crepitations, yes),
   frequency(respiratory_tract_infection, Frequency).


diagnose(gord, Frequency) :-
   symptom(cough, yes),
   symptom(onset, chronic),
   symptom(reflux_symptoms, yes),
   symptom(pain_character, burning),
   frequency(gord, Frequency).


diagnose(ace_inhibitor_cough, Frequency) :-
   symptom(cough, yes),
   symptom(taking_ace_inhibitor, yes),
   symptom(onset, chronic),
   frequency(ace_inhibitor_cough, Frequency).
    

diagnose(bronchiectasis, Frequency) :-
   symptom(cough, yes),
   symptom(sputum_character, purulent),
   symptom(onset, chronic),
   symptom(dyspnoea, yes),
   finding(crepitations, yes),
   finding(clubbing, yes),
   frequency(bronchiectasis, Frequency).


diagnose(lung_cancer, Frequency) :-
   symptom(cough, yes),
   symptom(onset, chronic),
   symptom(sputum_character, bloodstained),
   symptom(smoking_history, yes),
   symptom(dyspnoea, yes),
   symptom(haemoptysis, yes),
   symptom(weight_loss, yes),
   finding(lymphadenopathy, yes),
   finding(reduced_air_entry, yes),
   frequency(lung_cancer, Frequency).


diagnose(tb, Frequency) :-
   symptom(cough, yes),
   symptom(onset, chronic),
   symptom(sputum_character, bloodstained),
   symptom(haemoptysis, yes),
   symptom(weight_loss, yes),
   symptom(fever, yes),
   finding(crepitations, yes),
   frequency(tb, Frequency).


diagnose(pulmonary_oedema, Frequency) :-
   symptom(cough, yes),
   symptom(onset, acute),
   symptom(dyspnoea, yes),
   symptom(sputum_character, pink),
   finding(crepitations, yes),
   frequency(pulmonary_oedema, Frequency).


diagnose(pulmonary_embolism, Frequency) :-
   symptom(cough, yes),
   symptom(onset, acute),
   symptom(sputum_character, bloodstained),
   symptom(dyspnoea, yes),
   symptom(fever, yes),
   symptom(cyanosis, yes),
   frequency(pulmonary_embolism, Frequency).


diagnose(pneumonia, Frequency) :-
   symptom(haemoptysis, yes),
   symptom(cough, yes),
   symptom(sputum_character, bloodstained),
   symptom(breathing, bronchial),
   symptom(fever, yes),
   symptom(chest_pain, yes),
   finding(crepitations, yes),
   frequency(pneumonia, Frequency).


diagnose(chronic_bronchitis, Frequency) :-
   symptom(haemoptysis, yes),
   symptom(onset, chronic),
   symptom(cough, yes),
   symptom(sputum_character, purulent),
   symptom(dyspnoea, yes),
   finding(clubbing, yes),
   finding(chest, hyperexpanded),
   finding(crepitations, yes),
   frequency(chronic_bronchitis, Frequency).


diagnose(goodpastures_syndrome, Frequency) :-
   symptom(haemoptysis, yes),
   symptom(haematuria, yes),
   symptom(dyspnoea, yes),
   symptom(renal_disease, yes),
   frequency(goodpastures_syndrome, Frequency).


diagnose(wegeners_granulomatosis, Frequency) :-
   symptom(haemoptysis, yes),
   symptom(epistaxis, yes),
   symptom(renal_disease, yes),
   finding(loss_nasal_bridge, yes),
   finding(saddling_nose, yes),
   frequency(wegeners_granulomatosis, Frequency).


diagnose(mitral_stenosis, Frequency) :-
   symptom(haemoptysis, yes),
   symptom(cough, yes),
   symptom(onset, chronic),
   symptom(sputum_character, purulent),
   symptom(flecks_blood, yes),
   symptom(dyspnoea, yes),
   symptom(fever, yes),
   frequency(mitral_stenosis, Frequency).


diagnose(hereditary_haemorrhagic_telangiectasia, Frequency) :-
   symptom(haemoptysis, yes),
   symptom(epistaxis, yes),
   finding(dilated_blood_vessels, yes),
   frequency(hereditary_haemorrhagic_telangiectasia, Frequency).


diagnose(coagulation_disorders, Frequency) :-
   symptom(haemoptysis, yes),
   symptom(taking_anticoagulant, yes),
   symptom(atrial_fibrillation, yes),
   frequency(coagulation_disorders, Frequency).


/* ------------------------------------------------------------
   SECTION 3 -- INVESTIGATIONS
   One suggest_test/2 fact per (diagnosis, test) pair.
   Source: Churchill's General and Specific Investigations sections.
   ------------------------------------------------------------ */

% TODO: add suggest_test/2 facts here.
% suggest_test(<diagnosis>, <test_atom>).

suggest_test(copd, sputum_cultures).


suggest_test(asthma, peak_flow).
suggest_test(asthma, respiratory_function_test).


suggest_test(respiratory_tract_infection, wcc).
suggest_test(respiratory_tract_infection, cxr).
suggest_test(respiratory_tract_infection, fbc).


suggest_test(gord, ph_studies).


suggest_test(bronchiectasis, sputum_cultures).
suggest_test(bronchiectasis, cxr).
suggest_test(bronchiectasis, respiratory_function_test).
suggest_test(bronchiectasis, ct_thorax).


suggest_test(lung_cancer, cxr).
suggest_test(lung_cancer, ct_thorax).
suggest_test(lung_cancer, tissue_biopsies).


suggest_test(tb, sputum_cultures).
suggest_test(tb, cxr).
suggest_test(tb, urine_cultures).
suggest_test(tb, bronchial_washing).
suggest_test(tb, lung_biopsy).
suggest_test(tb, mantoux_test).


suggest_test(pulmonary_oedema, cxr).
suggest_test(pulmonary_oedema, echocardiography).


suggest_test(pulmonary_embolism, wcc).
suggest_test(pulmonary_embolism, vq_scan).
suggest_test(pulmonary_embolism, pulmonary_angiography).
suggest_test(pulmonary_embolism, ecg).
suggest_test(pulmonary_embolism, pulmonary_angiogram).


suggest_test(pneumonia, cxr).
suggest_test(pneumonia, bronchoscopy).


suggest_test(chronic_bronchitis, fbc).
suggest_test(chronic_bronchitis, cxr).
suggest_test(chronic_bronchitis, bronchoscopy).


suggest_test(mitral_stenosis, fbc).
suggest_test(mitral_stenosis, cxr).
suggest_test(mitral_stenosis, bronchoscopy).


suggest_test(goodpastures_syndrome, ues).
suggest_test(goodpastures_syndrome, cxr).
suggest_test(goodpastures_syndrome, bronchoscopy).
suggest_test(goodpastures_syndrome, urinalysis).
suggest_test(goodpastures_syndrome, antiglomerular_basement_antibodies).
suggest_test(goodpastures_syndrome, renal_biopsy).



suggest_test(wegeners_granulomatosis, ues).
suggest_test(wegeners_granulomatosis, cxr).
suggest_test(wegeners_granulomatosis, bronchoscopy).
suggest_test(wegeners_granulomatosis, urinalysis).
suggest_test(wegeners_granulomatosis, c_anca).
suggest_test(wegeners_granulomatosis, renal_biopsy).


suggest_test(hereditary_haemorrhagic_telangiectasia, bronchoscopy).


suggest_test(coagulation_disorders, bronchoscopy).





/* ------------------------------------------------------------
   SECTION 4 -- PROOF TRACE
   One explain_step/3 clause per symptom/finding each rule depends on.
   ------------------------------------------------------------ */

% TODO: add explain_step/3 clauses here.
% explain_step(<diagnosis>, <symptom_atom>,
%     'Rationale: why this finding points toward this diagnosis').

% --- copd ---
explain_step(copd, cough,
   'La inflamación crónica y la secreción de moco producen tos crónica').
explain_step(copd, onset,
   'El COPD tiene evolución lenta, por lo que los síntomas suelen ser crónicos').
explain_step(copd, sputum_character, 
   'El esputo mocoide refleja producción excesiva de moco').
explain_step(copd, smoking_history,
   'El tabaquismo es el principal factor de riesgo para desarrollar COPD').
explain_step(copd, cyanosis, 
   'La obstrucción crónica del flujo aéreo puede producir cianosis').
explain_step(copd, wheeze_on_auscultation,
   'El estrechamiento de las vías respiratorias produce silbancias detectadas durante la auscultación').
explain_step(copd, reduced_air_entry, 
   'El estrechamiento de las vías disminuye la entrada de aire').


explain_step(asthma, cough, 
   'La inflamación y estrechamiento de las vías respiratorias producen episodios de tos').
explain_step(asthma, onset, 
   'La tos producida suele aparecer de forma aguda').
explain_step(asthma, wheeze, 
   'El estrechamiento de las vías genera silbancias').
explain_step(asthma, dyspnoea, 
   'La obstrucción del flujo aéreo producen la sensación de falta de aire').
explain_step(asthma, wheeze_on_auscultation, 
   'Las silbancias son audibles durante la auscultación').


explain_step(respiratory_tract_infection, cough, 
   'La inflamación e irritación de las vías produce tos').
explain_step(respiratory_tract_infection, onset,
   'Las infecciones suelen comenzar de forma aguda').
explain_step(respiratory_tract_infection, fever, 
   'La fiebre refleja la respuesta inmunológica frente a la infección').
explain_step(respiratory_tract_infection, crepitations, 
   'Las secreciones y el líquido en las vías producen crepitaciones durante la auscultación').


explain_step(gord, cough, 
   'El reflujo ácido irrita la laringe, provocando tos').
explain_step(gord, onset,
   'El GORD suele tener evolución crónica debido a la exposición repetida del esófago al ácido gástrico').
explain_step(gord, reflux_symptoms, 
   'La regurgitación y acidez estomacal son síntomas típicos del reflujo').
explain_step(gord, pain_character, 
   'El ardor refleja la irritación esofágica por el ácido gástrico').


explain_step(ace_inhibitor_cough, cough,
   'Los inhibidores de la ECA producen tos por la acumulación de sustancias irritantes').
explain_step(ace_inhibitor_cough, taking_ace_inhibitor, 
   'El antecedente de uso de inhibidores de la ECA es importante para sospechar de tos inducida por medicamento').
explain_step(ace_inhibitor_cough, onset, 
   'La tos suele ser crónica después de inicar tratamiento con inhibidores de la ECA').


explain_step(bronchiectasis, cough, 
   'La dilatación crónica de los bronquios acumula secreciones y produce tos').
explain_step(bronchiectasis, sputum_character, 
   'El esputo purulento refleja infección bacteriana y acumulación de secreciones en los bronquios').
explain_step(bronchiectasis, onset,
   'La enfermedad tiene evolución crónica debido al daño permanente a las vías respiratorias').
explain_step(bronchiectasis, crepitations,
   'Las secreciones en los bronquios generan crepitaciones audibles durante la auscultación').
explain_step(bronchiectasis, clubbing,
   'La hipoxia e inflamación puede indicar enfermedad avanzada').


explain_step(lung_cancer, cough,
   'El crecimiento del tumor en o cerca de las vías respiratorias las irrita, generando tos').
explain_step(lung_cancer, onset, 
   'El cáncer pulmonar suele desarrollarse de forma progresiva, generando síntomas crónicos').
explain_step(lung_cancer, sputum_character,
   'El esputo con sangre puede aparecer por el tumor rompiendo pequeños vasos sanguíneos').
explain_step(lung_cancer, smoking_history,
   'El tabaquismo es el principal factor de riesgo para desarrollar cáncer pulmonar').
explain_step(lung_cancer, dyspnoea, 
   'La disminución de la función pulmonar producen dificultad respiratoria').
explain_step(lung_cancer, haemoptysis,
   'La hemoptisis ocurre por el sangrado de vasos afectados por el tumor').
explain_step(lung_cancer, weight_loss,
   'La pérdida de peso refleja el avance de la enfermedad').
explain_step(lung_cancer, lymphadenopathy,
   'La metástasis hace que los ganglios linfáticos se inflamen o agranden').
explain_step(lung_cancer, reduced_air_entry,
   'La obstrucción de las vías respiratorias disminuyen la entrada de aire').


explain_step(tb, cough,
   'La tuberculosis irrita las vías respiratorias y produce tos').
explain_step(tb, onset,
   'La tuberculosis suele evolucionar lentamente, por lo que causa síntomas crónicos').
explain_step(tb, sputum_character,
   'El esputo con sangre puede aparecer por daño del tejido pulmonar').
explain_step(tb, haemoptysis,
   'La hemoptisis ocurre por sangrado de vasos en áreas pulmonares afectadas').
explain_step(tb, weight_loss,
   'La pérdida de peso se debe a alteraciones metabólicas causadas por la respuesta del sistema inmune').
explain_step(tb, fever,
   'La fiebre es la respuesta inmunológica frente a la enfermedad').
explain_step(tb, crepitations,
   'La inflamación y líquidos dentro de los pulmones producen crepitaciones audibles durante la auscultación').


explain_step(pulmonary_oedema, cough,
   'La acumulación de líquidos en los alveólos y vías respiratorias produce tos').
explain_step(pulmonary_oedema, onset,
   'El edema pulmonar suele aparecer de forma aguda por el aumento de presión en la circulación pulmonar').
explain_step(pulmonary_oedema, dyspnoea,
   'El líquido alveolar dificulta el intercambio gaseoso y produce disnea').
explain_step(pulmonary_oedema, sputum_character,
   'El esputo rosado aparece por la mezcla de líquido alveolar y sangre').
explain_step(pulmonary_oedema, crepitations,
   'La presencia de líquido genera crepitaciones audibles durante la auscultación').


explain_step(pulmonary_embolism, cough,
   'La irritación de los receptores de los vasos sanguíneos produce tos').
explain_step(pulmonary_embolism, onset,
   'La embolia pulmonar suele presentarse de forma súbita, por lo que los síntomas son agudos').
explain_step(pulmonary_embolism, sputum_character,
   'El esputo con sangre puede aparecer por daño vascular').
explain_step(pulmonary_embolism, dyspnoea,
   'La obstrucción vascular pulmonar altera el intercambio gaseoso y produce disnea').
explain_step(pulmonary_embolism, fever,
   'La fiebre puede aparecer como respuesta inflamatoria al daño pulmonar').
explain_step(pulmonary_embolism, cyanosis,
   'La alteración en la oxigenación puede producir cianosis en casos severos').


explain_step(pneumonia, haemoptysis,
   'La hemoptisis puede aparecer debido a la inflamación e irritación del tejido pulmonar').
explain_step(pneumonia, cough,
   'La tos es unos de los principales sintomas de la neumonia').
explain_step(pneumonia, sputum_character,
   'El esputo sanguinolento puede presentarse en caso de neumonia severa').
explain_step(pneumonia, breathing,
   'La respiración bronquial sugiere consolidación pulmonar').
explain_step(pneumonia, fever,
   'La fiebre indica un proceso infeccioso activo').
explain_step(pneumonia, chest_pain,
   'El dolor toracico es frecuente por la inflamación pleural').
explain_step(pneumonia, crepitations,
   'Las crepitaciones son sonidos pulmonares asociados a líquido alveolar').


explain_step(chronic_bronchitis, haemoptysis,
   'La hemoptisis puede aparecer por inflamación crónica y daño de las vías respiratorias').
explain_step(chronic_bronchitis, onset,
   'El inicio crónico es caracteristico de la bronquitis crónica, ya que los sintomas persisten').
explain_step(chronic_bronchitis, cough,
   'La tos crónica es uno de los síntomas principales debido a la irritación continua de los bronquios').
explain_step(chronic_bronchitis, sputum_character,
   'El esputo purulento sugiere infección o exceso de secreciones bronquiales asociado a bronquitis crónica').
explain_step(chronic_bronchitis, dyspnoea,
   'La disnea ocurre por obstrucción del flujo de aire').
explain_step(chronic_bronchitis, clubbing,
   'La acropaquia puede aparecer en enfermedad pulmonar crónica avanzada').
explain_step(chronic_bronchitis, chest,
   'El tórax hiperexpandido sugiere atrapamiento de aire cronicos').
explain_step(chronic_bronchitis, crepitations,
   'Las crepitaciones pueden deberse a acumulación de secreciones en las vías respiratorias').


explain_step(goodpastures_syndrome, haemoptysis,
   'La hemoptisis ocurre por hemorragia alveolar causada por daño autoinmune en los pulmones').
explain_step(goodpastures_syndrome, haematuria,
   'La hematuria es un signo de glomerulonefritis debido al compromiso renal autoinmune').
explain_step(goodpastures_syndrome, dyspnoea,
   'La disnea puede aparecer por hemorragia pulmonar y disminución del intercambio gaseoso').
explain_step(goodpastures_syndrome, renal_disease,
   'La enfermedad es caracteristica del síndrome por afectación de los glomerulos').


explain_step(wegeners_granulomatosis, haemoptysis,
   'La hemoptisis puede ocurrir por inflamación del tejido pulmonar').
explain_step(wegeners_granulomatosis, epistaxis,
   'La epistaxis es frecuente por inflamación y ulceración de la mucosa nasal').
explain_step(wegeners_granulomatosis, renal_disease,
   'La enfermedad renal aparece por glomerulonefritis asociada a la inflamación de vasos sanguíneos').
explain_step(wegeners_granulomatosis, loss_nasal_bridge,
   'La destrucción del puente nasal ocurre por daño granulomatoso crónico en el tabique nasal').
explain_step(wegeners_granulomatosis, saddling_nose,
   'La nariz en silla de montar es una deformidad causada por destrucción del cartilago nasal').


explain_step(mitral_stenosis, haemoptysis,
   'La hemoptisis puede aparecer por hipertensión venosa pulmonar').
explain_step(mitral_stenosis, cough,
   'La tos puede deberse a congestión pulmonar causada por aumento de presión').
explain_step(mitral_stenosis, onset,
   'El inicio crónico es caracteristico debido a la progresión lenta de la enfermedad').
explain_step(mitral_stenosis, sputum_character,
   'El esputo purulento puede presentarse por complicaciones secundarias a la enfermedad').
explain_step(mitral_stenosis, flecks_blood,
   'Las estrias de sangre en el esputo son compatibles con congestión y ruptura de vasos pulmonares').
explain_step(mitral_stenosis, dyspnoea,
   'La disnea es frecuente por complicaciones secundarias a la estenosis mitral').
explain_step(mitral_stenosis, fever,
   'La fiebre puede aparecer en presencia de complicaciones asociadas').


explain_step(hereditary_haemorrhagic_telangiectasia, haemoptysis,
   'La hemoptisis puede ocurrir por sangrado de malformaciones vasculares pulmonares').
explain_step(hereditary_haemorrhagic_telangiectasia, dilated_blood_vessels,
   'Las telangiectasias y vasos dilatados son hallazgos caracteristicos de esta enfermedad hereditaria').
explain_step(hereditary_haemorrhagic_telangiectasia, epistaxis,
   'Epistaxis recurrente por telangiectasias nasales').


explain_step(coagulation_disorders, haemoptysis,
   'La hemoptisis puede ocurrir por alteraciones de la coagulación o sangrado favorecido por anticoagulantes').
explain_step(coagulation_disorders, taking_anticoagulant,
   'El uso de anticoagulantes incrementa el riesgo de sangrado y hemoptisis').
explain_step(coagulation_disorders, atrial_fibrillation,
   'La fibrilación auricular suele requerir tratamiento anticoagulante asociado a riesgo hemorrágico').



/* ------------------------------------------------------------
   SECTION 5 -- EXCLUSION RULES  (optional but encouraged)
   ------------------------------------------------------------ */

% TODO: add exclude_if/2 rules here.
% exclude_if(<diagnosis>, 'Reason string') :-
%     finding(<finding_atom>, <value>).//


/*exclude_if(asthma, 'Si el estornudo es monofonico puede sugerir obstrucción intraluminal de un objeto externo') :-
   finding(wheeze_on_auscultation, yes).*/
/*exclude_if(ace_inhibitor_cough, 'Si no se toma el medicamento, no puede ser tos inducida por el medicamento') :-
   symptom(taking_ace_inhibitor, no).*/


