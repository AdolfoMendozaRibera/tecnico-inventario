---
artefacto: Flujo v0.2
proyecto: Gestión de objetos reservados en inventario de taller técnico
materia: IHC
persona: Carlos (técnico)
tarea: Reservar un repuesto disponible para un equipo en reparación
complementa: Flujo v0.1 (consultar estado)
---

# Flujo v0.2 — Reservar un repuesto

## Camino principal

```
Buscar el repuesto → Ver que está disponible → Reservar → Ingresar equipo destino → Confirmar reserva
```

## Detalle por paso

**Inicio**
¿Qué hace que Carlos entre a este flujo? → Ya sabe (o acaba de confirmar con el Flujo v0.1) que el repuesto está disponible, y necesita asegurarlo para el equipo que está reparando en ese momento antes de que otro compañero lo tome.

**Acción**
¿Qué debe hacer en cada paso?
1. Desde el detalle del repuesto, tocar el botón **"Reservar"** (visible únicamente si el repuesto está disponible).
2. Ver confirmado el nombre del repuesto que va a reservar.
3. Ingresar el **equipo destino** (campo obligatorio): el nombre o descripción del equipo al que se destinará el repuesto (ej. "Laptop Asus cliente Juan").
4. Ingresar el **motivo** (campo opcional): cualquier aclaración adicional (ej. "pantalla rota").
5. Tocar **"Confirmar Reserva"**.
6. Ver el mensaje de confirmación: *"Reserva confirmada"*.

**Resultado**
¿Cómo sabe que terminó? → El repuesto cambia su estado a "Reservado" y ahora aparece con el equipo destino visible para cualquier otro técnico que lo consulte. Carlos ve la confirmación inmediata en pantalla.

---

## Resultado esperado
Carlos reserva un repuesto en segundos sin depender de que un compañero esté disponible para avisarle. El sistema garantiza que no haya dos reservas simultáneas sobre el mismo repuesto — si alguien más lo reserva primero, la operación falla de forma controlada y Carlos lo ve al instante.

## Relación con el Flujo v0.1
El Flujo v0.1 (consultar estado) y este flujo (reservar) son complementarios: Carlos puede consultar primero y luego reservar desde la misma pantalla de detalle del repuesto. No son tareas excluyentes — se ejecutan en secuencia natural dentro del mismo recorrido.

## Pregunta pendiente
¿Qué pasa si otro técnico reserva el mismo repuesto en el instante exacto en que Carlos también confirma? El sistema ya previene esto con una operación atómica del lado del servidor (RPC en Supabase). Pendiente: definir el mensaje de error exacto que ve Carlos en ese caso.

---

## Nota para el equipo
Este flujo describe únicamente el acto de **crear una reserva**. La gestión de reservas ya activas (ver mis reservas, liberar o marcar como usado un repuesto) es una tercera tarea relacionada, pendiente de documentar como **Flujo v0.3** si el tiempo lo permite.
