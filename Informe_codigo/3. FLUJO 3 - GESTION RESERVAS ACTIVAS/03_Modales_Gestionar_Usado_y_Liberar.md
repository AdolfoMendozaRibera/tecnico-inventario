---
title: "03. Modales Contextuales y Retroalimentación Táctil"
date: 2026-09-18
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - bottom-sheet
  - ux-mobile
  - haptic-feedback
  - anti-double-submit
---

# 03. Modales Contextuales (`GestionarReservaSheet`, `MarcarUsadoSheet` y `LiberarRepuestoSheet`)

> **Archivos Analizados:**  
> - [`gestionar_reserva_sheet.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/widgets/gestionar_reserva_sheet.dart)  
> - [`marcar_usado_sheet.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/widgets/marcar_usado_sheet.dart)  
> - [`liberar_repuesto_sheet.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/widgets/liberar_repuesto_sheet.dart)

---

## 1. 🎯 Propósito General

Proporcionar una experiencia táctil fluida de 3 capas en la zona ergonómica del pulgar (**Thumb Zone**) para realizar mutaciones sobre las reservas activas sin perder de vista la pantalla principal.

---

## 2. ⚙️ Flujo de Modales y Métodos Clave

### A. Modal Principal: `GestionarReservaSheet`
Al pulsar sobre una tarjeta de reserva propia en `MisReservasScreen`, se despliega este modal presentando 3 botones de acción clara:
1. **Marcar como Usado:** (Botón principal oscuro con ícono verde).
2. **Liberar Repuesto al Taller:** (Botón secundario rojo claro `#FFF5F5` para destacar la acción de devolución).
3. **Editar Reserva:** (Botón secundario bordeado para corregir datos de destino).

### B. Modal de Ajuste de Cantidad: `MarcarUsadoSheet` y `LiberarRepuestoSheet`
Ambos modales incorporan un **Stepper de Selección de Cantidad (`_StepperButton`)** con cálculo dinámico en tiempo real:
- Muestra las unidades seleccionadas a descontar.
- Muestra el texto reactivo: `"Quedará N unidad(es) reservada(s)"` o `"Se consumirá la reserva completa"`.
- Protege contra envío múltiple deshabilitando el botón de confirmación y mostrando `CircularProgressIndicator`.

```dart
Future<void> _confirmar() async {
  setState(() => _cargando = true); // Anti-double submit
  final exito = await provider.marcarComoUsado(widget.repuesto.id, _cantidad);
  if (!mounted) return;
  Navigator.pop(context);
  if (exito) {
    HapticFeedback.lightImpact(); // Retroalimentación táctil inmediata
    widget.onConfirmar('Reserva completada: repuesto usado con éxito');
  }
}
```

---

## 3. 🎓 Preguntas de Examen (Defensa de Código)

### Pregunta 1: *"¿De qué manera se previene el envío doble (Anti-Double Submit) cuando el técnico pulsa el botón de Confirmar en el modal?"*
> **Respuesta recomendada:**  
> *"En la línea 42 de `marcar_usado_sheet.dart`, al presionar Confirmar lo primero que hace `_confirmar()` es hacer `setState(() => _cargando = true)`. El botón evalúa `onPressed: _cargando ? null : _confirmar`, deshabilitándose inmediatamente y reemplazando el texto por un spinner `CircularProgressIndicator` hasta que la respuesta de Supabase retorna."*

### Pregunta 2: *"¿Cómo se implementa el principio de accesibilidad y ergonomía táctil en estos modales?"*
> **Respuesta recomendada:**  
> *"Respetamos la Regla del Pulgar desplegando toda la interacción desde la parte inferior mediante `showModalBottomSheet` con bordes redondeados (24px). Además, todas las áreas táctiles (`_StepperButton` y `_ActionButton`) tienen un tamaño superior al estándar mínimo de 48x48dp y disparan `HapticFeedback.lightImpact()` para confirmación táctil en pantalla."*

---

## 4. 📱 Demostración en Código

1. **Ubicación en el código:** Abrir [`marcar_usado_sheet.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/widgets/marcar_usado_sheet.dart) en la línea 48 y señalar la llamada a `HapticFeedback.lightImpact()`.
2. **Ubicación en la App:** Abrir la pestaña **Mis Reservas**, seleccionar una reserva y presionar **Marcar como Usado** para interactuar con el Stepper.
