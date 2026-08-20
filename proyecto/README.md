# Reservas Taller

Aplicación móvil desarrollada en Flutter para la gestión de un taller mecánico. Permite administrar repuestos y realizar reservas.

## Características

- **Gestión de Repuestos**: Visualización y administración del inventario de repuestos.
- **Reservas**: Sistema para gestionar las reservas del taller.
- **Backend con Supabase**: Integración con Supabase para la base de datos y autenticación, utilizando Row Level Security (RLS) para proteger los datos.

## Estructura del Proyecto

El proyecto sigue una arquitectura estructurada por características (features):

- `lib/core/`: Configuraciones, tema y cliente de Supabase.
- `lib/features/repuestos/`: Módulo de inventario de repuestos.
- `lib/features/reservas/`: Módulo de gestión de reservas.
- `lib/shared/`: Widgets reutilizables.
- `supabase/`: Migraciones y políticas de seguridad (RLS) para la base de datos.

## Requisitos

- Flutter SDK (versión más reciente recomendada)
- Configuración de Supabase (URL y API Key) para el entorno.

## Configuración

1. Clonar el repositorio.
2. Ejecutar `flutter pub get` para instalar las dependencias.
3. Configurar las variables de entorno para Supabase.
4. Ejecutar la aplicación con `flutter run`.
