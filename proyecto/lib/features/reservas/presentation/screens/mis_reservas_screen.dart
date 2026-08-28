import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../repuestos/providers/repuestos_provider.dart';

class MisReservasScreen extends StatelessWidget {
  const MisReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas Activas', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<RepuestosProvider>(
          builder: (context, provider, child) {
            final repuestos = provider.misReservas;
            
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (repuestos.isEmpty) {
              return const Center(
                child: Text(
                  'No tienes reservas activas', 
                  style: TextStyle(fontSize: 16, color: Colors.grey)
                )
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(24.0), // Escala 8px: 24 (margen general)
              itemCount: repuestos.length,
              itemBuilder: (context, index) {
                final repuesto = repuestos[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0), // Escala 8px: 16
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              repuesto.nombre,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Chip(
                            label: Text('Activa', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            backgroundColor: Colors.orangeAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Escala 8px: 8
                      
                      // Jerarquía 2: Información secundaria
                      Row(
                        children: [
                          Icon(Icons.devices, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 8), // Escala 8px: 8
                          Expanded(
                            child: Text(
                              'Destino: ${repuesto.equipoDestino ?? "N/A"}',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      
                      if (repuesto.motivo != null && repuesto.motivo!.isNotEmpty) ...[
                        const SizedBox(height: 8), // Escala 8px: 8
                        Row(
                          children: [
                            Icon(Icons.notes, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 8), // Escala 8px: 8
                            Expanded(
                              child: Text(
                                'Motivo: ${repuesto.motivo}',
                                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 24), // Escala 8px: 24 (separando info de acciones)
                      
                      // Jerarquía 3: Acción
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                provider.liberarRepuesto(repuesto.id);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12), // Espaciado
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Marcar Usado / Liberar', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }
        ),
      ),
    );
  }
}
