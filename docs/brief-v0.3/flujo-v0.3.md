---
artefacto: Flujo v0.3
proyecto: Gestión de objetos reservados en inventario de taller técnico
materia: IHC
persona: Carlos (técnico)
tarea: Gestionar una reserva activa (consumir o liberar el repuesto)
complementa: Flujo v0.2 (reservar)
---

# Flujo v0.3 — Gestión de Reservas Activas (Consumir o Liberar)

## Camino principal

```
Abrir Mis Reservas → Seleccionar reserva activa → Elegir acción (Consumir o Liberar) → Confirmar acción
```

## Detalle por paso

**Inicio**
¿Qué hace que Carlos entre a este flujo? → Ya tiene un repuesto reservado a su nombre y acaba de instalarlo en el equipo destino (necesita darlo de baja), o se da cuenta de que ya no lo va a necesitar (necesita devolverlo).

**Acción**
¿Qué debe hacer en cada paso?
1. Navegar a la pantalla **"Mis Reservas"**.
2. Ubicar en la lista el repuesto que desea gestionar.
3. El sistema le debe presentar dos opciones claras y diferenciadas para ese repuesto:
   - **Opción A: Marcar como Usado (Consumir):** Para cuando el repuesto ya fue instalado en el equipo del cliente.
   - **Opción B: Liberar (Cancelar reserva):** Para devolverlo al inventario general para que otro técnico lo use.
4. Tocar la opción correspondiente a su necesidad.
5. Confirmar la acción en un diálogo de advertencia (ej. *"¿Estás seguro de que deseas marcar este repuesto como usado? Esta acción no se puede deshacer"*).
6. Ver el mensaje emergente de éxito confirmando el nuevo estado.

**Resultado**
¿Cómo sabe que terminó? → El repuesto desaparece de su lista personal de "Mis Reservas". 
- Si lo **consumió**, el sistema lo marca como "usado" (o lo da de baja). 
- Si lo **liberó**, su estado vuelve a ser "disponible" para todo el equipo.

---

## Resultado esperado
Carlos puede cerrar el ciclo de su reserva de manera precisa. El inventario se mantiene fiel a la realidad, evitando que repuestos queden en estado "reservado" de forma permanente o que se mezclen las acciones de liberar y usar.

## Relación con el Flujo v0.2
Es la continuación lógica y final del Flujo v0.2 (Reservar). Mientras que el v0.2 "aparta" el repuesto temporalmente, este Flujo v0.3 cierra la operación decidiendo el destino final de la pieza.

## Pregunta pendiente
¿Deberíamos mantener un historial de los repuestos consumidos/usados (ej. cambiar el estado a "consumido") o simplemente eliminarlos por completo de la base de datos? (Se sugiere cambiar a estado "consumido" para que el administrador tenga un historial de qué repuestos se gastaron).
