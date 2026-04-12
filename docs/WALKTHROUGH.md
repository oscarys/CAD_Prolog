# Guía de práctica — Una sesión diagnóstica completa

Este documento lo guía a través de una sesión completa del sistema CAD,
utilizando un caso clínico realista. Trabaje con **la aplicación en ejecución**
en paralelo, ingresando las respuestas indicadas en cada paso.

Al finalizar habrá recorrido todas las fases del interrogatorio clínico, leído
una traza de demostración Prolog real, y comprendido exactamente cómo las reglas
`.pl` produjeron el resultado en pantalla.

---

## El caso

> **Sr. Carlos Mendoza, 58 años, masculino.**
>
> Ingresa al servicio de urgencias sosteniéndose el pecho. Describe un dolor
> torácico central, opresivo, que inició hace 25 minutos mientras estaba
> sentado en su escritorio y que no ha cedido. El dolor irradia hacia el
> brazo izquierdo. Presenta diaforesis profusa. Niega haber tenido disnea
> de esfuerzo antes de este episodio; los antiácidos que tomó en la sala
> de espera no le dieron alivio.
>
> En la exploración: pulso 102, TA 148/94. El ECG muestra elevación del
> segmento ST en derivaciones V2-V5. La troponina está pendiente (muestra
> tomada al ingreso, resultado aún no disponible). Los pulsos son iguales
> y presentes en las cuatro extremidades.

Lea el caso una vez, luego inicie la aplicación y siga los pasos a continuación.

---

## Fase 1 — Datos demográficos

Abra `http://localhost:5000`. Verá la cuadrícula de presentaciones y los
campos de datos del paciente.

**Ingrese:**

| Campo | Valor |
|-------|-------|
| Motivo de consulta | **Dolor torácico** |
| Edad | **58** |
| Sexo | **Masculino** |

Haga clic en **Iniciar interrogatorio**.

> **Lo que ocurrió internamente:**
> Al hacer clic, `session.py` almacena la clave de presentación (`chest_pain`),
> la edad y el sexo. Nada llega a Prolog todavía — el puente se ejecuta una
> sola vez, al final de la Fase 3.

---

## Fase 2 — Historia clínica

Ahora se recorrerán 21 preguntas sobre síntomas, una a la vez.
El átomo que aparece en la parte inferior de cada tarjeta (p. ej.,
`symptom(chest_pain, Value)`) es exactamente lo que se asertará en Prolog
cuando el puente se ejecute.

Responda cada pregunta de la siguiente manera:

| Pregunta | Respuesta | Hecho Prolog asertado |
|----------|-----------|----------------------|
| ¿El paciente tiene dolor torácico? | Sí | `symptom(chest_pain, yes)` |
| ¿Cómo describe el paciente el dolor? | Opresivo / constrictivo | `symptom(pain_character, crushing)` |
| ¿Dónde se localiza el dolor? | Central / retroesternal | `symptom(pain_location, central)` |
| ¿El dolor se desencadena con el esfuerzo? | **No** | `symptom(exertional, no)` |
| ¿Cuánto tiempo dura cada episodio (minutos)? | **25** | `symptom(pain_duration_minutes, 25)` |
| ¿El dolor irradia al brazo (especialmente izquierdo)? | Sí | `symptom(radiation_to_arm, yes)` |
| ¿El dolor irradia hacia la espalda? | No | `symptom(radiation_to_back, no)` |
| ¿El dolor empeora al inspirar (pleurítico)? | No | `symptom(pleuritic, no)` |
| ¿El paciente tiene disnea? | No | `symptom(dyspnoea, no)` |
| ¿El paciente suda en exceso? | Sí | `symptom(sweating, yes)` |
| ¿El paciente ha expectorado sangre? | No | `symptom(haemoptysis, no)` |
| ¿El paciente tiene tos? | No | `symptom(cough, no)` |
| ¿El paciente tiene fiebre? | No | `symptom(fever, no)` |
| ¿El dolor empeora al inclinarse o acostarse? | No | `symptom(worse_on_bending_or_lying, no)` |
| ¿El dolor cede con antiácidos? | No | `symptom(relieved_by_antacids, no)` |
| ¿El dolor cede con nitroglicerina (GTN) sublingual? | No | `symptom(relieved_by_gtn, no)` |
| ¿El dolor cede al inclinarse hacia adelante? | No | `symptom(relieved_by_sitting_forward, no)` |
| ¿El dolor empeora con el movimiento o la palpación del tórax? | No | `symptom(worse_on_movement, no)` |
| ¿El inicio fue súbito (en segundos)? | No (gradual en minutos) | `symptom(sudden_onset, no)` |
| ¿El dolor se limita a un lado en distribución en banda? | No | `symptom(unilateral_dermatomal, no)` |
| ¿El paciente ha presentado ánimo deprimido o depresión? | No | `symptom(low_mood, no)` |
| ¿El paciente tiene antecedente de neoplasia conocida? | No | `symptom(history_of_malignancy, no)` |

> **Consejo:** Use el atajo de teclado **Y** o **N** para preguntas de sí/no,
> luego **Enter** para avanzar. Toda la fase de historia toma aproximadamente
> 90 segundos a ese ritmo.

---

## Fase 3 — Exploración física

Ahora se preguntará sobre los hallazgos de la exploración clínica.

| Pregunta | Respuesta | Hecho Prolog asertado |
|----------|-----------|----------------------|
| ¿Los pulsos son simétricos en las cuatro extremidades? | **Sí** (simétricos) | `finding(pulse_asymmetry, no)` |
| ¿La presión venosa yugular está elevada? | No | `finding(jvp_elevated, no)` |
| ¿Hay dolor localizado en la pared torácica a la palpación? | No | `finding(chest_wall_tenderness, no)` |
| ¿Los ruidos respiratorios están disminuidos en un lado? | No | `finding(breath_sounds_reduced_unilateral, no)` |
| ¿Hay signos de trombosis venosa profunda (pierna inflamada y dolorosa)? | No | `finding(dvt_signs, no)` |
| ¿Hay exantema vesicular en distribución dermatomérica? | No | `finding(vesicular_rash, no)` |
| ¿Hay dolor puntual directamente sobre una costilla? | No | `finding(localised_rib_tenderness, no)` |
| ¿El ECG muestra cambios isquémicos? | **Sí** | `finding(ecg_changes, yes)` |
| ¿La troponina sérica está elevada? | No (aún no disponible) | `finding(troponin_elevated, no)` |
| ¿Troponina a las 12 horas del inicio? | **Aún no disponible** | `finding(troponin_at_12h, not_done)` |
| ¿Resultado de dímero D? | No realizado | `finding(d_dimer, not_done)` |

> **Nota sobre la troponina:** la troponina se eleva dentro de las 6 horas del
> inicio del IAM. Este paciente llegó 25 minutos después del inicio — el resultado
> está genuinamente pendiente. Responder "Aún no disponible" es clínicamente
> correcto e impide que la regla de exclusión del IAM se active incorrectamente.

Tras el último hallazgo, haga clic en **Siguiente hallazgo**. El puente se
ejecuta automáticamente — Prolog corre, recopila todos los resultados y
redirige a la página de diagnóstico.

---

## Fase 4 — Resultados

La página de diagnóstico se carga. Esto es lo que debe ver y por qué.

### Lo que hizo el puente (internamente)

Antes de llamar a Prolog, `bridge.py` ejecutó este ciclo:

```python
# 1. Asertar los 22 hechos del paciente en SWI-Prolog
assertz(patient_age(58))
assertz(patient_sex(male))
assertz(symptom(chest_pain, yes))
assertz(symptom(pain_character, crushing))
assertz(symptom(exertional, no))
assertz(symptom(pain_duration_minutes, 25))
assertz(symptom(radiation_to_arm, yes))
assertz(symptom(sweating, yes))
# ... (síntomas y hallazgos restantes)
assertz(finding(ecg_changes, yes))
assertz(finding(pulse_asymmetry, no))
assertz(finding(troponin_at_12h, not_done))

# 2. Consultar diagnose/2 — recopilar todas las soluciones
# 3. Deduplicar por nombre de diagnóstico
# 4. Verificar exclude_if/2 para cada resultado
# 5. Recopilar explain_step/3 y suggest_test/2 por diagnóstico
# 6. Ordenar: common → occasional → rare
# 7. Retraer todos los hechos — la BC queda sin estado
```

### Diagnósticos activos

#### Infarto agudo de miocardio — common

Es el resultado principal, mostrado con borde izquierdo verde y etiqueta de
frecuencia. Haga clic en el encabezado de la tarjeta para abrir la traza de
demostración.

**¿Por qué se activó esta regla?** Dos reglas independientes en `chest_pain.pl`
coincidieron:

**Regla 1** (basada en duración):
```prolog
diagnose(myocardial_infarction, Frequency) :-
    symptom(chest_pain, yes),         % ✓ yes
    symptom(pain_character, crushing), % ✓ crushing
    symptom(exertional, no),           % ✓ no — ocurre en reposo
    symptom(pain_duration_minutes, D), % ✓ 25
    D >= 20,                           % ✓ 25 >= 20
    frequency(myocardial_infarction, Frequency).
```

**Regla 2** (tríada clásica):
```prolog
diagnose(myocardial_infarction, Frequency) :-
    symptom(chest_pain, yes),          % ✓ yes
    symptom(pain_character, crushing), % ✓ crushing
    symptom(radiation_to_arm, yes),    % ✓ yes
    symptom(sweating, yes),            % ✓ yes
    frequency(myocardial_infarction, Frequency).
```

Ambas reglas se activan de forma independiente — Prolog retrocede a través de
todas las cláusulas de `diagnose/2`. El conjunto `seen` del puente deduplica
el resultado para que el IAM aparezca solo una vez.

**La traza de demostración en pantalla** muestra la justificación de
`explain_step/3` para cada síntoma del que dependieron las reglas:

| Síntoma | Justificación (en inglés, desde `chest_pain.pl`) |
|---------|--------------------------------------------------|
| chest_pain | Severe crushing chest pain is the cardinal symptom of MI |
| pain_character | Crushing quality reflects ischaemia of the myocardium |
| exertional | Unlike angina, MI occurs at rest — ongoing ischaemia despite absence of demand increase |
| pain_duration_minutes | Pain lasting 20+ minutes at rest is treated as MI until proven otherwise |
| radiation_to_arm | Radiation to left arm via dermatomes T1-T2 is a classic feature of MI |
| sweating | Diaphoresis reflects sympathetic activation in response to severe ischaemic pain |

> **Nota:** Las justificaciones provienen directamente de las cláusulas
> `explain_step/3` en `chest_pain.pl`, por eso aparecen en inglés.
> Las justificaciones de sus propios módulos las redactará usted.

**Estudios recomendados:**
ECG · Troponina sérica · BH · Rx tórax · Ecocardiograma

### ¿Por qué no aparece la angina?

Abra `chest_pain.pl` y localice la regla de angina:

```prolog
diagnose(angina, Frequency) :-
    symptom(chest_pain, yes),
    symptom(pain_character, crushing),
    symptom(exertional, yes),          % ← requiere exertional = yes
    ( symptom(pain_duration_minutes, D) -> D < 20 ; true ),
    frequency(angina, Frequency).
```

Asertamos `symptom(exertional, no)`. El tercer objetivo falla inmediatamente —
Prolog no retrocede hacia un valor diferente, simplemente falla la cláusula.
No existe otra cláusula `diagnose(angina, _)`, por lo que la angina no produce
ninguna solución.

Esto es clínicamente correcto: el dolor del Sr. Mendoza inició en reposo, que
es la distinción definitoria entre angina (de esfuerzo) e IAM (en reposo).

### Diagnósticos excluidos

Dos diagnósticos aparecen tachados con una explicación:

**Disección aórtica — excluida**
```prolog
exclude_if(aortic_dissection,
           'Symmetric pulses in all four limbs make dissection unlikely') :-
    finding(pulse_asymmetry, no).   % ✓ asertamos esto
```
`finding(pulse_asymmetry, no)` fue asertado → la exclusión se activa →
la disección aórtica se elimina de la lista activa.

**Depresión — excluida**
```prolog
exclude_if(depression,
           'Objective cardiac abnormality found ...') :-
    ( finding(ecg_changes, yes) ; finding(troponin_elevated, yes) ).
```
`finding(ecg_changes, yes)` satisface la disyunción → excluida.
Esta es una regla de seguridad: las causas psicológicas nunca deben aceptarse
mientras haya hallazgos cardíacos objetivos presentes.

### El volcado de hechos de la sesión

Desplácese al final de la página de resultados y expanda
**"Ver hechos asertados enviados a Prolog"**. Verá cada hecho
`patient_age/1`, `symptom/2` y `finding/2` que fue asertado antes de la
consulta. Este es su panel de depuración principal — cuando sus propias reglas
no se comporten como se espera, aquí debe buscar primero.

---

## Cinco puntos clave antes de escribir su módulo

**1. La tabla de frecuencias debe ir primero.**
`diagnose/2` termina con `frequency(Diagnosis, Frequency)`. Si escribe una
regla antes de su hecho `frequency/2`, la regla falla silenciosamente — sin
error, sin salida. Defina la tabla completa antes de cualquier regla.

**2. Múltiples cláusulas para un diagnóstico son correctas.**
El IAM tiene dos cláusulas independientes porque tiene dos presentaciones
clínicas distintas. Prolog las encuentra todas por retroceso; el puente
deduplica. Use múltiples cláusulas siempre que un diagnóstico tenga perfiles
de síntomas genuinamente diferentes.

**3. Las variables dentro de `\+` son locales — use if-then en su lugar.**
`\+ symptom(X, D), D >= 20` es un error: `D` está indefinida fuera de `\+`.
Use `( symptom(X, D) -> D < 20 ; true )` para comprobaciones numéricas
condicionales.

**4. `exclude_if` se activa después de `diagnose/2`.**
El puente recopila todos los diagnósticos primero, luego verifica exclusiones.
Use `diagnose/2` para evidencia positiva; use `exclude_if/2` para restricciones
de seguridad inapelables.

**5. `explain_step/3` es parte del contrato.**
Cada síntoma que su regla `diagnose/2` verifica necesita una cláusula
`explain_step/3` correspondiente. Si falta, el panel de demostración muestra
una advertencia. La suite de pruebas verifica esto automáticamente.

---

## Pruébelo usted mismo

Vuelva a ejecutar la sesión con un cuadro clínico diferente y observe
cómo cambian los resultados:

**Variante A — Angina estable clásica:**
Mismo paciente. Cambie: esfuerzo = **Sí**, duración = **8 minutos**.
Todo lo demás igual. La angina debe aparecer; el IAM no debe aparecer.

**Variante B — Pericarditis:**
Cualquier edad/sexo. Dolor: central, pleurítico = **Sí**, cede al inclinarse
hacia adelante = **Sí**. Sin irradiación, sin sudoración, sin esfuerzo.
La pericarditis debe aparecer como resultado principal.

**Variante C — Herpes zóster:**
Cualquier edad. Dolor ardoroso, dermatomérico unilateral = **Sí**.
Hallazgo: exantema vesicular = **Sí**. Sin hallazgos cardíacos.
El herpes zóster debe ser el único diagnóstico activo.

Para cada variante, abra la traza de demostración y rastree cada justificación
hasta su cláusula `explain_step/3` en `chest_pain.pl`. Esa correspondencia
uno a uno entre pantalla y fuente es exactamente lo que construirá para su
propia presentación.
