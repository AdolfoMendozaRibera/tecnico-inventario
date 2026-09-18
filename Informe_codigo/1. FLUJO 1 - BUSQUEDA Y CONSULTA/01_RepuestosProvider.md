---
title: "Defensa de Código: RepuestosProvider (Estado de Inventario y Consulta)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - provider
  - repuestos
  - supabase
  - flujo-1
---

# `RepuestosProvider` — Gestión Reactiva del Inventario

> **Ubicación del Archivo:** [`proyecto/lib/features/repuestos/providers/repuestos_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/providers/repuestos_provider.dart)

---

## 1. Propósito General: ¿Qué problema resuelve y por qué es esencial?

Este archivo es el **cerebro de datos** para todo lo relacionado con los repuestos del taller.

Sin este archivo:
- Cada pantalla tendría que conectarse directamente a Supabase mediante SQL/PostgREST suelto, duplicando código y peticiones.
- Cuando un técnico reserva o libera un repuesto, las otras pantallas no se enterarían y mostrarían datos desactualizados.
- La aplicación mezclaría lógica de red dentro de los widgets de la interfaz (violando Clean Architecture).

`RepuestosProvider` descarga los repuestos una sola vez, los clasifica en memoria en listas separadas (`disponibles`, `reservados`, `misReservas`), y notifica automáticamente a la UI mediante `notifyListeners()`.

---

## 2. Funciones y Métodos Clave (Para señalar en pantalla)

### 🔹 Listas y Getters de Estado (Líneas 8-19)
- **Dónde señalar:** Declaración de variables privadas y getters públicos.
- **Qué hace:**
  - `_disponibles`: Almacena solo los repuestos con `estado == 'disponible'`.
  - `_reservados`: Almacena repuestos bloqueados por técnicos con `estado == 'reservado'`.
  - `_isLoading`: Booleano que indica si se está ejecutando una llamada a red.
  - `_lastError`: Mensaje humano en caso de fallo de red (o `null` si la operación fue exitosa).

### 🔹 `fetchRepuestos()` (Líneas 21-49)
- **Dónde señalar:** Método principal de carga.
- **Qué hace:**
  1. **Líneas 22-24:** Activa `_isLoading = true`, resetea `_lastError = null` y ejecuta `notifyListeners()` para que la pantalla dibuje los skeletons inmediatamente.
  2. **Líneas 30-32 (Query con JOIN):** Ejecuta la consulta a Supabase:
     ```dart
     .from('repuesto')
     .select('*, tecnico:reservado_por(nombre)')
     .order('nombre');
     ```
     *Nota técnica:* Hace un **Foreign Key JOIN** relacional entre la tabla `repuesto` y `tecnico` para traer el nombre legible de quién tiene reservada la pieza en una sola petición.
  3. **Líneas 34-41 (Filtrado en Memoria):** Parsea la lista de JSON a objetos `Repuesto` y la divide según su estado.
  4. **Líneas 42-45 (Captura Resiliente):** Si ocurre un error de red o timeout, captura la excepción y asigna un mensaje humano: *"No se pudo conectar al inventario. Revisa tu conexión e intenta de nuevo."*
  5. **Líneas 47-48:** Desactiva `_isLoading = false` y vuelve a notificar a los widgets.

---

## 3. Preguntas de Examen (Defensa de Código en Vivo)

### ❓ Pregunta 1 del Docente:
> *“Muéstrame en el código cómo obtienes el nombre del técnico que reservó una pieza si ese dato está en otra tabla de la base de datos.”*

📍 **Qué señalar en pantalla:**
Ve a la **Línea 31**:
```dart
.select('*, tecnico:reservado_por(nombre)')
```
🗣️ **Qué responder textualmente:**
> *"Aquí en la línea 31 utilizamos la sintaxis de PostgREST de Supabase para hacer un JOIN relacional directo. Le indicamos a Supabase que traiga todos los campos de `repuesto` y que, a través de la clave foránea `reservado_por`, consulte la tabla `tecnico` y extraiga únicamente el campo `nombre`. Esto evita hacer múltiples consultas lentas en bucle (*problema N+1*) y resuelve todo en una sola llamada de red."*

---

### ❓ Pregunta 2 del Docente:
> *“¿Por qué separas los repuestos en `_disponibles` y `_reservados` dentro del Provider en lugar de hacer dos consultas separadas a Supabase?”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 34 a 37**:
```dart
_disponibles = allRepuestos.where((r) => r.estado == 'disponible').toList();
_reservados = allRepuestos.where((r) => r.estado == 'reservado').toList();
```
🗣️ **Qué responder textualmente:**
> *"Por optimización de red y reducción de latencia. En lugar de hacer dos peticiones HTTP separadas a la base de datos (`WHERE estado = 'disponible'` y luego `WHERE estado = 'reservado'`), traemos el lote completo en una sola petición y realizamos la segregación en memoria con Dart (`where`). Esto reduce el consumo de datos y hace que el cambio entre pestañas en la interfaz sea instantáneo a 60 FPS."*

---

### ❓ Pregunta 3 del Docente:
> *“¿Cómo maneja este Provider un corte abrupto de internet para que la app no se congele ni lance una pantalla roja de error?”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 42-45 (bloque `try / catch`)** y a la **Línea 23 (`_lastError = null`)**.
🗣️ **Qué responder textualmente:**
> *"Todo el flujo de red está envuelto en un bloque `try/catch`. Si la petición falla por falta de internet o timeout, el `catch` intercepta el error, almacena un mensaje explicativo y comprensible en `_lastError`, apaga `_isLoading` y ejecuta `notifyListeners()`. De este modo, la vista recibe el evento y reemplaza los skeletons por el widget `InventarioErrorState` con un botón de 'Reintentar', sin provocar ningún crash."*
