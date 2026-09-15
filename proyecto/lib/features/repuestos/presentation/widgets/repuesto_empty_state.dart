import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Widget de estado vacío con guía y llamadas a la acción claras ("a prueba de errores")
/// según Figma (Repuesto sin resultado.png / Reserva sin resultado.png).
class RepuestoEmptyState extends StatelessWidget {
  final String query;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback onClearSearch;

  const RepuestoEmptyState({
    super.key,
    required this.query,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Círculo decorativo con lupa y signo de interrogación
            Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 58,
                      color: Color(0xFF94A3B8),
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Text(
                        '?',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Título
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.slate900,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),

            // Mensaje explicativo con el término de búsqueda
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 290),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.4,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Botón Primario: "+ Acción"
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(
                  Icons.add_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                label: Text(
                  actionLabel,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.slate800,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

            // Enlace Secundario: "Limpiar búsqueda"
            TextButton(
              onPressed: onClearSearch,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF475569),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Limpiar búsqueda',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
