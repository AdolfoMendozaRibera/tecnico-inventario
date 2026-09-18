---
title: "Defensa de Código: AuthProvider (Estado de Sesión y Roles)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - provider
  - auth
  - supabase
  - roles
---

# `AuthProvider` — Gestión Global de Sesión y Roles

> **Ubicación del Archivo:** [`proyecto/lib/features/auth/providers/auth_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/auth/providers/auth_provider.dart)

---

## 1. Propósito General: ¿Qué problema resuelve y por qué es esencial?

En una aplicación de taller con múltiples usuarios, la interfaz necesita saber en todo momento **quién está conectado** y **qué rol tiene** (`admin` vs `empleado`).

Sin este archivo:
- No habría forma de saber si quien usa la app es un técnico que solo debe gestionar sus propias piezas o un encargado que puede auditar las reservas de todo el taller.
- La lógica de autenticación estaría duplicada dentro de los Widgets (violando el principio de **UI Tonta / Lógica Ciega**).

`AuthProvider` centraliza el ciclo de vida de la sesión con Supabase y notifica a los widgets cuando el usuario inicia o cierra sesión o cuando cambia de rol.

---

## 2. Funciones y Métodos Clave (Para señalar en pantalla)

### 🔹 `enum UserRole { admin, empleado }` (Líneas 6-9)
- **Dónde señalar:** Inicio del archivo.
- **Qué hace:** Define el contrato fuertemente tipado de los dos perfiles de usuario del taller. Evita usar "strings mágicos" como `"admin"` en la UI.

### 🔹 Getters de Permisos: `isAdmin`, `isEmpleado`, `displayName` (Líneas 18-31)
- **Dónde señalar:** Debajo de las variables privadas de `AuthProvider`.
- **Qué hace:** Permite que cualquier pantalla consulte `context.watch<AuthProvider>().isAdmin` para mostrar u ocultar botones administrativos de forma reactiva.

### 🔹 `_initSession()` y `_detectRoleFromUser()` (Líneas 37-55)
- **Dónde señalar:** Métodos internos llamados en el constructor.
- **Qué hace:** Al abrir la app, recupera la sesión activa persistida en Supabase (`auth.currentUser`) y lee los metadatos o el email del usuario para asignar el rol correspondiente sin forzar un login repetido.

### 🔹 `signIn(email, password, {preferredRole})` (Líneas 64-91)
- **Dónde señalar:** Función asíncrona principal.
- **Qué hace:** 
  1. Activa `_isLoading = true` y limpia errores previos.
  2. Llama a `SupabaseService.client.auth.signInWithPassword(...)`.
  3. Guarda el `User` resultante en `_currentUser`, asigna el rol y ejecuta `notifyListeners()` para redibujar la app.
  4. Si las credenciales fallan, captura la excepción y guarda un mensaje comprensible en `_errorMessage`.

### 🔹 `signOut()` (Líneas 94-105)
- **Dónde señalar:** Final de la clase.
- **Qué hace:** Cierra la sesión en Supabase (`auth.signOut()`), resetea `_currentUser = null` y notifica a los widgets para que la app regrese a la pantalla de login.

---

## 3. Preguntas de Examen (Defensa de Código en Vivo)

### ❓ Pregunta 1 del Docente:
> *“Muéstrame en el código cómo sabe la aplicación si el usuario actual es un Administrador o un Técnico.”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 47-54 (`_detectRoleFromUser`)** y a los **getters de las Líneas 18-19**.
🗣️ **Qué responder textualmente:**
> *"Aquí en `_detectRoleFromUser`, leemos los metadatos del usuario (`userMetadata['role']`) retornados por Supabase tras autenticar. Si contiene 'admin', asignamos `_currentRole = UserRole.admin`. Luego, cualquier Widget del árbol puede consultar el getter booleano `isAdmin` para condicionar su interfaz de forma limpia y desacoplada."*

---

### ❓ Pregunta 2 del Docente:
> *“¿Por qué utilizas `ChangeNotifier` y `notifyListeners()` en lugar de manejar el estado con `setState` en la pantalla de login?”*

📍 **Qué señalar en pantalla:**
Señala la declaración `class AuthProvider extends ChangeNotifier` (**Línea 11**) y el llamado `notifyListeners()` en las **Líneas 83 y 103**.
🗣️ **Qué responder textualmente:**
> *"Porque la sesión y el rol no pertenecen a una sola pantalla; son un estado global que afecta a toda la aplicación (como el Dashboard, Inventario y Reservas). Al extender de `ChangeNotifier`, inyectamos este provider en el `main.dart` con `MultiProvider`, permitiendo que cualquier pantalla reaccione a los cambios de autenticación sin acoplar la lógica de red a la vista."*

---

### ❓ Pregunta 3 del Docente:
> *“¿Qué pasa si se pierde la conexión a internet cuando el técnico intenta iniciar sesión?”*

📍 **Qué señalar en pantalla:**
Señala el bloque `try / catch` en las **Líneas 85-90**.
🗣️ **Qué responder textualmente:**
> *"El bloque `catch` intercepta el fallo de red, desactiva la bandera de carga (`_isLoading = false`) y asigna un mensaje en lenguaje humano a `_errorMessage` ('Credenciales incorrectas o error de conexión'). La UI recibe `false`, lee ese mensaje y despliega un `SnackBar` o banner de error sin provocar un crash de la aplicación."*
