import 'package:flutter/material.dart';

// features/repuestos/presentation/screens/repuesto_detail_screen.dart
//
// RF-02: Mostrar el estado del repuesto: disponible o reservado.
// RF-03: Si está reservado, mostrar el equipo/motivo de destino.
// RNF-01: Esta pantalla es el 3er toque máximo desde InicioScreen.
//
// Estados visuales a manejar: Loading | Error | Detalle completo.
// UI "tonta": sin lógica de negocio ni llamadas directas a Supabase.

class RepuestoDetailScreen extends StatelessWidget {
  final String repuestoId;

  const RepuestoDetailScreen({super.key, required this.repuestoId});

  @override
  Widget build(BuildContext context) {
    // TODO: Consumir RepuestosProvider para obtener detalle por repuestoId
    // TODO: Mostrar EstadoBadge prominente (RF-02)
    // TODO: Si estado == 'reservado': mostrar equipoDestino y motivo (RF-03)
    // TODO: Botón "Reservar" → navegar a ReservarScreen (solo si disponible)
    // TODO: Botón "Liberar / Marcar usado" → disparar evento al ReservasProvider (RF-07)
    return const Scaffold(
      body: Center(child: Text('RepuestoDetailScreen — placeholder RF-02, RF-03')),
    );
  }
}
