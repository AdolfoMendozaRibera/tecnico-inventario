import 'package:flutter/material.dart';

// shared/widgets/loading_indicator.dart
//
// Responsabilidad: indicador de carga reutilizable entre todas las features.
// Usado en cualquier pantalla que consume datos de Supabase mientras espera respuesta.
//
// REGLA: estilo (colores, tamaño) tomado del tema — sin hardcoding.

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Centrar y aplicar color del tema (Theme.of(context).colorScheme.primary)
    return const Center(child: CircularProgressIndicator());
  }
}
