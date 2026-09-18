import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Estado vacío para cuando el inventario NO tiene ningún repuesto registrado.
/// Se muestra solo cuando no hay búsqueda activa (primera vez o taller vacío).
/// Sigue la regla UX: Ícono + mensaje claro + botón de acción directa.
class TallerVacioState extends StatelessWidget {
  /// Callback para navegar al formulario de agregar repuesto.
  final VoidCallback? onAgregar;

  /// Variante para la pestaña de Reservados (no tiene botón de agregar).
  final bool esReservados;

  const TallerVacioState({
    super.key,
    this.onAgregar,
    this.esReservados = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono principal con fondo suave
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                esReservados
                    ? Icons.bookmark_border_rounded
                    : Icons.inventory_2_outlined,
                size: 40,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 20),

            // Título adaptado al contexto
            Text(
              esReservados
                  ? 'Ningún repuesto reservado'
                  : 'El taller está vacío',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.slate900,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),

            // Descripción contextual
            Text(
              esReservados
                  ? 'Cuando un técnico reserve un repuesto aparecerá aquí con todos sus detalles.'
                  : 'Aún no hay repuestos registrados en el inventario del taller. Agrega el primero para empezar.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
            ),

            // Botón de acción solo en pestaña Disponibles y si hay callback
            if (!esReservados && onAgregar != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.slate800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: onAgregar,
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Agregar primer repuesto'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
