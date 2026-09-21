# 🚀 VaultTecno — Información Completa y Ficha Técnica de la Aplicación

> Este documento contiene **toda la información relevante, técnica, funcional y de negocio** de la aplicación móvil **VaultTecno**. Está estructurado especialmente para servir como fuente de contenido para construir una página landing de descarga del APK, portal corporativo o presentación de proyecto.

---

## 📱 1. Resumen Ejecutivo (Pitch del Producto)

**VaultTecno** es una aplicación móvil nativa (Android) de **Gestión Inteligente de Inventario y Trazabilidad de Repuestos** diseñada específicamente para **talleres de reparación electrónica y servicio técnico de dispositivos**.

Resuelve el desorden habitual en talleres donde las piezas se pierden, se toman sin registrar o se generan disputas entre técnicos por el uso de componentes limitados. A través de un sistema de **reservas atómicas**, **trazabilidad en tiempo real** y **control de stock parcial**, VaultTecno transforma la gestión caótica en un flujo digital auditado y transparente.

---

## 💥 2. Problemas que Resuelve y Solución de Negocio

| Problema Habitual en Talleres | Solución de VaultTecno |
| :--- | :--- |
| **Pérdida y descontrol de stock:** No se sabe si una pantalla o batería realmente está en estantería o ya la tomó otro técnico. | **Inventario Centralizado y Sincronizado:** Visualización instantánea de stock *Disponible* vs. *Reservado* con sincronización en la nube. |
| **Reserva duplicada (Double Booking):** Dos técnicos intentan usar el mismo repuesto al mismo tiempo. | **Reservas Atómicas (Online-Only):** Mutación directa en base de datos con prevención de condiciones de carrera. Solo un técnico logra apartar la pieza. |
| **Falta de Trazabilidad:** Piezas que desaparecen sin saber en qué reparación o dispositivo se instalaron. | **Historial Completo de Reparaciones:** Registro inalterable con técnico responsable, equipo de destino, motivo y marca de tiempo ISO UTC. |
| **Mermas sin justificación:** Repuestos dañados durante la instalación que se tiran a la basura sin reporte. | **Flujo de Baja por Daño/Merma:** Proceso auditado con motivo descriptivo para control de calidad e inventario físico. |
| **Fricción al operar:** Aplicaciones lentas o complejas que entorpecen el trabajo manual del técnico en mesa. | **Diseño Ergonómico (Thumb Zone):** Interfaz optimizada para uso a una sola mano, respuestas hápticas y cero botones ocultos. |

---

## 👥 3. Perfiles y Sistema de Roles

La aplicación opera bajo un esquema de **Seguridad y Control de Acceso basado en Roles (RBAC)** con políticas RLS (Row Level Security) directas en PostgreSQL:

### 1️⃣ Técnico de Reparaciones (`empleado`)
* **Enfoque:** Operación diaria y agilidad en mesa de trabajo.
* **Permisos:** 
  * Explorar catálogo general del taller.
  * Reservar repuestos (selección por cantidad, equipo destino y motivo).
  * Gestionar **sus propias reservas** (marcar como usado, liberar al taller parcial/totalmente, editar datos de destino).
  * Dar de baja repuestos por daño durante su trabajo.
  * Consultar su historial de repuestos instalados y bajas.

### 2️⃣ Encargado / Administrador de Taller (`admin`)
* **Enfoque:** Auditoría, supervisión, gestión de stock y toma de decisiones.
* **Permisos:**
  * Todo lo que hace el Técnico +
  * **Vista global "Reservas del Taller":** Monitorear y gestionar las reservas activas de **todos los técnicos** (ideal si un técnico falta o deja una pieza apartada).
  * **Historial Global y Filtro por Técnico:** Filtrar el historial por cualquier técnico del taller para revisar rendimiento o uso de componentes.
  * **Edición de Datos Maestros:** Modificar SKU, ubicación física en estantería y detalles de piezas.
  * **Baja Directa por Inventario:** Dar de baja unidades obsoletas o dañadas en recepción.

---

## 🔄 4. Los 4 Flujos Principales de la Aplicación

```
                    ┌─────────────────────────┐
                    │    CATÁLOGO DISPONIBLE  │
                    └────────────┬────────────┘
                                 │ (Flujo 2: Reserva Atómica)
                                 ▼
                    ┌─────────────────────────┐
                    │     RESERVA ACTIVA      │
                    └────┬────────────────┬───┘
                         │                │
(Flujo 3A: Liberar)      │                │ (Flujo 3A: Marcar como Usado)
                         ▼                ▼
       ┌───────────────────┐    ┌───────────────────┐
       │ DE VUELTA A STOCK │    │ HISTORIAL USADOS  │
       └───────────────────┘    └───────────────────┘
                                          ▲
(Flujo 4: Baja Directa por Daño)          │
──────────────────────────────────────────┘
```

### 🔍 Flujo 1 — Búsqueda, Filtro y Consulta de Inventario
* **Objetivo:** Encontrar piezas en menos de 3 segundos.
* **Características:**
  * Búsqueda en vivo por nombre o categoría con debounce optimizado.
  * Filtros de estado rápido (*Todos*, *Disponibles*, *Reservados*).
  * **Ficha Técnica Contextual:** Muestra ubicación física en taller (ej. *Caja B3 - Estante 2*), SKU, categoría y estado.
  * **Estados de Borde Resilientes:** Skeleton loaders shimmer para cargas, vista de inventario vacío y pantalla de *sin resultados de búsqueda* con acceso rápido a registrar nueva pieza.

### 🔒 Flujo 2 — Reserva Atómica de Repuestos
* **Objetivo:** Apartar una pieza de forma inmediata sin riesgo de colisión.
* **Características:**
  * Formulario ergométrico con Stepper interactivo (`+` / `-`) o teclado numérico para seleccionar cantidad.
  * Campo obligatorio de **Equipo Destino** (ej. *Redmi Note 10 Azul*) y **Motivo**.
  * **Atomicidad en Base de Datos:** `UPDATE repuesto SET estado = 'reservado' WHERE id = $1 AND estado = 'disponible'`. Si otro técnico la toma en el mismo milisegundo, la app notifica el conflicto y refresca el catálogo.
  * **Modo Online-Only:** Exige conexión para prevenir reservas duplicadas.
  * Nivel de confirmación con respuesta háptica (`HapticFeedback.lightImpact()`) y comprobante visual con datos de trazabilidad.

### 🔄 Flujo 3 — Gestión de Reservas Activas (Consumo y Devolución Parcial)
* **Objetivo:** Administrar las piezas apartadas mientras se realiza la reparación.
* **Características:**
  * **Operaciones Parciales por Cantidad:** Si un técnico reservó 5 piezas y usa 3, el sistema registra 3 como *Usadas* y mantiene 2 en *Reserva*.
  * **Acciones Rápidas:**
    * **Marcar como Usado:** Descuenta del inventario e ingresa al Historial de Reparaciones.
    * **Liberar al Taller:** Devuelve la pieza al catálogo público para que otros técnicos la usen.
    * **Editar Reserva:** Corregir equipo destino o notas.
  * **Banner de Retroalimentación Humana:** Notificación verde esmeralda (`#10B981`) que confirma el resultado exacto durante 3 segundos.
  * **Seguridad Admin:** El encargado puede auditar o liberar reservas de cualquier técnico desde la pestaña de *Taller*.

### 📝 Flujo 4 — Registro, Edición y Baja por Daño (CRUD Completo)
* **Objetivo:** Mantener el catálogo maestro actualizado.
* **Características:**
  * **Alta de Repuestos:** Formulario rápido con nombre, categoría, cantidad inicial y datos opcionales (SKU, ubicación en taller).
  * **Edición de Repuestos:** Modificación táctil de datos maestros.
  * **Baja por Daño / Merma:** Flujo de descarte con confirmación destructiva y motivo explicativo (ej. *Flex roto en instalación*).

### 📜 Flujo 5 — Historial y Trazabilidad de Reparaciones
* **Objetivo:** Auditoría total del consumo del taller.
* **Características:**
  * Registro unificado de repuestos **Usados (Instalados)** y **Bajas (Mermas)**.
  * **Micro-KPIs:** Total de piezas instaladas con éxito vs. total dadas de baja.
  * **Filtros por Período:** *Hoy*, *Esta semana*, *Este mes*, *Todo el tiempo*.
  * **Filtros por Tipo y Búsqueda Predictiva:** Búsqueda por repuesto, cliente/equipo, motivo o técnico.
  * Ficha de trazabilidad de solo lectura (`DetalleHistorialSheet`).

---

## 🎨 5. Diseño, Estética y Experiencia de Usuario (UX/UI)

* **Paleta de Colores Curada (Slate & Accent):**
  * Slate Oscuro (`#0F172A` / `#1E293B`): Estructura, navegación y jerarquía de texto.
  * Verde Esmeralda (`#10B981` / `#D1FAE5`): Estados disponibles, confirmaciones y repuestos instalados.
  * Ámbar Warm (`#F59E0B` / `#FEF3C7`): Reservas activas y atención requerida.
  * Rojo Coral (`#EF4444` / `#FEE2E2`): Bajas por daño y acciones de eliminación.
* **Tipografía:** Google Fonts **Inter** (100% legible, aspecto limpio y técnico).
* **Regla del Pulgar (Thumb Zone):** Menús, botones de acción y modales ubicados en el tercio inferior de la pantalla para operar fácilmente con una mano en el taller.
* **Anti-Double Submit:** Todos los botones de confirmación se inhabilitan y muestran estados de carga (`CircularProgressIndicator`) durante las peticiones para evitar registros duplicados.

---

## 🛠️ 6. Arquitectura Técnica y Tecnologías

| Componente | Tecnología Utilizada | Razón de Elección |
| :--- | :--- | :--- |
| **Frontend Mobile** | Flutter 3.x (Dart 3) | Rendimiento nativo, excelente fluidez de renders a 60/120 fps. |
| **Backend / DB** | Supabase (PostgreSQL) | BD relacional potente, APIs REST inmediatas y autenticación segura. |
| **Autenticación** | Supabase Auth | Manejo de Tokens JWT y metadatos de usuario encriptados. |
| **Seguridad DB** | Row Level Security (RLS) | Reglas de acceso ejecutadas a nivel servidor/BD, evitando manipulaciones. |
| **Navegación** | `go_router` | Rutas declarativas y protegidas por autenticación/rol. |
| **Gestión de Estado** | Provider / ChangeNotifier | Reactividad limpia, ligera y eficiente. |

---

## 📊 7. Datos de Prueba / Credenciales para Demostración Web

Para publicar en la página web de descarga y permitir que los evaluadores o clientes prueben la aplicación en vivo, se sugieren las siguientes credenciales de prueba preconfiguradas:

```
┌──────────────────────────────────────────────────────────┐
│                   CREDENCIALES DE PRUEBA                 │
├──────────────────────────┬───────────────────────────────┤
│ ROL ENCARGADO / ADMIN    │ ROL TÉCNICO / EMPLEADO        │
├──────────────────────────┼───────────────────────────────┤
│ Email: admin@taller.com  │ Email: tecnico@taller.com     │
│ Pass:  password123       │ Pass:  password123            │
└──────────────────────────┴───────────────────────────────┘
```

---

## 💡 8. Frases Destacadas (Highlights para Landing Page)

* ⚡ *"De la estantería al equipo del cliente en 3 toques."*
* 🔒 *"Cero repuestos duplicados: Reservas atómicas validadas en la nube."*
* 📊 *"Trazabilidad total: Sabrás exactamente qué técnico instaló cada repuesto y en qué dispositivo."*
* 📱 *"Diseñado para el taller: Interfaz ergonómica de una sola mano."*
* 🛡️ *"Control de stock parcial: Reserva 5, usa 3 y devuelve 2 con un solo deslizamiento."*

---

> Documento generado automáticamente para soporte de despliegue y landing page — **VaultTecno v0.5**.
