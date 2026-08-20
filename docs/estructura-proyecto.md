# Estructura de carpetas del proyecto

> Referencia de arquitectura — actualizar cuando se agregue una feature nueva del backlog. No es parte del SRS (que dice *qué* debe hacer el sistema); este documento dice *cómo* está organizado el código.

## Por qué esta estructura (feature-first)

Se organiza por **funcionalidad**, no por capa técnica (evitamos Clean Architecture completa por ahora — sería sobre-ingeniería para 2 features). Cada carpeta dentro de `features/` es autocontenida: tiene sus propios modelos, pantallas y lógica de estado. Ventaja concreta: agregar una feature nueva del backlog (ej. vencimientos) significa crear una carpeta nueva, sin modificar las que ya existen y ya están probadas — reduce el riesgo de romper algo que funciona.

Si en el futuro una feature específica crece mucho en lógica de negocio (por ejemplo, reglas complejas de quién puede liberar la reserva de otro técnico), recién ahí se le agrega una subcarpeta `domain/` **solo a esa feature** — no a todo el proyecto de una vez.

## Árbol de carpetas

```
repo-raiz/
│
├── lib/
│   ├── main.dart
│   │
│   ├── core/                          # Código compartido por todo el proyecto
│   │   ├── supabase_client.dart       # Inicialización de Supabase
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── constants/
│   │       └── app_constants.dart
│   │
│   ├── features/
│   │   ├── repuestos/                 # RF-01, RF-02, RF-03, RF-08
│   │   │   ├── data/
│   │   │   │   ├── repuesto_model.dart
│   │   │   │   └── repuesto_repository.dart   # Llamadas a Supabase
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── inicio_screen.dart      # RF-08 (resumen)
│   │   │   │   │   ├── repuestos_list_screen.dart  # RF-01
│   │   │   │   │   └── repuesto_detail_screen.dart # RF-02, RF-03
│   │   │   │   └── widgets/
│   │   │   │       └── estado_badge.dart       # Chip visual disponible/reservado
│   │   │   └── providers/
│   │   │       └── repuestos_provider.dart
│   │   │
│   │   └── reservas/                  # RF-04, RF-05, RF-06, RF-07
│   │       ├── data/
│   │       │   └── reserva_repository.dart
│   │       ├── presentation/
│   │       │   ├── screens/
│   │       │   │   ├── reservar_screen.dart     # RF-04, RF-05
│   │       │   │   └── mis_reservas_screen.dart # RF-06
│   │       │   └── widgets/
│   │       └── providers/
│   │           └── reservas_provider.dart
│   │
│   └── shared/                        # Widgets reutilizables entre features
│       └── widgets/
│           └── loading_indicator.dart
│
├── supabase/
│   ├── migrations/
│   │   └── 0001_init_schema.sql       # Tablas: Tecnico, Tienda, Repuesto
│   └── policies/
│       └── repuestos_rls.sql          # Políticas RLS + constraint anti-race-condition (RNF-06)
│
├── docs/                              # Artefactos de la materia IHC, versionados junto al código
│   ├── brief-v0.2.md
│   ├── persona-v0.1.md
│   ├── app-map-v0.1.md
│   ├── flujo-v0.1.md
│   └── srs-v0.2.md
│
├── test/
│   └── (tests por feature, misma convención de carpetas)
│
├── pubspec.yaml
└── README.md                          # Instrucciones para ejecutar/revisar el proyecto
```

## Notas de uso

- **`docs/` dentro del repo:** así el docente (y cualquiera que clone el repo) encuentra el brief, la persona, el app map, el flujo y el SRS sin tener que buscarlos en Obsidian por separado. También cumple el checklist de la clase 3 ("Repositorio actualizado" + "README con instrucciones").
- **`supabase/policies/`:** las políticas RLS y la restricción anti-condición-de-carrera (RNF-06) quedan versionadas como código SQL, no solo configuradas manualmente en el panel de Supabase — así si alguno de los dos reconstruye el proyecto desde cero, no depende de recordar qué configuró en la web.
- **Reparto de trabajo:** con esta separación, Integrante 1 puede trabajar en `features/repuestos/` e Integrante 2 en `features/reservas/` en paralelo, sin pisarse archivos — coincide con el reparto sugerido en el SRS v0.2, sección 9.
