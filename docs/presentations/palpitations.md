# Palpitations — p. 351–353

## Diagnoses

| Atom | Display name | Frequency |
|------|-------------|-----------|
| `sinus_tachycardia` | Sinus tachycardia | common |
| `atrial_fibrillation` | Atrial fibrillation | common |
| `svt` | SVT | occasional |
| `ventricular_ectopics` | Ventricular ectopics | common |
| `ventricular_tachycardia` | Ventricular tachycardia | occasional |
| `hyperthyroidism` | Hyperthyroidism | occasional |
| `anaemia` | Anaemia | occasional |
| `anxiety` | Anxiety | common |

## Symptom atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `palpitations` | yesno | `yes` / `no` |
| `character` | choice | `fast` / `irregular` / `missed_beats` |
| `onset` | choice | `sudden` / `gradual` |
| `duration_seconds` | number | integer seconds |
| `syncope_with_palpitations` | yesno | `yes` / `no` |
| `chest_pain` | yesno | `yes` / `no` |
| `dyspnoea` | yesno | `yes` / `no` |
| `thyroid_symptoms` | yesno | `yes` / `no` |
| `caffeine_use` | yesno | `yes` / `no` |
| `anxiety` | yesno | `yes` / `no` |

## Finding atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `pulse_rate` | number | beats per minute |
| `pulse_rhythm` | choice | `regular` / `irregular` |
| `ecg_rhythm` | yesno | `yes` / `no` — abnormal if `yes` |
| `bp_elevated` | yesno | `yes` / `no` |
| `tremor` | yesno | `yes` / `no` |
| `thyroid_enlargement` | yesno | `yes` / `no` |
