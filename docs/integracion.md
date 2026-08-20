1. Crear el proyecto en Supabase y anotar credenciales
Si todavía no lo hiciste, creá el proyecto en supabase.com. Anotá dos datos de la sección API Settings: la **URL del proyecto** y la **anon key** (clave pública, segura para el cliente). NO toques ni copies la 'service_role key' para nada de esto — esa es la que dijimos que nunca va en Flutter, rompe todas las RLS.


2. Generar y ejecutar el schema de tablas
Pedile a Antigravity el archivo `supabase/migrations/0001_init_schema.sql`, basándose en la sección 6 (Modelo de datos) del SRS v0.2 — las tablas Tecnico, Tienda y Repuesto. Revisá el SQL generado vos mismo antes de correrlo (nombres de columnas, tipos de dato) y recién después pegalo en el SQL Editor de Supabase para crear las tablas reales.


3. Política RLS mínima temporal (solo para poder ver datos)
Por defecto, si activás RLS en una tabla sin ninguna política, Supabase bloquea TODAS las consultas — Marco va a ver listas vacías y va a pensar que su código está mal cuando en realidad es la base de datos la que no deja pasar nada. Pedí una política simple de solo lectura (SELECT) para las tablas, marcada explícitamente como temporal en un comentario del SQL, para desbloquear el desarrollo. Las políticas reales y completas (incluyendo el RNF-06 de anti-duplicado) las armamos después, con más cuidado, no ahora bajo apuro.


4. Cargar datos de prueba (seed)
Insertá manualmente (o pedíle el SQL a Antigravity) 3-4 filas de ejemplo en Repuesto: algunos disponibles, alguno reservado con equipo_destino relleno. Sin esto, Marco va a conectar su UI a una tabla vacía y no va a poder verificar visualmente si su pantalla funciona bien.


5. Generar los modelos Dart
Pedíle a Antigravity que genere las clases Dart (`repuesto_model.dart`, etc.) reflejando exactamente las columnas del schema que ya creaste. Esto es lo que Marco va a usar para tipar sus widgets — sin esto, no sabe qué campos existen ni cómo se llaman.


6. Generar el repository con los métodos que Marco va a consumir
Esto es lo que realmente responde a lo que Marco pedía con 'hacé las APIs': pedíle a Antigravity que genere `repuesto_repository.dart` con las firmas de métodos que Marco va a llamar (ej. `Future<List<Repuesto>> getRepuestos()`, `Future<void> reservarRepuesto(...)`), aunque la implementación interna todavía sea simple. Esto es tu 'contrato' — Marco programa sus pantallas llamando a estos métodos, sin necesitar saber que por dentro hablan con Supabase.