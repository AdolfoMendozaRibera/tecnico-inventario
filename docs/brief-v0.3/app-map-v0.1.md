---
artefacto: App map v0.1
proyecto: Gestión de objetos reservados en inventario de taller técnico
materia: IHC
persona: Carlos (técnico)
alcance: Navegación para consultar disponibilidad/reserva de repuestos y gestionar reservas propias
---

# App map v0.1 — Repuestos y reservas

## Estructura general

```
Inicio
 ├─ Resumen
 └─ Disponibles vs reservados

Repuestos
 ├─ Disponibles
 └─ Reservados: equipo destino → Liberar / marcar usado

Reserva
 ├─ Reservar repuesto → Confirmar destino
 └─ Mis reservas
```


## Detalle por sección

**Inicio**
¿Qué encuentra Carlos al entrar? → Un resumen rápido de la actividad y un conteo simple de cuántos repuestos están disponibles y cuántos reservados en ese momento. No muestra stock detallado, precios ni reposición — eso está fuera de alcance.

**Repuestos**
¿Qué puede hacer acá? → Consultar el inventario compartido en dos vistas: los repuestos disponibles para usar, y los reservados, cada uno con el equipo o cliente al que está destinado. Desde un repuesto reservado, Carlos también puede liberarlo o marcarlo como usado una vez que ya cumplió su función, para que no quede "reservado" indefinidamente.

**Reserva**
¿Qué puede hacer acá? → Reservar un repuesto para un equipo específico, confirmando de inmediato a qué equipo queda destinado, y revisar sus propias reservas activas sin depender de preguntarle a otro técnico o dejar notas físicas.

---

## Resultado esperado
Carlos puede moverse por la app y, en pocos toques, saber qué hay disponible, qué está reservado y para quién, reservar lo que necesita, y liberar lo que ya usó — todo dentro de la misma sección de Repuestos y Reserva, sin secciones adicionales que no aporten a este objetivo.

## Pregunta pendiente
¿"Mis reservas" debería mostrar solo las reservas hechas por Carlos, o todas las reservas activas del taller (visibles para todos los técnicos, como pide el alcance del brief)? Lo definiremos al bajar esta sección a wireframes.

---

## Nota para el equipo
Este App map cubre únicamente la navegación relacionada con **disponibilidad, consulta y reserva de repuestos** (brief punto 06). No incluye precios, reposición, vencimientos, proveedores, ganancias, gestión completa de reparaciones ni clasificación general del inventario (punto 07 — fuera de alcance). El flujo de tarea "Consultar estado de un repuesto" (Flujo v0.1) es un artefacto aparte que detalla el camino paso a paso dentro de la sección Repuestos.
