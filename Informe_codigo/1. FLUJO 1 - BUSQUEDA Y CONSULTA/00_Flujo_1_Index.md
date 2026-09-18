---
title: "Índice: Flujo 1 — Búsqueda y Consulta (Exploración del Inventario)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - flujo-1
  - inventario
  - exploracion
  - busqueda
---

# 📦 Flujo 1: Búsqueda y Consulta del Inventario (Exploración)

> **Propósito del Flujo:** Permitir a cualquier miembro del taller (técnicos y administradores) consultar en tiempo real el catálogo de repuestos disponibles y reservados, con búsqueda reactiva sin latencia, debounce inteligente y resiliencia ante caídas de red.

---

## 🗺️ Mapa de Archivos y Responsabilidades

| Archivo de Documentación | Archivo en Código | Responsabilidad Principal |
| :--- | :--- | :--- |
| [[01_RepuestosProvider\|01. RepuestosProvider]] | [`repuestos_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/providers/repuestos_provider.dart) | Estado reactivo, llamadas a Supabase con JOINs, separación de listas y captura de errores. |
| [[02_RepuestosListScreen\|02. RepuestosListScreen]] | [`repuestos_list_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/screens/repuestos_list_screen.dart) | Vista principal con pestañas (Disponibles / Reservados), buscador con debounce de 220ms y conmutador de los 4 estados. |
| [[03_RepuestoModel\|03. RepuestoModel]] | [`repuesto_model.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/data/repuesto_model.dart) | Modelo de dominio inmutable, serialización JSON y resolución de relaciones relacionales de Supabase. |
| [[04_Tarjetas_Disponibles_Reservadas\|04. Tarjetas de Inventario]] | [`disponible_card.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/core/widgets/disponible_card.dart) & [`inventario_reservado_card.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/inventario_reservado_card.dart) | Componentes atómicos de presentación con badges de stock, técnicos asignados y acciones directas. |
| [[05_EstadosBorde_Inventario\|05. Estados de Borde UX]] | `inventario_error_state.dart`, `taller_vacio_state.dart`, `repuesto_empty_state.dart`, `repuesto_skeleton_card.dart` | Los 4 estados de borde obligatorios: Loading con Shimmer, Empty sin búsqueda, Empty con búsqueda y Error con reintento. |

---

## 🎯 Criterios Clave de Arquitectura y UX Cumplidos

1. **Virtualización de Listas (`ListView.builder`):** No carga todos los registros en memoria; solo renderiza lo visible en pantalla para mantener 60/120 FPS.
2. **Debounce (220 ms):** Evita recálculos innecesarios y saturación de la CPU mientras el usuario escribe en el buscador.
3. **Resiliencia Visual (4 Estados de Borde):**
   - **Loading:** Skeletons animados que respetan la forma de la tarjeta (sin saltos bruscos de pantalla).
   - **Empty:** Distinción clara entre "el taller no tiene repuestos todavía" y "no hay coincidencias para tu búsqueda".
   - **Error:** Lenguaje comprensible (*"Sin conexión al inventario"*) con botón de acción (*"Reintentar"*).
   - **Success:** Listados agrupados con pull-to-refresh (`RefreshIndicator`).
