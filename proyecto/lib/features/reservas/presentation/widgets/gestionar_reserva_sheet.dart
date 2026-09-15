import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../repuestos/data/repuesto_model.dart';
import '../../../../core/theme/app_colors.dart';
import 'marcar_usado_sheet.dart';
import 'liberar_repuesto_sheet.dart';
import 'editar_reserva_sheet.dart';

/// Bottom Sheet principal del Flujo v0.3 — "Gestionar tu Reserva".
/// Presenta los datos clave de la reserva y ofrece 3 acciones distintas.
class GestionarReservaSheet extends StatelessWidget {
  final Repuesto repuesto;

  /// Callback ejecutado tras una acción exitosa (marcar, liberar o editar).
  /// Recibe el mensaje de éxito para que la pantalla muestre el banner verde.
  final void Function(String mensaje) onAccionExitosa;

  const GestionarReservaSheet({
    super.key,
    required this.repuesto,
    required this.onAccionExitosa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.slate200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Título + Badge "Tu Reserva"
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gestionar tu Reserva',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      repuesto.nombre,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.slate500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Tu Reserva',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Tarjeta "Asignado a"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.slate200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asignado a:',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate500,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  repuesto.equipoDestino?.isNotEmpty == true
                      ? repuesto.equipoDestino!
                      : 'Sin equipo asignado',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Cantidad reservada
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Cantidad  ',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.slate500,
                ),
              ),
              Text(
                '${repuesto.cantidad}',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Acción 1: Marcar como Usado
          _ActionButton(
            icon: Icons.check_circle_rounded,
            iconColor: Colors.white,
            iconBg: const Color(0xFF10B981),
            label: 'Marcar como Usado',
            subtitle: 'El repuesto se descontará del inventario',
            backgroundColor: AppColors.slate900,
            textColor: Colors.white,
            subtitleColor: const Color(0xFF94A3B8),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => MarcarUsadoSheet(
                  repuesto: repuesto,
                  onConfirmar: onAccionExitosa,
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          // Acción 2: Liberar al Taller
          _ActionButton(
            icon: Icons.add_rounded,
            iconColor: const Color(0xFFDC2626),
            iconBg: const Color(0xFFFEE2E2),
            label: 'Liberar Repuesto al Taller',
            subtitle: 'Volverá a estar disponible para el taller',
            backgroundColor: const Color(0xFFFFF5F5),
            textColor: const Color(0xFFDC2626),
            subtitleColor: const Color(0xFFEF4444),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => LiberarRepuestoSheet(
                  repuesto: repuesto,
                  onConfirmar: onAccionExitosa,
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          // Acción 3: Editar Reserva
          _ActionButton(
            icon: Icons.edit_rounded,
            iconColor: AppColors.slate500,
            iconBg: AppColors.slate100,
            label: 'Editar Reserva',
            subtitle: 'Corrige el equipo destino o el motivo',
            backgroundColor: Colors.white,
            textColor: AppColors.slate900,
            subtitleColor: AppColors.slate500,
            border: Border.all(color: AppColors.slate200, width: 1.5),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => EditarReservaSheet(
                  repuesto: repuesto,
                  onConfirmar: onAccionExitosa,
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          // Cancelar
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.slate500,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

/// Widget interno reutilizable para cada fila de acción del sheet.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final Color subtitleColor;
  final BoxBorder? border;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
    required this.subtitleColor,
    this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: border,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
