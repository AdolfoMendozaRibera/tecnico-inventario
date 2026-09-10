import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/reservation_card.dart';
import '../../../../core/widgets/disponible_card.dart';
import '../../../reservas/presentation/screens/reservar_screen.dart';
import '../../../../core/supabase_client.dart';
import 'agregar_repuesto_form_screen.dart';

class RepuestosListScreen extends StatelessWidget {
  const RepuestosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Inventario del Taller',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: -0.4,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.yellowHighlight,
            indicatorWeight: 3,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
            tabs: const [
              Tab(text: 'Disponibles', icon: Icon(Icons.check_circle_outline)),
              Tab(text: 'Reservados', icon: Icon(Icons.lock_outline)),
            ],
          ),
        ),
        // ── FAB — Flujo v0.4: Agregar nuevo repuesto ────────────────────
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const AgregarRepuestoFormScreen(),
            ));
          },
          backgroundColor: AppColors.yellowDefault,
          foregroundColor: Colors.black,
          elevation: 2,
          icon: const Icon(Icons.add_rounded, size: 22),
          label: Text(
            'Agregar repuesto',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
        body: Consumer<RepuestosProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                _ListaDisponibles([...provider.disponibles, ...provider.reservados]),
                _ListaReservados(provider.reservados),
              ],
            );
          }
        ),
      ),
    );
  }
}

class _ListaDisponibles extends StatelessWidget {
  final List repuestos;
  const _ListaDisponibles(this.repuestos);

  @override
  Widget build(BuildContext context) {
    if (repuestos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No hay repuestos disponibles',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: repuestos.length,
      itemBuilder: (context, index) {
        final repuesto = repuestos[index];
        return DisponibleCard(
          repuesto: repuesto,
          onReservar: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ReservarScreen(
                repuestoId: repuesto.id,
                repuestoNombre: repuesto.nombre,
              ),
            ));
          },
        );
      },
    );
  }
}

class _ListaReservados extends StatelessWidget {
  final List repuestos;
  const _ListaReservados(this.repuestos);

  @override
  Widget build(BuildContext context) {
    if (repuestos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_open, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No hay repuestos reservados en el taller',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    final currentUserId = SupabaseService.client.auth.currentUser?.id;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: repuestos.length,
      itemBuilder: (context, index) {
        final repuesto = repuestos[index];
        final esMiReserva = repuesto.reservadoPor == currentUserId;
        final nombreTecnico = repuesto.reservadoPorNombre;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Etiqueta: quién reservó esta pieza
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, left: 4.0),
              child: Row(
                children: [
                  Icon(
                    esMiReserva ? Icons.person : Icons.person_outline,
                    size: 14,
                    color: esMiReserva
                        ? const Color(0xFFFFD400)
                        : Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    esMiReserva
                        ? 'Tu reserva'
                        : 'Reservado por: ${nombreTecnico ?? 'Otro técnico'}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: esMiReserva
                          ? const Color(0xFFD4A000)
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            ReservationCard(
              repuesto: repuesto,
              // Si no es mi reserva, el callback es null → el botón queda oculto en la card
              onLiberar: esMiReserva
                  ? () async {
                      final accion = await showDialog<String>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Text('Gestionar Repuesto',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700, fontSize: 18)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¿Qué acción deseas realizar con "${repuesto.nombre}"?',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey.shade800),
                              ),
                              if (repuesto.equipoDestino != null &&
                                  repuesto.equipoDestino!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Asignado a: ${repuesto.equipoDestino}',
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade700),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      Navigator.pop(ctx, 'usar'),
                                  icon: const Icon(Icons.check_circle,
                                      size: 18, color: Colors.black),
                                  label: Text('Marcar como Usado',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFFFFD400),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      Navigator.pop(ctx, 'liberar'),
                                  icon: const Icon(Icons.undo,
                                      size: 18, color: Colors.black87),
                                  label: Text('Liberar al Taller',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87)),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.grey.shade400),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, null),
                              child: Text('Cancelar',
                                  style: GoogleFonts.inter(
                                      color: Colors.grey.shade600)),
                            ),
                          ],
                        ),
                      );

                      if (accion == null || !context.mounted) return;

                      if (accion == 'usar') {
                        final provider = context.read<RepuestosProvider>();
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
                        final exito = await context
                            .read<RepuestosProvider>()
                            .liberarRepuesto(repuesto.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(exito
                                  ? 'Repuesto liberado y devuelto al taller'
                                  : 'Error al liberar el repuesto.'),
                              backgroundColor: exito ? Colors.black87 : Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      }
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}
