import 'package:flutter/material.dart';

// core/theme/app_theme.dart
//
// Responsabilidad: definir el sistema de diseño completo de la app.
// REGLA: nunca usar colores o medidas hardcodeadas fuera de este archivo.
// Todos los widgets deben referenciar Theme.of(context) o las constantes definidas aquí.
//
// TODO: Definir paleta de colores (ColorScheme)
// TODO: Definir tipografía (TextTheme)
// TODO: Definir tema de botones, inputs, chips (para EstadoBadge)

class AppTheme {
  AppTheme._(); // No instanciable

  static ThemeData get light => ThemeData(
        // TODO: completar con tokens de diseño reales
        useMaterial3: true,
      );
}
