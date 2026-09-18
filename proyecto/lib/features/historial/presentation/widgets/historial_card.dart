import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../repuestos/data/repuesto_model.dart';
import 'detalle_historial_sheet.dart';

/// Tarjeta de historial para el listado de trazabilidad (Flujo 5).
/// Muestra de forma concisa y visualmente clara el repuesto consumido o dado de baja,
/// el equipo destino, el motivo/merma, el técnico responsable y la fecha.
/// Al tocar la tarjeta, abre la ficha completa de trazabilidad [DetalleHistorialSheet].
class HistorialCard extends StatelessWidget {
  final Repuesto repuesto;

  const HistorialCard({
    super.key,
    required this.repuesto,
  });

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'Fecha no reg.';
    final local = fecha.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year;
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$d/$m/$y · $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final bool esUsado = repuesto.estado == 'usado';
    final fecha = repuesto.fechaReserva ?? repuesto.createdAt;
    final nombreTecnico = repuesto.reservadoPorNombre ?? 'Técnico asignado';
    final equipo = repuesto.equipoDestino?.trim();
    final motivo = repuesto.motivo?.trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => DetalleHistorialSheet.show(context, repuesto),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila Superior: Estado del movimiento (Instalado vs Baja) + Categoría
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge semántico de estado
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: esUsado ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: esUsado ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: esUsado ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          esUsado ? 'INSTALADO' : 'BAJA / MERMA',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: esUsado ? const Color(0xFF047857) : const Color(0xFFB91C1C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Cantidad si es mayor a 1
                  if (repuesto.cantidad > 1)
                    Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'x${repuesto.cantidad}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate700,
                        ),
                      ),
                    ),
                  // Chip de Categoría
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      repuesto.categoria.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nombre del Repuesto
              Text(
                repuesto.nombre,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              // Ficha rápida: Destino o Motivo
              if (esUsado && equipo != null && equipo.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.devices_outlined,
                        size: 16,
                        color: AppColors.slate400,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.slate600,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Equipo: ',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: equipo),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

              if (motivo != null && motivo.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        esUsado ? Icons.build_circle_outlined : Icons.report_problem_outlined,
                        size: 16,
                        color: esUsado ? AppColors.slate400 : const Color(0xFFF87171),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.slate600,
                            ),
                            children: [
                              TextSpan(
                                text: esUsado ? 'Motivo: ' : 'Razón de baja: ',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: motivo),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

              const Divider(height: 18, thickness: 1, color: Color(0xFFF1F5F9)),

              // Fila Inferior: Técnico + Fecha + Affordance
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 15,
                    color: AppColors.slate400,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      nombreTecnico,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: AppColors.slate400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatearFecha(fecha),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.slate400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
