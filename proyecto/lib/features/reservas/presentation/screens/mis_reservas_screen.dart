import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../repuestos/providers/repuestos_provider.dart';
import '../../../../core/widgets/reservation_card.dart';

class MisReservasScreen extends StatelessWidget {
  const MisReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis Reservas Activas',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: -0.4,
          ),
        ),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No tienes reservas activas', 
                      style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.fetchRepuestos(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                itemCount: repuestos.length,
                itemBuilder: (context, index) {
                  final repuesto = repuestos[index];
                  return ReservationCard(
                    repuesto: repuesto,
                    onLiberar: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            'Liberar Repuesto',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                          ),
                          content: Text(
                            '¿Deseas marcar como usado o liberar "${repuesto.nombre}" para que vuelva a estar disponible en el taller?',
                            style: GoogleFonts.inter(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Sí, Liberar'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await provider.liberarRepuesto(repuesto.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Repuesto liberado exitosamente')),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            );
          }
        ),
      ),
    );
  }
}
