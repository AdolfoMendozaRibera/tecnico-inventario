---
title: "Defensa de Código: LoginScreen (UI de Autenticación e Isotipo VaultTecno)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - ui
  - login
  - go-router
  - branding
---

# `LoginScreen` — Pantalla de Acceso Oficial de VaultTecno

> **Ubicación del Archivo:** [`proyecto/lib/features/auth/presentation/screens/login_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/auth/presentation/screens/login_screen.dart)

---

## 1. Propósito General: ¿Qué problema resuelve y por qué es esencial?

Es la puerta de entrada segura al sistema. Su función es:
1. Capturar credenciales de acceso con ergonomía táctil y validaciones de campo no vacío.
2. Permitir la alternancia de perfiles de usuario (*Técnico* vs *Encargado Admin*) para pruebas de los distintos flujos.
3. Establecer la identidad visual del producto con el nombre y logotipo de **VaultTecno**.

Respeta estrictamente el principio de **UI Tonta**: la pantalla no realiza peticiones HTTP directas ni modifica la base de datos; simplemente delega la acción a `AuthProvider` y reacciona al resultado.

---

## 2. Funciones y Widgets Clave (Para señalar en pantalla)

### 🔹 Controladores y Estados Locales (Líneas 20-30)
- **Dónde señalar:** Declaraciones `_emailController`, `_passwordController`, `_obscurePassword` y `_selectedRole`.
- **Qué hace:** Gestionan el texto de entrada y la visibilidad de la contraseña. El método `dispose()` destruye los controladores para evitar fugas de memoria (*memory leaks*).

### 🔹 `_onRoleChanged(UserRole role)` (Líneas 32-41)
- **Dónde señalar:** Método de cambio de rol.
- **Qué hace:** Actualiza `_selectedRole` y pre-rellena credenciales demostrativas (`carlos.tecnico@taller.com` o `admin.taller@taller.com`), acelerando las pruebas en vivo.

### 🔹 `_ejecutarLogin()` (Líneas 43-76)
- **Dónde señalar:** Función asíncrona de envío.
- **Qué hace:** 
  1. Valida localmente que los campos no estén vacíos (Early Return).
  2. Llama a `context.read<AuthProvider>().signIn(...)`.
  3. Comprueba `if (!mounted) return;` para evitar errores de contexto si el usuario salió de pantalla durante la petición.
  4. Si es exitoso, navega a la ruta principal mediante `context.go('/')`.

### 🔹 Isotipo Oficial VaultTecno (Líneas 96-146)
- **Dónde señalar:** Bloque del `Container` central con gradiente y escudo.
- **Qué hace:** Renderiza el logotipo vectorial nativo con gradiente azul oscuro (`#334155` a `#0F172A`), icono de escudo (`Icons.shield_rounded`), candado de bóveda y un acento ámbar (`AppColors.secondary`).

### 🔹 Selector Segmentado de Roles `_RoleTabButton` (Líneas 165-204 y 310-387)
- **Dónde señalar:** Píldora táctil superior al formulario.
- **Qué hace:** Proporciona un selector ergonómico para conmutar entre *Técnico* y *Encargado (Admin)* antes de entrar al sistema.

---

## 3. Preguntas de Examen (Defensa de Código en Vivo)

### ❓ Pregunta 1 del Docente:
> *“¿Por qué utilizas `context.read<AuthProvider>()` en `_ejecutarLogin()` pero usas `context.watch<AuthProvider>()` en el método `build()`?”*

📍 **Qué señalar en pantalla:**
Señala la **Línea 57** (`context.read`) y la **Línea 80** (`context.watch`).
🗣️ **Qué responder textualmente:**
> *"Excelente pregunta, ingeniero. `context.watch` se usa dentro del método `build` porque necesitamos que el widget se redibuje automáticamente cuando cambie el estado (por ejemplo, cuando `isLoading` pasa a `true` para mostrar el spinner). En cambio, dentro del callback `_ejecutarLogin()`, usamos `context.read` porque solo necesitamos invocar la función `signIn` una sola vez sin suscribir el método a cambios continuos de estado, evitando reconstrucciones innecesarias."*

---

### ❓ Pregunta 2 del Docente:
> *“¿Para qué sirve la línea `if (!mounted) return;` antes de ejecutar `context.go('/')`?”*

📍 **Qué señalar en pantalla:**
Señala la **Línea 64**.
🗣️ **Qué responder textualmente:**
> *"Es una buena práctica obligatoria de Flutter para operaciones asíncronas. Garantiza que el widget siga presente en el árbol de widgets después de que termine la llamada a la red en Supabase. Si el usuario cerró la pantalla mientras la petición estaba en curso, `!mounted` detiene la ejecución e impide un error de excepción por acceder a un `BuildContext` obsoleto."*

---

### ❓ Pregunta 3 del Docente:
> *“¿Por qué el botón de login deshabilita su `onPressed` cuando `isLoading` es `true`?”*

📍 **Qué señalar en pantalla:**
Señala la **Línea 261** (`onPressed: isLoading ? null : _ejecutarLogin`).
🗣️ **Qué responder textualmente:**
> *"Esto implementa el estándar arquitectónico de **Anti-Double Submit**. Al pasar `null` a `onPressed`, Flutter desactiva visual y físicamente el botón mientras la petición está en vuelo, impidiendo que un usuario impaciente presione varias veces y sature la base de datos con peticiones concurrentes."*
