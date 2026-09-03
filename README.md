# 🛠️ Gestión de Repuestos Reservados — Taller Técnico

> **Proyecto Académico — Interacción Humano-Computador (IHC)**  
> Aplicación móvil interna para la gestión y sincronización en tiempo real del estado de repuestos electrónicos entre técnicos de un taller.

---

## 👥 Información del Proyecto

* **Materia:** Interacción Humano-Computador (IHC)
* **Tipo de Proyecto:** Aplicación Móvil / Web
* **Modalidad:** En Pareja
* **Integrantes:**
  * **Adolfo Mendoza Ribera**
  * **Marco Guzman Montalvan**

---

## 🎯 Propósito y Contexto del Problema

En los talleres de reparación electrónica donde laboran múltiples técnicos, un problema crítico y recurrente es el **uso indebido de repuestos**: piezas apartadas para la reparación de un equipo específico terminan siendo utilizadas por otro técnico por falta de visibilidad inmediata.

Esta aplicación resuelve ese problema ofreciendo un flujo ágil de un solo módulo, permitiendo a los técnicos:
1. Saber de forma inmediata si un repuesto está **disponible** o **reservado**.
2. **Apartar un repuesto** asociándolo al equipo destino y motivo de la reparación.
3. Consultar rápidamente **"Mis Reservas"** con vista en detalle (fecha, categoría, motivo).
4. **Liberar o marcar como usado** el repuesto al finalizar la reparación.

---

## 🚀 Funcionalidades Principales (Alcance MVP)

* **📊 Resumen del Taller (Inicio):** Visualización general del estado del taller con tarjetas de métricas en tiempo real (*Disponibles* y *Reservados*).
* **📦 Inventario de Repuestos:** Exploración por pestañas de repuestos disponibles y reservados.
* **🔒 Flujo de Reserva Rápido:** Formulario ágil para apartar piezas indicando equipo del cliente y motivo.
* **📋 Mis Reservas Activas:** Tarjetas interactivas con doble estado (modo compacto y modo detalle expandible con fecha y categoría).
* **⚡ Liberación Inmediata:** Acción de liberar repuestos para retornarlos automáticamente al inventario disponible.
* **🔐 Autenticación de Técnicos:** Acceso seguro con perfiles vinculados a la tienda mediante Supabase Auth.

---

## 🛠️ Tecnologías Utilizadas

* **Framework:** [Flutter](https://flutter.dev/) (Dart `>=3.7.0 <4.0.0`)
* **Gestión de Estado:** [Provider](https://pub.dev/packages/provider)
* **Navegación:** [GoRouter](https://pub.dev/packages/go_router)
* **Backend como Servicio (BaaS):** [Supabase](https://supabase.com/)
  * Base de datos relacional PostgreSQL.
  * Autenticación con Row Level Security (RLS).
  * Soporte en tiempo real (Realtime).
* **Tipografía & Diseño:**
  * Diseño basado en **Figma** con componentes de estados interactivos (*Default*, *Hover*, *Pressed*).
  * Fuente oficial: **Inter** vía [google_fonts](https://pub.dev/packages/google_fonts).

---

## 📁 Arquitectura del Proyecto (Feature-First)

El proyecto sigue una arquitectura **Feature-First** para máxima modularidad y simplicidad:

```text
proyecto/
├── lib/
│   ├── main.dart                      # Punto de entrada de la app
│   ├── core/                          # Código transversal
│   │   ├── supabase_client.dart       # Conexión y credenciales de Supabase
│   │   ├── theme/                     # Tokens de colores Figma y AppTheme
│   │   │   ├── app_colors.dart
│   │   │   └── app_theme.dart
│   │   └── widgets/                   # Componentes base con estados
│   │       ├── active_badge.dart      # Badge de estado interactivo (3 estados)
│   │       └── reservation_card.dart  # Tarjeta de reserva (colapsada / expandida)
│   │
│   └── features/                      # Módulos independientes por funcionalidad
│       ├── auth/                      # Login y registro de técnicos
│       ├── home/                      # Contenedor principal y barra de navegación
│       ├── inicio/                    # Pantalla de resumen del taller
│       ├── repuestos/                 # Modelos, listas y providers de repuestos
│       └── reservas/                  # Pantallas de reserva y mis reservas activas
│
├── docs/                              # Documentación del proyecto (SRS, notas, brief)
└── supabase/                          # Esquemas SQL, migraciones y políticas RLS
```

---

## 💻 Guía de Instalación y Ejecución Local

### Prerrequisitos
* [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (versión 3.27+ recomendada).
* Navegador Google Chrome o Microsoft Edge.

### Pasos para ejecutar

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/AdolfoMendozaRibera/tecnico-inventario.git
   cd tecnico-inventario
   ```

2. **Instalar dependencias:**
   ```bash
   cd proyecto
   flutter pub get
   ```

3. **Ejecutar en el navegador:**
   * En Google Chrome:
     ```bash
     flutter run -d chrome
     ```
   * O en Microsoft Edge:
     ```bash
     flutter run -d edge
     ```

4. **Verificar calidad del código:**
   ```bash
   flutter analyze
   ```
