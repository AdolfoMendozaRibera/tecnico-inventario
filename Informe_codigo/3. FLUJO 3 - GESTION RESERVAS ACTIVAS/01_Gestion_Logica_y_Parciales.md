---
title: "01. Lógica de Liberación y Consumo Parcial en RepuestosProvider"
date: 2026-09-18
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - provider
  - stock-parcial
  - supabase
  - mutaciones
---

# 01. Lógica de Liberación y Consumo Parcial en `RepuestosProvider`

> **Archivo Analizado:** [`proyecto/lib/features/repuestos/providers/repuestos_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/providers/repuestos_provider.dart)  
> **Líneas Clave:** `120` a `215` (`marcarComoUsado` y `liberarRepuesto`)

---

## 1. 🎯 Propósito General

En el trabajo diario de taller, los técnicos suelen reservar lotes de repuestos (ej: 5 botones o 4 conectores). Al momento de reparar el equipo, puede darse el caso de que solo utilicen una parte y necesiten liberar el resto para otros compañeros, o que consuman la reserva por partes.

`RepuestosProvider` soporta **operaciones parciales por cantidad**:
- Si la cantidad a liberar/usar es igual al total reservado, la reserva se liquida o se devuelve completa a disponible.
- Si la cantidad es menor al total reservado, se descuenta esa porción y el sobrante se mantiene bajo la reserva del técnico o vuelve al catálogo según corresponda.

---

## 2. ⚙️ Funciones y Métodos Clave

### A. `marcarComoUsado(String repuestoId, int cantidadAUsar)`
* **Firma:** `Future<bool> marcarComoUsado(String repuestoId, int cantidadAUsar)`

```dart
Future<bool> marcarComoUsado(String repuestoId, int cantidadAUsar) async {
  try {
    // 1. Obtener la reserva actual para conocer la cantidad reservada
    final repuesto = _misReservas.firstWhere((r) => r.id == repuestoId, orElse: () => _reservados.firstWhere((r) => r.id == repuestoId));
    final int cantidadActual = repuesto.cantidad;

    if (cantidadAUsar >= cantidadActual) {
      // Consumo Total: cambiar estado a 'usado' o eliminar la reserva
      await _supabase.from('repuesto').update({
        'estado': 'usado',
      }).eq('id', repuestoId);
    } else {
      // Consumo Parcial: restar la cantidad consumida
      final int nuevaCantidad = cantidadActual - cantidadAUsar;
      await _supabase.from('repuesto').update({
        'cantidad': nuevaCantidad,
      }).eq('id', repuestoId);
    }

    await fetchRepuestos();
    return true;
  } catch (e) {
    _lastError = 'Error al marcar como usado: $e';
    return false;
  }
}
```

### B. `liberarRepuesto(String repuestoId, int cantidadALiberar)`
* **Firma:** `Future<bool> liberarRepuesto(String repuestoId, int cantidadALiberar)`

```dart
Future<bool> liberarRepuesto(String repuestoId, int cantidadALiberar) async {
  try {
    final repuesto = _misReservas.firstWhere((r) => r.id == repuestoId, orElse: () => _reservados.firstWhere((r) => r.id == repuestoId));
    final int cantidadActual = repuesto.cantidad;

    if (cantidadALiberar >= cantidadActual) {
      // Liberación Total: Limpiar datos de reserva y devolver a disponible
      await _supabase.from('repuesto').update({
        'estado': 'disponible',
        'equipo_destino': null,
        'motivo': null,
        'reservado_por': null,
        'fecha_reserva': null,
      }).eq('id', repuestoId);
    } else {
      // Liberación Parcial: Restar de la reserva actual
      await _supabase.from('repuesto').update({
        'cantidad': cantidadActual - cantidadALiberar,
      }).eq('id', repuestoId);
      
      // (Opcional) Retornar sobrante a la pila de disponibles de la misma categoría/tienda
    }

    await fetchRepuestos();
    return true;
  } catch (e) {
    _lastError = 'Error al liberar el repuesto: $e';
    return false;
  }
}
```

---

## 3. 🎓 Preguntas de Examen (Defensa de Código)

### Pregunta 1: *"¿Qué sucede en la base de datos cuando un técnico decide liberar 2 de las 5 unidades que tenía reservadas?"*
> **Respuesta recomendada:**  
> *"El método `liberarRepuesto` compara la cantidad solicitada (2) contra la cantidad total reservada (5). Al detectar que es una liberación parcial, ejecuta un `UPDATE` en Supabase reduciendo el campo `cantidad` a 3 (`5 - 2 = 3`), manteniendo el estado en 'reservado' y la asignación al técnico. Luego refresca el provider con `fetchRepuestos()`."*

### Pregunta 2: *"¿Cómo se garantiza que un técnico no intente liberar o usar más unidades de las que realmente reservó?"*
> **Respuesta recomendada:**  
> *"La restricción está asegurada tanto en UI como en la lógica del provider. En la interfaz (`MarcarUsadoSheet` y `LiberarRepuestoSheet`), los botones del Stepper limitan el rango entre 1 y `repuesto.cantidad`. A nivel de provider, se lee la cantidad real guardada antes de actualizar."*

---

## 4. 📱 Demostración en Código

1. **Ubicación en el código:** Abrir [`repuestos_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/providers/repuestos_provider.dart) y mostrar las bifurcaciones `if (cantidad >= cantidadActual)`.
2. **Ubicación en la App:** En la pestaña **Mis Reservas**, presionar sobre una tarjeta reservada con 2 o más unidades y abrir el sheet **Marcar como Usado**.
