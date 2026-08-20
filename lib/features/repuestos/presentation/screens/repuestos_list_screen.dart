import 'package:flutter/material.dart';

// features/repuestos/presentation/screens/repuestos_list_screen.dart
//
// RF-01: Permitir buscar un repuesto por nombre o categoría.
// RNF-01: Llegar a esta pantalla en máximo 2 toques desde InicioScreen.
// RNF-03: Operable con una sola mano.
//
// Estados visuales a manejar: Loading | Error | Empty | Lista con datos.
// UI "tonta": sin lógica de negocio ni llamadas directas a Supabase.

class RepuestosListScreen extends StatelessWidget {
  const RepuestosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Consumir RepuestosProvider (lista + estado de carga)
    // TODO: Campo de búsqueda que filtre por nombre o categoría (RF-01)
    // TODO: Cada ítem navega a RepuestoDetailScreen
    // TODO: Mostrar EstadoBadge (disponible/reservado) en cada ítem de la lista
    return const Scaffold(
      body: Center(child: Text('RepuestosListScreen — placeholder RF-01')),
    );
  }
}
