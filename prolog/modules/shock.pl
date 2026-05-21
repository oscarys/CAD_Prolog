/* ============================================================
   MODULE: shock
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 406-409
   AUTHORS: Yamil Bustos Herrera
   SYSTEM:  Cardiovascular / Sepsis
   
   Shock is defined as an abnormality of the circulation resulting
   in inadequate organ perfusion and tissue oxygenation.
   Four categories: hypovolaemic, cardiogenic, distributive and 
   obstructive.

     ============================================================ */

:- module(shock, [diagnose/2, frequency/2,
                   suggest_test/2, explain_step/3,
                   exclude_if/2]).

:- encoding(utf8).

/* ------------------------------------------------------------
   FREQUENCY TABLE
   One fact per diagnosis. Values: common | occasional | rare
   Source: Churchill's colour coding for this presentation.
   ------------------------------------------------------------ */

frequency(haemorrhage                           ,  common).
frequency(burns                                 ,  common).
frequency(gastrointestinal_losses               ,  common).
frequency(myocardial_infarction                 ,  common).
frequency(acute_valvular_damage                 ,  common).
frequency(arrhythmia                            ,  common).
frequency(sepsis                                ,  common).
frequency(massive_pulmonary_embolism            ,  occasional).
frequency(tension_pneumothorax                  ,  occasional).
frequency(anaphylaxis                           ,  rare).
frequency(neurogenic_shock                      ,  rare).
frequency(cardiac_tamponade                     ,  rare).

/* ------------------------------------------------------------
   DIAGNOSTIC RULES
   ------------------------------------------------------------ */

% --- Hypovolaemic ---

diagnose(haemorrhage, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    symptom(preceding_trauma, yes),
    finding(clammy_skin, yes),
    finding(jvp_low, yes),
    frequency(haemorrhage, Frequency).

diagnose(burns, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    symptom(thermal_injury, yes),
    finding(clammy_skin, yes),
    finding(jvp_low, yes),
    frequency(burns, Frequency).

diagnose(gastrointestinal_losses, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    ( symptom(vomiting, yes) 
    ; symptom(diarrhoea, yes) 
    ; symptom(intestinal_obstruction, yes) ),
    finding(clammy_skin, yes),
    finding(jvp_low, yes),
    frequency(gastrointestinal_losses, Frequency).

% --- Cardiogenic ---

diagnose(myocardial_infarction, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    symptom(chest_pain, yes),
    finding(clammy_skin, yes),
    finding(jvp_elevated, yes),
    finding(ecg_mi_changes, yes),
    frequency(myocardial_infarction, Frequency).

diagnose(acute_valvular_damage, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    finding(clammy_skin, yes),
    finding(jvp_elevated, yes),
    finding(new_cardiac_murmur, yes),
    frequency(acute_valvular_damage, Frequency).

diagnose(arrhythmia, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    finding(clammy_skin, yes),
    finding(jvp_elevated, yes),
    finding(ecg_arrhythmia, yes),
    frequency(arrhythmia, Frequency).

% --- Distributive ---

diagnose(sepsis, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    symptom(infection_presence, yes),
    finding(warm_skin, yes),
    finding(pyrexia, yes),
    frequency(sepsis, Frequency).

diagnose(anaphylaxis, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    ( symptom(allergy_exposure, yes) ; finding(urticaria, yes) ; finding(angioedema, yes) ),
    finding(clammy_skin, yes),
    ( finding(bronchospasm, yes) ; finding(wheeze, yes) ),
    frequency(anaphylaxis, Frequency).

diagnose(neurogenic_shock, Frequency) :-
    symptom(shock, yes),
    \+ symptom(tachycardia, yes),
    symptom(preceding_trauma, yes),
    symptom(acute_paralysis, yes),
    finding(clammy_skin, yes),
    frequency(neurogenic_shock, Frequency).

% --- Obstructive ---

diagnose(massive_pulmonary_embolism, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    symptom(dyspnoea, yes),
    symptom(chest_pain, yes),
    finding(cyanosis, yes),
    finding(clammy_skin, yes),
    finding(jvp_elevated, yes),
    frequency(massive_pulmonary_embolism, Frequency).

diagnose(tension_pneumothorax, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    symptom(dyspnoea, yes),
    finding(cyanosis, yes),
    finding(clammy_skin, yes),
    finding(jvp_elevated, yes),
    finding(unilateral_absent_breath_sounds, yes),
    frequency(tension_pneumothorax, Frequency).

diagnose(cardiac_tamponade, Frequency) :-
    symptom(shock, yes),
    symptom(tachycardia, yes),
    symptom(dyspnoea, yes),
    finding(clammy_skin, yes),
    finding(pulsus_paradoxus, yes),
    finding(jvp_elevated, yes),
    finding(muffled_heart_sounds, yes),
    finding(ecg_alternans, yes),
    frequency(cardiac_tamponade, Frequency).


/* ------------------------------------------------------------
   SECTION 3 -- INVESTIGATIONS
   Source: Churchill's General and Specific Investigations sections.
   ------------------------------------------------------------ */

suggest_test(haemorrhage,                     fbc).


suggest_test(burns,                           fbc).


suggest_test(gastrointestinal_losses,         fbc).
suggest_test(gastrointestinal_losses,         urea_and_electrolytes).


suggest_test(myocardial_infarction,           fbc).
suggest_test(myocardial_infarction,           ecg).


suggest_test(acute_valvular_damage,           fbc).
suggest_test(acute_valvular_damage,           echocardiography).


suggest_test(arrhythmia,                      fbc).
suggest_test(arrhythmia,                      ecg).


suggest_test(sepsis,                          fbc).
suggest_test(sepsis,                          blood_cultures).


suggest_test(massive_pulmonary_embolism,      pulse_oximetry).
suggest_test(massive_pulmonary_embolism,      abg).
suggest_test(massive_pulmonary_embolism,      echocardiography).
suggest_test(massive_pulmonary_embolism,      ct_pulmonary_angiography).


suggest_test(tension_pneumothorax,            pulse_oximetry).
suggest_test(tension_pneumothorax,            abg).
suggest_test(tension_pneumothorax,            cxr).
% NOTE: Churchill explicitly states the diagnosis of tension
% pneumothorax should be clinical and relieved before CXR is done.

suggest_test(anaphylaxis,                     fbc).


suggest_test(neurogenic_shock,                fbc).
suggest_test(neurogenic_shock,                ct_spine).
suggest_test(neurogenic_shock,                mri_spine).


suggest_test(cardiac_tamponade,               fbc).
suggest_test(cardiac_tamponade,               ecg).
suggest_test(cardiac_tamponade,               cxr).
suggest_test(cardiac_tamponade,               echocardiography).


/* ------------------------------------------------------------
   PROOF TRACE
   ------------------------------------------------------------ */

% --- haemorrhage ---
explain_step(haemorrhage, shock,
    'El shock hemorrágico se produce por pérdida aguda de volumen').
explain_step(haemorrhage, tachycardia,
    'La taquicardia es el primer indicador del shock').
explain_step(haemorrhage, preceding_trauma,
    'El traumatismo penetrante se acompaña invariablemente de hemorragia; el traumatismo cerrado de pelvis y huesos largos puede causar sangrado oculto significativo').
explain_step(haemorrhage, clammy_skin,
    'La vasoconstricción periférica produce piel fría y sudorosa').
explain_step(haemorrhage, jvp_low,
    'La presión venosa yugular (PVY) baja es el discriminador clave del shock hipovolémico').
 
% --- burns ---
explain_step(burns, shock,
    'Las quemaduras destruyen la barrera cutánea, generando pérdida de líquido').
explain_step(burns, tachycardia,
    'La taquicardia refleja la respuesta compensadora ante la pérdida de volumen sanguíneo').
explain_step(burns, thermal_injury,
    'El antecedente de exposición al fuego, explosiones o agua caliente es causante directo del shock por quemadura').
explain_step(burns, clammy_skin,
    'La vasoconstricción compensadora produce piel fría y húmeda').
explain_step(burns, jvp_low,
    'La reducción de volumen intravascular se manifiesta como PVY baja').
 
% --- gastrointestinal_losses ---
explain_step(gastrointestinal_losses, shock,
    'Las pérdidas digestivas masivas (vómitos, diarrea, obstrucción intestinal) causan pérdida de volumen intravascular y shock').
explain_step(gastrointestinal_losses, tachycardia,
    'La taquicardia indica respuesta simpática ante la hipovolemia').
explain_step(gastrointestinal_losses, vomiting,
    'El vómito provoca pérdida de agua, sodio y cloruro, con la consiguiente hipovolemia').
explain_step(gastrointestinal_losses, diarrhoea,
    'La diarrea produce pérdida de agua, sodio y potasio; es causa frecuente de shock').
explain_step(gastrointestinal_losses, intestinal_obstruction,
    'La obstrucción intestinal produce acumulación de líquido en el tercer espacio, reduciendo el volumen circulante eficaz').
explain_step(gastrointestinal_losses, clammy_skin,
    'La vasoconstricción compensadora en la hipovolemia produce piel fría y sudorosa').
explain_step(gastrointestinal_losses, jvp_low,
    'La PVY baja confirma el mecanismo hipovolémico por pérdidas digestivas').
 
% --- myocardial_infarction ---
explain_step(myocardial_infarction, shock,
    'El IAM reduce el gasto cardíaco, provocando shock cardiogénico').
explain_step(myocardial_infarction, tachycardia,
    'La taquicardia intenta mantener el gasto cardíaco ante la caída del volumen sanguíneo').
explain_step(myocardial_infarction, chest_pain,
    'El dolor torácico opresivo central orienta a isquemia miocárdica como causa del shock').
explain_step(myocardial_infarction, clammy_skin,
    'La vasoconstricción simpática periférica produce piel fría y sudorosa en el shock cardiogénico').
explain_step(myocardial_infarction, jvp_elevated,
    'La PVY elevada distingue el shock cardiogénico del hipovolémico').
explain_step(myocardial_infarction, ecg_mi_changes,
    'Los cambios electrocardiográficos confirman el infarto como etiología del shock').
 
% --- acute_valvular_damage ---
explain_step(acute_valvular_damage, shock,
    'La insuficiencia valvular aguda reduce bruscamente el gasto cardíaco eficaz').
explain_step(acute_valvular_damage, tachycardia,
    'Respuesta compensadora simpática ante la reducción aguda del volumen sistólico').
explain_step(acute_valvular_damage, clammy_skin,
    'La vasoconstricción simpática periférica produce piel fría y sudorosa').
explain_step(acute_valvular_damage, jvp_elevated,
    'La PVY elevada confirma el mecanismo cardiogénico').
explain_step(acute_valvular_damage, new_cardiac_murmur,
    'El soplo cardíaco de nueva aparición es el hallazgo auscultatorio clave de la insuficiencia valvular aguda como causa de shock cardiogénico').
 
% --- arrhythmia ---
explain_step(arrhythmia, shock,
    'Las arritmias reducen el gasto cardíaco a valores incompatibles con la perfusión orgánica').
explain_step(arrhythmia, tachycardia,
    'La taquicardia puede ser el mecanismo causante del shock o una respuesta compensadora a la bradicardia extrema').
explain_step(arrhythmia, clammy_skin,
    'La vasoconstricción simpática periférica produce piel fría y sudorosa').
explain_step(arrhythmia, jvp_elevated,
    'La PVY elevada confirma el mecanismo cardiogénico').
explain_step(arrhythmia, ecg_arrhythmia,
    'El ECG identifica directamente la arritmia precipitante del shock cardiogénico  -  hallazgo diagnóstico definitorio').
 
% --- sepsis ---
explain_step(sepsis, shock,
    'La liberación masiva de mediadores inflamatorios en la sepsis produce vasodilatación periférica con reducción de las resistencias vasculares sistémicas').
explain_step(sepsis, tachycardia,
    'La taquicardia es la respuesta compensadora ante la caída de las resistencias vasculares y el aumento del gasto cardíaco requerido en el shock distributivo').
explain_step(sepsis, infection_presence,
    'La identificación del foco infeccioso es esencial para guiar el tratamiento antibiótico en el shock séptico').
explain_step(sepsis, warm_skin,
    'La piel caliente al tacto diferencia el shock séptico del hipovolémico y cardiogénico').
explain_step(sepsis, pyrexia,
    'La fiebre refleja la respuesta inflamatoria sistémica a la infección').
 
% --- anaphylaxis ---
explain_step(anaphylaxis, shock,
    'La anafilaxia produce vasodilatación masiva y aumento de la permeabilidad vascular').
explain_step(anaphylaxis, tachycardia,
    'La respuesta simpática ante la vasodilatación e hipovolemia genera taquicardia').
explain_step(anaphylaxis, allergy_exposure,
    'Alimentos (marisco, cacahuetes, huevo), veneno de insectos, penicilina, contrastes yodados y agentes anestésicos son los desencadenantes más frecuentes').
explain_step(anaphylaxis, urticaria,
    'La urticaria es una manifestación cutánea característica de la anafilaxia').
explain_step(anaphylaxis, angioedema,
    'El angioedema es una manifestación cutánea característica de la anafilaxia').
explain_step(anaphylaxis, clammy_skin,
    'Piel fría y sudorosa característica de estado en shock').
explain_step(anaphylaxis, bronchospasm,
    'El broncoespasmo produce sibilancias audibles y es un componente frecuente del shock anafiláctico').
explain_step(anaphylaxis, wheeze,
    'Sibilancias producidas por la contracción muscular en los bronquios').
 
% --- neurogenic ---
explain_step(neurogenic_shock, shock,
    'La lesión medular alta interrumpe las vías simpáticas descendentes, eliminando el tono vasomotor y produciendo hipotensión por vasodilatación').
explain_step(neurogenic_shock, tachycardia,
    'La taquicardia puede estar ausente en el shock neurogénico  -  rasgo que lo distingue de otras formas de shock').
explain_step(neurogenic_shock, preceding_trauma,
    'El antecedente traumático es imprescindible en el diagnóstico del shock neurogénico - la lesión vertebral debe confirmarse con imagen').
explain_step(neurogenic_shock, acute_paralysis,
    'La parálisis aguda post-traumática es la manifestación neurológica directa de la lesión medular que desencadena el shock neurogénico').
explain_step(neurogenic_shock, clammy_skin,
    'Piel fría y sudorosa característica de estado en shock').
 
% --- massive_pulmonary_embolism ---
explain_step(massive_pulmonary_embolism, shock,
    'La embolia pulmonar masiva obstruye el lecho vascular pulmonar, elevando la poscarga del ventrículo derecho hasta provocar shock obstructivo').
explain_step(massive_pulmonary_embolism, tachycardia,
    'La taquicardia es la respuesta compensadora al bajo gasto cardíaco por obstrucción').
explain_step(massive_pulmonary_embolism, dyspnoea,
    'La disnea es el síntoma más frecuente del embolismo pulmonar masivo').
explain_step(massive_pulmonary_embolism, chest_pain,
    'El dolor torácico pleurítico aparece cuando el infarto periférico compromete la pleura parietal').
explain_step(massive_pulmonary_embolism, cyanosis,
    'La cianosis indica hipoxemia').
explain_step(massive_pulmonary_embolism, clammy_skin,
    'La vasoconstricción simpática periférica produce piel fría y sudorosa en el shock obstructivo').
explain_step(massive_pulmonary_embolism, jvp_elevated,
    'La PVY elevada refleja el fallo ventricular derecho agudo por sobrecarga de presión  -  hallazgo cardinal del shock obstructivo').

 
% --- tension_pneumothorax ---
explain_step(tension_pneumothorax, shock,
    'El neumotórax a tensión colapsa el pulmón afecto, desvía el mediastino y comprime el corazón, reduciendo el retorno venoso y el gasto cardíaco').
explain_step(tension_pneumothorax, tachycardia,
    'La taquicardia compensa el bajo gasto cardíaco por obstrucción mecánica al llenado cardíaco').
explain_step(tension_pneumothorax, dyspnoea,
    'La disnea refleja el colapso pulmonar unilateral y la hipoxemia resultante').
explain_step(tension_pneumothorax, cyanosis,
    'La cianosis indica hipoxemia').
explain_step(tension_pneumothorax, clammy_skin,
    'La vasoconstricción simpática periférica produce piel fría y sudorosa').
explain_step(tension_pneumothorax, jvp_elevated,
    'La PVY elevada distingue el neumotórax a tensión siendo un hallazgo cardinal del shock obstructivo').
explain_step(tension_pneumothorax, unilateral_absent_breath_sounds,
    'La abolición unilateral del murmullo vesicular es el hallazgo exploratorio definitorio del neumotórax').
 
% --- cardiac_tamponade ---
explain_step(cardiac_tamponade, shock,
    'El derrame pericárdico comprime las cavidades cardíacas, impide el llenado diastólico y reduce el gasto cardíaco hasta producir shock obstructivo').
explain_step(cardiac_tamponade, tachycardia,
    'La taquicardia intenta compensar el bajo volumen sistólico secundario a la compresión pericárdica').
explain_step(cardiac_tamponade, dyspnoea,
    'La disnea es característica de todas las causas de shock obstructivo').
explain_step(cardiac_tamponade, clammy_skin,
    'La vasoconstricción simpática periférica produce piel fría y sudorosa').
explain_step(cardiac_tamponade, pulsus_paradoxus,
    'La disminución anormal de la presión sistólica en inspiración es consistente con taponamiento cardíaco').
explain_step(cardiac_tamponade, jvp_elevated,
    'La elevación de la PVY refleja el aumento de la presión de llenado del VD por compresión externa del pericardio').
explain_step(cardiac_tamponade, muffled_heart_sounds,
    'Los ruidos cardíacos amortiguados son característicos del taponamiento cardíaco').
explain_step(cardiac_tamponade, ecg_alternans,
    'Las complejos QRS alternantes son un indicador específico de un taponamiento cardíaco').

/* ------------------------------------------------------------
   EXCLUSION RULES
   ------------------------------------------------------------ */

exclude_if(haemorrhage,
           'Sin antecedente traumático y PVY elevada  -  el mecanismo hipovolémico hemorrágico es improbable') :-
    \+ symptom(preceding_trauma, yes),
    finding(jvp_low, no).
  
exclude_if(sepsis,
           'Piel no caliente al tacto, sin foco infeccioso identificado  -  el shock séptico es improbable como diagnóstico primario') :-
    finding(warm_skin, no),
    \+ symptom(infection_presence, yes).
 
exclude_if(cardiac_tamponade,
           'Ausencia de pulso paradójico y ECG sin alternancia eléctrica  -  taponamiento cardíaco improbable') :-
    finding(pulsus_paradoxus, no),
    finding(ecg_alternans, no).
 
exclude_if(tension_pneumothorax,
           'Murmullo vesicular presente y simétrico bilateralmente  -  neumotórax a tensión excluido') :-
    finding(unilateral_absent_breath_sounds, no).
 
exclude_if(neurogenic_shock,
           'La taquicardia presente hace improbable el shock neurogénico puro, en el cual la respuesta simpática está bloqueada') :-
    symptom(tachycardia, yes),
    \+ symptom(preceding_trauma, yes).