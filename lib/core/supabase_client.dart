import 'package:supabase_flutter/supabase_flutter.dart';

/// Encapsulación del cliente de Supabase.
///
/// REGLA: Las credenciales van únicamente por variables de entorno
/// (`--dart-define` o `String.fromEnvironment`), NUNCA hardcodeadas en Git.
class AppSupabase {
  AppSupabase._();

  /// Inicializa la conexión con Supabase en el `main.dart`.
  static Future<void> init() async {
    const url = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: '',
    );
    const anonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: '',
    );

    if (url.isEmpty || anonKey.isEmpty) {
      // Advertencia en desarrollo si no se pasan por --dart-define
      print(
        '⚠️ ADVERTENCIA: SUPABASE_URL o SUPABASE_ANON_KEY no fueron provistas via --dart-define.',
      );
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  /// Instancia global de Supabase
  static SupabaseClient get client => Supabase.instance.client;
}
