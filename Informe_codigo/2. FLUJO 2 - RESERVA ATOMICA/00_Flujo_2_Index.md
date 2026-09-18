---
title: "Índice: Flujo 2 — Reserva Atómica de Repuestos"
date: 2026-09-18
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - flujo-2
  - reserva-atomica
  - concurrencia
  - race-conditions
  - online-only
---

# 🔒 Flujo 2: Reserva Atómica de Repuestos

> **Propósito del Flujo:** Garantizar que un técnico del taller pueda apartar y reservar un repuesto físico de manera **atómica e inmediata**, impidiendo que dos técnicos reserven la misma pieza simultáneamente (condición de carrera / double-booking), proporcionando retroalimentación táctil y redirigiendo fluidamente a las vistas correspondientes.

---

## 🗺️ Mapa de Archivos y Responsabilidades

| Archivo de Documentación | Archivo en Código | Responsabilidad Principal |
| :--- | :--- | :--- |
| [[01_Atomicidad_y_Provider\|01. Atomicidad y Provider]] | [`repuestos_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/providers/repuestos_provider.dart) | Lógica de mutación atómica en Supabase con cláusula `WHERE estado = 'disponible'`, detección de concurrencia y refresco de listas. |
| [[02_DetalleDisponibleSheet\|02. Modal Detalle Disponible]] | [`detalle_disponible_sheet.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/detalle_disponible_sheet.dart) | Modal inferior contextual (Thumb Zone) con badge de disponibilidad y disparador del formulario con anti-doble clic. |
| [[03_ReservarScreen_Formulario_y_Stepper\|03. Pantalla de Reserva & Stepper]] | [`reservar_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/screens/reservar_screen.dart) | Formulario con validaciones en vivo, contador/stepper híbrido (`+`, `-`, manual $\ge 1$), anti-double submit y pulso háptico (`HapticFeedback`). |
| [[04_ReservaConfirmadaScreen_y_Navigation\|04. Confirmación & Enrutamiento]] | [`reserva_confirmada_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/screens/reserva_confirmada_screen.dart) & [`navigation_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/home/providers/navigation_provider.dart) | Comprobante visual de reserva con datos de trazabilidad y redirección a pestañas mediante `NavigationProvider` y `popUntil`. |

---

## 🎯 Criterios Críticos de Arquitectura y Negocio en este Flujo

1. **Atomicidad Real (Optimistic Concurrency Control):**
   - No se confía en validaciones previas de lectura.
   - El `UPDATE` en base de datos exige `WHERE id = repuestoId AND estado = 'disponible'`. Si otro técnico ganó la pieza 1 milisegundo antes, la consulta actualiza 0 filas y la aplicación rechaza la operación informando al técnico.
2. **Flujo Estrictamente Online-Only:**
   - Este flujo **no permite cola offline**, ya que la integridad física del inventario depende de la verificación en tiempo real con el servidor central.
3. **UX Móvil Ergonómica (Regla del Pulgar y Micro-interacciones):**
   - Contador interactivo para seleccionar unidades sin fricción.
   - Feedback táctil (`HapticFeedback.lightImpact()`) al momento exacto de la confirmación.
   - Bloqueo de botones contra doble envío durante peticiones asíncronas.
