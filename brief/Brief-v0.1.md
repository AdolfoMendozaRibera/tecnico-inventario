---

## proyecto: Gestión de objetos reservados en inventario de taller técnico version: 0.1 materia: IHC integrante_1: integrante_2:

# Brief v0.1 — Objetos reservados/de terceros en inventario de taller técnico

---

## 01. Problema

**¿Qué dificultad queremos comprender?**

En tiendas de reparación de electrónica donde más de una persona maneja el mismo inventario (técnico principal y ayudante, o varios técnicos), un producto o repuesto puede estar físicamente disponible pero ya tener un destino asignado: reservado para un equipo específico en reparación, o perteneciente a un tercero. Cuando esa reserva no queda comunicada de forma clara y visible para todos, existe riesgo real de que otra persona lo use, lo venda o lo mueva sin saberlo.

**Evidencia:**

- Un técnico reservó una pantalla de laptop de gama alta para un equipo específico, pero no dejó constancia visible. Su ayudante la instaló en otro equipo por error. La solución tuvo que resolverse avisando por mensaje y reforzando con notas escritas — con la consiguiente pérdida de tiempo.
- En otro caso, un ayudante debía usar un spray especial para una laptop concreta, pero al no haber claridad sobre qué producto correspondía a qué equipo, utilizó uno distinto y dañó el monitor. La reparación del daño resultó costosa.
- Ambos casos ocurrieron por confusión entre equipos similares o parecidos que se encuentran en reparación al mismo tiempo, sin un sistema de etiquetado o registro que distinga claramente qué está reservado, para qué, y para quién.

---

## 02. Usuario

**¿Para quién existe esta necesidad?**

Técnicos de reparación de electrónica que comparten el mismo inventario dentro de una tienda: tanto el técnico principal/jefe como su ayudante o empleado. Ambos roles manipulan el stock indistintamente durante el día — reservan repuestos para equipos en reparación, y también los buscan y utilizan. La necesidad no distingue jerarquía: cualquiera de los dos puede ser quien reserva o quien, por desconocimiento, usa algo que no debía.

**Rasgos de comportamiento relevantes:**

- Trabajan diariamente en la tienda, alternando entre recepción, reparación y entrega de equipos.
- Están acostumbrados a usar el celular para tareas del negocio, pero abandonan procesos que requieren demasiados pasos para una acción simple.
- Suelen tener varios equipos similares en reparación al mismo tiempo, lo que aumenta el riesgo de confusión.

**Fuera de alcance:** el cliente final de la tienda no es usuario de esta aplicación — es una herramienta interna, de uso exclusivo entre quienes trabajan en el mostrador/taller.

---

## 03. Tarea

**¿Qué intenta hacer esa persona?**

Antes de tomar, vender o utilizar un producto o repuesto del inventario, el técnico —sea el principal o su ayudante— necesita confirmar con certeza si ese ítem está disponible o si ya fue reservado para un equipo específico, evitando confundirlo con productos similares destinados a otros equipos en reparación simultánea.

---

## 04. Contexto

**¿Dónde, cuándo y con qué limitaciones?**

|Aspecto|Detalle|
|---|---|
|**Dónde**|Mostrador y banco de trabajo de la tienda, dentro de un espacio compartido con otras tiendas de técnicos (tipo galería comercial).|
|**Cuándo**|Durante la revisión y reparación de un equipo, momento en el que el técnico identifica qué piezas necesita y cuáles debe reservar o comprar.|
|**Quién puede estar presente**|El propio técnico y su ayudante trabajando en simultáneo; clientes que llegan en cualquier momento sin previo aviso; incluso técnicos de otras tiendas cercanas que ocasionalmente solicitan prestado algún componente (ej. un disco duro).|
|**Conectividad**|Estable — no representa una limitación técnica para el diseño de la solución.|
|**Presión de tiempo**|Alta en varios momentos: el técnico suele aceptar múltiples trabajos en paralelo, llegando a desvelarse para cumplir plazos, con poco margen para procesos administrativos lentos.|

---

## 05. Brief (síntesis)

**¿Cómo organizamos lo que sabemos?**

|Campo|Resumen|
|---|---|
|Problema|Objetos reservados o de terceros se mezclan con el inventario disponible sin un sistema claro y visible para señalar su estado, generando pérdidas de tiempo y dinero cuando se usan por error.|
|Usuario|Técnico principal y/o ayudante de una tienda de reparación electrónica que comparten el mismo inventario.|
|Tarea|Confirmar con certeza si un ítem está disponible o reservado, y para qué equipo, antes de usarlo o venderlo.|
|Contexto|Mostrador/banco de trabajo de la tienda, con presión de tiempo alta y múltiples equipos similares en reparación simultánea.|
|Idea inicial|Mecanismo de marcado de estado (disponible / reservado — con motivo y equipo asociado) visible en tiempo real para todos los que operan el inventario.|
|Alcance (MVP)|Marcar un ítem como reservado, indicando el equipo o motivo asociado, y que ese estado sea visible para cualquier técnico que consulte ese producto. Precios, reposición con proveedor y vencimientos quedan fuera de esta primera entrega.|

---

## 06. Hipótesis

**¿Qué creemos que debemos comprobar?**

> **H1:** Si los técnicos de una tienda pueden marcar un producto o repuesto como reservado —indicando para qué equipo— de forma visible para todos, se reduce la frecuencia de errores donde alguien usa o vende algo que ya tenía un destino asignado, evitando las pérdidas de tiempo y dinero observadas en los casos reportados.

Esta hipótesis se pondrá a prueba en la fase de construcción y testeo del proyecto, mediante observación directa y feedback del técnico entrevistado y su equipo.

---

## Backlog de problemas relacionados (fuera del alcance actual, para fases futuras)

1. Vencimiento de productos sin control.
2. Falta de stock no detectada a tiempo.
3. Cálculo de gasto vs. ganancia del inventario.
4. Reposición lenta con proveedor (proceso repetitivo producto por producto).
5. Falta de clasificación de tipos de producto / ubicación física.
6. Dependencia de cuaderno/hoja física como único respaldo.