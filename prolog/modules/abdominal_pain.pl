/* ============================================================
   MODULE: abdominal_pain
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 3-8
   AUTHORS: <your names>
   SYSTEM:  Gastrointestinal / Urológico / Ginecológico
   ============================================================ */

:- module(abdominal_pain, [diagnose/2, frequency/2,
                   suggest_test/2, explain_step/3,
                   exclude_if/2]).

:- encoding(utf8).

/* ------------------------------------------------------------
   SECCIÓN 1 -- TABLA DE FRECUENCIAS
   Fuente: código de color de Churchill p.3-4
   🟢 común  🟡 ocasional  🔴 raro
   ------------------------------------------------------------ */

frequency(appendicitis,          common).     % 🟢
frequency(peptic_ulcer,          common).     % 🟢
frequency(biliary_colic,         common).     % 🟢 (acute cholecystitis green)
frequency(intestinal_obstruction,common).     % 🟢
frequency(diverticulitis,        common).     % 🟢
frequency(mesenteric_adenitis,   common).     % 🟢
frequency(acute_pancreatitis,    common).     % 🟢
frequency(ureteric_colic,        common).     % 🟢
frequency(ectopic_pregnancy,     common).     % 🟢
frequency(aortic_aneurysm,       occasional). % 🟡


/* ------------------------------------------------------------
   SECCIÓN 2 -- REGLAS DIAGNÓSTICAS
   Cada cláusula codifica un cuadro clínico de Churchill.
   ------------------------------------------------------------ */

% --- Apendicitis ---
% Dolor clásico que migra de la zona periumbilical a la FID,
% con fiebre, náusea y defensa localizada.
diagnose(appendicitis, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(pain_location, rif),
    symptom(fever, yes),
    symptom(nausea_vomiting, yes),
    finding(guarding, yes),
    frequency(appendicitis, Frequency).

diagnose(appendicitis, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(pain_location, rif),
    symptom(onset, gradual),
    finding(rebound_tenderness, yes),
    frequency(appendicitis, Frequency).

% --- Úlcera péptica ---
% Dolor epigástrico urente o roedor, relacionado con comidas,
% posible historia de AINE o H. pylori.
diagnose(peptic_ulcer, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(pain_location, epigastric),
    symptom(nausea_vomiting, yes),
    \+ symptom(jaundice, yes),
    frequency(peptic_ulcer, Frequency).

% --- Cólico biliar / Colecistitis aguda ---
% Dolor en cuadrante superior derecho, irradiación a escápula,
% náusea, intolerancia a grasas.
diagnose(biliary_colic, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(pain_location, ruq),
    symptom(nausea_vomiting, yes),
    frequency(biliary_colic, Frequency).

diagnose(biliary_colic, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(pain_location, ruq),
    symptom(fever, yes),
    finding(guarding, yes),
    frequency(biliary_colic, Frequency).

% --- Obstrucción intestinal ---
% Dolor cólico, distensión, vómitos, constipación absoluta,
% borborigmos metálicos o silencio abdominal.
diagnose(intestinal_obstruction, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(onset, colicky),
    symptom(constipation, yes),
    symptom(nausea_vomiting, yes),
    ( finding(bowel_sounds, absent) ; finding(bowel_sounds, tinkling) ),
    frequency(intestinal_obstruction, Frequency).

diagnose(intestinal_obstruction, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(constipation, yes),
    symptom(previous_surgery, yes),
    symptom(nausea_vomiting, yes),
    frequency(intestinal_obstruction, Frequency).

% --- Diverticulitis ---
% Dolor en FII, fiebre, cambio en el hábito intestinal,
% más frecuente en adultos mayores.
diagnose(diverticulitis, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(pain_location, lif),
    symptom(fever, yes),
    symptom(onset, gradual),
    frequency(diverticulitis, Frequency).

% --- Adenitis mesentérica ---
% Dolor en FID o generalizado en niños, con fiebre y antecedente
% de infección respiratoria reciente. Simula apendicitis.
diagnose(mesenteric_adenitis, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(pain_location, rif),
    symptom(fever, yes),
    \+ finding(guarding, yes),
    \+ finding(rebound_tenderness, yes),
    frequency(mesenteric_adenitis, Frequency).

% --- Pancreatitis aguda ---
% Dolor epigástrico o central intenso que irradia a la espalda,
% náusea, vómito, puede haber íleo.
diagnose(acute_pancreatitis, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(pain_location, epigastric),
    symptom(onset, sudden),
    symptom(nausea_vomiting, yes),
    \+ symptom(pain_location, rif),
    frequency(acute_pancreatitis, Frequency).

diagnose(acute_pancreatitis, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(pain_location, central),
    symptom(nausea_vomiting, yes),
    symptom(onset, sudden),
    frequency(acute_pancreatitis, Frequency).

% --- Cólico ureteral ---
% Dolor tipo cólico que irradia del flanco a la ingle,
% hematuria, agitación extrema del paciente.
diagnose(ureteric_colic, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(onset, colicky),
    symptom(loin_to_groin_radiation, yes),
    frequency(ureteric_colic, Frequency).

diagnose(ureteric_colic, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(loin_to_groin_radiation, yes),
    symptom(haematuria, yes),
    frequency(ureteric_colic, Frequency).

% --- Embarazo ectópico ---
% Solo en pacientes femeninas. Dolor abdominal bajo con amenorrea,
% sangrado vaginal, posible colapso hemodinámico.
diagnose(ectopic_pregnancy, Frequency) :-
    patient_sex(female),
    symptom(abdominal_pain, yes),
    symptom(last_menstrual_period, yes),
    symptom(pain_location, lif),
    frequency(ectopic_pregnancy, Frequency).

diagnose(ectopic_pregnancy, Frequency) :-
    patient_sex(female),
    symptom(abdominal_pain, yes),
    symptom(last_menstrual_period, yes),
    symptom(onset, sudden),
    finding(guarding, yes),
    frequency(ectopic_pregnancy, Frequency).

% --- Aneurisma aórtico ---
% Dolor abdominal o de espalda, masa pulsátil, colapso en rotura.
% Alta mortalidad — siempre buscar en >60 años con dolor súbito.
diagnose(aortic_aneurysm, Frequency) :-
    symptom(abdominal_pain, yes),
    symptom(onset, sudden),
    finding(pulsatile_mass, yes),
    frequency(aortic_aneurysm, Frequency).


/* ------------------------------------------------------------
   SECCIÓN 3 -- ESTUDIOS RECOMENDADOS
   Fuente: Churchill's p.7-8
   ------------------------------------------------------------ */

suggest_test(appendicitis,           fbc).
suggest_test(appendicitis,           cxr).
suggest_test(appendicitis,           urine_microscopy).
suggest_test(appendicitis,           ultrasound_abdomen).
suggest_test(appendicitis,           ct_abdomen).

suggest_test(peptic_ulcer,           fbc).
suggest_test(peptic_ulcer,           ogd).
suggest_test(peptic_ulcer,           h_pylori_breath_test).
suggest_test(peptic_ulcer,           cxr).

suggest_test(biliary_colic,          fbc).
suggest_test(biliary_colic,          lfts).
suggest_test(biliary_colic,          ultrasound_abdomen).
suggest_test(biliary_colic,          mrcp).

suggest_test(intestinal_obstruction, fbc).
suggest_test(intestinal_obstruction, uande).
suggest_test(intestinal_obstruction, axr).
suggest_test(intestinal_obstruction, ct_abdomen).

suggest_test(diverticulitis,         fbc).
suggest_test(diverticulitis,         crp).
suggest_test(diverticulitis,         ct_abdomen).
suggest_test(diverticulitis,         colonoscopy).

suggest_test(mesenteric_adenitis,    fbc).
suggest_test(mesenteric_adenitis,    ultrasound_abdomen).
suggest_test(mesenteric_adenitis,    throat_swab).

suggest_test(acute_pancreatitis,     fbc).
suggest_test(acute_pancreatitis,     serum_amylase).
suggest_test(acute_pancreatitis,     lfts).
suggest_test(acute_pancreatitis,     ct_abdomen).
suggest_test(acute_pancreatitis,     ultrasound_abdomen).

suggest_test(ureteric_colic,         urine_microscopy).
suggest_test(ureteric_colic,         fbc).
suggest_test(ureteric_colic,         uande).
suggest_test(ureteric_colic,         ivu).
suggest_test(ureteric_colic,         axr).

suggest_test(ectopic_pregnancy,      beta_hcg).
suggest_test(ectopic_pregnancy,      fbc).
suggest_test(ectopic_pregnancy,      ultrasound_pelvis).

suggest_test(aortic_aneurysm,        fbc).
suggest_test(aortic_aneurysm,        ultrasound_abdomen).
suggest_test(aortic_aneurysm,        ct_abdomen).


/* ------------------------------------------------------------
   SECCIÓN 4 -- TRAZA DE DEMOSTRACIÓN
   Una cláusula explain_step/3 por síntoma/hallazgo en diagnose/2.
   ------------------------------------------------------------ */

% --- appendicitis ---
explain_step(appendicitis, abdominal_pain,
    'El dolor abdominal es el síntoma cardinal de la apendicitis').
explain_step(appendicitis, pain_location,
    'La localización en la fosa ilíaca derecha refleja la posición anatómica del apéndice — el dolor clásico migra de la zona periumbilical a la FID').
explain_step(appendicitis, fever,
    'La fiebre refleja la respuesta inflamatoria local  -  la peritonitis generalizada produce fiebre alta').
explain_step(appendicitis, nausea_vomiting,
    'La náusea y el vómito acompañan habitualmente a la apendicitis por irritación peritoneal y reflejo vagal').
explain_step(appendicitis, guarding,
    'La defensa muscular indica irritación peritoneal localizada sobre el apéndice inflamado').
explain_step(appendicitis, onset,
    'El inicio gradual en horas es típico de la apendicitis  -  el inicio súbito sugiere perforación o torsión').
explain_step(appendicitis, rebound_tenderness,
    'El signo de Blumberg indica irritación peritoneal  -  hallazgo importante de apendicitis aguda').

% --- peptic_ulcer ---
explain_step(peptic_ulcer, abdominal_pain,
    'El dolor epigástrico es el síntoma principal de la úlcera péptica').
explain_step(peptic_ulcer, pain_location,
    'La localización epigástrica corresponde a la región gástrica y duodenal afectada por la úlcera').
explain_step(peptic_ulcer, nausea_vomiting,
    'La náusea y el vómito son frecuentes por irritación de la mucosa gástrica o retraso del vaciamiento').
explain_step(peptic_ulcer, jaundice,
    'La ausencia de ictericia diferencia la úlcera péptica de la patología biliar o hepática').

% --- biliary_colic ---
explain_step(biliary_colic, abdominal_pain,
    'El cólico biliar causa dolor en el cuadrante superior derecho por obstrucción transitoria del conducto cístico por un cálculo').
explain_step(biliary_colic, pain_location,
    'La localización en el cuadrante superior derecho corresponde a la proyección anatómica de la vesícula biliar').
explain_step(biliary_colic, nausea_vomiting,
    'La náusea y el vómito acompañan al cólico biliar por estimulación vagal durante el espasmo del conducto biliar').
explain_step(biliary_colic, fever,
    'La fiebre en el contexto de dolor en CSD sugiere colecistitis aguda con inflamación o infección de la vesícula').
explain_step(biliary_colic, guarding,
    'La defensa muscular en el CSD indica colecistitis aguda con irritación peritoneal local').

% --- intestinal_obstruction ---
explain_step(intestinal_obstruction, abdominal_pain,
    'La obstrucción intestinal produce dolor cólico por peristalsis aumentada contra el obstáculo').
explain_step(intestinal_obstruction, onset,
    'El carácter cólico del dolor (intermitente, en oleadas) es patognomónico de la obstrucción intestinal mecánica').
explain_step(intestinal_obstruction, constipation,
    'La constipación absoluta (ausencia de heces y gases) es una característica definitoria de la obstrucción intestinal completa').
explain_step(intestinal_obstruction, nausea_vomiting,
    'El vómito es prominente  -  fecaloideo en obstrucciones distales, bilioso en las proximales').
explain_step(intestinal_obstruction, bowel_sounds,
    'Los ruidos hidroaéreos ausentes indican íleo paralítico; los metálicos tintineo sugieren obstrucción mecánica con asa distendida').
explain_step(intestinal_obstruction, previous_surgery,
    'La cirugía abdominal previa es la causa más frecuente de obstrucción por adherencias  -  siempre investigar en el antecedente').

% --- diverticulitis ---
explain_step(diverticulitis, abdominal_pain,
    'La diverticulitis causa dolor abdominal por inflamación o perforación de un divertículo del colon').
explain_step(diverticulitis, pain_location,
    'La localización en la fosa ilíaca izquierda corresponde a la distribución más frecuente de divertículos en el colon sigmoide').
explain_step(diverticulitis, fever,
    'La fiebre refleja la respuesta inflamatoria o infecciosa local en el divertículo afectado').
explain_step(diverticulitis, onset,
    'El inicio gradual diferencia la diverticulitis de la perforación visceral aguda que se presenta de manera súbita').

% --- mesenteric_adenitis ---
explain_step(mesenteric_adenitis, abdominal_pain,
    'La adenitis mesentérica causa dolor abdominal por inflamación de los ganglios linfáticos mesentéricos, generalmente tras una infección respiratoria').
explain_step(mesenteric_adenitis, pain_location,
    'La localización en la FID puede simular apendicitis  -  la adenitis mesentérica es más frecuente en niños y adolescentes').
explain_step(mesenteric_adenitis, fever,
    'La fiebre refleja la infección sistémica subyacente, habitualmente viral, que desencadena la linfadenitis mesentérica').
explain_step(mesenteric_adenitis, guarding,
    'La ausencia de defensa muscular ayuda a diferenciar la adenitis mesentérica de la apendicitis aguda  -  la irritación peritoneal es mínima').
explain_step(mesenteric_adenitis, rebound_tenderness,
    'La ausencia de signo de Blumberg es un dato diferenciador importante frente a la apendicitis  -  no hay irritación peritoneal franca').

% --- acute_pancreatitis ---
explain_step(acute_pancreatitis, abdominal_pain,
    'El dolor abdominal intenso es el síntoma cardinal de la pancreatitis aguda por autodigestión enzimática del páncreas').
explain_step(acute_pancreatitis, pain_location,
    'La localización epigástrica o central refleja la posición retroperitoneal del páncreas  -  el dolor puede irradiar en banda hacia la espalda').
explain_step(acute_pancreatitis, onset,
    'El inicio súbito e intenso es característico de la pancreatitis aguda  -  el paciente recuerda el momento exacto del inicio').
explain_step(acute_pancreatitis, nausea_vomiting,
    'La náusea y el vómito son prominentes en la pancreatitis aguda  -  el vómito no alivia el dolor, a diferencia de la úlcera péptica').

% --- ureteric_colic ---
explain_step(ureteric_colic, abdominal_pain,
    'El cólico ureteral produce dolor abdominal intensísimo por distensión ureteral al progresar el cálculo').
explain_step(ureteric_colic, onset,
    'El carácter cólico (va y viene en oleadas) refleja el peristaltismo ureteral contra el obstáculo litíasico').
explain_step(ureteric_colic, loin_to_groin_radiation,
    'La irradiación del flanco a la ingle sigue el trayecto anatómico del uréter  -  signo prácticamente patognomónico del cólico ureteral').
explain_step(ureteric_colic, haematuria,
    'La hematuria (macro o microscópica) resulta del traumatismo de la mucosa ureteral por el cálculo en migración').

% --- ectopic_pregnancy ---
explain_step(ectopic_pregnancy, abdominal_pain,
    'El embarazo ectópico causa dolor abdominal por distensión de la trompa de Falopio o hemoperitoneo en la rotura').
explain_step(ectopic_pregnancy, last_menstrual_period,
    'El retraso menstrual indica embarazo  -  todo dolor abdominal en una mujer en edad fértil con amenorrea debe descartar embarazo ectópico').
explain_step(ectopic_pregnancy, pain_location,
    'La localización en la FII (o FID) corresponde a la trompa de Falopio afectada').
explain_step(ectopic_pregnancy, onset,
    'El inicio súbito con colapso sugiere rotura tubárica con hemoperitoneo  -  emergencia quirúrgica').
explain_step(ectopic_pregnancy, guarding,
    'La defensa muscular indica hemoperitoneo o irritación peritoneal por rotura tubárica  -  requiere cirugía urgente').

% --- aortic_aneurysm ---
explain_step(aortic_aneurysm, abdominal_pain,
    'El aneurisma aórtico abdominal causa dolor por expansión rápida o rotura  -  de alta mortalidad si no se trata urgentemente').
explain_step(aortic_aneurysm, onset,
    'El inicio súbito e intenso sugiere rotura o disección del aneurisma  -  emergencia vascular').
explain_step(aortic_aneurysm, pulsatile_mass,
    'La masa pulsátil y expansiva a la palpación abdominal es el signo clínico definitorio del aneurisma aórtico abdominal').


/* ------------------------------------------------------------
   SECCIÓN 5 -- REGLAS DE EXCLUSIÓN
   ------------------------------------------------------------ */

% La apendicitis queda excluida si hay datos claros de peritonitis
% generalizada SIN fiebre ni leucocitosis  -  pensar en otra causa.
exclude_if(ectopic_pregnancy,
           'Paciente masculino  -  el embarazo ectópico solo ocurre en mujeres') :-
    patient_sex(male).

exclude_if(aortic_aneurysm,
           'Ausencia de masa pulsátil y dolor no súbito hacen improbable el aneurisma') :-
    \+ finding(pulsatile_mass, yes),
    \+ symptom(onset, sudden).

exclude_if(mesenteric_adenitis,
           'Presencia de defensa muscular o Blumberg positivo sugiere apendicitis u otra causa quirúrgica') :-
    ( finding(guarding, yes) ; finding(rebound_tenderness, yes) ).

