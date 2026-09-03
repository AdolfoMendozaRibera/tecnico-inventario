import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/repuestos/data/repuesto_model.dart';
import '../theme/app_colors.dart';
import 'active_badge.dart';

/// Componente Figma: `Card`
/// Posee dos estados interactivos:
/// 1. `Default` (Colapsado): Fondo blanco, borde #E0E0E0, información principal.
/// 2. `Detalle` (Expandido al dar click): Fondo #696565, texto en contraste blanco,
///    muestra categoría, equipo, motivo, fecha de reserva y acciones completas.
class ReservationCard extends StatefulWidget {
  final Repuesto repuesto;
  final VoidCallback onLiberar;
  final VoidCallback? onMarcarUsado;
  final bool initialExpanded;

  const ReservationCard({
    super.key,
    required this.repuesto,
    required this.onLiberar,
    this.onMarcarUsado,
    this.initialExpanded = false,
  });

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'No registrada';
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year;
    final hora = fecha.hour.toString().padLeft(2, '0');
    final min = fecha.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$anio a las $hora:$min';
  }

  @override
  Widget build(BuildContext context) {
    final repuesto = widget.repuesto;

    // Colores según el estado (Default vs Detalle de Figma)
    final cardBg = _isExpanded ? AppColors.cardDetailBg : AppColors.cardBg;
    final textColor = _isExpanded ? AppColors.cardDetailText : AppColors.textPrimary;
    final subtextColor = _isExpanded ? Colors.white.withValues(alpha: 0.85) : AppColors.textSecondary;
    final borderColor = _isExpanded ? AppColors.cardDetailBg : AppColors.cardBorder;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 14.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isExpanded ? 0.12 : 0.04),
                blurRadius: _isExpanded ? 10 : 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fila superior: Nombre del repuesto + Badge "Activa"
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      repuesto.nombre,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ActiveBadge(
                    label: repuesto.estado == 'reservado' ? 'Activa' : 'Disponible',
                    onTap: () {
                      setState(() => _isExpanded = !_isExpanded);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Información común: Destino
              Row(
                children: [
                  Icon(
                    Icons.devices_other,
                    size: 16,
                    color: _isExpanded ? AppColors.yellowDefault : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Destino: ${repuesto.equipoDestino ?? "No especificado"}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: subtextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Motivo (siempre que exista)
              if (repuesto.motivo != null && repuesto.motivo!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 16,
                      color: _isExpanded ? AppColors.yellowDefault : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Motivo: ${repuesto.motivo}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: subtextColor,
                        ),
                        maxLines: _isExpanded ? 4 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              // SECCIÓN DETALLE EXPANDIDA (Figma Variant Default=detalle)
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.white24, height: 20),

                      // Categoría
                      Row(
                        children: [
                          const Icon(Icons.category_outlined, size: 16, color: AppColors.yellowDefault),
                          const SizedBox(width: 8),
                          Text(
                            'Categoría: ',
                            style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              repuesto.categoria,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Fecha y hora de reserva
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 16, color: AppColors.yellowDefault),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Reservado: ${_formatearFecha(repuesto.fechaReserva)}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Botones de acción en detalle
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: widget.onLiberar,
                              icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.black),
                              label: const Text('Liberar / Usado'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellowDefault,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),

              // Pie en modo colapsado (Texto según Figma "Marcar usado / Liberar")
              if (!_isExpanded) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Toca para ver detalle',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onLiberar,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.textPrimary,
                      ),
                      child: Text(
                        'Marcar usado / Liberar',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
