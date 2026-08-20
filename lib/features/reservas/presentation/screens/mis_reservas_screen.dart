import 'package:flutter/material.dart';

// features/reservas/presentation/screens/mis_reservas_screen.dart
//
// RF-06: Mostrar ÚNICAMENTE las reservas hechas por el técnico logueado,
//        no las de todo el taller.
//        Filtro crítico: se aplica en la query de Supabase (server-side), no en la UI.
//
// Estados visuales a manejar: Loading | Error | Empty | Lista de reservas propias.
// UI "tonta": sin lógica de negocio ni llamadas directas a Supabase.

class MisReservasScreen extends StatelessWidget {
  const MisReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Consumir ReservasProvider.misReservas (ya filtradas por tecnicoId)
    // TODO: Cada ítem muestra: nombre repuesto, equipoDestino, fechaReserva
    // TODO: Acción "Liberar" o "Marcar usado" por ítem → RF-07
    return const Scaffold(
      body: Center(child: Text('MisReservasScreen — placeholder RF-06')),
    );
  }
}
