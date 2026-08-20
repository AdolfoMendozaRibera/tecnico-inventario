# Documento de Especificación de Requisitos de Software (SRS)
# Gestión de Repuestos Reservados — Taller Técnico

---

| Campo | Detalle |
|---|---|
| **Versión** | 0.2 |
| **Fecha** | Agosto 2026 |
| **Estado** | Brief v0.3 — MVP para entrega de octubre |
| **Materia** | IHC |
| **Alcance** | Producto Mínimo Viable — una sola funcionalidad principal |

---

## Historial de Revisiones

| Versión | Fecha | Autor | Descripción |
|---|---|---|---|
| 0.1 | Ago 2026 | Equipo | Primera versión, sin formato de trazabilidad ni glosario |
| 0.2 | Ago 2026 | Equipo | Reestructurado con formato profesional, dimensionado al alcance real del MVP (8 RF, sin infraestructura de despliegue innecesaria) |

---

## Tabla de Contenidos

1. Introducción
2. Descripción general
3. Arquitectura técnica (resumen — ver `estructura-proyecto.md` para detalle de carpetas)
4. Requisitos funcionales
5. Requisitos no funcionales
6. Modelo de datos
7. Fuera de alcance
8. Glosario
9. Apéndice — Resumen de requisitos

---

## 1. Introducción

### 1.1 Propósito
Especificar los requisitos funcionales y no funcionales del MVP que permite a técnicos de un taller compartir el estado de disponibilidad/reserva de repuestos, evitando el uso indebido de piezas ya destinadas a otro equipo.

Este documento cubre **únicamente el alcance definido para la primera entrega** (Brief v0.2/v0.3). No es un documento de producto final — las funcionalidades del backlog (vencimientos, proveedores, ganancias) se especificarán en versiones futuras de este mismo documento, cuando corresponda.

### 1.2 Alcance
Aplicación móvil interna, de un solo módulo, para consultar y gestionar el estado de reserva de repuestos dentro de un taller.

### 1.3 Definiciones y acrónimos

| Término | Definición |
|---|---|
| RF | Requisito Funcional |
| RNF | Requisito No Funcional |
| RLS | Row Level Security — seguridad a nivel de fila en PostgreSQL/Supabase |
| MVP | Minimum Viable Product |
| Realtime | Suscripción a cambios de base de datos en vivo, vía Supabase |
| Repuesto | Producto o pieza del inventario del taller |
| Reservar | Marcar un repuesto como destinado a un equipo específico |
| Liberar | Quitar el estado de reserva de un repuesto |

---

## 2. Descripción general

### 2.1 Perspectiva del producto
Aplicación nueva e independiente. Sin integraciones externas ni sistemas heredados.

### 2.2 Usuario objetivo
Ver **Persona v0.1** (Carlos): técnico que comparte inventario con otra persona, usa el celular entre reparaciones, abandona procesos con demasiados pasos.

### 2.3 Restricciones generales
- Alcance limitado a lo definido en Brief v0.2 punto 06 — no incluir funciones fuera de ese punto sin actualizar antes este documento.
- Plazo: primera entrega principios de octubre 2026.
- Equipo de 2 personas — los requisitos están dimensionados para poder repartirse en paralelo sin bloquearse mutuamente (ver sección 9).

### 2.4 Supuestos y dependencias
- **Conectividad estable asumida** (validado con el usuario entrevistado). Riesgo declarado: sin soporte offline en esta versión; si falla la conexión en el momento crítico, el sistema no puede prevenir un error de uso indebido. Se documenta como riesgo aceptado, no como omisión accidental.
- Un solo taller por instancia de la app (sin multi-tienda).
- Visibilidad de "Mis reservas" acotada al técnico logueado — confirmado en pareja (ver sección 4, RF-06).

---

## 3. Arquitectura técnica (resumen)

| Capa | Tecnología |
|---|---|
| Mobile | Flutter (Android prioritario) |
| Backend/DB | Supabase (PostgreSQL + Realtime + Auth + RLS) |
| Estado en cliente | Provider |
| API intermedia propia | Ninguna en esta versión (decisión YAGNI — se evalúa agregar si la lógica de negocio crece) |

La organización de carpetas del proyecto está documentada por separado en `estructura-proyecto.md`, para no mezclar la especificación de requisitos (qué debe hacer el sistema) con la organización del código (cómo está construido) — son documentos con ciclos de actualización distintos.

---

## 4. Requisitos funcionales

| ID | Requisito | Origen / Trazabilidad |
|---|---|---|
| RF-01 | El sistema debe permitir buscar un repuesto por nombre o categoría. | Flujo v0.1, paso 2 |
| RF-02 | El sistema debe mostrar el estado del repuesto: disponible o reservado. | Flujo v0.1, paso 3 |
| RF-03 | Si está reservado, el sistema debe mostrar el equipo/motivo de destino. | Flujo v0.1, paso 4 |
| RF-04 | El sistema debe permitir reservar un repuesto disponible, indicando el equipo/motivo de destino. | App map v0.1, sección Reserva |
| RF-05 | El sistema debe confirmar visualmente el destino asignado al completar una reserva. | App map v0.1, sección Reserva |
| RF-06 | El sistema debe mostrar en "Mis reservas" únicamente las reservas hechas por el técnico logueado, no las de todo el taller. | Definido en pareja (audio de Marco, 18/08) |
| RF-07 | El sistema debe permitir liberar un repuesto reservado o marcarlo como usado, devolviéndolo a estado disponible. | App map v0.1, sección Repuestos |
| RF-08 | El sistema debe mostrar un resumen con el conteo de repuestos disponibles y reservados al abrir la app. | App map v0.1, sección Inicio |

---

## 5. Requisitos no funcionales

| ID | Requisito | Justificación |
|---|---|---|
| RNF-01 | Consultar el estado de un repuesto no debe tomar más de 3 toques desde la pantalla de inicio. | Persona: abandona procesos largos |
| RNF-02 | Los cambios de estado deben propagarse a otros dispositivos en menos de 2 segundos. | RF-08, visibilidad compartida en tiempo real |
| RNF-03 | La interfaz debe ser operable con mínima interacción (una mano libre). | Contexto: técnico con manos ocupadas durante reparación |
| RNF-04 | El acceso a los datos debe estar restringido por taller mediante autenticación (Supabase RLS). | Seguridad básica |
| RNF-05 | La aplicación debe funcionar en Android de gama media. No se garantiza soporte iOS en esta versión. | Contexto real del taller |
| RNF-06 | El sistema debe impedir que dos técnicos reserven el mismo repuesto simultáneamente, mediante una restricción a nivel de base de datos — no únicamente validación en la interfaz. | Riesgo de condición de carrera identificado en revisión de arquitectura (18/08) |

---

## 6. Modelo de datos (borrador)

```
Tecnico
├─ id
├─ nombre
└─ tienda_id (FK)

Tienda
├─ id
└─ nombre

Repuesto
├─ id
├─ nombre
├─ categoria
├─ estado (disponible / reservado)
├─ tienda_id (FK)
├─ equipo_destino (nullable)
├─ motivo (nullable)
├─ reservado_por (FK a Tecnico, nullable)
└─ fecha_reserva (nullable)
```

**Nota:** el modelo se mantiene mínimo a propósito. Campos del backlog (precio, proveedor, vencimiento) se agregan cuando ese requisito entre formalmente al alcance — no antes.

---

## 7. Fuera de alcance

Heredado del Brief v0.2/v0.3: control de precios, reposición de productos, vencimientos, proveedores, ganancias, gestión completa de reparaciones, clasificación general del inventario, soporte multi-tienda, modo offline.

---

## 8. Glosario

Ver tabla de definiciones en sección 1.3 — no se duplica contenido; para un proyecto de este tamaño, un solo glosario compacto es suficiente y evita mantener dos listas sincronizadas.

---

## 9. Apéndice — Resumen de requisitos y posible reparto de roles

| Bloque | Requisitos | Rol sugerido |
|---|---|---|
| Consulta de estado | RF-01, RF-02, RF-03, RF-08, RNF-01, RNF-02 | Integrante 1 |
| Reserva y liberación | RF-04, RF-05, RF-06, RF-07, RNF-06 | Integrante 2 |
| Transversal (Auth, RLS, Realtime) | RNF-04, RNF-05 | Ambos, en conjunto, antes de dividir lo demás |

*El reparto es una sugerencia inicial — ajustarlo según cómo se sientan más cómodos trabajando cada uno.*
