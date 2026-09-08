# Documento de Especificación de Requisitos de Software (SRS)
# Gestión de Repuestos Reservados — Taller Técnico

---

| Campo | Detalle |
|---|---|
| **Versión** | 0.3 |
| **Fecha** | Septiembre 2026 |
| **Estado** | En desarrollo activo — infraestructura base completada, UI pendiente |
| **Materia** | IHC |
| **Alcance** | Producto Mínimo Viable — una sola funcionalidad principal |

---

## Historial de Revisiones

| Versión | Fecha | Autor | Descripción |
|---|---|---|---|
| 0.1 | Ago 2026 | Equipo | Primera versión, sin formato de trazabilidad ni glosario |
| 0.2 | Ago 2026 | Equipo | Reestructurado con formato profesional, dimensionado al alcance real del MVP (8 RF, sin infraestructura de despliegue innecesaria) |
| 0.3 | Sep 2026 | Equipo + Antigravity | Actualizado para reflejar avances de infraestructura: proyecto Supabase creado, schema SQL ejecutado, repositorios Dart implementados, esqueleto Flutter completo. Se elimina el status "borrador" del modelo de datos. Se agrega sección 10 de estado de implementación. |

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
9. Apéndice — Resumen de requisitos y reparto de roles
10. **[NUEVO]** Estado de implementación al 19/08/2026

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
| Repository | Clase Dart que encapsula toda comunicación con Supabase. La UI nunca accede a Supabase directamente. |
| Seed Data | Datos de prueba precargados en la base de datos para facilitar el desarrollo visual de la UI. |

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
- Visibilidad de "Mis reservas" acotada al técnico logueado — confirmado en pareja (audio de Marco, 18/08).
- **[v0.3]** No se implementará Auth de Supabase en la fase inicial de desarrollo UI — los `tecnicoId` se pasan como constantes de prueba (`'22222222-2222-2222-2222-222222222222'`) mientras el integrante encargado de UI valida el flujo visual. Auth se integrará en una fase posterior antes de la entrega final.

---

## 3. Arquitectura técnica (resumen)

| Capa | Tecnología | Estado |
|---|---|---|
| Mobile | Flutter (Android prioritario) | Esqueleto creado — pantallas en desarrollo |
| Backend/DB | Supabase (PostgreSQL + Realtime + Auth + RLS) | ✅ Operativo — tablas y seed data cargados |
| Estado en cliente | Provider | Pendiente de implementar en providers |
| API intermedia propia | Ninguna (decisión YAGNI) | — |
| Credenciales | `--dart-define` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) | ✅ Configurado |

La organización de carpetas del proyecto está documentada por separado en `estructura-proyecto.md`. Ver también `docs/guia-integracion-equipo.md` para instrucciones de cómo correr la app y consumir los repositorios.

---

## 4. Requisitos funcionales

| ID | Requisito | Origen / Trazabilidad | Estado |
|---|---|---|---|
| RF-01 | El sistema debe permitir buscar un repuesto por nombre o categoría. | Flujo v0.1, paso 2 | Repository ✅ — UI ⏳ |
| RF-02 | El sistema debe mostrar el estado del repuesto: disponible o reservado. | Flujo v0.1, paso 3 | Repository ✅ — UI ⏳ |
| RF-03 | Si está reservado, el sistema debe mostrar el equipo/motivo de destino. | Flujo v0.1, paso 4 | Repository ✅ — UI ⏳ |
| RF-04 | El sistema debe permitir reservar un repuesto disponible, indicando el equipo/motivo de destino. | App map v0.1, sección Reserva | Repository ✅ — UI ⏳ |
| RF-05 | El sistema debe confirmar visualmente el destino asignado al completar una reserva. | App map v0.1, sección Reserva | UI ⏳ |
| RF-06 | El sistema debe mostrar en "Mis reservas" únicamente las reservas hechas por el técnico logueado, no las de todo el taller. | Definido en pareja (audio de Marco, 18/08) | Repository ✅ — UI ⏳ |
| RF-07 | El sistema debe permitir liberar un repuesto reservado o marcarlo como usado, devolviéndolo a estado disponible. | App map v0.1, sección Repuestos | Repository ✅ — UI ⏳ |
| RF-08 | El sistema debe mostrar un resumen con el conteo de repuestos disponibles y reservados al abrir la app. | App map v0.1, sección Inicio | Repository ✅ — UI ⏳ |

**Leyenda:** ✅ Implementado | ⏳ Pendiente | ❌ Bloqueado

---

## 5. Requisitos no funcionales

| ID | Requisito | Justificación | Estado |
|---|---|---|---|
| RNF-01 | Consultar el estado de un repuesto no debe tomar más de 3 toques desde la pantalla de inicio. | Persona: abandona procesos largos | ⏳ (depende de navegación UI) |
| RNF-02 | Los cambios de estado deben propagarse a otros dispositivos en menos de 2 segundos. | RF-08, visibilidad compartida en tiempo real | Repository ✅ (stream Realtime) — UI ⏳ |
| RNF-03 | La interfaz debe ser operable con mínima interacción (una mano libre). | Contexto: técnico con manos ocupadas durante reparación | ⏳ (criterio de diseño UI) |
| RNF-04 | El acceso a los datos debe estar restringido por taller mediante autenticación (Supabase RLS). | Seguridad básica | ✅ RLS habilitada — políticas definitivas pendientes |
| RNF-05 | La aplicación debe funcionar en Android de gama media. No se garantiza soporte iOS en esta versión. | Contexto real del taller | ⏳ (pruebas al finalizar UI) |
| RNF-06 | El sistema debe impedir que dos técnicos reserven el mismo repuesto simultáneamente, mediante una restricción a nivel de base de datos. | Riesgo de condición de carrera (18/08) | ✅ Implementado en `reserva_repository.dart` mediante filtro `.eq('estado', 'disponible')` en la mutación |

---

## 6. Modelo de datos

> **[v0.3]** Modelo implementado en producción. Tablas creadas en Supabase. Ya no es borrador.

```
Tienda
├─ id            UUID PRIMARY KEY DEFAULT gen_random_uuid()
└─ nombre        TEXT NOT NULL
└─ created_at    TIMESTAMPTZ NOT NULL DEFAULT now()

Tecnico
├─ id            UUID PRIMARY KEY DEFAULT gen_random_uuid()
├─ nombre        TEXT NOT NULL
├─ tienda_id     UUID NOT NULL → tienda(id) ON DELETE CASCADE
└─ created_at    TIMESTAMPTZ NOT NULL DEFAULT now()

Repuesto
├─ id            UUID PRIMARY KEY DEFAULT gen_random_uuid()
├─ nombre        TEXT NOT NULL
├─ categoria     TEXT NOT NULL
├─ estado        TEXT NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'reservado'))
├─ tienda_id     UUID NOT NULL → tienda(id) ON DELETE CASCADE
├─ equipo_destino TEXT NULL
├─ motivo        TEXT NULL
├─ reservado_por UUID NULL → tecnico(id) ON DELETE SET NULL
├─ fecha_reserva TIMESTAMPTZ NULL
└─ created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
```

**RLS:** Habilitada en las 3 tablas. Políticas temporales de solo lectura activas durante desarrollo. Políticas definitivas por taller/técnico se implementarán antes de la entrega final.

**Nota:** el modelo se mantiene mínimo a propósito. Campos del backlog (precio, proveedor, vencimiento) se agregan cuando ese requisito entre formalmente al alcance — no antes.

---

## 7. Fuera de alcance

Heredado del Brief v0.2/v0.3: control de precios, reposición de productos, vencimientos, proveedores, ganancias, gestión completa de reparaciones, clasificación general del inventario, soporte multi-tienda, modo offline.

---

## 8. Glosario

Ver tabla de definiciones en sección 1.3 — no se duplica contenido; para un proyecto de este tamaño, un solo glosario compacto es suficiente y evita mantener dos listas sincronizadas.

---

## 9. Apéndice — Resumen de requisitos y reparto de roles

| Bloque | Requisitos | Rol sugerido |
|---|---|---|
| Consulta de estado | RF-01, RF-02, RF-03, RF-08, RNF-01, RNF-02 | Integrante 1 (Marco — Flutter UI) |
| Reserva y liberación | RF-04, RF-05, RF-06, RF-07, RNF-06 | Integrante 2 |
| Infraestructura (Supabase, schema, repositorios) | RNF-04, RNF-05 | Integrante 1 (Adolfo) ✅ Completado |

*El reparto es una sugerencia inicial — ajustarlo según cómo se sientan más cómodos trabajando cada uno.*

---

## 10. Estado de Implementación al 19/08/2026

> Sección nueva en v0.3. Documenta el avance real del proyecto al momento de esta revisión.

### ✅ Completado

| Artefacto | Archivo | Descripción |
|---|---|---|
| Proyecto Supabase | — (cloud) | Proyecto `tecnico-inventario` creado en Supabase. RLS habilitada. |
| Schema SQL | `supabase/migrations/0001_init_schema.sql` | Tablas `tienda`, `tecnico`, `repuesto` con tipos, constraints y RLS |
| Políticas RLS temporales | `supabase/migrations/0001_init_schema.sql` | SELECT abierto a `anon`/`authenticated` para desarrollo |
| Datos de prueba (seed) | `supabase/seed.sql` | 1 tienda, 2 técnicos, 4 repuestos (2 disponibles, 2 reservados) |
| Modelo Dart | `lib/features/repuestos/data/repuesto_model.dart` | Clase inmutable con `fromJson`, `toJson`, `copyWith` |
| Repository de repuestos | `lib/features/repuestos/data/repuesto_repository.dart` | `getRepuestos`, `buscarRepuestos`, `getRepuestoById`, `getConteoResumen`, `escucharRepuestosRealtime` |
| Repository de reservas | `lib/features/reservas/data/reserva_repository.dart` | `reservarRepuesto` (atómico), `liberarRepuesto`, `marcarComoUsado`, `getMisReservas` |
| Configuración Supabase | `lib/core/supabase_client.dart` | Credenciales via `--dart-define`, sin hardcoding |
| Esqueleto Flutter | `lib/` completo | Todas las screens y widgets con placeholders comentados |
| pubspec.yaml | `pubspec.yaml` | Dependencias `provider: ^6.1.2`, `supabase_flutter: ^2.5.6` |
| Protección de secretos | `.gitignore` | `docs/supabase-contraseña.md` excluido del repositorio |
| Guía para el equipo | `docs/guia-integracion-equipo.md` | Instrucciones de ejecución, IDs de prueba, ejemplos de uso de los repositorios |

### ⏳ Pendiente

| Tarea | Responsable | Prioridad |
|---|---|---|
| Implementar `RepuestosProvider` (ChangeNotifier) | Marco | Alta |
| Implementar `ReservasProvider` (ChangeNotifier) | Marco | Alta |
| UI: `InicioScreen` con conteo real (RF-08) | Marco | Alta |
| UI: `RepuestosListScreen` con búsqueda (RF-01) | Marco | Alta |
| UI: `RepuestoDetailScreen` con estado (RF-02, RF-03) | Marco | Alta |
| UI: `ReservarScreen` formulario (RF-04, RF-05) | Marco | Alta |
| UI: `MisReservasScreen` (RF-06) | Marco | Alta |
| UI: Acción liberar/marcar usado (RF-07) | Marco | Media |
| `AppTheme` con paleta de colores definida | Equipo | Media |
| GoRouter: árbol de rutas completo en `main.dart` | Marco | Alta |
| Políticas RLS definitivas por taller | Adolfo | Antes de entrega |
| Integración Auth de Supabase | Ambos | Antes de entrega |
