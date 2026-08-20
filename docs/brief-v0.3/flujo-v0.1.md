---
artefacto: Flujo v0.1
proyecto: Gestión de objetos reservados en inventario de taller técnico
materia: IHC
persona: Carlos (técnico)
tarea: Confirmar si un repuesto está disponible o reservado antes de usarlo
---

# Flujo v0.1 — Consultar estado de un repuesto

## Camino principal

```
Abrir la aplicación → Buscar el repuesto → Ver estado → Ver equipo destino (si está reservado)
```

## Detalle por paso

**Inicio**
¿Qué hace que Carlos entre a este flujo? → Está por tomar, usar o vender un repuesto y necesita confirmar antes si puede hacerlo.

**Acción**
¿Qué debe hacer en cada paso?
1. Abrir la aplicación.
2. Buscar el repuesto (por nombre, categoría, o el que está frente a él).
3. Ver su estado: disponible o reservado.
4. Si está reservado, ver para qué equipo o cliente está destinado.

**Resultado**
¿Cómo sabe que terminó? → Carlos sabe con certeza si puede usar ese repuesto o no, sin necesidad de preguntarle a nadie ni revisar notas físicas.

---

## Resultado esperado
Carlos consulta un repuesto y en segundos sabe si está disponible o reservado, evitando errores como los ya documentados (repuesto usado en el equipo equivocado).

## Pregunta pendiente
¿Qué pasa si Carlos no encuentra el repuesto en la búsqueda (no está registrado todavía)? Lo definiremos en una siguiente iteración.

---

## Nota para el equipo
Este es el flujo de **consulta**. El flujo de **reservar un repuesto** (que ya está esbozado en el App map: Reservar repuesto → Confirmar destino → Mis reservas) es una segunda tarea relacionada, pendiente de dibujar como Flujo v0.2 si el tiempo lo permite — no es parte de esta primera entrega para no mezclar dos tareas en un mismo diagrama.
