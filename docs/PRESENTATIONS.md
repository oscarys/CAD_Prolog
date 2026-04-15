# Presentations — index

Each presentation has its own file in `docs/presentations/` with the full
tables of diagnoses, symptom atoms, and finding atoms.

The atoms listed there are **the contract** between `app.py` (which generates
the UI questions) and your `.pl` module. Use them verbatim.

---

## The 18 presentations

| System | Presentation | Churchill's p. | File |
|--------|-------------|----------------|------|
| Cardiovascular | Chest pain ★ | 57–61 | [chest_pain.md](presentations/chest_pain.md) |
| Cardiovascular | Palpitations | 351–353 | [palpitations.md](presentations/palpitations.md) |
| Cardiovascular | Syncope | 427–430 | [syncope.md](presentations/syncope.md) |
| Respiratory | Dyspnoea | 109–114 | [dyspnoea.md](presentations/dyspnoea.md) |
| Respiratory | Cough / haemoptysis | 84–90, 191–195 | [cough_haemoptysis.md](presentations/cough_haemoptysis.md) |
| Respiratory | Stridor | 419–422 | [stridor.md](presentations/stridor.md) |
| Gastrointestinal | Abdominal pain | 3–8 | [abdominal_pain.md](presentations/abdominal_pain.md) |
| Gastrointestinal | Jaundice | 240–249 | [jaundice.md](presentations/jaundice.md) |
| Gastrointestinal | Haematemesis | 182–186 | [haematemesis.md](presentations/haematemesis.md) |
| Gastrointestinal | Diarrhoea | 95–100 | [diarrhoea.md](presentations/diarrhoea.md) |
| Neurological | Headache | 207–211 | [headache.md](presentations/headache.md) |
| Neurological | Convulsions | 80–83 | [convulsions.md](presentations/convulsions.md) |
| Neurological | Coma / confusion | 67–79 | [coma_confusion.md](presentations/coma_confusion.md) |
| Systemic | Pyrexia of unknown origin | 374–377 | [pyrexia_unknown_origin.md](presentations/pyrexia_unknown_origin.md) |
| Systemic | Weight loss | 483–490 | [weight_loss.md](presentations/weight_loss.md) |
| Systemic | Shock | 406–409 | [shock.md](presentations/shock.md) |
| Urogenital / Endocrine | Haematuria | 187–190 | [haematuria.md](presentations/haematuria.md) |
| Urogenital / Endocrine | Polyuria / thirst | 359–362, 431–433 | [polyuria_thirst.md](presentations/polyuria_thirst.md) |
| Urogenital / Endocrine | Oedema | 343–346 | [oedema.md](presentations/oedema.md) |

★ Chest pain is the **worked example** — read `prolog/modules/chest_pain.pl`
alongside its reference file before starting your own module.

---

## Common atom conventions

All files follow the same three-table format:

- **Diagnoses** — atom name, display name, Churchill's frequency (common / occasional / rare)
- **Symptom atoms** — used with `symptom(Name, Value)` in your Prolog rules
- **Finding atoms** — used with `finding(Name, Value)` in your Prolog rules

Where a diagnosis applies only to a specific demographic, a note is included
below the table (e.g. `ectopic_pregnancy` — female only; `febrile_convulsion`
— children).
