# Cough / haemoptysis — p. 84–90, 191–195

## Diagnoses

| Atom | Display name | Frequency |
|------|-------------|-----------|
| `copd` | COPD | common |
| `asthma` | Asthma | common |
| `respiratory_tract_infection` | Respiratory tract infection | common |
| `gord` | GORD | common |
| `ace_inhibitor_cough` | ACE inhibitor cough | common |
| `bronchiectasis` | Bronchiectasis | occasional |
| `lung_cancer` | Lung cancer | occasional |
| `tuberculosis` | Tuberculosis | occasional |
| `pulmonary_oedema` | Pulmonary oedema | occasional |
| `pulmonary_embolism` | Pulmonary embolism | occasional |
| `pneumonia` | Pneumonia | common |

> `ace_inhibitor_cough` — only if `taking_ace_inhibitor = yes`.

## Symptom atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `cough` | yesno | `yes` / `no` |
| `haemoptysis` | yesno | `yes` / `no` |
| `sputum_character` | choice | `purulent` / `mucoid` / `bloodstained` / `frothy` |
| `onset` | choice | `acute` / `chronic` |
| `smoking_history` | yesno | `yes` / `no` |
| `weight_loss` | yesno | `yes` / `no` |
| `dyspnoea` | yesno | `yes` / `no` |
| `wheeze` | yesno | `yes` / `no` |
| `fever` | yesno | `yes` / `no` |
| `taking_ace_inhibitor` | yesno | `yes` / `no` |
| `reflux_symptoms` | yesno | `yes` / `no` |

## Finding atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `wheeze_on_auscultation` | yesno | `yes` / `no` |
| `crepitations` | yesno | `yes` / `no` |
| `reduced_air_entry` | yesno | `yes` / `no` |
| `clubbing` | yesno | `yes` / `no` |
| `lymphadenopathy` | yesno | `yes` / `no` |
