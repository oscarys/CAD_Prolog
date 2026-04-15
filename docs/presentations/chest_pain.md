# Chest pain — p. 57–61 · WORKED EXAMPLE

See `prolog/modules/chest_pain.pl` for the complete reference implementation.

## Diagnoses

| Atom | Display name | Frequency |
|------|-------------|-----------|
| `angina` | Angina pectoris | common |
| `myocardial_infarction` | Myocardial infarction | common |
| `pericarditis` | Pericarditis | occasional |
| `aortic_dissection` | Aortic dissection | occasional |
| `reflux_oesophagitis` | Reflux oesophagitis | common |
| `oesophageal_spasm` | Oesophageal spasm | occasional |
| `peptic_ulcer` | Peptic ulcer | common |
| `pneumonia` | Pneumonia | occasional |
| `pneumothorax` | Pneumothorax | occasional |
| `pulmonary_embolism` | Pulmonary embolism | occasional |
| `costochondritis` | Costochondritis | common |
| `herpes_zoster` | Herpes zoster | occasional |
| `rib_metastasis` | Rib metastasis | rare |
| `depression` | Depression | occasional |

## Symptom atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `chest_pain` | yesno | `yes` / `no` |
| `pain_character` | choice | `crushing` / `burning` / `tearing` / `gnawing` / `constant` / `atypical` |
| `pain_location` | choice | `central` / `left_sided` / `epigastric` / `right_sided` |
| `exertional` | yesno | `yes` / `no` |
| `pain_duration_minutes` | number | integer minutes |
| `radiation_to_arm` | yesno | `yes` / `no` |
| `radiation_to_back` | yesno | `yes` / `no` |
| `pleuritic` | yesno | `yes` / `no` |
| `dyspnoea` | yesno | `yes` / `no` |
| `sweating` | yesno | `yes` / `no` |
| `haemoptysis` | yesno | `yes` / `no` |
| `cough` | yesno | `yes` / `no` |
| `fever` | yesno | `yes` / `no` |
| `worse_on_bending_or_lying` | yesno | `yes` / `no` |
| `relieved_by_antacids` | yesno | `yes` / `no` |
| `relieved_by_gtn` | yesno | `yes` / `no` |
| `relieved_by_sitting_forward` | yesno | `yes` / `no` |
| `worse_on_movement` | yesno | `yes` / `no` |
| `sudden_onset` | yesno | `yes` / `no` |
| `unilateral_dermatomal` | yesno | `yes` / `no` |
| `low_mood` | yesno | `yes` / `no` |
| `history_of_malignancy` | yesno | `yes` / `no` |

## Finding atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `pulse_asymmetry` | yesno | `yes` / `no` |
| `jvp_elevated` | yesno | `yes` / `no` |
| `chest_wall_tenderness` | yesno | `yes` / `no` |
| `breath_sounds_reduced_unilateral` | yesno | `yes` / `no` |
| `dvt_signs` | yesno | `yes` / `no` |
| `vesicular_rash` | yesno | `yes` / `no` |
| `localised_rib_tenderness` | yesno | `yes` / `no` |
| `ecg_changes` | yesno | `yes` / `no` |
| `troponin_elevated` | yesno | `yes` / `no` |
| `troponin_at_12h` | choice | `positive` / `negative` / `not_done` |
| `d_dimer` | choice | `positive` / `negative` / `not_done` |
