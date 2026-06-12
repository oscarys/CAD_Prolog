/* ============================================================
   MODULE: haematuria
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor  -  Elsevier 2010, p. <PAGE>
   AUTHORS: Cesar Adame Salome

   INSTRUCTIONS:
   1. Replace <your_presentation_name> with the atom for your presentation
      e.g.  headache, dyspnoea, abdominal_pain
   2. Replace <PAGE> with the Churchill's page number
   3. Fill in every section. Do not delete section headers.
   4. When done: run  pytest tests/test_kb.py   -  all checks must pass.
   5. See prolog/modules/chest_pain.pl for a fully worked example.
   ============================================================ */

:- module( haematuria, [diagnose/2, frequency/2,
                                      suggest_test/2, explain_step/3,
                                      exclude_if/2]).

:- encoding(utf8).


/* ------------------------------------------------------------
   SECTION 1  -  FREQUENCY TABLE
   Fill this in first. One fact per diagnosis you will encode.
   Values: common | occasional | rare
   Source: Churchill's colour coding for your presentation.
   ------------------------------------------------------------ */

frequency(urinary_tract_infection,      common).
frequency(glomerular_disease,           common).
frequency(kidney_carcinoma,             common).
frequency(kidney_stones,                common).
frequency(bladder_carcinoma,            common).
frequency(schistosomiasis,              common).
frequency(benign_prostatic_hypertrophy, common).
frequency(prostate_carcinoma,           common).
frequency(kidney_trauma,                occasional).
frequency(ureter_stones,                occasional).
frequency(bladder_stones,               occasional).
frequency(urethra_trauma,               occasional).
frequency(urethra_stones,               occasional).
frequency(urethritis,                   occasional).
frequency(anticoagulant_therapy,        occasional).
frequency(thrombocytopenia,             occasional).
frequency(polycystic_kidney,            rare).
frequency(renal_embolism,               rare).
frequency(renal_vein_thrombosis,        rare).
frequency(vascular_malformation,        rare).
frequency(tuberculosis,                 rare).
frequency(ureteral_neoplasm,            rare).
frequency(urethral_neoplasm,            rare).
frequency(strenuous_exercise,           rare).
frequency(haemophilia,                  rare).
frequency(sickle_cell_disease,          rare).
frequency(malaria,                      rare).

/* ------------------------------------------------------------
   SECTION 2  -  DIAGNOSTIC RULES
   One diagnose/2 clause per distinct clinical picture.
   Each clause must end with:  frequency(Diagnosis, Frequency).
   Use symptom/2 and finding/2 calls to match the patient's data.
   ------------------------------------------------------------ */

% --- Kidney ---

diagnose(glomerular_disease, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   frequency(glomerular_disease, Frequency).

diagnose(kidney_carcinoma, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   symptom(weight_loss, yes),
   symptom(smoking_history, yes),
   symptom(age_over_40, yes),
   finding(renal_mass, yes),
   frequency(kidney_carcinoma, Frequency).

diagnose(kidney_carcinoma, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   symptom(weight_loss, yes),
   symptom(age_over_40, yes),
   finding(renal_mass, yes),
   frequency(kidney_carcinoma, Frequency).

diagnose(kidney_carcinoma, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   symptom(weight_loss, yes),
   symptom(smoking_history, yes),
   finding(renal_mass, yes),
   frequency(kidney_carcinoma, Frequency).

diagnose(kidney_carcinoma, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   symptom(weight_loss, yes),
   finding(renal_mass, yes),
   frequency(kidney_carcinoma, Frequency).

diagnose(kidney_stones, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   symptom(dysuria, yes),
   symptom(urinary_frequency, yes),
   frequency(kidney_stones, Frequency).

diagnose(kidney_trauma, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   symptom(renal_biopsy, yes),
   frequency(kidney_trauma, Frequency).

diagnose(kidney_trauma, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   frequency(kidney_trauma, Frequency).

diagnose(polycystic_kidney, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   symptom(history_polycystic_kidney, yes),
   frequency(polycystic_kidney, Frequency).

diagnose(renal_embolism, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   symptom(urinary_difficulty, yes),
   frequency(renal_embolism, Frequency).

diagnose(renal_vein_thrombosis, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   symptom(poor_stream, yes),
   frequency(renal_vein_thrombosis, Frequency).

diagnose(vascular_malformation, Frequency) :-
   symptom(haematuria, yes),
   symptom(loin_pain, yes),
   finding(abdominal_murmur, yes),
   frequency(vascular_malformation, Frequency).

% --- Ureter ---

diagnose(ureter_stones, Frequency) :-
   symptom(haematuria, yes),
   symptom(ureteric_colic, yes),
   symptom(loin_pain, yes),
   frequency(ureter_stones, Frequency).

diagnose(ureteral_neoplasm, Frequency) :-
   symptom(haematuria, yes),
   symptom(dysuria, yes),
   symptom(loin_pain, yes),
   symptom(ureteric_colic, yes),
   frequency(ureteral_neoplasm, Frequency).

% --- Bladder ---

diagnose(bladder_carcinoma, Frequency) :-
   symptom(haematuria, yes),
   finding(suprapubic_tenderness, yes),
   symptom(urinary_frequency, yes),
   symptom(dysuria, yes),
   symptom(age_over_40, yes),
   symptom(smoking_history, yes),
   frequency(bladder_carcinoma, Frequency).

diagnose(bladder_carcinoma, Frequency) :-
   symptom(haematuria, yes),
   finding(suprapubic_tenderness, yes),
   symptom(urinary_frequency, yes),
   symptom(dysuria, yes),
   symptom(smoking_history, yes),
   frequency(bladder_carcinoma, Frequency).

diagnose(bladder_carcinoma, Frequency) :-
   symptom(haematuria, yes),
   finding(suprapubic_tenderness, yes),
   symptom(urinary_frequency, yes),
   symptom(dysuria, yes),
   symptom(age_over_40, yes),
   frequency(bladder_carcinoma, Frequency).

diagnose(bladder_carcinoma, Frequency) :-
   symptom(haematuria, yes),
   finding(suprapubic_tenderness, yes),
   symptom(urinary_frequency, yes),
   symptom(dysuria, yes),
   frequency(bladder_carcinoma, Frequency).

diagnose(schistosomiasis, Frequency) :-
   symptom(haematuria, yes),
   symptom(dysuria, yes),
   symptom(urinary_frequency, yes),
   symptom(trip_abroad, yes),
   frequency(schistosomiasis, Frequency).

diagnose(bladder_stones, Frequency) :-
   symptom(haematuria, yes),
   finding(suprapubic_tenderness, yes),
   symptom(urinary_frequency, yes),
   symptom(dysuria, yes),
   frequency(bladder_stones, Frequency).

diagnose(bladder_trauma, Frequency) :-
   symptom(haematuria, yes),
   (symptom(haematuria_location, entire); symptom(haematuria_location, end)),
   finding(suprapubic_tenderness, yes),
   symptom(urinary_frequency, yes),
   symptom(dysuria, yes),
   frequency(bladder_trauma, Frequency).

% --- Prostate ---

diagnose(benign_prostatic_hypertrophy, Frequency) :-
   patient_sex(male), 
   symptom(haematuria, yes),
   symptom(urinary_frequency, yes),
   finding(enlarged_prostate, yes),
   finding(enlargement_type, smooth),
   frequency(benign_prostatic_hypertrophy, Frequency).
    
diagnose(prostate_carcinoma, Frequency) :-
   patient_sex(male),
   symptom(haematuria, yes),
   symptom(urinary_frequency, yes),
   finding(enlarged_prostate, yes),
   finding(enlargement_type, hard),
   symptom(smoking_history, yes),
   symptom(age_over_40, yes),
   symptom(bone_tenderness, yes),
   frequency(prostate_carcinoma, Frequency).

diagnose(prostate_carcinoma, Frequency) :-
   patient_sex(male),
   symptom(haematuria, yes),
   symptom(urinary_frequency, yes),
   finding(enlarged_prostate, yes),
   finding(enlargement_type, hard),
   symptom(smoking_history, yes),
   symptom(bone_tenderness, yes),
   frequency(prostate_carcinoma, Frequency).

diagnose(prostate_carcinoma, Frequency) :-
   patient_sex(male),
   symptom(haematuria, yes),
   symptom(urinary_frequency, yes),
   finding(enlarged_prostate, yes),
   finding(enlargement_type, hard),
   symptom(age_over_40, yes),
   symptom(bone_tenderness, yes),
   frequency(prostate_carcinoma, Frequency).

diagnose(prostate_carcinoma, Frequency) :-
   patient_sex(male),
   symptom(haematuria, yes),
   symptom(urinary_frequency, yes),
   finding(enlarged_prostate, yes),
   finding(enlargement_type, hard),
   symptom(smoking_history, yes),
   symptom(age_over_40, yes),
   frequency(prostate_carcinoma, Frequency).

diagnose(prostate_carcinoma, Frequency) :-
   patient_sex(male),
   symptom(haematuria, yes),
   symptom(urinary_frequency, yes),
   finding(enlarged_prostate, yes),
   finding(enlargement_type, hard),
   symptom(smoking_history, yes),
   frequency(prostate_carcinoma, Frequency).

diagnose(prostate_carcinoma, Frequency) :-
   patient_sex(male),
   symptom(haematuria, yes),
   symptom(urinary_frequency, yes),
   finding(enlarged_prostate, yes),
   finding(enlargement_type, hard),
   symptom(age_over_40, yes),
   frequency(prostate_carcinoma, Frequency).

% --- Urethra ---

diagnose(urethra_trauma, Frequency) :-
   symptom(haematuria, yes),
   symptom(haematuria_location, initial),
   symptom(pelvic_fractures, yes),
   frequency(urethra_trauma, Frequency).

diagnose(urethra_stones, Frequency) :-
   symptom(haematuria, yes),
   finding(urethra_mass, yes),
   frequency(urethra_stones, Frequency).

diagnose(urethritis, Frequency) :-
   symptom(haematuria, yes),
   symptom(dysuria, yes),
   frequency(urethritis, Frequency).

diagnose(urethral_neoplasm, Frequency) :-
   symptom(haematuria, yes),
   finding(urethra_mass, yes),
   frequency(urethral_neoplasm, Frequency).

% --- General ---

diagnose(urinary_tract_infection, Frequency) :-
   symptom(haematuria, yes),
   symptom(dysuria, yes),
   frequency(urinary_tract_infection, Frequency).

diagnose(anticoagulant_therapy, Frequency) :-
   symptom(haematuria, yes),
   symptom(ureteric_colic, yes),
   symptom(anticoagulant_use, yes),
   frequency(anticoagulant_therapy, Frequency). 
  
diagnose(thrombocytopenia, Frequency) :-
   symptom(haematuria, yes),
   frequency(thrombocytopenia, Frequency).

diagnose(tuberculosis, Frequency) :-
   symptom(haematuria, yes),
   symptom(painless_haematuria, yes),
   finding(history_of_tuberculosis, yes),
   frequency(tuberculosis, Frequency).

diagnose(strenuous_exercise, Frequency) :-
   symptom(haematuria, yes),
   symptom(strenuous_exercise, yes),
   frequency(strenuous_exercise, Frequency).

diagnose(haemophilia, Frequency) :-
   symptom(haematuria, yes),
   frequency(haemophilia, Frequency).

diagnose(sickle_cell_disease, Frequency) :-
   symptom(haematuria, yes),
   symptom(evidence_sickle_cell_disease, yes),
   frequency(sickle_cell_disease, Frequency).

diagnose(malaria, Frequency) :-
   symptom(haematuria, yes),
   finding(evidence_malaria, yes),
   symptom(trip_abroad, yes),
   frequency(malaria, Frequency).

diagnose(malaria, Frequency) :-
   symptom(haematuria, yes),
   finding(evidence_malaria, yes),
   frequency(malaria, Frequency).

/* ------------------------------------------------------------
   SECTION 3  -  INVESTIGATIONS
   One suggest_test/2 fact per (diagnosis, test) pair.
   Source: Churchill's General Investigations and Specific
           Investigations sections for your presentation.
   ------------------------------------------------------------ */

% --- Kidney ---

suggest_test(glomerular_disease, urine_microscopy).
suggest_test(glomerular_disease, renal_biopsy).

suggest_test(kidney_carcinoma, urine_microscopy).
suggest_test(kidney_carcinoma, ivu).
suggest_test(kidney_carcinoma, ct).
suggest_test(kidney_carcinoma, cystoscopy).
suggest_test(kidney_carcinoma, selective_renal_angiography).
suggest_test(kidney_carcinoma, renal_biopsy).
suggest_test(kidney_carcinoma, cxr).

suggest_test(kidney_stones, urine_microscopy).
suggest_test(kidney_stones, ivu).
suggest_test(kidney_stones, us).
suggest_test(kidney_stones, cystoscopy).
suggest_test(kidney_stones, kub).

suggest_test(kidney_trauma, urine_microscopy).
suggest_test(kidney_trauma, us).

suggest_test(polycystic_kidney, urine_microscopy).
suggest_test(polycystic_kidney, us).

suggest_test(renal_embolism, urine_microscopy).
suggest_test(renal_embolism, clotting_screen).
suggest_test(renal_embolism, ct).

suggest_test(renal_vein_thrombosis, urine_microscopy).

suggest_test(vascular_malformation, urine_microscopy).
suggest_test(vascular_malformation, fbc).
suggest_test(vascular_malformation, esr).

% --- Ureter ---

suggest_test(ureter_stones, urine_microscopy).
suggest_test(ureter_stones, ivu).
suggest_test(ureter_stones, us).
suggest_test(ureter_stones, cystoscopy).
suggest_test(ureter_stones, kub).
suggest_test(ureter_stones, ureteroscopy).

suggest_test(ureteral_neoplasm, urine_microscopy).
suggest_test(ureteral_neoplasm, esr).
suggest_test(ureteral_neoplasm, ivu).
suggest_test(ureteral_neoplasm, ct).
suggest_test(ureteral_neoplasm, cystoscopy).
suggest_test(ureteral_neoplasm, ureteroscopy).

% --- Bladder ---

suggest_test(bladder_carcinoma, cxr).
suggest_test(bladder_carcinoma, urine_microscopy).
suggest_test(bladder_carcinoma, ivu).
suggest_test(bladder_carcinoma, ct).
suggest_test(bladder_carcinoma, cystoscopy).

suggest_test(schistosomiasis, urine_microscopy).

suggest_test(bladder_stones, urine_microscopy).
suggest_test(bladder_stones, ivu).
suggest_test(bladder_stones, us).
suggest_test(bladder_stones, cystoscopy).
suggest_test(bladder_stones, kub).

suggest_test(bladder_trauma, urine_microscopy).

% --- Prostate ---

suggest_test(benign_prostatic_hypertrophy, urine_microscopy).
suggest_test(benign_prostatic_hypertrophy, ivu).
suggest_test(benign_prostatic_hypertrophy, ct).
suggest_test(benign_prostatic_hypertrophy, cystoscopy).

suggest_test(prostate_carcinoma, urine_microscopy).
suggest_test(prostate_carcinoma, ivu).
suggest_test(prostate_carcinoma, ct).
suggest_test(prostate_carcinoma, cystoscopy).
suggest_test(prostate_carcinoma, cxr).
suggest_test(prostate_carcinoma, psa).
suggest_test(prostate_carcinoma, prostatic_biopsy).

% --- Urethra ---

suggest_test(urethra_trauma, urine_microscopy).

suggest_test(urethra_stones, urine_microscopy).
suggest_test(urethra_stones, ivu).
suggest_test(urethra_stones, us).
suggest_test(urethra_stones, cystoscopy).
suggest_test(urethra_stones, kub).

suggest_test(urethritis, urine_microscopy).
suggest_test(urethritis, cystoscopy).
suggest_test(urethritis, fbc).
suggest_test(urethritis, esr).

suggest_test(urethral_neoplasm, urine_microscopy).
suggest_test(urethral_neoplasm, esr).
suggest_test(urethral_neoplasm, ivu).
suggest_test(urethral_neoplasm, ct).
suggest_test(urethral_neoplasm, cystoscopy).
suggest_test(urethral_neoplasm, ureteroscopy).

% --- General ---

suggest_test(urinary_tract_infection, fbc).
suggest_test(urinary_tract_infection, esr).
suggest_test(urinary_tract_infection, urine_microscopy).
suggest_test(urinary_tract_infection, cystoscopy).

suggest_test(anticoagulant_therapy, urine_microscopy).
suggest_test(anticoagulant_therapy, clotting_screen).

suggest_test(thrombocytopenia, urine_microscopy).
suggest_test(thrombocytopenia, fbc).
suggest_test(thrombocytopenia, esr).

suggest_test(tuberculosis, urine_microscopy).
suggest_test(tuberculosis, fbc).
suggest_test(tuberculosis, esr).
suggest_test(tuberculosis, cxr).
suggest_test(tuberculosis, ivu).

suggest_test(strenuous_exercise, urine_microscopy).
suggest_test(strenuous_exercise, fbc).
suggest_test(strenuous_exercise, esr).
suggest_test(strenuous_exercise, clotting_screen).

suggest_test(haemophilia, urine_microscopy).
suggest_test(haemophilia, clotting_screen).

suggest_test(sickle_cell_disease, urine_microscopy).
suggest_test(sickle_cell_disease, sickling_test).

suggest_test(malaria, urine_microscopy).

/* ------------------------------------------------------------
   SECTION 4  -  PROOF TRACE
   One explain_step/3 clause for EVERY symptom/finding that any
   of your diagnose/2 rules depends on.
   Rationale should be a human-readable sentence (use single quotes).
   ------------------------------------------------------------ */

% --- Kidney ---

explain_step(glomerular_disease, haematuria,
   'La presencia de hematuria sugiere daño o inflamación en los glomérulos renales, permitiendo el paso de sangre hacia la orina.').
explain_step(glomerular_disease, loin_pain,
   'El dolor en la región lumbar sugiere afectación renal asociada a inflamación o alteración funcional del riñón.').

explain_step(kidney_carcinoma, haematuria,
   'La presencia de hematuria sugiere daño o invasión de estructuras vasculares del riñón por una posible masa tumoral.').
explain_step(kidney_carcinoma, loin_pain,
   'El dolor en la región lumbar sugiere crecimiento o expansión de una lesión renal que comprime tejidos cercanos.').
explain_step(kidney_carcinoma, weight_loss,
   'La pérdida de peso inexplicada sugiere un proceso maligno sistémico asociado a aumento del metabolismo tumoral.').
explain_step(kidney_carcinoma, smoking_history,
   'El antecedente de tabaquismo sugiere exposición prolongada a carcinógenos relacionados con el desarrollo de cáncer renal.').
explain_step(kidney_carcinoma, age_over_40,
   'La edad mayor de 40 años sugiere un mayor riesgo mutaciones celulares asociadas a neoplasias renales').
explain_step(kidney_carcinoma, haematuria,
   'La presencia de una masa renal en estudios de imagen sugiere directamente una posible neoplasia originada en el riñón.').

explain_step(kidney_stones, haematuria,
   'La presencia de hematuria sugiere irritación o lesión de las vías urinarias causada por el paso de cálculos renales.').
explain_step(kidney_stones, loin_pain,
   'El dolor en la región lumbar sugiere obstrucción o distensión del tracto urinario provocada por un cálculo renal.').
explain_step(kidney_stones, dysuria,
   'La disuria sugiere irritación e inflamación del tracto urinario durante la micción debido al desplazamiento de los cálculos.').
explain_step(kidney_stones, urinary_frequency,
   'El aumento en la frecuencia urinaria sugiere irritación vesical o urgencia urinaria secundaria a la presencia de cálculos en las vías urinarias.').

explain_step(kidney_trauma, haematuria,
   'La presencia de hematuria sugiere lesión o sangrado en el tejido renal secundario a daño traumático.').
explain_step(kidney_trauma, loin_pain,
   'El dolor en la región lumbar sugiere inflamación, contusión o lesión directa sobre el riñón.').
explain_step(kidney_trauma, renal_biopsy,
   'El antecedente reciente de biopsia renal sugiere una posible lesión iatrogénica del riñón.').

explain_step(polycystic_kidney, haematuria,
   'La presencia de hematuria sugiere daño o ruptura de quistes renales que permiten el paso de sangre hacia la orina.').
explain_step(polycystic_kidney, loin_pain,
   'El dolor en la región lumbar sugiere aumento del tamaño renal o presión causada por múltiples quistes en el riñón.').
explain_step(polycystic_kidney, history_polycystic_kidney,
   'El antecedente familiar de enfermedad renal poliquística sugiere una predisposición genética asociada al desarrollo de quistes renales múltiples.').

explain_step(renal_embolism, haematuria,
   'La presencia de hematuria sugiere daño isquémico o lesión vascular en el tejido renal debido a una disminución del flujo sanguíneo.').
explain_step(renal_embolism, loin_pain,
   'El dolor en la región lumbar sugiere un evento agudo de compromiso vascular renal asociado a isquemia o infarto del riñón.').
explain_step(urinary_difficulty, haematuria,
   'La dificultad urinaria sugiere alteración en la función renal.').

explain_step(renal_vein_thrombosis, haematuria,
   'La presencia de hematuria sugiere  daño en el tejido renal causado por obstrucción del drenaje venoso.').
explain_step(renal_vein_thrombosis, loin_pain,
   'El dolor en la región lumbar sugiere congestión y aumento de presión dentro del riñón debido a la obstrucción del drenaje venoso causada por el trombo.').
explain_step(renal_vein_thrombosis, poor_stream,
   'La disminución en la fuerza del flujo urinario sugiere alteración funcional del sistema urinario asociada al compromiso renal.').

explain_step(vascular_malformation, haematuria,
   'La presencia de hematuria sugiere alteraciones vasculares renales que pueden provocar sangrado hacia las vías urinarias.').
explain_step(vascular_malformation, loin_pain,
   'El dolor en la región lumbar sugiere cambios en el flujo sanguíneo o presión anormal sobre el tejido renal.').
explain_step(vascular_malformation, abdominal_murmur,
   'La presencia de un soplo abdominal sugiere flujo sanguíneo turbulento asociado a una anomalía vascular.').

% --- Ureter ---

explain_step(ureter_stones, haematuria,
   'La presencia de hematuria sugiere irritación o lesión de las vías urinarias causada por el desplazamiento de cálculos.').
explain_step(ureter_stones, ureteric_colic,
   'El cólico ureteral sugiere obstrucción aguda del uréter debido al paso de un cálculo urinario.').
explain_step(ureter_stones, loin_pain,
   'El dolor en la región lumbar sugiere aumento de presión en el sistema urinario secundario a la obstrucción del flujo de orina.').

explain_step(ureteral_neoplasm, haematuria,
   'La presencia de hematuria sugiere sangrado originado por una lesión tumoral en el tracto urinario.').
explain_step(ureteral_neoplasm, dysuria,
   'La disuria sugiere irritación e inflamación de las vías urinarias causada por el crecimiento de una masa ureteral.').
explain_step(ureteral_neoplasm, loin_pain,
   'El dolor en la región lumbar sugiere obstrucción parcial del flujo urinario.').
explain_step(ureteral_neoplasm, ureteric_colic,
   'El cólico ureteral sugiere episodios de obstrucción del uréter provocados por el crecimiento de la neoplasia.').

% --- Bladder ---

explain_step(bladder_carcinoma, haematuria,
   'La presencia de hematuria sugiere sangrado originado por una posible lesión tumoral en la vejiga.').
explain_step(bladder_carcinoma, suprapubic_tenderness,
   'La sensibilidad o dolor suprapúbico sugiere irritación e inflamación local en la vejiga urinaria.').
explain_step(bladder_carcinoma, urinary_frequency,
   'El aumento en la frecuencia urinaria sugiere disminución de la capacidad vesical.').
explain_step(bladder_carcinoma, dysuria,
   'La disuria sugiere inflamación e irritación del tracto urinario inferior asociada al compromiso vesical.').
explain_step(bladder_carcinoma, age_over_40,
   'Una edad mayor de 40 años sugiere un mayor riesgo de desarrollo de neoplasias del tracto urinario.').
explain_step(bladder_carcinoma, smoking_history,
   'El antecedente de tabaquismo sugiere exposición prolongada a carcinógenos relacionados con el desarrollo de cáncer vesical.').

explain_step(schistosomiasis, haematuria,
   'La presencia de hematuria sugiere daño e inflamación del tracto urinario causada por la infección parasitaria.').
explain_step(schistosomiasis, dysuria,
   'La disuria sugiere irritación del tracto urinario secundario al depósito de huevos.').
explain_step(schistosomiasis, urinary_frequency,
   'El aumento en la frecuencia urinaria sugiere inflamación e irritación vesical asociada al compromiso urinario.').
explain_step(schistosomiasis, trip_abroad,
   'El antecedente de viaje al extranjero sugiere posible exposición a zonas endémicas donde existe transmisión del parásito.').

explain_step(bladder_stones, haematuria,
   'La presencia de hematuria sugiere irritación o lesión vesical causada por los cálculos.').
explain_step(bladder_stones, suprapubic_tenderness,
   'La sensibilidad o dolor suprapúbico sugiere inflamación e irritación localizada en la vejiga urinaria.').
explain_step(bladder_stones, urinary_frequency,
   'El aumento en la frecuencia urinaria sugiere irritación vesical y sensación constante de necesidad de orinar.').
explain_step(bladder_stones, dysuria,
   'La disuria sugiere dolor e incomodidad durante la micción debido al roce de los cálculos con la mucosa urinaria.').

explain_step(bladder_trauma, haematuria,
   'La presencia de hematuria sugiere lesión o sangrado en la vejiga urinaria secundario a daño traumático.').
explain_step(bladder_trauma, haematuria_location,
   'La hematuria presente durante toda la micción o al final de esta sugiere que el origen del sangrado se localiza en la vejiga o en el tracto urinario inferior.').
explain_step(bladder_trauma, suprapubic_tenderness,
   'La sensibilidad o dolor suprapúbico sugiere inflamación o lesión directa de la pared vesical.').
explain_step(bladder_trauma, urinary_frequency,
   'El aumento en la frecuencia urinaria sugiere irritación de la vejiga y disminución de su capacidad funcional tras el trauma.').
explain_step(bladder_trauma, dysuria,
   'La disuria sugiere inflamación e irritación del tracto urinario inferior causada por la lesión vesical.').

% --- Prostate ---

explain_step(benign_prostatic_hypertrophy, haematuria,
   'La presencia de hematuria sugiere congestión o irritación de los vasos sanguíneos prostáticos al aumento del tamaño de la próstata.').
explain_step(benign_prostatic_hypertrophy, urinary_frequency,
   'El aumento en la frecuencia urinaria sugiere obstrucción parcial del flujo urinario causada por el crecimiento prostático.').
explain_step(benign_prostatic_hypertrophy, enlarged_prostate,
   'El hallazgo de una próstata aumentada de tamaño sugiere hiperplasia del tejido prostático que comprime la uretra.').
explain_step(benign_prostatic_hypertrophy, enlargement_type,
   'Una próstata agrandada con consistencia lisa y uniforme sugiere un crecimiento benigno más que un proceso maligno.').

explain_step(prostate_carcinoma, haematuria,
   'La presencia de hematuria sugiere invasión o irritación del tracto urinario por una lesión prostática maligna.').
explain_step(prostate_carcinoma, urinary_frequency,
   'El aumento en la frecuencia urinaria sugiere obstrucción del flujo urinario secundaria al crecimiento de la próstata.').
explain_step(prostate_carcinoma, enlarged_prostate,
   'El hallazgo de una próstata aumentada de tamaño sugiere proliferación anormal del tejido prostático.').
explain_step(prostate_carcinoma, enlargement_type,
   'Una próstata dura e irregular sugiere infiltración tumoral maligna.').
explain_step(prostate_carcinoma, bone_tenderness,
   'La sensibilidad o dolor óseo sugiere posible diseminación metastásica hacia el tejido óseo, hallazgo frecuente en cáncer prostático avanzado.').
explain_step(prostate_carcinoma, age_over_40,
   'Una edad mayor de 40 años sugiere un mayor riesgo de desarrollo de neoplasias del tracto urinario.').
explain_step(prostate_carcinoma, smoking_history,
   'El antecedente de tabaquismo sugiere exposición prolongada a carcinógenos relacionados con el desarrollo de cáncer vesical.').

% --- Urethra ---

explain_step(urethra_trauma, haematuria,
   'La presencia de hematuria sugiere lesión y sangrado en el tracto urinario.').
explain_step(urethra_trauma, haematuria_location,
   'La hematuria al inicio de la micción sugiere que el origen del sangrado se localiza en la uretra.').
explain_step(urethra_trauma, pelvic_fractures,
   'La presencia de fracturas pélvicas sugiere un mecanismo traumático capaz de producir daño uretral, especialmente en la uretra posterior.').

explain_step(urethra_stones, haematuria,
   'La presencia de hematuria sugiere irritación uretral causada por el paso o la impactación de un cálculo.').
explain_step(urethra_stones, urethra_mass,
   'La presencia de una masa palpable en la uretra sugiere obstrucción local compatible con un cálculo alojado en el conducto uretral.').

explain_step(urethritis, haematuria,
   'La presencia de hematuria sugiere inflamación e irritación de la mucosa uretral con daño leve de los vasos sanguíneos.').
explain_step(urethritis, dysuria,
   'La disuria sugiere inflamación de la uretra que produce dolor o ardor durante la micción.').

explain_step(urethral_neoplasm, haematuria,
   'La presencia de hematuria sugiere sangrado originado por una lesión tumoral en la uretra.').
explain_step(urethral_neoplasm, urethra_mass,
   'La presencia de una masa uretral sugiere crecimiento anormal de tejido compatible con una neoplasia.').

% --- General ---

explain_step(thrombocytopenia, haematuria,
   'La disminución de plaquetas puede provocar sangrado urinario debido a alteraciones en la coagulación.').

explain_step(urinary_tract_infection, haematuria,
   'La presencia de hematuria sugiere inflamación e irritación de las vías urinarias causada por un proceso infeccioso.').
explain_step(urinary_tract_infection, dysuria,
   'La disuria sugiere inflamación del tracto urinario que produce dolor o ardor durante la micción.').

explain_step(anticoagulant_therapy, haematuria,
   'La presencia de hematuria sugiere sangrado urinario favorecido por la disminución de la coagulación sanguínea.').
explain_step(anticoagulant_therapy, haematuria,
   'El cólico ureteral sugiere irritación u obstrucción del tracto urinario asociada al paso de coágulos o sangrado.').
explain_step(anticoagulant_therapy, haematuria,
   'El antecedente de uso de anticoagulantes sugiere una mayor predisposición a episodios hemorrágicos en las vías urinarias.').

explain_step(kidney_carcinoma, haematuria,
   'La presencia de hematuria sugiere sangrado urinario secundario a una alteración en los mecanismos de coagulación.').

explain_step(tuberculosis, haematuria,
   'La presencia de hematuria sugiere daño e inflamación del tracto urinario secundario a infección crónica.').
explain_step(tuberculosis, painless_haematuria,
   'La hematuria indolora sugiere una lesión urinaria de evolución lenta, característica de algunas infecciones granulomatosas como la tuberculosis.').
explain_step(tuberculosis, history_of_tuberculosis,
   'El antecedente de tuberculosis sugiere posible diseminación o reactivación de la infección hacia el sistema genitourinario.').

explain_step(strenuous_exercise, haematuria,
   'La presencia de hematuria sugiere irritación transitoria o microlesiones en las vías urinarias secundarias al esfuerzo físico intenso.').
explain_step(strenuous_exercise, strenuous_exercise,
   'El antecedente de ejercicio extenuante sugiere aumento del estrés mecánico y vascular sobre el sistema urinario.').

explain_step(haemophilia, haematuria,
   'La deficiencia de factores de coagulación favorece episodios hemorrágicos espontáneos o prolongados, incluyendo sangrado en las vías urinarias.').

explain_step(sickle_cell_disease, haematuria,
   'La presencia de hematuria sugiere daño vascular o isquemia en el tejido renal causada por alteraciones en los glóbulos rojos.').
explain_step(sickle_cell_disease, evidence_sickle_cell_disease,
   'La evidencia de enfermedad de células falciformes sugiere obstrucción de pequeños vasos sanguíneos por eritrocitos deformados.').

explain_step(malaria, haematuria,
   'La presencia de hematuria sugiere daño renal o hemólisis asociada a la infección parasitaria.').
explain_step(malaria, haematuria,
   'La evidencia clínica o de laboratorio de malaria sugiere infección activa por parásitos del género Plasmodium.').
explain_step(malaria, haematuria,
   'El antecedente de viaje al extranjero sugiere exposición a zonas endémicas donde la malaria es transmitida por mosquitos.').

/* ------------------------------------------------------------
   SECTION 5  -  EXCLUSION RULES  (optional but encouraged)
   Encode hard clinical exclusions using findings.
   The body should check one or more finding/2 facts.
   ------------------------------------------------------------ */

exclude_if(benign_prostatic_hypertrophy,
         'La hiperplasia benigna de próstata sólo afecta a pacientes masculinos') :-
   patient_sex(female).

exclude_if(prostate_carcinoma,
         'El cáncer de próstata sólo afecta a pacientes masculinos') :- 
   patient_sex(female).