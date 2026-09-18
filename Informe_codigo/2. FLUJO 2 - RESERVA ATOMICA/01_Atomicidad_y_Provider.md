---
title: "01. Atomicidad y Lógica de Reserva en RepuestosProvider"
date: 2026-09-18
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - provider
  - atomicidad
  - supabase
  - race-condition
---

# 01. Atomicidad y Lógica de Reserva en `RepuestosProvider`

> **Archivo Analizado:** [`proyecto/lib/features/repuestos/providers/repuestos_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/providers/repuestos_provider.dart)  
> **Líneas Clave:** `51` a `84` (Método `reservarRepuesto`)

---

## 1. 🎯 Propósito General

En un taller con múltiples técnicos trabajando en simultáneo, dos personas pueden intentar apartar el mismo repuesto disponible exactamente al mismo tiempo (ej: una pantalla o una batería única). 

Si la aplicación hiciera primero una lectura (`SELECT`) y luego una escritura (`UPDATE`), existiría una **Condición de Carrera (Race Condition / Double Booking)** donde ambos técnicos creerían haber apartado la pieza.

El método `reservarRepuesto` resuelve este problema aplicando **Atomicidad en Base de Datos**: la verificación de disponibilidad y la asignación se ejecutan en una sola sentencia SQL indivisible.

---

## 2. ⚙️ Funciones y Métodos Clave

### `reservarRepuesto(String repuestoId, String equipo, String motivo)`
* **Ubicación:** `lib/features/repuestos/providers/repuestos_provider.dart` (Líneas 51–84).
* **Firma:** `Future<bool> reservarRepuesto(String repuestoId, String equipo, String motivo)`

```dart
Future<bool> reservarRepuesto(String repuestoId, String equipo, String motivo) async {
  _lastError = null;
  final userId = _supabase.auth.currentUser?.id;
  if (userId == null) {
    _lastError = 'No hay sesión de usuario activa.';
    return false;
  }

  try {
    // RNF-06: Mutación atómica con filtro estricto de estado 'disponible'
    // Si otro técnico lo reservó simultáneamente, no actualizará ninguna fila.
    final response = await _supabase.from('repuesto').update({
      'estado': 'reservado',
      'equipo_destino': equipo,
      'motivo': motivo,
      'reservado_por': userId,
      'fecha_reserva': DateTime.now().toIso8601String(),
    }).eq('id', repuestoId).eq('estado', 'disponible').select('id');

    final updatedList = response as List;
    if (updatedList.isEmpty) {
      _lastError = 'Este repuesto ya fue reservado por otro técnico en el taller.';
      await fetchRepuestos(); // Refresca para actualizar la UI del técnico perdedor
      return false;
    }

    await fetchRepuestos(); // Refresca listas locales para reflejar el cambio
    return true;
  } catch (e) {
    _lastError = 'No se pudo completar la reserva. Revisa tu conexión e inténtalo de nuevo.';
    debugPrint('Error reserving: $e');
    return false;
  }
}
```

### 🔍 ¿Qué hace el código internamente?
1. **Identificación de Sesión (`auth.currentUser`):** Obtiene el UUID del técnico autenticado para asociarlo al campo `reservado_por`.
2. **Mutación Condicional Atómica:**
   - Envía el `UPDATE` a la tabla `repuesto`.
   - **Clave de Atomicidad:** Aplica `.eq('id', repuestoId).eq('estado', 'disponible')`. En Postgres, esto se traduce a `UPDATE repuesto SET ... WHERE id = $1 AND estado = 'disponible'`.
   - Si el estado ya no era `'disponible'` (porque otra transacción lo modificó una fracción de segundo antes), el motor de base de datos no modifica ninguna fila y devuelve una lista vacía (`updatedList.isEmpty`).
3. **Manejo del Conflicto de Concurrencia:** Si `updatedList.isEmpty`, detecta que otro técnico ganó la pieza, asigna un mensaje de error explicativo y dispara `fetchRepuestos()` para que la pantalla del usuario se actualice al estado real del taller.
4. **Sincronización Inmediata:** Si tuvo éxito, llama a `fetchRepuestos()` para mover la pieza de la lista `_disponibles` a `_reservados` y `_misReservas`.

---

## 3. 🎓 Preguntas de Examen (Defensa de Código)

### Pregunta 1: *"¿Por qué este flujo debe ser estrictamente Online-Only y no Offline-First con sincronización en cola?"*
> **Respuesta recomendada:**  
> *"Porque la reserva de un activo físico limitado no tolera la eventual consistencia offline. Si dos técnicos sin internet en el taller reservaran la misma pieza física en sus teléfonos de forma offline, al sincronizarse ambos creerían que la pieza les pertenece, generando un conflicto físico en el taller. Por regla de negocio (RNF-06 y Roadmap Flujo 2), la reserva requiere validación centralizada en tiempo real con el servidor."*

### Pregunta 2: *"¿Dónde está la garantía en el código de que no ocurre una condición de carrera (Race Condition)?"*
> **Respuesta recomendada:**  
> *"Ocurre en la línea 68 de `repuestos_provider.dart`. No hacemos un `SELECT` previo para ver si está libre y luego un `UPDATE`. Hacemos la mutación directa condicionada por `.eq('estado', 'disponible')`. A nivel de motor relacional en PostgreSQL/Supabase, la fila se bloquea durante la sentencia; el primer `UPDATE` en ejecutarse cambia el estado a 'reservado', y cualquier `UPDATE` concurrente inmediato evaluará la condición como falsa, retornando cero filas afectadas."*

### Pregunta 3: *"¿Qué sucede en la interfaz de usuario si la consulta atómica detecta que el repuesto ya fue ganado por otro técnico?"*
> **Respuesta recomendada:**  
> *"El provider captura la lista vacía (`updatedList.isEmpty`), setea `_lastError = 'Este repuesto ya fue reservado por otro técnico en el taller.'`, refresca el catálogo con `fetchRepuestos()` y retorna `false`. La pantalla `ReservarScreen` lee ese error y despliega el banner rojo de error reactivo sin bloquear la aplicación."*

---

## 4. 📱 Cómo demostrarlo en vivo en la pantalla

1. **Ubicación en el código:** Abrir [`repuestos_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/providers/repuestos_provider.dart) en la línea 51 y señalar el encadenamiento `.eq('id', repuestoId).eq('estado', 'disponible')`.
2. **Ubicación en la app:** Al intentar reservar un repuesto sin conexión o que haya sido reservado previamente, mostrar el banner de alerta reactivo en [`ReservarScreen`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/screens/reservar_screen.dart).
