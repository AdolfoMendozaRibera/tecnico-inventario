import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../repuestos/providers/repuestos_provider.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        backgroundColor: AppColors.slate50,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Resumen del Taller',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.slate900,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.slate900,
              size: 24,
            ),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              await SupabaseService.client.auth.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Consumer<RepuestosProvider>(
          builder: (context, provider, child) {
            final int countDisponibles = provider.disponibles.length;
            final int countReservados = provider.reservados.length;
            final int countMisReservas = provider.misReservas.length;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  // Título principal según Figma
                  Text(
                    'Estado actual del inventario',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtítulo según Figma
                  Text(
                    'Hola, aquí puedes ver los repuestos disponibles\ny el estado actual de tus reservas.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.slate500,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  
                  // Fila de Tarjetas de Métricas según Figma
                  Row(
                    children: [
                      // Tarjeta Disponibles (Verde Esmeralda)
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Disponibles',
                          count: countDisponibles.toString(),
                          bgColor: AppColors.emeraldBg,
                          borderColor: AppColors.emeraldBorder,
                          badgeColor: AppColors.emeraldBadge,
                          valueColor: AppColors.emeraldValue,
                          labelColor: AppColors.emeraldLabel,
                          badgeIcon: Icons.check_rounded,
                          isCircleBadge: true,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Tarjeta Reservados (Ámbar / Naranja)
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Reservados',
                          count: countReservados.toString(),
                          bgColor: AppColors.amberBg,
                          borderColor: AppColors.amberBorder,
                          badgeColor: AppColors.amberBadge,
                          valueColor: AppColors.amberValue,
                          labelColor: AppColors.amberLabel,
                          badgeIcon: Icons.access_time_rounded,
                          isCircleBadge: false,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tarjeta / Banner Informativo de Reservas Activas
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.slate200, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        // Ícono circular de información
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.infoAura,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.infoBorder, width: 1.5),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.infoIcon,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                countMisReservas == 1
                                    ? 'Tienes 1 reserva activa'
                                    : 'Tienes $countMisReservas reservas activas',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.slate800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                countMisReservas > 0
                                    ? 'Revisa los detalles en la pestaña de reservas'
                                    : 'No tienes repuestos reservados actualmente',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.slate500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String count,
    required Color bgColor,
    required Color borderColor,
    required Color badgeColor,
    required Color valueColor,
    required Color labelColor,
    required IconData badgeIcon,
    required bool isCircleBadge,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge del ícono
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: isCircleBadge ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircleBadge ? null : BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                badgeIcon,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 18),
          
          // Número métrico
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 38,
              fontWeight: FontWeight.w700,
              color: valueColor,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 6),
          
          // Etiqueta
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}
