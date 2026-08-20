import 'package:flutter/material.dart';

// features/repuestos/presentation/screens/inicio_screen.dart
//
// RF-08: Mostrar resumen con conteo de repuestos disponibles y reservados al abrir la app.
// RNF-01: Consultar estado de un repuesto en máximo 3 toques desde esta pantalla.
// RNF-02: Los conteos deben reflejar cambios en tiempo real (Supabase Realtime).
//
// UI "tonta": solo muestra datos que recibe del provider. Sin lógica de negocio aquí.

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Consumir RepuestosProvider para obtener conteo disponibles/reservados
    // TODO: Botón/navegación hacia RepuestosListScreen (RF-01)
    return const Scaffold(
      body: Center(child: Text('InicioScreen — placeholder RF-08')),
    );
  }
}
