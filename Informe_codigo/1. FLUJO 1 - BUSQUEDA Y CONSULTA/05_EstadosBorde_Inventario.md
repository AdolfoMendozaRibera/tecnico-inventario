---
title: "Defensa de Código: Los 4 Estados de Borde UX (Loading, Empty, Error, Overflow)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - ux
  - resiliencia
  - skeletons
  - error-handling
  - flujo-1
---

# 🛡️ Estados de Borde UX en el Inventario

> **Ubicación de Archivos:**
> - [`proyecto/lib/features/repuestos/presentation/widgets/repuesto_skeleton_card.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/repuesto_skeleton_card.dart)
> - [`proyecto/lib/features/repuestos/presentation/widgets/inventario_error_state.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/inventario_error_state.dart)
> - [`proyecto/lib/features/repuestos/presentation/widgets/taller_vacio_state.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/taller_vacio_state.dart)
> - [`proyecto/lib/features/repuestos/presentation/widgets/repuesto_empty_state.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/repuesto_empty_state.dart)

---

## 1. Propósito General: ¿Qué problema resuelve y por qué es esencial?

En aplicaciones de campo o taller, una interfaz no puede quedarse en blanco, congelarse ni mostrar errores crudos del servidor como *"SocketException: OS Error: Connection refused"*.

El estándar arquitectónico exige **4 estados de borde obligatorios**:
1. **Loading (Carga):** `RepuestoSkeletonCard` con efecto Shimmer.
2. **Error (Fallo de Red):** `InventarioErrorState` con mensaje humano y reintento.
3. **Empty Inicial (Taller Vacío):** `TallerVacioState` cuando el inventario no tiene piezas registradas.
4. **Empty de Búsqueda (Sin Coincidencias):** `RepuestoEmptyState` cuando la búsqueda no encuentra el término pero ofrece registrarlo.

---

## 2. Anatomía de los 4 Widgets de Borde

### 1️⃣ `RepuestoSkeletonCard` (Loading con Shimmer)
- **Dónde señalar:** `repuesto_skeleton_card.dart`.
- **Qué hace:** Imita exactamente la geometría, paddings y dimensiones de la tarjeta real (`DisponibleCard`). Mientras los datos viajan desde Supabase, el usuario percibe una carga rápida y el layout no sufre ningún salto brusco (*Cumulative Layout Shift - CLS*).

### 2️⃣ `InventarioErrorState` (Fallo de Conexión)
- **Dónde señalar:** `inventario_error_state.dart`.
- **Qué hace:** 
  - Muestra un icono `Icons.wifi_off_rounded` con fondo carmesí suave `Color(0xFFFEE2E2)`.
  - Presenta el mensaje procesado por el Provider (*"No se pudo conectar al inventario. Revisa tu conexión e intenta de nuevo."*).
  - Incluye un botón primario de ancho completo `Reintentar` que vuelve a invocar `fetchRepuestos()`.

### 3️⃣ `TallerVacioState` (Inventario en Cero)
- **Dónde señalar:** `taller_vacio_state.dart`.
- **Qué hace:** Se activa cuando la lista del taller está vacía y el usuario **no** está buscando nada. Ofrece un mensaje orientativo (*"El taller está vacío"*) y un botón directo para que el administrador agregue el primer repuesto.

### 4️⃣ `RepuestoEmptyState` (Búsqueda sin Resultados)
- **Dónde señalar:** `repuesto_empty_state.dart`.
- **Qué hace:** Se activa cuando el usuario escribió en el buscador algo que no existe (ej: *"Pantalla iPhone 15"*). Muestra dos acciones directas:
  - Botón primario: *"Registrar este Repuesto"* (abre el formulario pasando el nombre ya escrito).
  - Botón secundario: *"Limpiar búsqueda"* (resetea el filtro).

---

## 3. Preguntas de Examen (Defensa de Código en Vivo)

### ❓ Pregunta 1 del Docente:
> *“¿Por qué utilizas Skeleton Cards animados en lugar de un `CircularProgressIndicator` centrado?”*

📍 **Qué señalar en pantalla:**
Muestra [`repuesto_skeleton_card.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/repuesto_skeleton_card.dart) y las **Líneas 92 a 97 de `repuestos_list_screen.dart`**.
🗣️ **Qué responder textualmente:**
> *"Porque un spinner aislado en el centro de la pantalla genera un 'salto de layout' (Layout Shift) cuando los datos terminan de llegar, deteriorando la experiencia visual. Los Skeletons preparan la estructura visual de las tarjetas antes de que lleguen los datos reales, logrando una transición visualmente fluida y dando la sensación psicológica de que la aplicación responde más rápido."*

---

### ❓ Pregunta 2 del Docente:
> *“¿Cómo manejas los estados vacíos (*Empty States*) para que no sean un punto muerto (*Dead End*) para el usuario?”*

📍 **Qué señalar en pantalla:**
Muestra [`repuesto_empty_state.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/repuesto_empty_state.dart) (Líneas 98 a 145) y [`taller_vacio_state.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/taller_vacio_state.dart) (Líneas 73 a 94).
🗣️ **Qué responder textualmente:**
> *"Nunca dejamos un estado vacío como simple texto plano. Aplicamos el principio UX de 'Acción Guiada': si el taller está vacío, le mostramos el botón directo para agregar el primer repuesto. Y si buscó un repuesto inexistente, le damos el botón para registrarlo inmediatamente, transfiriendo el término buscado al formulario para que no tenga que volver a escribirlo."*

---

### ❓ Pregunta 3 del Docente:
> *“¿Por qué está prohibido mostrar errores crudos de la base de datos o stack traces en la interfaz móvil?”*

📍 **Qué señalar en pantalla:**
Muestra [`inventario_error_state.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/inventario_error_state.dart).
🗣️ **Qué responder textualmente:**
> *"Por dos motivos fundamentales: **Seguridad** y **Experiencia de Usuario**. Un stack trace técnico expone detalles internos de la base de datos o URLs del backend, lo que representa una vulnerabilidad. Además, un técnico en el taller necesita un mensaje claro y accionable en lenguaje humano (como 'Sin conexión al inventario') con un botón directo para reintentar la operación con un solo toque."*
