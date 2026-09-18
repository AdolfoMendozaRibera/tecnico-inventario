---
title: "Capa 0: Capa Transversal — Auth, Roles y Sistema Base"
date: 2026-09-17
author: Preparación de Defensa Técnica
tags:
  - defensa-codigo
  - capa-0
  - auth
  - arquitectura
  - obsidian-ready
---

# Capa Transversal 0: Arquitectura Base, Seguridad y Roles

> [!NOTE]
> **Concepto Clave para el Evaluador:** Esta capa **NO es un flujo de negocio**, sino la **infraestructura transversal** que autentica al usuario, gobierna qué datos puede ver según su rol (`admin` vs `empleado`) e inyecta el sistema de diseño visual de **VaultTecno**.

---

## 🗂️ Mapa de Archivos de la Capa 0

| Archivo | Ruta Relativa | Responsabilidad Principal |
|---|---|---|
| [[01_AuthProvider]] | `lib/features/auth/providers/auth_provider.dart` | Estado global de sesión, rol activo y permisos. |
| [[02_LoginScreen]] | `lib/features/auth/presentation/screens/login_screen.dart` | UI de acceso, selector de rol visual e isotipo VaultTecno. |
| [[03_SupabaseClient]] | `lib/core/supabase_client.dart` | Wrapper e inicialización singleton de Supabase. |
| [[04_DesignSystem_Theme]] | `lib/core/theme/app_colors.dart` & `app_theme.dart` | Tokenización atómica y escala tipográfica. |
| [[05_Main_Router]] | `lib/main.dart` | Entrypoint, inyección de Providers y GoRouter. |

---

## 🎯 Resumen Rápido para Defender en Vivo

Si el docente pregunta: *“¿Por qué el login no es el Flujo 1?”*
- **Respuesta exacta:** *"Ingeniero, el login es una capa de soporte de seguridad (Capa 0). Los flujos de negocio del sistema son los que generan valor operativo al taller: Búsqueda (F1), Reserva (F2), Cierre de Reserva (F3) y Alta de Repuestos (F4). La Capa 0 únicamente modula qué información y botones ve un técnico frente a un encargado."*
