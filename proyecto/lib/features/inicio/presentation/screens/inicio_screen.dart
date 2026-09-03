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
      appBar: AppBar(
        title: Text(
          'Resumen del Taller',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: -0.4,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              SupabaseService.client.auth.signOut();
              context.go('/login');
            },
          )
        ],
      ),
      body: SafeArea(
        child: Consumer<RepuestosProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título principal según Figma (style_PJIW5L)
                  Text(
                    'Estado Actual del Inventario',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtítulo según Figma (style_9OBJAY)
                  Text(
                    'Hola, aquí puedes ver los repuestos disponibles\ny tus reservas.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  
                  // Fila de Tarjetas según Figma (Card 3:3004 y Card 3:3020)
                  Row(
                    children: [
                      // Tarjeta Disponibles (Verde Figma)
                      Expanded(
                        child: _buildStatCard(
                          title: 'Disponibles',
                          count: provider.disponibles.length.toString(),
                          bgColor: AppColors.statGreenBg,
                          borderColor: AppColors.statGreenBorder,
                          textColor: AppColors.statGreenText,
                          icon: Icons.check_circle_outline,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Tarjeta Reservados (Naranja Figma)
                      Expanded(
                        child: _buildStatCard(
                          title: 'Reservados',
                          count: provider.reservados.length.toString(),
                          bgColor: AppColors.statOrangeBg,
                          borderColor: AppColors.statOrangeBorder,
                          textColor: AppColors.statOrangeText,
                          icon: Icons.pending_actions,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Resumen informativo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.yellowHighlight, size: 28),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Tienes ${provider.misReservas.length} reserva(s) activa(s) a tu nombre.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8), // Border radius 8px de Figma
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: textColor),
          const SizedBox(height: 12),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
