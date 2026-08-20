import 'package:flutter/material.dart';

// features/repuestos/presentation/widgets/estado_badge.dart
//
// Responsabilidad: chip visual que muestra el estado de un repuesto.
// Usado en RepuestosListScreen y RepuestoDetailScreen.
//
// Dos variantes: 'disponible' (color verde del tema) | 'reservado' (color rojo/naranja del tema).
// REGLA: colores tomados de AppTheme, nunca hardcodeados aquí.

class EstadoBadge extends StatelessWidget {
  final String estado; // 'disponible' | 'reservado'

  const EstadoBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    // TODO: Usar AppConstants.estadoDisponible / estadoReservado para comparar
    // TODO: Aplicar color y etiqueta según estado
    // TODO: Usar tokens de color de Theme.of(context)
    return Chip(label: Text(estado));
  }
}
