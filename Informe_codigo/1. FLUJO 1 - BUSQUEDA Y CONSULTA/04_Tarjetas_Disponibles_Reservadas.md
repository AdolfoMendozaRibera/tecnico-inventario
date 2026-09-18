---
title: "Defensa de Código: Tarjetas de Inventario (DisponibleCard e InventarioReservadoCard)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - widgets
  - ui
  - ergonomia
  - figma
  - flujo-1
---

# `DisponibleCard` e `InventarioReservadoCard` — Componentes Atómicos de Presentación

> **Ubicación de Archivos:**
> - [`proyecto/lib/core/widgets/disponible_card.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/core/widgets/disponible_card.dart)
> - [`proyecto/lib/features/repuestos/presentation/widgets/inventario_reservado_card.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/widgets/inventario_reservado_card.dart)

---

## 1. Propósito General: ¿Qué problema resuelve y por qué es esencial?

Estos dos widgets representan las unidades visuales atómicas que el técnico u operario ve en el listado de inventario.

Sin estos widgets:
- El código de renderizado de cada tarjeta estaría duplicado dentro del `ListView.builder` de la pantalla.
- No se respetaría la regla de **Thumb Zone (zona ergonómica del pulgar)** ni las dimensiones mínimas táctiles (≥ 48dp).
- El diseño visual no guardaría fidelidad con los mockups de Figma ni con los estándares de contraste de color.

Ambos widgets son **UI Tonta (Display Only)**: reciben el objeto `Repuesto` inmutable y los callbacks (`onReservar`, `onTap`), desacoplando totalmente la presentación de la lógica de negocio.

---

## 2. Funciones y Componentes Clave (Para señalar en pantalla)

### 🔹 `DisponibleCard` — Tarjeta de Repuesto en Stock (Líneas 11-158)
- **Estructura en dos columnas:**
  - **Columna Izquierda (Líneas 47-101):** Muestra el nombre con `maxLines: 2` y `TextOverflow.ellipsis` para evitar desbordamientos de texto en pantallas angostas, icono de categoría y el stock disponible.
  - **Columna Derecha (Líneas 104-150):** 
    - **Badge Verde:** Contenedor con `Color(0xFFECFDF5)` y texto verde esmeralda `Color(0xFF047857)` para indicar estado disponible sin ambigüedades.
    - **Botón "Reservar":** `ElevatedButton` con estilo `AppColors.slate800`, ubicado en la zona derecha accesible al pulgar, que dispara el callback `onReservar`.
  - **Toque en la tarjeta completa (Líneas 38-41):** Al hacer tap fuera del botón, el `InkWell` despliega el modal `DetalleDisponibleSheet` (Flujo 2).

### 🔹 `InventarioReservadoCard` — Tarjeta de Repuesto Apartado (Líneas 10-176)
- **Estructura informativa enriquecida:**
  - **Cabecera con Técnico:** Muestra el nombre del técnico que realizó la reserva (`repuesto.reservadoPorNombre`) o *"Técnico asignado"*.
  - **Badge Ámbar de Alerta:** Etiqueta visual `Color(0xFFFFFBEB)` con texto ámbar `Color(0xFFB45309)` que previene confusiones dejando claro que la pieza no está libre.
  - **Metadatos del Trabajo:** Despliega el **Equipo destino** (ej: *"Dell Inspiron 15"*) y el **Motivo** (ej: *"Cambio de pantalla por rotura"*).
  - **Toque con Efecto Ripple:** El `InkWell` abre `DetalleReservaSheet` para que el técnico o admin vea la auditoría completa o libere el repuesto.

---

## 3. Preguntas de Examen (Defensa de Código en Vivo)

### ❓ Pregunta 1 del Docente:
> *“¿Cómo evitas que un nombre de repuesto muy largo rompa el diseño visual de la tarjeta (*Overflow error*)?”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 61 a 63 de `disponible_card.dart`**:
```dart
maxLines: 2,
overflow: TextOverflow.ellipsis,
```
🗣️ **Qué responder textualmente:**
> *"Protegemos la tarjeta limitando el texto a un máximo de 2 líneas (`maxLines: 2`) y activando `TextOverflow.ellipsis`. Si el nombre del repuesto excede el ancho disponible de la pantalla, Flutter trunca el texto agregando automáticamente puntos suspensivos ('...') en lugar de romper el layout o lanzar el error de desbordamiento de píxeles (*RenderFlex overflowed*)."*

---

### ❓ Pregunta 2 del Docente:
> *“¿Por qué estas tarjetas reciben callbacks (`onReservar`, `onTap`) en lugar de hacer la navegación o la llamada a Supabase directamente dentro del widget?”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 12-15 de `disponible_card.dart`**:
```dart
final Repuesto repuesto;
final VoidCallback onReservar;
final VoidCallback? onTap;
```
🗣️ **Qué responder textualmente:**
> *"Porque aplicamos el principio de **UI Tonta (Display Only)** y Responsabilidad Única. Una tarjeta solo debe encargarse de pintar los datos visuales que recibe. Al delegar las acciones a través de `VoidCallback`, el widget se mantiene 100% desacoplado y reutilizable en cualquier otra pantalla (por ejemplo, en un buscador global o un historial de compras) sin acoplarse a un flujo de navegación rígido."*

---

### ❓ Pregunta 3 del Docente:
> *“¿Cómo garantizas la accesibilidad táctil en los botones y áreas de toque según los estándares de diseño móvil?”*

📍 **Qué señalar en pantalla:**
Ve a la **Línea 135 de `disponible_card.dart` (`minimumSize: const Size(82, 36)`)** y al padding del `InkWell` (**Línea 42**).
🗣️ **Qué responder textualmente:**
> *"Toda el área de la tarjeta está envuelta en un `Material` transparente con `InkWell` y padding de 16dp, proporcionando una superficie de contacto superior a los 48x48dp estándar requeridos por Material Design. Además, el botón 'Reservar' tiene un área táctil definida que evita toques erróneos accidentales al operar el móvil con una sola mano en el taller."*
