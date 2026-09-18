---
title: "Defensa de Código: RepuestoModel (Entidad de Dominio y Mapeo JSON)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - model
  - json
  - inmutabilidad
  - flujo-1
---

# `Repuesto` — Modelo de Dominio e Inmutabilidad

> **Ubicación del Archivo:** [`proyecto/lib/features/repuestos/data/repuesto_model.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/data/repuesto_model.dart)

---

## 1. Propósito General: ¿Qué problema resuelve y por qué es esencial?

Este archivo define la estructura de datos tipada de un repuesto dentro de la aplicación.

Sin este archivo:
- La aplicación tendría que manipular diccionarios dinámicos no tipados (`Map<String, dynamic>`) en cada widget.
- Un error de tipeo (por ejemplo escribir `'estdo'` en lugar de `'estado'`) pasaría desapercibido en tiempo de compilación y fallaría en vivo ante el usuario.
- No se garantizaría la **inmutabilidad** de los datos en memoria.

`Repuesto` convierte las respuestas crudas de Supabase en una entidad inmutable con tipos estrictos (`String`, `int`, `DateTime`) y métodos de conveniencia como `fromJson` y `copyWith`.

---

## 2. Funciones y Métodos Clave (Para señalar en pantalla)

### 🔹 Propiedades Inmutables (`final`) (Líneas 1-22)
- **Dónde señalar:** Declaración de variables dentro de `class Repuesto`.
- **Qué hace:** Todos los campos son `final`. Una vez instanciado un objeto `Repuesto`, no puede ser mutado accidentalmente por ningún widget.
- **Campos destacados:**
  - `cantidad`: Entero con valor por defecto `1`, base para futuras operaciones de stock parcial.
  - `reservadoPorNombre`: Campo adicional obtenido mediante el JOIN con la tabla `tecnico`.
  - `fechaReserva` y `createdAt`: Tipados como `DateTime?` para garantizar el manejo de fechas en UTC.

### 🔹 Factory Constructor: `Repuesto.fromJson()` (Líneas 39-63)
- **Dónde señalar:** Líneas 39 a 63.
- **Qué hace:**
  - **Líneas 40-42 (Extracción Relacional):**
    ```dart
    final tecnicoData = json['tecnico'];
    final nombreTecnico = tecnicoData is Map ? tecnicoData['nombre'] as String? : null;
    ```
    Mapea de forma segura el objeto anidado `{ "tecnico": { "nombre": "Juan Pérez" } }` retornado por el JOIN de Supabase. Si es `null`, asigna `null` sin lanzar excepción.
  - **Líneas 56-61 (Parsing Seguro de Fechas):** Usa `DateTime.tryParse()` para convertir strings ISO 8601 a objetos de fecha sin riesgo de provocar un crash si la fecha viene vacía o mal formateada.

### 🔹 Método `copyWith()` (Líneas 66-96)
- **Dónde señalar:** Final del archivo.
- **Qué hace:** Permite clonar un repuesto modificando solo los atributos deseados (por ejemplo, cambiar `estado: 'reservado'`) preservando la inmutabilidad del objeto original.

---

## 3. Preguntas de Examen (Defensa de Código en Vivo)

### ❓ Pregunta 1 del Docente:
> *“¿Cómo resuelves el mapeo cuando Supabase te devuelve una relación anidada en formato JSON?”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 40 a 42**:
```dart
final tecnicoData = json['tecnico'];
final nombreTecnico = tecnicoData is Map ? tecnicoData['nombre'] as String? : null;
```
🗣️ **Qué responder textualmente:**
> *"Cuando Supabase ejecuta un JOIN relacional, la tabla foránea no viene aplanada, sino como un mapa anidado bajo la clave `'tecnico'`. Aquí verificamos mediante `is Map` si ese nodo existe y es un objeto válido. Si es así, extraemos `tecnicoData['nombre']` de forma segura. Si el repuesto está disponible y no tiene técnico asignado, la expresión evalúa a `null` de manera limpia y sin lanzar una excepción de tipo."*

---

### ❓ Pregunta 2 del Docente:
> *“¿Por qué todos los atributos de esta clase son `final` y para qué sirve el método `copyWith`?”*

📍 **Qué señalar en pantalla:**
Ve a la **Línea 2 (`final String id;`)** y a la **Línea 66 (`Repuesto copyWith(...)`)**.
🗣️ **Qué responder textualmente:**
> *"Todos los atributos son `final` para aplicar el principio de **Inmutabilidad** exigido por Clean Architecture. Esto garantiza que ningún widget pueda alterar el estado de un repuesto en memoria de forma silenciosa. Cuando necesitamos actualizar un repuesto (por ejemplo, al cambiar de 'disponible' a 'reservado'), usamos `copyWith()`, que genera una nueva instancia inmutable con los cambios específicos manteniendo los demás valores intactos."*

---

### ❓ Pregunta 3 del Docente:
> *“¿Por qué utilizas `DateTime.tryParse` en lugar de `DateTime.parse` para las fechas?”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 56 a 61**:
```dart
fechaReserva: json['fecha_reserva'] != null
    ? DateTime.tryParse(json['fecha_reserva'].toString())
    : null,
```
🗣️ **Qué responder textualmente:**
> *"Porque `DateTime.parse` lanza un `FormatException` bloqueante si la cadena recibida no cumple con el estándar ISO 8601 o si la base de datos envía un dato nulo inesperado. Al usar `DateTime.tryParse`, si ocurre alguna anomalía en el formato, el método devuelve `null` de forma segura en lugar de interrumpir la ejecución de la aplicación."*
