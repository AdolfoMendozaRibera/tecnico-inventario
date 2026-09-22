---
artefacto: Flujo v0.5
proyecto: Gestión de objetos reservados en inventario de taller técnico
materia: IHC
persona: Carlos (técnico) / Administrador
tarea: Consultar el historial de movimientos de repuestos instalados y dados de baja
complementa: Flujo v0.1 (consultar estado), Flujo v0.2 (reservar), Flujo v0.3 (usar / dar de baja)
---

# Flujo v0.5 — Historial y Trazabilidad de Movimientos

## Camino principal

```
Abrir sección "Historial" → Ver resumen de KPIs (instalados / bajas) → Aplicar filtros opcionales (tipo, período, técnico) → Buscar por texto → Consultar detalle de un movimiento
```

## Detalle por paso

**Inicio**
¿Qué hace que Carlos (o el admin) entre a este flujo? → Necesita confirmar qué repuestos se usaron, en qué equipo quedaron instalados, o cuáles fueron descartados por daño o merma. También puede necesitar responder a un cliente o supervisor sobre el destino de una pieza específica.

**Acción**
¿Qué debe hacer en cada paso?

1. **Abrir la pantalla de Historial** desde la barra de navegación inferior (ícono "Historial y Trazabilidad").
2. **Ver el resumen de KPIs** en la cabecera:
   - Contador de piezas **Instaladas** (chip verde).
   - Contador de piezas con **Baja / Merma** (chip rojo).
   - Ambos contadores se actualizan reactivamente según los filtros activos.
3. **Filtrar por Tipo** (opcional) mediante chips de segmento:
   - **Todos** — muestra instalados y bajas juntos.
   - **Instalados** — solo repuestos con estado `usado` (instalados en un equipo).
   - **Bajas** — solo repuestos con estado `baja` (descartados por daño o merma).
4. **Filtrar por Período** (opcional) mediante chips horizontales deslizables:
   - *Todo*, *Hoy*, *Esta semana*, *Este mes*.
5. **Filtrar por Técnico** (solo vista Admin, opcional):
   - Si el usuario es administrador y hay técnicos disponibles, aparece una fila de chips con los nombres de técnicos para filtrar por responsable.
6. **Buscar por texto** (opcional):
   - Campo de búsqueda con debounce (220 ms) que filtra en tiempo real por nombre de pieza, equipo destino, motivo de baja o nombre de técnico.
   - Botón de limpieza instantánea (×) visible cuando hay texto ingresado.
7. **Pull-to-refresh**: Deslizar hacia abajo recarga el historial desde Supabase.
8. **Ver la lista de movimientos**: Cada tarjeta muestra el nombre del repuesto, categoría, estado (instalado / baja), equipo destino o motivo, técnico responsable y fecha/hora del movimiento.
9. **Consultar el detalle** (opcional): Tocar una tarjeta abre un bottom sheet con la información completa del movimiento.

**Resultado**
¿Cómo sabe que terminó? → Carlos (o el admin) localiza el movimiento buscado, confirma el equipo o motivo asociado y puede reportar con certeza qué pasó con esa pieza. No necesita buscar en notas físicas ni preguntar a compañeros.

---

## Estados de borde implementados

| Estado | Comportamiento |
|---|---|
| **Loading** | Se muestran 4 skeleton cards con shimmer mientras se carga desde Supabase |
| **Error** | Ícono de nube desconectada + mensaje humano + botón "Reintentar" |
| **Vacío (sin filtros)** | Mensaje indicando que aún no hay movimientos registrados |
| **Vacío (con filtros activos)** | Mensaje específico indicando que no hay resultados con los filtros aplicados + botón "Limpiar filtros" |
| **Lista poblada** | `ListView.builder` con paginación de items, permite scroll fluido |

---

## Resultado esperado
Carlos o el administrador pueden rastrear en segundos cualquier repuesto consumido: saben quién lo usó, en qué equipo quedó instalado o por qué fue descartado. El filtrado combinado (tipo + período + técnico + búsqueda libre) permite acotar rápidamente un movimiento específico sin tener que revisar todo el historial manualmente.

## Relación con los otros flujos
- **Cierra el ciclo del Flujo v0.3:** El historial es la evidencia permanente de los movimientos de "Usar" y "Dar de baja" ejecutados en ese flujo.
- **Complementa el Flujo v0.1:** Si Carlos busca un repuesto y ya no lo encuentra como disponible o reservado, el historial le explica qué ocurrió (fue instalado o dado de baja).
- **Vista diferenciada por rol:** El técnico solo ve sus propios movimientos; el administrador ve el historial global de todos los técnicos y puede filtrar por responsable.

## Nota de implementación
El filtrado se realiza íntegramente **en memoria** sobre la lista cargada desde Supabase (`movimientosFiltrados` en `HistorialProvider`), sin llamadas adicionales a la red al cambiar filtros, lo que garantiza respuesta inmediata al usuario. La recarga completa desde la base de datos solo ocurre en el inicio de pantalla o al hacer pull-to-refresh.
