---
title: "Defensa de Código: Sistema de Diseño y Tokens (AppColors y AppTheme)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - theme
  - tokens
  - atomic-design
  - typography
---

# `AppColors` y `AppTheme` — Sistema de Diseño Atómico y Tokens Globales

> **Ubicación de Archivos:**
> - [`proyecto/lib/core/theme/app_colors.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/core/theme/app_colors.dart)
> - [`proyecto/lib/core/theme/app_theme.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/core/theme/app_theme.dart)

---

## 1. Propósito General: ¿Qué problema resuelve y por qué es esencial?

Cumple con la regla de **Tokenización Atómica (Regla 2.9)** de nuestra arquitectura móvil:
- **Prohibición de estilos "hardcodeados":** En ningún widget debe existir un `Color(0xFF1E293B)` o un `TextStyle(fontSize: 22)` suelto.
- **Mantenibilidad instantánea:** Si se decide cambiar el tono primario o la fuente corporativa, se modifica un solo archivo y toda la aplicación (más de 15 pantallas y componentes) se actualiza de manera uniforme y consistente.

---

## 2. Tokens y Clases Clave (Para señalar en pantalla)

### 🔹 Paleta de Colores de Marca y Estados (`AppColors`)
- **`AppColors.primary` (`#1E293B`):** Azul Oscuro Técnico para botones y navegación principal.
- **`AppColors.secondary` (`#F59E0B`):** Naranja/Ámbar para acentos de reserva.
- **`AppColors.success` (`#10B981`):** Verde Esmeralda para stock disponible y confirmaciones.
- **`AppColors.error` (`#EF4444`):** Rojo Coral para cancelaciones y validaciones.
- **`AppColors.textNight` (`#0F172A`):** Gris Noche de alto contraste para textos y títulos.
- **`AppColors.slate50` (`#F8FAFC`):** Fondo neutro de alta legibilidad.

### 🔹 Escala Tipográfica Centralizada (`AppTextStyles` en `app_theme.dart`)
- `screenTitle()`: `Inter Bold (700), 22px`.
- `cardTitle()`: `Inter SemiBold (600), 15px`.
- `body()`: `Inter Regular (400), 13px`.
- `labelOverline()`: `Inter SemiBold (600), 11px, mayúsculas con tracking`.
- `button()`: `Inter Bold (700), 15px`.
- `caption()`: `Inter Regular (400), 12px, #64748B`.

### 🔹 `AppTheme.lightTheme` (Líneas 61-180 de `app_theme.dart`)
- Configura los temas por defecto de Material 3 para `appBarTheme`, `elevatedButtonTheme`, `cardTheme` e `inputDecorationTheme`, asegurando que cualquier nuevo botón o tarjeta herede los bordes redondeados (12-14px) y colores oficiales sin configuración manual.

---

## 3. Preguntas de Examen (Defensa de Código en Vivo)

### ❓ Pregunta 1 del Docente:
> *“¿Por qué las clases `AppColors` y `AppTextStyles` tienen un constructor privado `AppColors._();`?”*

📍 **Qué señalar en pantalla:**
Señala la **Línea 5** de `app_colors.dart` o la **Línea 7** de `app_theme.dart`.
🗣️ **Qué responder textualmente:**
> *"Porque son **clases puras de constantes y utilidades**. Al colocar un constructor privado `AppColors._()`, impedimos que algún desarrollador intente instanciar la clase por error con `var c = AppColors()`. Todos sus miembros son `static const`, garantizando máxima eficiencia de memoria compilada."*

---

### ❓ Pregunta 2 del Docente:
> *“¿Cómo garantiza este sistema de diseño la accesibilidad y el contraste de lectura?”*

📍 **Qué señalar en pantalla:**
Señala `AppColors.textNight` (`#0F172A`) sobre `AppColors.background` (`#F8FAFC`).
🗣️ **Qué responder textualmente:**
> *"Utilizamos una relación de contraste superior a **7:1** (cumpliendo con la norma internacional **WCAG AAA**) al combinar el Gris Noche `#0F172A` sobre fondos `#FFFFFF` y `#F8FAFC`. Además, el verde de éxito `#10B981` y el rojo de error `#EF4444` cuentan con fondos atenuados (`#ECFDF5` y `#FEF2F2`) para que la información sea distinguible incluso bajo luz solar directa en el taller."*
