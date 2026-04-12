# Presentations reference

For each presentation this document lists:
- The Churchill's page number
- The diagnoses to encode with their frequency
- The exact `symptom/2` and `finding/2` atoms the bridge will assert

These atoms are **the contract** between `app.py` (which generates the UI
questions) and your `.pl` module. Use them verbatim.

---

## Chest pain (p. 57-61)  -  WORKED EXAMPLE

See `prolog/modules/chest_pain.pl`.

---

## Headache (p. 207-211)

**Diagnoses:**

| Atom | Display name | Frequency |
|------|-------------|-----------|
| `tension_headache` | Tension headache | common |
| `migraine` | Migraine | common |
| `subarachnoid_haemorrhage` | Subarachnoid haemorrhage | occasional |
| `meningitis` | Meningitis | occasional |
| `cluster_headache` | Cluster headache | occasional |
| `raised_intracranial_pressure` | Raised intracranial pressure | occasional |
| `temporal_arteritis` | Temporal arteritis | rare |
| `acute_angle_closure_glaucoma` | Acute angle-closure glaucoma | rare |
| `carbon_monoxide_poisoning` | Carbon monoxide poisoning | rare |
| `cervical_spondylosis` | Cervical spondylosis | occasional |

**Symptom atoms:**

| Atom | Type | Values |
|------|------|--------|
| `headache` | yesno | `yes` / `no` |
| `onset` | choice | `sudden` / `gradual` / `progressive` |
| `character` | choice | `throbbing` / `tight_band` / `bursting` / `constant` |
| `location` | choice | `unilateral` / `bilateral` / `occipital` / `frontal` / `temporal` |
| `neck_stiffness` | yesno | `yes` / `no` |
| `photophobia` | yesno | `yes` / `no` |
| `nausea_vomiting` | yesno | `yes` / `no` |
| `aura` | yesno | `yes` / `no` |
| `worse_morning` | yesno | `yes` / `no` |
| `worse_on_coughing` | yesno | `yes` / `no` |
| `fever` | yesno | `yes` / `no` |
| `jaw_claudication` | yesno | `yes` / `no` |
| `visual_disturbance` | yesno | `yes` / `no` |
| `preceding_trauma` | yesno | `yes` / `no` |
| `history_of_malignancy` | yesno | `yes` / `no` |

**Finding atoms:**

| Atom | Values |
|------|--------|
| `pyrexia` | `yes` / `no` |
| `neck_stiffness_confirmed` | `yes` / `no` |
| `papilloedema` | `yes` / `no` |
| `focal_neurology` | `yes` / `no` |
| `temporal_artery_tender` | `yes` / `no` |
| `bp_elevated` | `yes` / `no` |
| `petechial_rash` | `yes` / `no` |

---

## Abdominal pain (p. 3-8)

**Key diagnoses:** appendicitis (common), peptic ulcer (common),
biliary colic (common), intestinal obstruction (occasional),
ureteric colic (occasional), ectopic pregnancy (occasional  -  female),
acute pancreatitis (occasional), mesenteric adenitis (occasional  -  children),
aortic aneurysm (rare), diverticulitis (occasional)

**Symptom atoms:** `abdominal_pain`, `onset` (sudden/gradual/colicky),
`pain_location` (rif/lif/epigastric/central/ruq/generalised),
`nausea_vomiting`, `fever`, `diarrhoea`, `constipation`, `pr_bleeding`,
`jaundice`, `haematuria`, `loin_to_groin_radiation`, `last_menstrual_period`,
`previous_surgery`

**Finding atoms:** `guarding`, `rigidity`, `rebound_tenderness`,
`bowel_sounds` (normal/absent/tinkling), `pulsatile_mass`, `hernial_orifice_tender`

---

## Dyspnoea (p. 109-114)

**Key diagnoses:** asthma (common), COPD (common), heart failure (common),
pneumonia (common), pulmonary embolism (occasional), pneumothorax (occasional),
pleural effusion (occasional), anaemia (common), pulmonary fibrosis (rare),
lung cancer (occasional)

**Symptom atoms:** `dyspnoea`, `onset` (sudden/gradual/progressive),
`worse_on_exertion`, `orthopnoea`, `paroxysmal_nocturnal_dyspnoea`,
`wheeze`, `cough`, `sputum`, `haemoptysis`, `chest_pain`, `fever`,
`leg_swelling`, `weight_loss`, `smoking_history`

**Finding atoms:** `wheeze_on_auscultation`, `crepitations`, `reduced_air_entry`,
`peripheral_oedema`, `jvp_elevated`, `tracheal_deviation`, `dullness_to_percussion`

---

## Cough / haemoptysis (p. 84-90, 191-195)

**Key diagnoses (cough):** COPD (common), asthma (common), respiratory_tract_infection (common),
GORD (common), ACE_inhibitor_cough (common), bronchiectasis (occasional),
lung_cancer (occasional), TB (occasional), pulmonary_oedema (occasional)

**Key diagnoses (haemoptysis):** bronchial_carcinoma (occasional), TB (occasional),
pulmonary_embolism (occasional), bronchiectasis (occasional), pneumonia (common)

**Symptom atoms:** `cough`, `haemoptysis`, `sputum_character`
(purulent/mucoid/bloodstained/frothy), `onset` (acute/chronic),
`smoking_history`, `weight_loss`, `dyspnoea`, `wheeze`, `fever`,
`taking_ace_inhibitor`, `reflux_symptoms`

---

## Jaundice (p. 240-249)

**Key diagnoses:** gallstones (common), hepatitis (common),
alcoholic_liver_disease (common), primary_biliary_cirrhosis (occasional),
pancreatic_carcinoma (occasional), haemolysis (occasional),
drug_induced_jaundice (occasional), biliary_stricture (rare)

**Symptom atoms:** `jaundice`, `dark_urine`, `pale_stools`,
`right_upper_quadrant_pain`, `fever`, `weight_loss`, `pruritus`,
`alcohol_use`, `drug_history`, `travel_history`, `nausea_vomiting`

**Finding atoms:** `hepatomegaly`, `splenomegaly`, `gallbladder_palpable`,
`stigmata_of_liver_disease`, `lymphadenopathy`, `urine_bilirubin`

---

## Haematemesis (p. 182-186)

**Key diagnoses:** peptic_ulcer (common), oesophageal_varices (occasional),
mallory_weiss_tear (occasional), oesophagitis (common),
gastric_carcinoma (occasional), vascular_malformation (rare)

**Symptom atoms:** `haematemesis`, `blood_character` (fresh/coffee_grounds),
`melaena`, `abdominal_pain`, `alcohol_use`, `nsaid_use`, `previous_peptic_ulcer`,
`liver_disease`, `dysphagia`, `weight_loss`

**Finding atoms:** `haemodynamic_instability`, `epigastric_tenderness`,
`stigmata_of_liver_disease`, `rectal_exam_melaena`

---

## Diarrhoea (p. 95-100)

**Key diagnoses:** gastroenteritis (common), irritable_bowel_syndrome (common),
inflammatory_bowel_disease (occasional), colorectal_carcinoma (occasional),
coeliac_disease (occasional), infective_colitis (common),
hyperthyroidism (occasional), malabsorption (occasional)

**Symptom atoms:** `diarrhoea`, `onset` (acute/chronic),
`blood_in_stool`, `mucus_in_stool`, `abdominal_pain`, `weight_loss`,
`fever`, `recent_travel`, `recent_antibiotics`, `family_history_bowel_cancer`,
`nocturnal_diarrhoea`, `steatorrhoea`

---

## Convulsions (p. 80-83)

**Key diagnoses:** epilepsy (common), febrile_convulsion (common  -  children),
meningitis (occasional), hypoglycaemia (common), hyponatraemia (occasional),
intracranial_tumour (occasional), alcohol_withdrawal (occasional),
eclampsia (occasional  -  pregnant female), stroke (occasional)

**Symptom atoms:** `convulsion`, `onset_age`, `fever`, `aura`, `postictal_confusion`,
`incontinence`, `tongue_biting`, `focal_onset`, `diabetes`, `alcohol_use`,
`drug_use`, `pregnancy`

**Finding atoms:** `pyrexia`, `focal_neurology`, `neck_stiffness`, `papilloedema`,
`blood_glucose_low`, `blood_glucose_high`, `sodium_abnormal`

---

## Coma / confusion (p. 67-79)

**Key diagnoses:** hypoglycaemia (common), drug_overdose (common),
alcohol_intoxication (common), stroke (common), meningitis (occasional),
head_injury (occasional), hepatic_encephalopathy (occasional),
uraemia (occasional), hypercapnia (occasional)

**Symptom atoms:** `reduced_consciousness`, `confusion`, `onset` (sudden/gradual),
`fever`, `head_injury`, `alcohol_use`, `drug_use`, `diabetes`,
`liver_disease`, `renal_disease`, `focal_neurology_history`

**Finding atoms:** `gcs_score`, `pyrexia`, `focal_neurology`, `neck_stiffness`,
`papilloedema`, `pinpoint_pupils`, `blood_glucose_low`, `jaundice`

---

## Pyrexia of unknown origin (p. 374-377)

**Key diagnoses:** occult_infection (common), lymphoma (occasional),
SLE (occasional), TB (occasional), infective_endocarditis (occasional),
drug_fever (occasional), malignancy_other (occasional),
adult_still_disease (rare), factitious_fever (rare)

**Symptom atoms:** `fever_duration_weeks`, `weight_loss`, `night_sweats`,
`lymphadenopathy`, `joint_pain`, `rash`, `cardiac_history`,
`travel_history`, `drug_history`, `immunosuppressed`

**Finding atoms:** `lymphadenopathy_confirmed`, `splenomegaly`, `hepatomegaly`,
`heart_murmur`, `rash_present`

---

## Weight loss (p. 483-490)

**Key diagnoses:** malignancy (common), depression (common),
diabetes_mellitus (common), hyperthyroidism (common),
malabsorption (occasional), COPD (occasional), heart_failure (occasional),
TB (occasional), HIV (occasional  -  risk factors)

**Symptom atoms:** `weight_loss`, `amount_kg`, `anorexia`, `dysphagia`,
`change_in_bowel_habit`, `polyuria`, `heat_intolerance`, `palpitations`,
`low_mood`, `chronic_cough`, `night_sweats`, `risk_factors_hiv`

---

## Shock (p. 406-409)

**Key diagnoses:** hypovolaemic_shock (common), septic_shock (common),
cardiogenic_shock (occasional), anaphylactic_shock (occasional),
neurogenic_shock (rare), obstructive_shock (rare)

**Symptom atoms:** `hypotension`, `tachycardia`, `preceding_haemorrhage`,
`fever`, `history_of_mi`, `exposure_to_allergen`, `spinal_injury`

**Finding atoms:** `bp_systolic`, `pulse_rate`, `capillary_refill`,
`jvp_elevated`, `jvp_absent`, `wheeze`, `urticaria`, `cold_peripheries`

---

## Haematuria (p. 187-190)

**Key diagnoses:** urinary_tract_infection (common), renal_calculi (common),
bladder_carcinoma (occasional), renal_carcinoma (occasional),
glomerulonephritis (occasional), benign_prostatic_hypertrophy (common  -  male),
coagulation_disorder (occasional)

**Symptom atoms:** `haematuria`, `painless_haematuria`, `dysuria`, `frequency`,
`loin_pain`, `clots`, `weight_loss`, `smoking_history`, `age_over_40`,
`anticoagulant_use`

---

## Polyuria / thirst (p. 359-362, 431-433)

**Key diagnoses:** diabetes_mellitus (common), diabetes_insipidus (rare),
psychogenic_polydipsia (rare), hypercalcaemia (occasional),
chronic_renal_failure (occasional)

**Symptom atoms:** `polyuria`, `thirst`, `weight_loss`, `lethargy`,
`nocturia`, `polydipsia`, `recent_head_injury`, `family_history_diabetes`

**Finding atoms:** `blood_glucose_high`, `urine_glucose`, `serum_calcium_elevated`

---

## Oedema (p. 343-346)

**Key diagnoses:** heart_failure (common), hypoalbuminaemia (common),
nephrotic_syndrome (occasional), venous_insufficiency (common),
lymphoedema (occasional), hypothyroidism (occasional),
drug_induced_oedema (occasional  -  calcium channel blockers, NSAIDs)

**Symptom atoms:** `oedema`, `distribution` (bilateral/unilateral/generalised),
`dyspnoea`, `orthopnoea`, `proteinuria`, `weight_gain`,
`liver_disease`, `drug_history`, `cold_intolerance`, `weight_gain`

**Finding atoms:** `pitting_oedema`, `jvp_elevated`, `ascites`,
`pleural_effusion`, `facial_oedema`, `bradycardia`

---

## Palpitations (p. 351-353)

**Key diagnoses:** sinus_tachycardia (common), atrial_fibrillation (common),
SVT (occasional), ventricular_ectopics (common), ventricular_tachycardia (occasional),
hyperthyroidism (occasional), anaemia (occasional), anxiety (common)

**Symptom atoms:** `palpitations`, `character` (fast/irregular/missed_beats),
`onset` (sudden/gradual), `duration_seconds`, `syncope_with_palpitations`,
`chest_pain`, `dyspnoea`, `thyroid_symptoms`, `caffeine_use`, `anxiety`

**Finding atoms:** `pulse_rate`, `pulse_rhythm` (regular/irregular),
`ecg_rhythm`, `bp_elevated`, `tremor`, `thyroid_enlargement`

---

## Syncope (p. 427-430)

**Key diagnoses:** vasovagal_syncope (common), cardiac_arrhythmia (occasional),
postural_hypotension (common), aortic_stenosis (occasional),
hypertrophic_cardiomyopathy (rare), epilepsy (occasional  -  differentiate),
TIA (occasional)

**Symptom atoms:** `syncope`, `prodrome` (yes/no  -  nausea/sweating/tunnel_vision),
`onset` (exertional/postural/standing/spontaneous), `duration_seconds`,
`convulsive_movements`, `postictal_confusion`, `cardiac_history`,
`antihypertensive_use`, `age_over_60`

**Finding atoms:** `bp_postural_drop`, `murmur`, `pulse_rhythm`, `ecg_changes`
