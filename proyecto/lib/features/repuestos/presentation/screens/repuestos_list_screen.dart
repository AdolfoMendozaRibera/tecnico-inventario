import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/reservation_card.dart';
import '../../../reservas/presentation/screens/reservar_screen.dart';
import '../../../../core/supabase_client.dart';

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
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: repuesto.estado != 'disponible' 
                  ? Colors.grey.shade200 
                  : AppColors.yellowDefault.withValues(alpha: 0.2),
              child: Icon(
                Icons.memory, 
                color: repuesto.estado != 'disponible' ? Colors.grey.shade400 : Colors.black87
              ),
            ),
            title: Text(
              repuesto.nombre,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, 
                fontSize: 15,
                color: repuesto.estado != 'disponible' ? Colors.grey.shade500 : null,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'Categoría: ${repuesto.categoria}',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
            trailing: ElevatedButton(
              onPressed: repuesto.estado != 'disponible' ? null : () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ReservarScreen(repuestoId: repuesto.id, repuestoNombre: repuesto.nombre)
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellowDefault,
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey.shade200,
                disabledForegroundColor: Colors.grey.shade500,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                repuesto.estado != 'disponible' ? 'Reservado' : 'Reservar',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
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
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: repuestos.length,
      itemBuilder: (context, index) {
        final repuesto = repuestos[index];
        return ReservationCard(
          repuesto: repuesto,
          onLiberar: () async {
            final currentUserId = SupabaseService.client.auth.currentUser?.id;
            
            if (repuesto.reservadoPor != currentUserId) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solo el técnico que realizó la reserva puede liberarla.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            }

            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Liberar Repuesto', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                content: Text('¿Deseas liberar "${repuesto.nombre}"?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                  ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sí, Liberar')),
                ],
              ),
            );
            if (confirm == true && context.mounted) {
              await context.read<RepuestosProvider>().liberarRepuesto(repuesto.id);
            }
          },
        );
      },
    );
  }
}
