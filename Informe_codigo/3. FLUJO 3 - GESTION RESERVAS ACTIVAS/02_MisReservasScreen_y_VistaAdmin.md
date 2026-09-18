---
title: "02. Pantalla Mis Reservas y Vista de Administrador de Taller"
date: 2026-09-18
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - ui-ux
  - mis-reservas
  - admin-role
  - banner-feedback
---

# 02. Pantalla `MisReservasScreen` y Vista de Administrador de Taller

> **Archivo Analizado:** [`proyecto/lib/features/reservas/presentation/screens/mis_reservas_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/screens/mis_reservas_screen.dart)  
> **Líneas Clave:** `56` a `214` (`build`, `SegmentedControl` y `AnimatedSwitcher`)

---

## 1. 🎯 Propósito General

La pantalla `MisReservasScreen` es la central de control de reservas activas. Su objetivo es ofrecer al técnico una visión limpia de sus piezas apartadas para uso inmediato en el taller, mientras que para el **Encargado de Taller (Admin)** provee un control global para auditar la totalidad de repuestos comprometidos por todo el personal.

---

## 2. ⚙️ Elementos y Componentes Clave

### A. Selector de Pestañas para Administradores (`_buildAdminTabButton`)
* **Ubicación:** Líneas 103–131 y 427–462.
* **Comportamiento:** Si `AuthProvider.isAdmin` es `true`, despliega un control segmentado en la parte superior con dos pestañas:
  1. **Mis Reservas:** Muestra únicamente las reservas donde `reservado_por == currentUser.id`.
  2. **Taller:** Muestra el listado completo de repuestos reservados en la tienda (`provider.reservados`).

```dart
final isViewingAll = isAdmin && _adminTab == 1;
final repuestos = isViewingAll ? provider.reservados : provider.misReservas;
```

### B. Banner Verde de Retroalimentación Humana (`AnimatedSwitcher`)
* **Ubicación:** Líneas 134–187.
* **Comportamiento:** Al completar cualquier acción (marcar usado, liberar o editar), el modal notifica a `MisReservasScreen` via callback `onAccionExitosa(mensaje)`. La pantalla activa el banner verde (`#10B981`) con animación suave y lo oculta automáticamente tras 3 segundos.

```dart
setState(() => _bannerMensaje = mensaje);
Future.delayed(const Duration(seconds: 3), () {
  if (mounted) setState(() => _bannerMensaje = null);
});
```

### C. Estado Vacío Mejorado (*"¡Todo al día!"*)
* **Ubicación:** Líneas 262–337.
* **Comportamiento:** Si el técnico no tiene reservas activas, presenta un contenedor ilustrado en tono verde esmeralda con mensaje amigable e instructivo, incorporando un botón CTA directo (`Ir al Catálogo de Repuestos`) que navega a la pestaña de Repuestos mediante `NavigationProvider`.

---

## 3. 🎓 Preguntas de Examen (Defensa de Código)

### Pregunta 1: *"¿Cómo diferencia la interfaz las reservas propias de las de otros técnicos en la vista de Administrador?"*
> **Respuesta recomendada:**  
> *"En la línea 355 de `mis_reservas_screen.dart`, calculamos `final isOwn = repuesto.reservadoPor == currentUserId;`. La tarjeta `ReservationCard` utiliza esa bandera para mostrar un indicador distintivo de propietario y deshabilitar o habilitar la interacción de edición directa."*

### Pregunta 2: *"¿Por qué se utilizó un banner flotante temporizado en lugar de un `SnackBar` convencional?"*
> **Respuesta recomendada:**  
> *"Siguiendo las reglas de UX/UI Mobile (Regla #2.7: Retroalimentación Humana Inmediata), los `SnackBar` por defecto de Flutter se acumulan en la parte inferior tapando la barra de navegación. El banner verde flotante temporizado en la parte superior mantiene visible el contexto de la lista y proporciona una confirmación visual clara y elegante."*

---

## 4. 📱 Demostración en Código

1. **Ubicación en el código:** Abrir [`mis_reservas_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/screens/mis_reservas_screen.dart) en la línea 103 para mostrar el `if (isAdmin)` y el `AnimatedSwitcher`.
2. **Ubicación en la App:** Iniciar sesión como `admin@taller.com` para observar el selector de vista **Mis Reservas / Taller**.
