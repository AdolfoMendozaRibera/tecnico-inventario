import 'package:flutter/material.dart';

// features/reservas/presentation/screens/reservar_screen.dart
//
// RF-04: Permitir reservar un repuesto disponible, indicando equipo/motivo de destino.
// RF-05: Confirmar visualmente el destino asignado al completar la reserva.
// RNF-03: Operable con una sola mano — mínimo de campos y toques.
//
// Flujo:
//   1. Técnico llega aquí desde RepuestoDetailScreen (repuesto disponible)
//   2. Ingresa equipoDestino y motivo
//   3. Confirma → ReservasProvider llama a ReservaRepository.reservarRepuesto() (RNF-06: atómico)
//   4. Feedback visual de éxito (RF-05) o error
//
// UI "tonta": sin lógica de negocio ni llamadas directas a Supabase.

class ReservarScreen extends StatelessWidget {
  final String repuestoId;

  const ReservarScreen({super.key, required this.repuestoId});

  @override
  Widget build(BuildContext context) {
    // TODO: Formulario con campos: equipoDestino (texto), motivo (texto)
    // TODO: Botón "Confirmar reserva" → dispara evento al ReservasProvider
    // TODO: Manejar estado de loading mientras se ejecuta la operación
    // TODO: Mostrar confirmación visual (RF-05) o mensaje de error
    return const Scaffold(
      body: Center(child: Text('ReservarScreen — placeholder RF-04, RF-05')),
    );
  }
}
