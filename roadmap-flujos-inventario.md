# ROADMAP DE FLUJOS — APP INVENTARIO DE REPUESTOS (Flutter)

Documento de trabajo para ir tachando mientras se construye en Antigravity. Se apoya en `reglas-arquitectura-flutter-mobile.md` — cualquier ítem marcado ⚠️ rompe alguna de esas reglas tal como está hoy.

---

## 0. CAPA TRANSVERSAL: AUTH + ROLES (NO es un flujo, va por defecto)

Login, recuperar contraseña y el sistema de roles **no se listan como Flujo N**. Son infraestructura de acceso (sección 5 de las reglas) que ya debería existir antes de construir cualquier flujo de negocio, y que **modula** los flujos existentes en vez de sumar uno nuevo.

- [ ] Login + recuperar contraseña (JWT + `flutter_secure_storage`, ya cubierto por reglas de seguridad).
- [ ] Definir roles mínimos: `admin` (o "encargado de taller") vs `empleado` (técnico).
- [ ] RLS en Supabase/policies en NestJS reflejando esos dos roles.
- [ ] Definir, por cada flujo existente, **qué cambia según el rol** (ver tabla abajo). No se construye un flujo nuevo para esto — se agrega un filtro/condicional dentro del flujo ya existente.

| Flujo | ¿Cambia algo por rol? |
|---|---|
| Flujo 1 — Búsqueda | No. `admin` y `empleado` ven el mismo inventario. |
| Flujo 2 — Reserva | No en el flujo en sí, pero solo puede reservar quien esté logueado como técnico activo. |
| Flujo 3 — Gestión de reservas | **Sí, es el punto crítico.** `empleado` ve solo "Mis Reservas". `admin` necesita ver "Reservas del Taller" (de todos) — ver sección 5. |
| Flujo 4 — Alta/Edición/Baja | Alta: cualquier técnico. Edición de datos maestros (ubicación, SKU) y Baja por daño: recomendado restringir a `admin` o encargado de inventario. |

---

## 1. FLUJO 1 — Búsqueda y Consulta (Exploración)

**Estado:** bien planteado, no está fusionado. Pendientes:

- [ ] Agregar estado **Error** (banner + "Reintentar") si la búsqueda pega a la API.
- [ ] Separar dos "empty states" distintos:
  - [ ] Inventario del taller vacío (primer uso de la app).
  - [ ] Búsqueda sin resultados ("No encontramos ese repuesto…" + botón "Registrar este Repuesto").
- [ ] Confirmar si el debounce de 220ms dispara red o filtra local:
  - Si es red → subir a 300–350ms.
  - Si es local sobre datos cacheados → dejar en 220ms.
- [ ] Diferenciar visualmente (cuando exista Flujo de Solicitud) el botón "Registrar este Repuesto" del futuro "Solicitar Pieza Faltante" para que el técnico no confunda "lo tengo en mano" con "no lo tengo, que lo compren".

---

## 2. FLUJO 2 — Reserva Atómica

**Estado:** sólido. Pendientes:

- [ ] ⚠️ Verificar que la atomicidad sea real a nivel DB (`SELECT FOR UPDATE` u optimistic locking con campo de versión en Prisma/Postgres), no solo una validación en el service antes del `update`.
- [ ] Agregar CTAs a la pantalla de éxito ("Ver Mis Reservas" / "Buscar otro repuesto") para consistencia con Flujo 4.
- [ ] **Marcar este flujo como online-only.** No permitir modo offline/cola de sincronización aquí — la garantía de "solo uno gana la pieza" depende del servidor. Mostrar mensaje claro si no hay conexión: *"Necesitas conexión para reservar, así evitamos que dos personas tomen la misma pieza"*.

---

## 3. FLUJO 3 — Gestión de Reservas Activas

**Estado:** ⚠️ acá están los dos problemas detectados.

### 3A. Separar responsabilidades (fusión de flujos)
- [ ] Dividir en el código (Notifiers/controllers separados) aunque la UI del bottom sheet se mantenga unificada:
  - **3A — Cierre de ciclo:** Consumir / Liberar (mutación irreversible de stock).
  - **3B — Edición de reserva activa:** actualizar equipo/motivo (no toca stock).
- [ ] Agregar anti-double-submit a los botones de confirmación de los modales verde (Consumir) y rojo (Liberar) — hoy solo está explícito en Flujo 2.
- [ ] Agregar estado **Empty** a "Mis Reservas" ("No tienes repuestos reservados").

### 3B. Extensión admin (esto resuelve el "Flujo 5" que faltaba)
- [ ] La pantalla "Mis Reservas" para `admin` pasa a ser (o convive con) **"Reservas del Taller"**, con filtro por técnico.
- [ ] El mismo bottom sheet de "Gestionar tu Reserva" se reutiliza — un `admin` puede liberar/editar/consumir una reserva ajena (ej. técnico de vacaciones que dejó una pieza apartada).
- [ ] Mostrar el nombre del técnico dueño de cada reserva cuando el que mira es `admin`.
- [ ] Confirmar RLS: `empleado` solo puede mutar sus propias reservas vía API aunque manipule la UI; `admin` puede mutar cualquiera.

---

## 4. FLUJO 4 — Registro de Nuevo Repuesto (Alta) + su mitad faltante (Edición/Reubicación/Baja)

**Estado:** ✅ **Completado y validado**.
- [x] Agregar anti-double-submit explícito en "Confirmar y Guardar".
- [x] Pedir permiso de cámara justo al tocar "Escanear", no antes.
- [x] **Completar el CRUD**:
  - [x] Vista de detalle/ficha técnica completa (SKU, compatibilidades, notas).
  - [x] Modo edición táctil (ubicación física en taller, datos maestros, notas técnicas) con validaciones.
  - [x] Baja por daño/merma — con modal de confirmación destructiva (`ModalBajaRepuesto`), selector de motivo y anti-double submit.
  - [x] Restricción de baja y edición según rol (`admin` / `empleado`).

---

## 5. PANTALLA PRINCIPAL / DASHBOARD (era tu "Opción 4" — no es un flujo N, es el shell)

No compite con los demás, es la base de navegación de la que cuelga todo. Constrúyela primero.

- [ ] KPIs básicos: reservas activas hoy, repuestos instalados este mes, categoría más usada.
- [ ] Accesos directos a tareas frecuentes (Buscar, Mis Reservas, Registrar Repuesto).
- [ ] Vista diferenciada por rol: `empleado` ve sus propios números; `admin` ve agregados del taller completo (técnico con más consumo, reservas de todos).
- [ ] Respeta thumb zone / `BottomNavigationBar` para los accesos directos.

---

## 5. FLUJO 5 — Historial y Trazabilidad de Reparaciones

**Estado:** ✅ **Completado y validado**.
- [x] Lista de trazabilidad con consulta unificada (`estado in ('usado', 'baja')`).
- [x] Micro-KPIs: total de repuestos instalados y total dados de baja/merma.
- [x] Filtros rápidos tipo chip: Por período (*Hoy, Esta semana, Este mes, Todo*) y por tipo (*Todos, Instalados, Bajas*).
- [x] Búsqueda predictiva con debounce por repuesto, destino, motivo o técnico.
- [x] Filtro de técnico para rol `admin`.
- [x] Ficha de trazabilidad completa de solo lectura (`DetalleHistorialSheet`) con destino, motivo, notas, SKU, fecha y técnico.
- [x] 4 estados de borde (Skeleton loading, Empty State con reseteo de filtros, Error con reintento, Overflow en ListView con Pull-to-refresh).

---

## 6. BACKLOG (siguiente flujo)

- [ ] **Solicitud de Repuesto Faltante** (tu "Opción 3"): botón "Solicitar Pieza Faltante" desde zero-results de Flujo 1, formulario rápido (equipo + urgencia), pestaña "Mis Solicitudes Pendientes". Va último porque depende de un proceso de compras fuera de la app.

---

## 7. ORDEN DE CONSTRUCCIÓN RECOMENDADO

1. Auth + Roles (capa 0) — si no existe todavía, va antes que cualquier flujo.
2. Dashboard/Home (sección 5) — shell de navegación.
3. Ajustes de Flujo 1 (estados de borde faltantes).
4. Ajustes de Flujo 2 (atomicidad real + online-only).
5. Separación 3A/3B + extensión admin de Flujo 3.
6. Completar Flujo 4 con Edición/Reubicación/Baja.
7. Historial y Trazabilidad.
8. Solicitud de Repuesto Faltante.

---

## 8. CHECKLIST RÁPIDO DE CIERRE (antes de dar por terminado cada flujo)

- [ ] ¿Tiene los 4 estados de borde (Loading/Empty/Error/Overflow)?
- [ ] ¿Los botones de mutación tienen anti-double-submit?
- [ ] ¿Se decidió explícitamente si es online-only u offline-first?
- [ ] ¿El rol correcto puede/no puede ejecutar cada acción (RLS + UI)?
- [ ] ¿Los mensajes de error/empty están en lenguaje humano, no técnico?
- [ ] ¿No se está mezclando más de una responsabilidad de negocio en el mismo controller/Notifier?
