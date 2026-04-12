# Walkthrough — A complete diagnostic session

This document guides you through a full end-to-end session with the CAD system,
using a realistic clinical case. Work through it **with the application running**
alongside, entering the answers shown at each step.

By the end you will have seen every phase of the exam script, read a real
Prolog proof trace, and understood exactly how the `.pl` rules produced the
output on screen.

---

## The case

> **Mr. Carlos Mendoza, 58 years old, male.**
>
> He walks into the emergency department holding his chest. He describes a
> central, crushing chest pain that started 25 minutes ago while he was
> sitting at his desk. The pain has not gone away. It radiates down his
> left arm. He is sweating profusely. He denies any shortness of breath
> on exertion before this episode, and antacids he took in the waiting
> room gave no relief.
>
> On examination: pulse 102, BP 148/94. ECG shows ST-segment elevation
> in leads V2-V5. Troponin is pending (sample taken on arrival, result
> not yet back). Pulses are equal and present in all four limbs.

Read the case once, then start the application and follow the steps below.

---

## Phase 1 — Demographics

Open `http://localhost:5000`. You will see the presentation grid and the
demographics fields.

**Enter:**

| Field | Value |
|-------|-------|
| Presenting complaint | **Chest pain** |
| Age | **58** |
| Sex | **Male** |

Click **Begin exam script**.

> **What just happened in Python:**
> When you click Begin, `session.py` stores the presentation key (`chest_pain`),
> age, and sex. Nothing is sent to Prolog yet — the bridge only fires at the
> very end, in Phase 4.

---

## Phase 2 — History

You will now be taken through 21 symptom questions, one at a time.
The atom shown at the bottom of each card (e.g. `symptom(chest_pain, Value)`)
is exactly what will be asserted into Prolog when the bridge runs.

Answer each question as follows:

| Question | Answer | Prolog fact asserted |
|----------|--------|---------------------|
| Does the patient have chest pain? | **Yes** | `symptom(chest_pain, yes)` |
| How does the patient describe the pain? | **Crushing / tight** | `symptom(pain_character, crushing)` |
| Where is the pain located? | **Central / retrosternal** | `symptom(pain_location, central)` |
| Is the pain brought on by exertion? | **No** | `symptom(exertional, no)` |
| How long does each episode last (minutes)? | **25** | `symptom(pain_duration_minutes, 25)` |
| Does the pain radiate to the arm? | **Yes** | `symptom(radiation_to_arm, yes)` |
| Does the pain radiate through to the back? | **No** | `symptom(radiation_to_back, no)` |
| Is the pain worse on breathing in (pleuritic)? | **No** | `symptom(pleuritic, no)` |
| Is the patient breathless? | **No** | `symptom(dyspnoea, no)` |
| Is the patient sweating excessively? | **Yes** | `symptom(sweating, yes)` |
| Has the patient coughed up blood? | **No** | `symptom(haemoptysis, no)` |
| Does the patient have a cough? | **No** | `symptom(cough, no)` |
| Does the patient have a fever? | **No** | `symptom(fever, no)` |
| Is the pain worse on bending or lying down? | **No** | `symptom(worse_on_bending_or_lying, no)` |
| Is the pain relieved by antacids? | **No** | `symptom(relieved_by_antacids, no)` |
| Is the pain relieved by GTN spray? | **No** | `symptom(relieved_by_gtn, no)` |
| Is the pain relieved by sitting forward? | **No** | `symptom(relieved_by_sitting_forward, no)` |
| Is the pain worse on movement or pressing the chest? | **No** | `symptom(worse_on_movement, no)` |
| Was the onset sudden (within seconds)? | **No** (gradual over minutes) | `symptom(sudden_onset, no)` |
| Is the pain restricted to one side in a band? | **No** | `symptom(unilateral_dermatomal, no)` |
| Has the patient been experiencing low mood? | **No** | `symptom(low_mood, no)` |
| Does the patient have a known malignancy? | **No** | `symptom(history_of_malignancy, no)` |

> **Tip:** Use the keyboard shortcut **Y** or **N** for yes/no questions,
> then **Enter** to advance. It takes about 90 seconds to run through all
> 21 questions at that pace.

---

## Phase 3 — Examination

You are now asked about clinical findings from the physical examination.

| Question | Answer | Prolog fact asserted |
|----------|--------|---------------------|
| Are pulses symmetric in all four limbs? | **Yes** (they are symmetric) | `finding(pulse_asymmetry, no)` |
| Is the JVP elevated? | **No** | `finding(jvp_elevated, no)` |
| Is there localised chest wall tenderness? | **No** | `finding(chest_wall_tenderness, no)` |
| Are breath sounds reduced on one side? | **No** | `finding(breath_sounds_reduced_unilateral, no)` |
| Are there signs of DVT? | **No** | `finding(dvt_signs, no)` |
| Is there a vesicular rash in a dermatomal distribution? | **No** | `finding(vesicular_rash, no)` |
| Is there point tenderness directly over a rib? | **No** | `finding(localised_rib_tenderness, no)` |
| Does the ECG show ischaemic changes? | **Yes** | `finding(ecg_changes, yes)` |
| Is serum troponin elevated? | **No** (result not back yet) | `finding(troponin_elevated, no)` |
| Troponin at 12 hours post-onset? | **Not yet done** | `finding(troponin_at_12h, not_done)` |
| D-dimer result? | **Not done** | `finding(d_dimer, not_done)` |

> **Note on the troponin question:** troponin rises within 6 hours of MI
> onset. This patient arrived within 25 minutes — the result is genuinely
> pending. Answering "not yet done" is clinically correct and prevents the
> exclusion rule from firing incorrectly.

Click **Next finding** after the last question. The bridge fires automatically.

---

## Phase 4 — Results

The results page loads. Here is what you should see and why.

### What the bridge did (behind the scenes)

Before calling Prolog, `bridge.py` ran this cycle:

```python
# 1. Assert all 22 patient facts into SWI-Prolog
assertz(patient_age(58))
assertz(patient_sex(male))
assertz(symptom(chest_pain, yes))
assertz(symptom(pain_character, crushing))
assertz(symptom(exertional, no))
assertz(symptom(pain_duration_minutes, 25))
assertz(symptom(radiation_to_arm, yes))
assertz(symptom(sweating, yes))
# ... (remaining symptoms and findings)
assertz(finding(ecg_changes, yes))
assertz(finding(pulse_asymmetry, no))
assertz(finding(troponin_at_12h, not_done))

# 2. Query diagnose/2 — collect all solutions
# 3. Deduplicate by diagnosis name
# 4. Check exclude_if/2 for each result
# 5. Collect explain_step/3 and suggest_test/2 per diagnosis
# 6. Sort: common → occasional → rare
# 7. Retract all facts — KB is stateless again
```

### Active diagnoses

#### Myocardial infarction — common

This is the top result, shown with a green left border and frequency badge.
Click the card header to open the proof trace.

**Why did this fire?** Two separate rules in `chest_pain.pl` both matched:

**Rule 1** (duration-based):
```prolog
diagnose(myocardial_infarction, Frequency) :-
    symptom(chest_pain, yes),        % ✓ yes
    symptom(pain_character, crushing), % ✓ crushing
    symptom(exertional, no),           % ✓ no — occurs at rest
    symptom(pain_duration_minutes, D), % ✓ 25
    D >= 20,                           % ✓ 25 >= 20
    frequency(myocardial_infarction, Frequency).
```

**Rule 2** (classic triad):
```prolog
diagnose(myocardial_infarction, Frequency) :-
    symptom(chest_pain, yes),          % ✓ yes
    symptom(pain_character, crushing), % ✓ crushing
    symptom(radiation_to_arm, yes),    % ✓ yes
    symptom(sweating, yes),            % ✓ yes
    frequency(myocardial_infarction, Frequency).
```

Both rules fire independently — Prolog backtracks through all clauses for
`diagnose/2`. The bridge's `seen` set deduplicates the result so MI appears
only once in the output.

**The proof trace on screen** shows the `explain_step/3` rationale for each
symptom the rules depended on:

| Symptom | Rationale |
|---------|-----------|
| chest_pain | Severe crushing chest pain is the cardinal symptom of MI |
| pain_character | Crushing quality reflects ischaemia of the myocardium |
| exertional | Unlike angina, MI occurs at rest — ongoing ischaemia despite absence of demand increase |
| pain_duration_minutes | Pain lasting 20+ minutes at rest is treated as MI until proven otherwise |
| radiation_to_arm | Radiation to left arm via dermatomes T1-T2 is a classic feature of MI |
| sweating | Diaphoresis reflects sympathetic activation in response to severe ischaemic pain |

**Investigations shown:**
ECG · Serum troponin · FBC · CXR · Echocardiogram

### Why did angina NOT appear?

Open `chest_pain.pl` and look at the angina rule:

```prolog
diagnose(angina, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, crushing),
    symptom(exertional, yes),          % ← requires exertional = yes
    ( symptom(pain_duration_minutes, D) -> D < 20 ; true ),
    frequency(angina, Frequency).
```

We asserted `symptom(exertional, no)`. The third goal fails immediately —
Prolog does not backtrack into a different value, it simply fails the clause.
No other `diagnose(angina, _)` clause exists, so angina produces no solution.

This is exactly correct clinically: Mr. Mendoza's pain started at rest, which
is the defining distinction between angina (exertional) and MI (at rest).

### Excluded diagnoses

Two diagnoses appear struck through with an explanation:

**Aortic dissection — excluded**
```prolog
exclude_if(aortic_dissection,
           'Symmetric pulses in all four limbs make dissection unlikely') :-
    finding(pulse_asymmetry, no).   % ✓ we asserted this
```
`finding(pulse_asymmetry, no)` was asserted → the exclusion fires → aortic
dissection is removed from the active list even though its `diagnose/2` rule
might have partially matched.

**Depression — excluded**
```prolog
exclude_if(depression,
           'Objective cardiac abnormality found ...') :-
    ( finding(ecg_changes, yes) ; finding(troponin_elevated, yes) ).
```
`finding(ecg_changes, yes)` satisfies the disjunction → excluded.
This is a safety rule: psychological causes must never be accepted while
objective cardiac findings are present.

### The session fact dump

Scroll to the bottom of the results page and expand **"View asserted facts
sent to Prolog"**. You will see every `patient_age/1`, `symptom/2`, and
`finding/2` fact that was asserted before the query. This is your debugging
panel — when your own rules don't fire as expected, this is the first place
to look.

---

## What to take away before writing your own module

**1. The frequency table must come first.**
`diagnose/2` ends with `frequency(Diagnosis, Frequency)`. If you write a rule
before its `frequency/2` fact, the rule silently fails every time.

**2. Multiple clauses for one diagnosis are fine — and often correct.**
MI has two independent clauses because there are two distinct clinical
presentations that both warrant the diagnosis. Prolog finds all of them;
the bridge deduplicates. You should use multiple clauses whenever a
diagnosis has genuinely different symptom profiles.

**3. `\+` scoping is the most common bug.**
`\+ symptom(X, yes)` means "not provable that symptom(X, yes) exists".
Any variable inside `\+` is local to that goal — it cannot be used outside.
Use `( symptom(X, D) -> D < 20 ; true )` for conditional numeric checks.

**4. `exclude_if/2` fires after `diagnose/2`.**
The bridge collects all diagnoses first, then checks exclusions. A diagnosis
can match `diagnose/2` and still be excluded. This means your rules should
encode positive evidence; exclusions encode hard clinical safety constraints.

**5. The proof trace is part of the contract.**
Every symptom your `diagnose/2` rule checks should have a matching
`explain_step/3` clause. If it doesn't, the proof panel shows a warning.
The rationale text is what students read — write it as a clinician would
explain it to a junior colleague.

---

## Now try it yourself

Re-run the session with a different clinical picture and observe how the
results change:

**Variant A — Classic angina:**
Same patient, but change exertional to **Yes** and duration to **8 minutes**.
Angina should appear; MI should not (duration < 20 and it resolves with rest).

**Variant B — Pericarditis:**
58M, central chest pain, worse on breathing in, relieved by sitting forward,
no radiation, no sweating. Pericarditis should appear as the top result.

**Variant C — Herpes zoster:**
Any age, burning pain, strictly one-sided in a band, vesicular rash present
on examination. Herpes zoster should be the sole active diagnosis.

For each variant, open the proof trace and trace each rationale sentence
back to its `explain_step/3` clause in `chest_pain.pl`. That traceability —
from screen to Prolog source — is what you will build for your own module.
