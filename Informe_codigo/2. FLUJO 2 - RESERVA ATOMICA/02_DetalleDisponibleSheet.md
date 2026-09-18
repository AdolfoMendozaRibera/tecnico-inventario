---
title: "02. Modal Bottom Sheet de Detalle Disponible"
date: 2026-09-18
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - bottom-sheet
  - ux-mobile
  - thumb-zone
  - anti-double-submit
---

# 02. Modal Bottom Sheet de Detalle Disponible (`DetalleDisponibleSheet`)

> **Archivo Analizado:** [`proyecto/lib/features/repuestos/presentation/widgets/detalle_disponible_sheet.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/detalle_disponible_sheet.dart)  
> **Líneas Clave:** `17` a `47` (`show` e `_irAReservar`), `290` a `337` (Botón con estado "Preparando formulario...")

---

## 1. 🎯 Propósito General

En ergonomía móvil para talleres mecánicos/electrónicos, navegar a una pantalla completa únicamente para consultar la ubicación física o el código de una pieza genera fricción innecesaria.

`DetalleDisponibleSheet` implementa un **Modal Bottom Sheet contextual** (respetando la zona del pulgar o *Thumb Zone*) que permite:
1. Inspeccionar rápidamente los metadatos de la pieza (código de pieza, estantería/nivel físico y disponibilidad).
2. Servir como punto de entrada fluido hacia el formulario de reserva con feedback de carga (*"Preparando formulario..."*).

---

## 2. ⚙️ Funciones y Métodos Clave

### `DetalleDisponibleSheet.show(BuildContext context, Repuesto repuesto)`
* **Ubicación:** Líneas 17–24.
* **Patrón de diseño:** Método de fábrica estático (*Static Helper Method*). Encapsula `showModalBottomSheet` para que las tarjetas de repuestos puedan abrir el modal con una sola línea de código limpia: `DetalleDisponibleSheet.show(context, repuesto)`.

```dart
static Future<void> show(BuildContext context, Repuesto repuesto) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DetalleDisponibleSheet(repuesto: repuesto),
  );
}
```

### `_irAReservar()`
* **Ubicación:** Líneas 33–47.
* **Manejo de estado y transición:**

```dart
void _irAReservar() async {
  setState(() => _isPreparing = true);
  await Future.delayed(const Duration(milliseconds: 280));
  if (!mounted) return;

  final navigator = Navigator.of(context);
  navigator.pop(); // Cierra el bottom sheet

  navigator.push(MaterialPageRoute(
    builder: (_) => ReservarScreen(
      repuestoId: widget.repuesto.id,
      repuestoNombre: widget.repuesto.nombre,
    ),
  ));
}
```

### 🔍 ¿Qué hace el código internamente?
1. **Feedback Visual Inmediato:** Al presionar *"Reservar para un Equipo"*, activa `_isPreparing = true`. El botón cambia instantáneamente su texto por un `CircularProgressIndicator` blanco y el texto *"Preparando formulario..."*, deshabilitando cualquier toque adicional (anti-doble toque).
2. **Micro-animación deliberada:** Espera un breve retraso (280ms) para dar suavidad perceptible a la UI antes de desmontar el BottomSheet.
3. **Cierre y Transición Limpia:** Cierra el modal (`navigator.pop()`) y empuja la pantalla `ReservarScreen` con el `repuestoId` y `repuestoNombre` inyectados limpiamente como parámetros inmutables.

---

## 3. 🎓 Preguntas de Examen (Defensa de Código)

### Pregunta 1: *"¿Por qué se utilizó un Modal Bottom Sheet en lugar de empujar directamente una pantalla de detalle completa?"*
> **Respuesta recomendada:**  
> *"Por la 'Regla del Pulgar' (Thumb Zone) de la arquitectura UX móvil. Un técnico suele sostener el teléfono con una sola mano en el taller; el BottomSheet aparece desde abajo, dejando las acciones críticas al alcance del pulgar sin obligar a extender la mano hacia la parte superior. Además, reduce la carga cognitiva permitiendo cerrar el modal deslizando hacia abajo sin perder la posición del listado."*

### Pregunta 2: *"¿Por qué se guarda `final navigator = Navigator.of(context);` antes de hacer el `pop()` y el `push()`?"*
> **Respuesta recomendada:**  
> *"Para evitar problemas de contexto desmontado (`BuildContext across asynchronous gaps`). Al invocar `pop()` sobre el modal, el contexto del widget del sheet puede quedar invalidado (`unmounted`). Capturar la referencia del `NavigatorState` antes del pop garantiza que la posterior llamada a `push(ReservarScreen)` se ejecute de manera segura en el navigator principal."*

---

## 4. 📱 Cómo demostrarlo en vivo en la pantalla

1. **En la pestaña Repuestos:** Tocar cualquier repuesto con badge verde **"Disponible"**.
2. **Verificar BottomSheet:** Mostrar cómo se despliega desde abajo con la barra de arrastre (*drag handle*), la estantería física y el botón *"Reservar para un Equipo"*.
3. **Pulsar el botón:** Mostrar cómo el botón se transforma en *"Preparando formulario..."* con spinner antes de abrir `ReservarScreen`.
