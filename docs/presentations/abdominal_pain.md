# Abdominal pain — p. 3–8

## Diagnoses

| Atom | Display name | Frequency |
|------|-------------|-----------|
| `appendicitis` | Appendicitis | common |
| `peptic_ulcer` | Peptic ulcer | common |
| `biliary_colic` | Biliary colic | common |
| `intestinal_obstruction` | Intestinal obstruction | occasional |
| `ureteric_colic` | Ureteric colic | occasional |
| `ectopic_pregnancy` | Ectopic pregnancy | occasional |
| `acute_pancreatitis` | Acute pancreatitis | occasional |
| `mesenteric_adenitis` | Mesenteric adenitis | occasional |
| `aortic_aneurysm` | Aortic aneurysm | rare |
| `diverticulitis` | Diverticulitis | occasional |

> `ectopic_pregnancy` — only in female patients (`patient_sex(female)`).
> `mesenteric_adenitis` — more common in children.

## Symptom atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `abdominal_pain` | yesno | `yes` / `no` |
| `onset` | choice | `sudden` / `gradual` / `colicky` |
| `pain_location` | choice | `rif` / `lif` / `epigastric` / `central` / `ruq` / `generalised` |
| `nausea_vomiting` | yesno | `yes` / `no` |
| `fever` | yesno | `yes` / `no` |
| `diarrhoea` | yesno | `yes` / `no` |
| `constipation` | yesno | `yes` / `no` |
| `pr_bleeding` | yesno | `yes` / `no` |
| `jaundice` | yesno | `yes` / `no` |
| `haematuria` | yesno | `yes` / `no` |
| `loin_to_groin_radiation` | yesno | `yes` / `no` |
| `last_menstrual_period` | yesno | `yes` / `no` — use as proxy for possible pregnancy |
| `previous_surgery` | yesno | `yes` / `no` |

## Finding atoms

| Atom | Type | Values / notes |
|------|------|----------------|
| `guarding` | yesno | `yes` / `no` |
| `rigidity` | yesno | `yes` / `no` |
| `rebound_tenderness` | yesno | `yes` / `no` |
| `bowel_sounds` | choice | `normal` / `absent` / `tinkling` |
| `pulsatile_mass` | yesno | `yes` / `no` |
| `hernial_orifice_tender` | yesno | `yes` / `no` |
