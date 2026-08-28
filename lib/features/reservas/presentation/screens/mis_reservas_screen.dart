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
    
    // Datos de prueba (UI estática)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0), // Escala 8px: 16 (margen general)
          children: [
            // Orientar
            const Padding(
              padding: EdgeInsets.only(bottom: 24.0), // Escala 8px: 24
              child: Text(
                'Tienes 2 repuestos reservados listos para usar.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            
            // Informar & Actuar
            _buildReservaCard(
              context,
              repuesto: 'Pantalla Samsung S20',
              equipo: 'Samsung S20 (Cliente: Juan P.)',
              fecha: 'Hoy, 10:30 AM',
            ),
            const SizedBox(height: 16), // Escala 8px: 16 (separación entre tarjetas)
            
            _buildReservaCard(
              context,
              repuesto: 'Batería iPhone 13',
              equipo: 'iPhone 13 Pro (Cliente: María L.)',
              fecha: 'Ayer, 04:15 PM',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservaCard(BuildContext context, {required String repuesto, required String equipo, required String fecha}) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Escala 8px: 16
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Escala 8px: 16
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8, // Escala 8px
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jerarquía 1: Dato principal
          Text(
            repuesto,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8), // Escala 8px: 8
          
          // Jerarquía 2: Información secundaria
          Row(
            children: [
              Icon(Icons.devices, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8), // Escala 8px: 8
              Expanded(
                child: Text(
                  equipo,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Escala 8px: 8
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8), // Escala 8px: 8
              Text(
                fecha,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 24), // Escala 8px: 24 (separando info de acciones)
          
          // Jerarquía 3: Acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12), // Espaciado
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Liberar', style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(width: 16), // Escala 8px: 16
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12), // Espaciado
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Marcar Usado', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
