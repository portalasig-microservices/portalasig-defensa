# 🎓 Guía de estudio — Defensa TEG (repaso rápido)
*Basada en el documento (89 págs), organizada por las 39 láminas. Lectura completa: ~25 min. Repaso exprés: leer solo los ▶ y la hoja de números.*

---

## ⚡ HOJA DE NÚMEROS (memorizar en frío)

| Dato | Valor |
|---|---|
| Deuda del monolito | **6 años**, controlador de **3.629 líneas**, **18 dominios**, tabla `site` con **18 relaciones** |
| Servicios nuevos | **4** (UAA, Site, Notify, PAIMA) + FE adaptado (no reescrito) |
| Coberturas (líneas/ramas) | UAA **84,6/64,4** · Notify **91,8/71,4** · Site **80,5/61,3** · PAIMA **85,5/78,6** |
| Gates CI | **70% líneas / 60% ramas** (JaCoCo, rompe el build si baja) |
| Tests | Integración **reales con Testcontainers + MySQL 8** (no H2) |
| Bugs reales encontrados | **17** (11 en tests/CI + 5 en caos + 1 por e2e) |
| E2E Cypress | **12 specs, 52 casos, 1m16s**, 18/20 corridas 100% verdes (2 flakes del screenshot del navegador, cero aserciones fallidas) |
| Benchmark GET | MS **136,7 ms / 347,8 rps** vs legacy 262,9 ms / 180,7 rps → **MS 1,9×** |
| Benchmark POST | empate (~86 vs ~90 ms), MS **0% error** vs legacy 1,39% |
| Benchmark auth | legacy 37 ms (MD5) vs MS 169 ms (**bcrypt deliberado**) |
| Caos | detección P1 en **1 ciclo MAPE (~2 min)**; peor caso con scheduler 5 min = **4m59s**; recuperación **~20 s** tras aprobación |
| Datos de prueba | ETL del dump real **anonimizado**: 96 cursos, ~200 sites, 9.292 inscripciones, 46 semestres |
| LLM | Kimi k2.6 (Moonshot) vía **relay TLS nginx** (geo-bloqueo), temperatura=1, `response_format=json` |
| Seguridad | OAuth2/JWT (Spring Authorization Server), bcrypt, clientes `portalasig_engine`/`portalasig_client` |
| Comunicación MS | REST síncrono + **Kafka** para eventos (notify consume) |

---

## 🎯 EL ARCO EN 30 SEGUNDOS (si solo recuerdas una cosa)
> "PortalAsig acumuló 6 años de deuda en un monolito que **nadie se atrevía a tocar**: el conocimiento era tácito. Hicimos tres cosas: **migramos** a microservicios con bases de datos por servicio, **sistematizamos** el mantenimiento con calidad exigida automáticamente en CI (tests reales, cobertura con gate, migraciones Flyway), y construimos **PAIMA**, un servicio de autogestión que observa el ecosistema, detecta caídas, diagnostica con IA y **propone** la reparación — pero **el humano siempre aprueba**. Todo quedó validado con números: cobertura medida, E2E real, benchmark término a término y un experimento de caos end-to-end."

---

## 📋 LÁMINA POR LÁMINA (1 min c/u)

### Apertura (1–3)
1. **Portada** — Título + tu nombre + tutor. ▶ "Buenos días, presento mi trabajo: un modelo de mantenimiento asistido por IA aplicado a la migración de PortalAsig a microservicios."
2. **Agenda** — ▶ "Cuatro partes: problema, conceptos, solución y validación con números."
3. *(lámina puente)*

### Contexto y problema (4–7)
5. **Una década de evolución** — 2016 monolito Node + AngularJS; 2020 FE a Vue (TEG anterior, backend intacto); 2020-2024 cambios incrementales sin mantenimiento sistemático; hoy: este trabajo. ▶ "El backend lleva 6 años sin rediseño."
6. **El backend monolítico hoy** — Controlador de 3.629 líneas, 18 dominios, tabla `site` con 18 relaciones, Node 12 EOL. ▶ "Un solo proceso lo hace todo; un cambio en evaluaciones puede romper correos."
7. **El problema de fondo es humano** — *CLAVE DE LA TESIS*. ▶ "El problema no es solo técnico: el conocimiento murió con quienes se fueron. Nadie documentó, nadie prueba, nadie se atreve. Mi trabajo ataca ESO: convertir conocimiento tácito en sistemas que lo imponen."

### Objetivos y visión (8–9)
8. **Objetivos** — General: diseño e implementación de un **modelo de mantenimiento asistido por IA** para la evolución del backend. Específicos: migrar a MS, sistematizar calidad/validación, autogestión con PAIMA. 
9. **Tres líneas de transformación** — Arquitectónica (monolito→MS), metodológica (tácito→sistemático), operativa (reactivo→autónomo). ▶ "Estas tres líneas estructuran todo lo que sigue."

### Marco conceptual (10–13)
11. **De monolito a microservicios** — Bounded contexts (DDD), database-per-service, despliegue independiente. Web 3.0: distribución, observabilidad, IA.
12. **MAPE-K** — Monitor-Analyze-Plan-Execute sobre Knowledge base (IBM autonomic computing). ▶ "PAIMA es literalmente este ciclo: Prometheus monitoriza, el planner con LLM analiza y planifica, el executor actúa, y la knowledge base son las alertas persistidas."
13. **Stack** — Java 17 + Spring Boot 3, MySQL 8 por servicio, Flyway, Kafka, Docker Compose, Prometheus/Loki/Grafana, k6, Cypress. ▶ "Todo open source y reproducible con `docker compose up`."

### Solución (14–24)
15. **Arquitectura general** — Diagrama: UAA (auth), Site (dominio académico), Notify (correos vía Kafka), PAIMA (supervisión), FE Vue, Config Server. ▶ "Cada servicio con su BD; Notify es asíncrono por Kafka."
16. **Dominios acotados** — Site = el dominio grande (sites, secciones, horarios, evaluaciones, participantes); UAA = identidad; Notify = notificaciones. ▶ "Corté por límites de negocio, no por capas técnicas."
17. **Database per service** — 3 MySQL independientes + Flyway versionado. ▶ "Ningún servicio lee la BD de otro; la integración es por API/eventos."
18. **Calidad sistemática** — Pipeline GH Actions: checkstyle → tests integración (Testcontainers+MySQL real) → JaCoCo gate 70/60 → branch protection con check requerido. ▶ "La calidad dejó de ser voluntad: el build ROMPE si baja la cobertura. Encontramos 11 bugs reales al exigirla."
19. **Flyway** — Migraciones versionadas por servicio; el esquema vive en el repo. ▶ "Adiós 'pregunta qué columnas tiene la tabla en prod'."
20. **FE adaptado** — No se reescribió: múltiples instancias Axios (una por servicio), guards de router por rol, Vuex por dominio, cookie `exchange_session`. ▶ "Migrar el backend sin obligar a rehacer el frontend fue una decisión de alcance."
21. **OAuth2/JWT E2E** — Spring Authorization Server; login por cédula, bcrypt, refresh tokens; clientes engine (client_credentials) y client. ▶ "El FE obtiene token anónimo antes del login y lo intercambia por uno de usuario."
22. **PAIMA** — El aporte central: servicio Spring Boot que corre el ciclo MAPE-K sobre Prometheus/Loki, planifica con LLM (Kimi k2.6) y notifica por correo. ▶ "No reemplaza al administrador: le prepara el diagnóstico."
23. **Operación 'en frío'** — Todo documentado: config centralizada (Config Server + repo git), CLI de operación, runbooks. ▶ "Que el próximo estudiante no dependa de preguntarme."
24. **IA propone, humano decide** — *Lámina ética clave*. ▶ "La acción destructiva (reiniciar un servicio) solo se ejecuta tras aprobación humana con actor y comentario auditados, y solo sobre una whitelist de servicios."

### Validación y resultados (25–33) — *la parte más preguntada, domina los números*
26. **Estrategia 4D** — Integración (JUnit), E2E (Cypress), rendimiento (k6), resiliencia (caos). 
27. **Cobertura** — Los 4 números de la hoja. ▶ "Todos sobre el gate 70/60, medidos contra MySQL real en CI. Site quedó en 80,5% justo sobre el 61,3% de ramas — el gate pasó a ser exigible, no aspiracional."
28. **Cypress** — 52 casos reales contra el stack sembrado: auth, guards, sites, PAIMA, admin. 1m16s, 18/20 corridas verdes. ▶ "La suite descubrió un bug real: evaluaciones sembradas con un tipo inexistente que daba 500."
29. **Benchmark k6** — LA TABLA. ▶ "Lectura honesta: ganamos 1,9× en lectura, empatamos en escritura con más robustez (el legacy devuelve 500 ante duplicados; el MS responde 200 idempotente), y en auth el legacy es más rápido porque compara MD5 — nosotros pagamos ~5× de CPU por bcrypt, y ese costo queda aislado en UAA, escalable por sí solo."
30. **Caos** — Experimento: `docker stop ms-site` → PAIMA detecta en 1 ciclo (~2 min), correo P1 en MailHog, diagnóstico Kimi, aprobación → `docker restart` → recuperación ~20 s. ▶ "Peor caso medido 4m59s por el scheduler de 5 min — y eso es configurable sin tocar código."
31. **La evidencia** — Capturas reales: alertas AUTO_EXECUTED, correo, chat. ▶ "No son maquetas: el chat muestra a Kimi diagnosticando un 401 real del actuator… y recomendando textualmente el fix que luego aplicamos."
32. **Comparativo global** — Tabla monolito vs MS en 6 dimensiones.
33. **Lo demostrado** — ▶ "Cada objetivo específico tiene su evidencia medible: migración (stack corriendo con datos reales), sistematización (CI verde con gates), autogestión (ciclo completo ejecutado 3 veces)."

### Cierre (34–39)
35. **Tres transformaciones** — Cierra el arco de la lámina 9.
36. **Limitaciones** — *Muéstrate honesto aquí, suma puntos*: detección acotada por el scheduler (5 min), probes sin autenticar para algunos actuators (hubo falsos DOWN), LLM externo (latencia/costo; Ollama soportado), benchmark local (no producción), k6 sin límites de recursos.
37. **Trabajo futuro** — Probes autenticados + etiqueta `application` en métricas, scheduler 30-60s, Kubernetes, sagas/outbox, aprendizaje sobre el historial de alertas, dashboards provisionados como código.
39. **Gracias** — Quedar para preguntas.

---

## ❓ PREGUNTAS PROBABLES + RESPUESTA CORTA

**¿Por qué microservicios y no modularizar el monolito?**
"Válido para sistemas mantenidos; aquí el monolito era intocable — 18 dominios en un controlador de 3.629 líneas sin tests. La fricción de cambio era total. La migración crea límites físicos donde antes había disciplina imposible."

**¿La IA puede reiniciar servicios sola? ¿No es peligroso?**
"No. Diseño human-in-the-loop: la IA solo PROPONE. La ejecución requiere aprobación con actor y comentario (auditado en la alerta), y el executor tiene whitelist {uaa, site, notify} — no puede tocar BD ni Prometheus."

**¿Qué pasa si PAIMA cae?**
"Nada operativo: PAIMA supervisa, no está en el camino crítico de las peticiones. Los MS siguen sirviendo; solo se pierde la autogestión hasta reiniciarlo."

**¿Por qué la autenticación es 4,5× más lenta en los MS?**
"Deliberado: el legacy compara MD5 (inseguro desde 2008); UAA usa bcrypt con costo de trabajo + firma JWT. Cuantificamos el precio de la seguridad: ~5× CPU por login, aislado en un servicio que escala independiente."

**¿Cobertura no es una métrica vanidosa?**
"Sola, sí. Por eso: (1) los tests son de integración REALES (Testcontainers+MySQL, no H2 ni mocks), (2) el gate rompe el build en CI con branch protection, (3) escribir los tests descubrió 11 bugs reales — la cobertura fue el vehículo, no la meta."

**¿Database-per-service y las transacciones entre servicios?**
"Hoy los dominios son independientes por diseño (notify es asíncrono vía Kafka). Transacciones cross-service quedan como trabajo futuro: patrón outbox/saga."

**¿Por qué un LLM externo (Kimi) y no uno local?**
"PAIMA tiene arquitectura de proveedores intercambiables: soporta Ollama local y OpenAI-compatible. Kimi por cuota gratuita y ventana de contexto grande; el geo-bloqueo de Moonshot lo resolvimos con un relay TLS nginx dentro del stack. Con Ollama funcionaría 100% offline con menos calidad de razonamiento."

**¿Los datos de prueba son reales? ¿Y la privacidad?**
"Son el dump real de producción de julio 2024 migrado por ETL: estructura y distribución reales (hasta 213 estudiantes por site). El dump ya venía anonimizado (tabla de usuarios vacía); las personas se asignan desde un pool ya anonimizado. Cero PII en el seed."

**¿Qué es 'Web 3.0' en tu marco teórico?**
"Tres tendencias que el trabajo materializa: distribución arquitectónica (MS), observabilidad instrumentada (Prometheus/Loki/Grafana) y análisis asistido por IA (PAIMA). El capítulo 4 demuestra cada una con evidencia."

**¿Por qué Docker Compose y no Kubernetes?**
"Alcance y reproducibilidad: un `docker compose up` levanta los 17 contenedores en cualquier máquina. K8s queda como línea de evolución; el modelo MAPE-K es agnóstico al orquestador."

**¿Qué pasó con los falsos positivos de monitoreo?**
"Real y documentado: los probes sin autenticar marcaban DOWN servicios vivos (401 en actuator) y PAIMA generó alertas P1 espurias — que el operador rechazó con comentario, demostrando también el flujo de rechazo. El fix (actuator permitAll alineado con UAA/Notify) quedó aplicado y commiteado."

**¿Cuánto tiempo tarda PAIMA en responder el chat?**
"Entre 30 y 100 segundos: Kimi k2.6 es un modelo razonador — consume tokens de razonamiento antes de responder. El timeout del cliente se ajustó a 180 s tras medirlo."

---

## ⏱️ SI VAS CORTO DE TIEMPO (ruta de 25 min)
Comprime así: 5-7 → 90s total · marco (11-13) → 2 min total · solución: prioriza 15, 18, 22, 24 · validación (26-33) es INELUDIBLE, no la cortes — es donde el jurado ve rigor · cierre 35-37 → 90s.

## 🚫 NO DIGAS
- "Novel/inteligencia artificial generativa va a reemplazar al administrador" → di: **asistencia con aprobación humana**
- "100% de cobertura / cero errores" → di: **gates 70/60, 18/20 corridas, números con contexto**
- "Kubernetes" como si existiera → es **trabajo futuro**
- "Los tests son unitarios" → son **de integración con MySQL real**
