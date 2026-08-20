import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../repuestos/providers/repuestos_provider.dart';

class MisReservasScreen extends StatelessWidget {
  const MisReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas Activas'),
      ),
      body: Consumer<RepuestosProvider>(
        builder: (context, provider, child) {
          final repuestos = provider.misReservas;
          
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (repuestos.isEmpty) {
            return const Center(child: Text('No tienes reservas activas'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: repuestos.length,
            itemBuilder: (context, index) {
              final repuesto = repuestos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              repuesto.nombre,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Chip(
                            label: Text('Activa'),
                            backgroundColor: Colors.orangeAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Destino: ${repuesto.equipoDestino ?? "N/A"}'),
                      if (repuesto.motivo != null && repuesto.motivo!.isNotEmpty)
                        Text('Motivo: ${repuesto.motivo}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              provider.liberarRepuesto(repuesto.id);
                            },
                            child: const Text('Marcar Usado / Liberar'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
