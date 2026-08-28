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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Técnico Inventario', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Escala 8px: 24
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Orientar
              const Text(
                'Resumen de hoy',
                style: TextStyle(
                  fontSize: 28, // Jerarquía: Título principal
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // Escala 8px: 8
              const Text(
                'Hola Carlos, este es el estado actual del inventario.',
                style: TextStyle(
                  fontSize: 16, // Jerarquía: Subtítulo
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32), // Escala 8px: 32 (Separación entre secciones)
              
              // Informar
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Disponibles',
                      count: '142',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16), // Escala 8px: 16
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Reservados',
                      count: '12',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              
              // Actuar
              SizedBox(
                width: double.infinity,
                height: 56, // Escala 8px: 56
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navegar a lista
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Escala 8px: 16
                    ),
                  ),
                  child: const Text(
                    'VER REPUESTOS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String count, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Escala 8px: 16
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16), // Escala 8px: 16
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14, // Jerarquía: etiqueta secundaria
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8), // Escala 8px: 8
          Text(
            count,
            style: TextStyle(
              fontSize: 32, // Jerarquía: Dato principal muy visible
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
