# Guía de Integración y Avance del Proyecto
## Proyecto: Técnico-Inventario (IHC 2026)

Este documento detalla la infraestructura, el modelo de datos y los repositorios ya disponibles para conectar las pantallas de Flutter con Supabase.

---

## 🚀 Resumen del Avance Realizado

1. **Esquema de Base de Datos en Supabase (`0001_init_schema.sql`)**:
   - Tablas `tienda`, `tecnico` y `repuesto` creadas en Supabase con sus restricciones y llaves foráneas según el **SRS v0.2 §6**.
   - Habilitación de **RLS (Row Level Security)** con política temporal de lectura para agilizar las pruebas visuales en Flutter.
   - Restricción de unicidad/estado para la reserva atómica (**RNF-06**).

2. **Datos de Prueba Iniciales (Seed Data)**:
   - Ya se insertó una tienda de prueba, dos técnicos de prueba y 4 repuestos (2 disponibles y 2 reservados) para poder probar la UI con datos reales desde el primer momento.

3. **Arquitectura Flutter (`lib/`)**:
   - Estructura *feature-first* creada (`core/`, `features/repuestos/`, `features/reservas/`, `shared/`).
   - Modelo Dart [`Repuesto`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/lib/features/repuestos/data/repuesto_model.dart) listo con mapeo `fromJson`, `toJson` y `copyWith`.
   - Repositorios [`RepuestoRepository`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/lib/features/repuestos/data/repuesto_repository.dart) y [`ReservaRepository`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/lib/features/reservas/data/reserva_repository.dart) listos con lógica de comunicación a Supabase.

---

## 🛠️ Cómo Ejecutar la App en Flutter

Para correr la app conectada a Supabase, pasa las variables de entorno mediante `--dart-define`:

```bash
flutter run --dart-define=SUPABASE_URL=https://ywpwpxxlfcdhjcpyuyob.supabase.co --dart-define=SUPABASE_ANON_KEY=sb_publishable_lATgQNDDi1XpwFTnof4zuQ_85_PDKvU
```

---

## 📡 Cómo Consumir las "APIs" / Repositorios desde los Widgets / Providers

### 1. Consultar y Buscar Repuestos (`RepuestoRepository`)

```dart
final repo = RepuestoRepository();

// Obtener todos los repuestos de una tienda (RF-01)
List<Repuesto> lista = await repo.getRepuestos(
  tiendaId: '11111111-1111-1111-1111-111111111111',
);

// Buscar por nombre o categoría (RF-01)
List<Repuesto> resultado = await repo.buscarRepuestos(
  tiendaId: '11111111-1111-1111-1111-111111111111',
  query: 'OLED',
);

// Resumen disponibles / reservados para Inicio (RF-08)
Map<String, int> conteo = await repo.getConteoResumen(
  tiendaId: '11111111-1111-1111-1111-111111111111',
);
// conteo['disponibles'], conteo['reservados']

// Escuchar cambios en vivo (RNF-02 - Realtime < 2s)
Stream<List<Repuesto>> stream = repo.escucharRepuestosRealtime(
  tiendaId: '11111111-1111-1111-1111-111111111111',
);
```

### 2. Reservar y Liberar Repuestos (`ReservaRepository`)

```dart
final reservaRepo = ReservaRepository();

// Reservar repuesto (RF-04, RF-05, RNF-06 atómico)
try {
  await reservaRepo.reservarRepuesto(
    repuestoId: 'a1111111-1111-1111-1111-111111111111',
    equipoDestino: 'Samsung A52 Azul - Pantalla rota',
    motivo: 'Cambio de display urgente',
    tecnicoId: '22222222-2222-2222-2222-222222222222',
  );
  // Mostrar confirmación visual (RF-05)
} catch (e) {
  // Manejar error si ya estaba reservado por otro técnico
}

// Obtener "Mis Reservas" del técnico logueado (RF-06)
List<Repuesto> misReservas = await reservaRepo.getMisReservas(
  tecnicoId: '22222222-2222-2222-2222-222222222222',
);

// Liberar o Marcar como usado (RF-07)
await reservaRepo.liberarRepuesto('b2222222-2222-2222-2222-222222222222');
```

---

## 🔑 IDs Fijos de Prueba en Supabase

Usa estos IDs para probar sin tener que crear auth todavía:

| Entidad | ID de prueba |
|---|---|
| **Tienda Central** | `'11111111-1111-1111-1111-111111111111'` |
| **Técnico Carlos** | `'22222222-2222-2222-2222-222222222222'` |
| **Técnico Marco** | `'33333333-3333-3333-3333-333333333333'` |
