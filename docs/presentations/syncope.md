# Syncope — p. 427–430

## Diagnoses

| Atom | Display name | Frequency |
|------|-------------|-----------|
| `vasovagal_syncope` | Vasovagal syncope | common |
| `cardiac_arrhythmia` | Cardiac arrhythmia | occasional |
| `postural_hypotension` | Postural hypotension | common |
| `aortic_stenosis` | Aortic stenosis | occasional |
| `hypertrophic_cardiomyopathy` | Hypertrophic cardiomyopathy | rare |
| `epilepsy` | Epilepsy | occasional |
| `tia` | TIA | occasional |

## Symptom atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `syncope` | yesno | `yes` / `no` |
| `prodrome` | yesno | `yes` if nausea / sweating / tunnel vision before episode |
| `onset` | choice | `exertional` / `postural` / `standing` / `spontaneous` |
| `duration_seconds` | number | integer seconds |
| `convulsive_movements` | yesno | `yes` / `no` |
| `postictal_confusion` | yesno | `yes` / `no` |
| `cardiac_history` | yesno | `yes` / `no` |
| `antihypertensive_use` | yesno | `yes` / `no` |
| `age_over_60` | yesno | `yes` / `no` |

## Finding atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `bp_postural_drop` | yesno | `yes` / `no` — drop ≥20 mmHg systolic on standing |
| `murmur` | yesno | `yes` / `no` |
| `pulse_rhythm` | choice | `regular` / `irregular` |
| `ecg_changes` | yesno | `yes` / `no` |
