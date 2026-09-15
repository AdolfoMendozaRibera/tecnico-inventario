import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repuesto_model.dart';
import '../../../../core/theme/app_colors.dart';

/// Tarjeta de repuesto reservado para el listado del taller
/// según el diseño de Figma (Reservados.png).
/// Muestra claramente la persona que reservó, destino, motivo
/// y permite ver el detalle completo mediante un tap intuitivo.
class InventarioReservadoCard extends StatelessWidget {
  final Repuesto repuesto;
  final VoidCallback onTap;

  const InventarioReservadoCard({
    super.key,
    required this.repuesto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nombreTecnico = repuesto.reservadoPorNombre ?? 'Técnico asignado';

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
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila Superior: Indicador del técnico + Badge ámbar
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Punto indicador decorativo
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF94A3B8),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFF475569),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reservado por: $nombreTecnico',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge ámbar "Reservado"
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Reservado',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Nombre del Repuesto
              Text(
                repuesto.nombre,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),

              // Destino
              Text(
                repuesto.equipoDestino?.isNotEmpty == true
                    ? 'Destino: ${repuesto.equipoDestino}'
                    : 'Sin equipo de destino especificado',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF334155),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Motivo
              Text(
                repuesto.motivo?.isNotEmpty == true
                    ? 'Motivo: ${repuesto.motivo}'
                    : 'Sin motivo registrado',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Footer: Aviso informativo de sólo lectura
              Row(
                children: [
                  const Icon(
                    Icons.work_outline_rounded,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'No puedes modificar reservas de otros técnicos',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFFCBD5E1),
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
