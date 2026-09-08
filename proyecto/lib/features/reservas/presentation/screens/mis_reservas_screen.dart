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
                      final accion = await showDialog<String>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: Text(
                            'Gestionar Repuesto',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¿Qué acción deseas realizar con "${repuesto.nombre}"?',
                                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade800),
                              ),
                              if (repuesto.equipoDestino != null && repuesto.equipoDestino!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Asignado a: ${repuesto.equipoDestino}',
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 18),
                              // Opción 1: Marcar como Usado (Consumir repuesto)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => Navigator.pop(ctx, 'usar'),
                                  icon: const Icon(Icons.check_circle, size: 18, color: Colors.black),
                                  label: Text(
                                    'Marcar como Usado',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD400),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Opción 2: Liberar (Devolver al taller)
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => Navigator.pop(ctx, 'liberar'),
                                  icon: const Icon(Icons.undo, size: 18, color: Colors.black87),
                                  label: Text(
                                    'Liberar al Taller',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black87),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.grey.shade400),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, null),
                              child: Text(
                                'Cancelar',
                                style: GoogleFonts.inter(color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (accion == null || !context.mounted) return;

                      if (accion == 'usar') {
                        final exito = await provider.marcarComoUsado(repuesto.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(exito
                                  ? 'Repuesto marcado como usado (descontado del inventario)'
                                  : 'Error al marcar como usado: ${provider.lastError ?? "Rechazado por Supabase"}'),
                              backgroundColor: exito ? Colors.black87 : Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      } else if (accion == 'liberar') {
                        final exito = await provider.liberarRepuesto(repuesto.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(exito
                                  ? 'Repuesto liberado y devuelto a disponibles en el taller'
                                  : 'Error al liberar el repuesto.'),
                              backgroundColor: exito ? Colors.black87 : Theme.of(context).colorScheme.error,
                            ),
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
