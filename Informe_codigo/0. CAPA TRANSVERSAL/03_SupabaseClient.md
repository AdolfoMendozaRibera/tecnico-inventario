---
title: "Defensa de Código: SupabaseService (Cliente y Conexión Backend)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - supabase
  - singleton
  - backend
  - wrappers
---

# `SupabaseService` — Wrapper y Conexión Centralizada al Backend

> **Ubicación del Archivo:** [`proyecto/lib/core/supabase_client.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/core/supabase_client.dart)

---

## 1. Propósito General: ¿Qué problema resuelve y por qué es esencial?

Cumple con el **Principio de Agnosticismo y Wrappers** de nuestra arquitectura limpia:
- En lugar de llamar directamente al SDK de Supabase o inicializarlo disperso por múltiples archivos, centraliza la URL del proyecto, la clave pública anon y el acceso al cliente en un único punto.
- Si mañana cambia la URL del backend o se migra de proveedor, solo se modifica este archivo en toda la aplicación.

---

## 2. Funciones y Métodos Clave (Para señalar en pantalla)

### 🔹 `initialize()` (Líneas 4-9)
- **Dónde señalar:** Método estático asíncrono.
- **Qué hace:** Es invocado en el `main()` antes de `runApp()`. Inicializa el motor de `Supabase.initialize(...)` con la URL del cluster en la nube y su clave de acceso público autorizada.

### 🔹 `get client` (Línea 11)
- **Dónde señalar:** Getter estático `static SupabaseClient get client`.
- **Qué hace:** Provee acceso bajo el patrón **Singleton** a la instancia activa de `Supabase.instance.client`, permitiendo realizar consultas a tablas (`from('repuestos')`), autenticación (`auth`) y llamadas RPC desde cualquier servicio o provider sin instanciar múltiples conexiones.

---

## 3. Preguntas de Examen (Defensa de Código en Vivo)

### ❓ Pregunta 1 del Docente:
> *“¿Por qué la clave `publishableKey` (o anon key) está visible en este archivo en lugar de estar completamente oculta?”*

📍 **Qué señalar en pantalla:**
Señala la **Línea 7**.
🗣️ **Qué responder textualmente:**
> *"La clave que se utiliza en clientes móviles de Supabase es la **clave pública anónima (Anon Key / Publishable Key)**. Por diseño de arquitectura de Supabase, esta clave es de lectura pública y la seguridad real **no depende de ocultar esta clave**, sino de las políticas de seguridad **RLS (Row Level Security)** y procedimientos almacenados en la base de datos PostgreSQL en el backend."*

---

### ❓ Pregunta 2 del Docente:
> *“¿Por qué este método es estático (`static`) y no una clase que se instancie con `new SupabaseService()`?”*

📍 **Qué señalar en pantalla:**
Señala la palabra `static` en las **Líneas 4 y 11**.
🗣️ **Qué responder textualmente:**
> *"Porque el cliente de Supabase debe ser un **Singleton global**. Al definirlo como estático, garantizamos que toda la aplicación comparta la misma conexión HTTP y el mismo pool de sockets para sincronización en tiempo real, evitando fugas de conexiones hacia la base de datos."*
