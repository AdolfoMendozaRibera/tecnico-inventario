---
title: "Índice: Flujo 3 — Gestión de Reservas Activas"
date: 2026-09-18
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - flujo-3
  - gestion-reservas
  - parciales
  - rls
  - admin-taller
---

# 🔄 Flujo 3: Gestión de Reservas Activas (Parciales y Totales)

> **Propósito del Flujo:** Permitir a los técnicos consultar sus reservas activas, consumir piezas marcándolas como usadas o liberarlas de nuevo al catálogo general (total o parcialmente por cantidad), con soporte de vista administrada para encargados de taller y notificaciones humanas mediante banners verdes animados.

---

## 🗺️ Mapa de Archivos y Responsabilidades

| Archivo de Documentación | Archivo en Código | Responsabilidad Principal |
| :--- | :--- | :--- |
| [[01_Gestion_Logica_y_Parciales\|01. Lógica de Liberación y Consumo Parcial]] | [`repuestos_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/providers/repuestos_provider.dart) | Métodos `marcarComoUsado` y `liberarRepuesto` con cálculo de saldo restante (`cantidad`), devolución parcial al catálogo o eliminación de la reserva. |
| [[02_MisReservasScreen_y_VistaAdmin\|02. Pantalla Mis Reservas & Rol Admin]] | [`mis_reservas_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/screens/mis_reservas_screen.dart) | Vista dividida por segmentos (Mis Reservas vs. Reservas del Taller para Admin), filtro de búsqueda, banner verde flotante auto-hide y estado vacío con CTA al catálogo. |
| [[03_Modales_Gestionar_Usado_y_Liberar\|03. Modales Contextuales & Feedback]] | `gestionar_reserva_sheet.dart`, `marcar_usado_sheet.dart`, `liberar_repuesto_sheet.dart` | Modales bottom sheet ergométricos en Thumb Zone con Stepper (`+`/`-`), vista previa del saldo que quedará reservado y respuesta táctil háptica (`HapticFeedback.lightImpact()`). |

---

## 🎯 Criterios Críticos de Arquitectura y UX en este Flujo

1. **Gestión Granular de Stock por Cantidad:**
   - Si un técnico reservó 5 piezas y solo utiliza 3, la aplicación no borra la reserva a ciegas: resta 3 unidades consumidas y deja 2 unidades aún reservadas en el taller. Si consume/libera las 5 completas, el repuesto regresa a disponible o se liquida.
2. **Segmentación y Seguridad RLS por Rol:**
   - Los técnicos estándar solo administran y ven sus propias reservas. El **Encargado de Taller (Admin)** dispone de pestañas conmutables para auditar el total de piezas apartadas en la tienda.
3. **UX Resiliente y Feedback Humano:**
   - Banner de alerta verde (`#10B981`) con auto-ocultado en 3 segundos que confirma exactamente la acción realizada (*"Reserva completada: repuesto usado con éxito"* o *"Repuesto liberado y disponible en el taller"*).
