import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../repuestos/data/repuesto_model.dart';
import '../../../../core/theme/app_colors.dart';
import 'marcar_usado_sheet.dart';
import 'liberar_repuesto_sheet.dart';
import 'editar_reserva_sheet.dart';

/// Bottom Sheet principal del Flujo v0.3 — "Gestionar tu Reserva".
/// Presenta los datos clave de la reserva de forma visible e inmediata (Categoría, Estado,
/// Cantidad, Equipo destino, Motivo y Fecha) y ofrece 3 acciones de ciclo de vida.
class GestionarReservaSheet extends StatelessWidget {
  final Repuesto repuesto;

  /// Callback ejecutado tras una acción exitosa (marcar, liberar o editar).
  /// Recibe el mensaje de éxito para que la pantalla muestre el banner de retroalimentación.
  final void Function(String mensaje) onAccionExitosa;

  const GestionarReservaSheet({
    super.key,
    required this.repuesto,
    required this.onAccionExitosa,
  });

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'Fecha no disponible';
    final local = fecha.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year;
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$d/$m/$y - $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final estadoPieza = repuesto.parsedEstadoPieza;
    final bool esNuevo = estadoPieza.toLowerCase().contains('nuevo');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
      child: SingleChildScrollView(
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
            const SizedBox(height: 18),

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
                          fontSize: 14,
                          color: AppColors.slate700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.amberBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.amberBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.amberBadge,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Tu Reserva',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.amberLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Fila de Chips: Categoría y Estado de Pieza ──────────────────
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Categoría
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.category_outlined, size: 13, color: Color(0xFF2563EB)),
                      const SizedBox(width: 4),
                      Text(
                        repuesto.categoria.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1D4ED8),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Estado de la pieza
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: esNuevo ? AppColors.emeraldBg : AppColors.amberBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: esNuevo ? AppColors.emeraldBorder : AppColors.amberBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        esNuevo ? Icons.verified_outlined : Icons.recycling_rounded,
                        size: 13,
                        color: esNuevo ? AppColors.emeraldValue : AppColors.amberValue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        estadoPieza,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: esNuevo ? AppColors.emeraldLabel : AppColors.amberLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Tarjeta de Resumen: Cantidad, Asignado a, Motivo y Fecha ─────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.slate50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.slate200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila Destacada: Cantidad Reservada
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          size: 18,
                          color: Color(0xFFB45309),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CANTIDAD RESERVADA',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '${repuesto.cantidad} ${repuesto.cantidad == 1 ? "unidad apartada" : "unidades apartadas"}',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.slate900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.slate200),
                        ),
                        child: Text(
                          '${repuesto.cantidad} uds',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.slate200, height: 1),
                  const SizedBox(height: 10),

                  // Destino
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.laptop_chromebook_rounded,
                        size: 18,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EQUIPO DESTINO',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              repuesto.equipoDestino?.isNotEmpty == true
                                  ? repuesto.equipoDestino!
                                  : 'Sin equipo asignado',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.slate200, height: 1),
                  const SizedBox(height: 10),

                  // Motivo
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        size: 18,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MOTIVO DE LA RESERVA',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              repuesto.motivo?.isNotEmpty == true
                                  ? repuesto.motivo!
                                  : 'Sin motivo registrado',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.slate800,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Fecha si existe
                  if (repuesto.fechaReserva != null) ...[
                    const SizedBox(height: 10),
                    const Divider(color: AppColors.slate200, height: 1),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.slate500,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Fecha de reserva: ${_formatearFecha(repuesto.fechaReserva)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Acción 1: Marcar como Usado ──────────────────────────────────
            _ActionButton(
              icon: Icons.check_circle_rounded,
              iconColor: Colors.white,
              iconBg: AppColors.success,
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

            // ── Acción 2: Liberar al Taller ─────────────────────────────────
            _ActionButton(
              icon: Icons.add_rounded,
              iconColor: AppColors.error,
              iconBg: AppColors.errorBg,
              label: 'Liberar Repuesto al Taller',
              subtitle: 'Volverá a estar disponible para el taller',
              backgroundColor: const Color(0xFFFFF5F5),
              textColor: AppColors.error,
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

            // ── Acción 3: Editar Reserva ────────────────────────────────────
            _ActionButton(
              icon: Icons.edit_rounded,
              iconColor: AppColors.slate600,
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
            const SizedBox(height: 12),

            // ── Cancelar ───────────────────────────────────────────────────
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.slate500,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
