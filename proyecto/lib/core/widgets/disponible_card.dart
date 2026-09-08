import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/repuestos/data/repuesto_model.dart';
import '../theme/app_colors.dart';
import 'active_badge.dart';

/// Componente para repuestos en estado `disponible`.
/// Diseñado con la misma jerarquía estética que la tarjeta de reservas de Figma:
/// 1. `Default` (Colapsado): Fondo blanco, información clave, badge "Disponible", botón rápido de reservar.
/// 2. `Detalle` (Expandido al dar click): Fondo #696565, texto en contraste blanco,
///    muestra categoría con chip, estado detallado, fecha de registro en inventario,
///    ubicación en el taller y botón de acción prominente "Reservar este Repuesto".
class DisponibleCard extends StatefulWidget {
  final Repuesto repuesto;
  final VoidCallback onReservar;
  final bool initialExpanded;

  const DisponibleCard({
    super.key,
    required this.repuesto,
    required this.onReservar,
    this.initialExpanded = false,
  });

  @override
  State<DisponibleCard> createState() => _DisponibleCardState();
}

class _DisponibleCardState extends State<DisponibleCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'Fecha no registrada';
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

    // Colores según estado interactivo (consistente con ReservationCard)
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
              // Fila superior: Nombre del repuesto + Badge "Disponible"
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
                    label: 'Disponible',
                    onTap: () {
                      setState(() => _isExpanded = !_isExpanded);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Información común colapsada: Categoría y estado rápido
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: _isExpanded ? AppColors.yellowDefault : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Categoría: ${repuesto.categoria}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: subtextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!_isExpanded) ...[
                    // Botón rápido en estado colapsado (cumple RNF-01: mínimo de toques)
                    ElevatedButton(
                      onPressed: widget.onReservar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellowDefault,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Reservar',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ],
              ),

              // SECCIÓN DETALLE EXPANDIDA (Fondo oscuro con información exhaustiva)
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.white24, height: 20),

                      // Estado detallado
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline, size: 16, color: AppColors.yellowDefault),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Estado: Disponible en taller (listo para asignación)',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Categoría con chip
                      Row(
                        children: [
                          const Icon(Icons.label_outline, size: 16, color: AppColors.yellowDefault),
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

                      // Ubicación en taller
                      Row(
                        children: [
                          const Icon(Icons.store_mall_directory_outlined, size: 16, color: AppColors.yellowDefault),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ubicación: Taller Central — Estantería de repuestos',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Fecha de alta en inventario
                      if (repuesto.createdAt != null) ...[
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 16, color: AppColors.yellowDefault),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Ingreso al inventario: ${_formatearFecha(repuesto.createdAt)}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      const SizedBox(height: 8),

                      // Botón principal de acción prominente en modo detalle
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: widget.onReservar,
                          icon: const Icon(Icons.bookmark_add_outlined, size: 18, color: Colors.black),
                          label: Text(
                            'Reservar para un Equipo',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellowDefault,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
