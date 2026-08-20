import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../repuestos/providers/repuestos_provider.dart';

class ReservarScreen extends StatefulWidget {
  final String repuestoId;
  final String repuestoNombre;

  const ReservarScreen({
    super.key,
    required this.repuestoId,
    required this.repuestoNombre,
  });

  @override
  State<ReservarScreen> createState() => _ReservarScreenState();
}

class _ReservarScreenState extends State<ReservarScreen> {
  final _equipoController = TextEditingController();
  final _motivoController = TextEditingController();

  @override
  void dispose() {
    _equipoController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar Repuesto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue.withValues(alpha: 0.05),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Repuesto a reservar:', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      widget.repuestoNombre,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _equipoController,
              decoration: const InputDecoration(
                labelText: 'Equipo Destino (Requerido)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.computer),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _motivoController,
              decoration: const InputDecoration(
                labelText: 'Motivo (Opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (_equipoController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El equipo destino es requerido')),
                  );
                  return;
                }
                
                await context.read<RepuestosProvider>().reservarRepuesto(
                  widget.repuestoId, 
                  _equipoController.text.trim(), 
                  _motivoController.text.trim()
                );
                
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reserva confirmada')),
                  );
                }
              },
              child: const Text('Confirmar Reserva'),
            )
          ],
        ),
      ),
    );
  }
}
