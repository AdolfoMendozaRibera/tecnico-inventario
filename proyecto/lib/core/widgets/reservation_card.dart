import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/repuestos/data/repuesto_model.dart';
import '../theme/app_colors.dart';

/// Tarjeta de repuesto reservado adaptada fielmente al diseño de Figma (SVG).
/// Presenta fondo blanco, bordes Slate-200, badge ámbar "Reservado",
/// detalles de equipo destino, motivo, técnico y botones operativos directos.
class ReservationCard extends StatelessWidget {
  final Repuesto repuesto;
  final VoidCallback? onLiberar;
  final VoidCallback? onMarcarUsado;
  final bool isMiReserva;
  final bool useRedLiberarButton;

  const ReservationCard({
    super.key,
    required this.repuesto,
    this.onLiberar,
    this.onMarcarUsado,
    this.isMiReserva = false,
    this.useRedLiberarButton = true,
  });

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'No registrada';
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year;
    final hora = fecha.hour.toString().padLeft(2, '0');
    final min = fecha.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$anio - $hora:$min';
  }

  @override
  Widget build(BuildContext context) {
    final tieneAcciones = onLiberar != null || onMarcarUsado != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila superior: Ícono de caja/inventario + Nombre y categoría + Badge "Reservado"
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Círculo decorativo slate-100
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.slate100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 20,
                  color: AppColors.slate500,
                ),
              ),
              const SizedBox(width: 12),

              // Nombre del repuesto y badge de categoría
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repuesto.nombre,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        repuesto.categoria.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Badge Figma: "Reservado" (#FEF3C7 fondo, #B45309 texto)
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
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Color(0xFFF1F5F9), height: 1),
          ),

          // Datos de la reserva: Destino
          Row(
            children: [
              const Icon(Icons.laptop_chromebook_rounded, size: 16, color: AppColors.slate500),
              const SizedBox(width: 8),
              Text(
                'Destino: ',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate500,
                ),
              ),
              Expanded(
                child: Text(
                  repuesto.equipoDestino ?? 'No especificado',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Motivo (si existe)
          if (repuesto.motivo != null && repuesto.motivo!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.description_outlined, size: 16, color: AppColors.slate500),
                const SizedBox(width: 8),
                Text(
                  'Motivo: ',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate500,
                  ),
                ),
                Expanded(
                  child: Text(
                    repuesto.motivo!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF475569),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          // Responsable / Técnico
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isMiReserva ? Icons.person_rounded : Icons.person_outline_rounded,
                size: 16,
                color: isMiReserva ? const Color(0xFFB45309) : AppColors.slate500,
              ),
              const SizedBox(width: 8),
              Text(
                'Reservado por: ',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate500,
                ),
              ),
              Expanded(
                child: Text(
                  isMiReserva
                      ? 'Tu reserva'
                      : (repuesto.reservadoPorNombre ?? 'Técnico del taller'),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isMiReserva ? FontWeight.w700 : FontWeight.w500,
                    color: isMiReserva ? const Color(0xFFB45309) : AppColors.slate900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Fecha de reserva
          if (repuesto.fechaReserva != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: AppColors.slate500),
                const SizedBox(width: 8),
                Text(
                  'Fecha: ',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate500,
                  ),
                ),
                Expanded(
                  child: Text(
                    _formatearFecha(repuesto.fechaReserva),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Botones de acción operativos (Figma: Botón Dark "Marcar como Usado" + Botón "Liberar al Taller")
          if (tieneAcciones) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                // Botón Primario: Marcar como Usado (Figma #1E293B)
                if (onMarcarUsado != null)
                  Expanded(
                    flex: 6,
                    child: ElevatedButton.icon(
                      onPressed: onMarcarUsado,
                      icon: const Icon(Icons.check_circle_rounded, size: 16, color: Colors.white),
                      label: Text(
                        'Marcar como Usado',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.slate800,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                if (onLiberar != null && onMarcarUsado != null)
                  const SizedBox(width: 10),
                // Botón Secundario: Liberar al Taller (Figma: Tonal Red #FEF2F2 con borde #FCA5A5)
                if (onLiberar != null)
                  Expanded(
                    flex: 5,
                    child: OutlinedButton.icon(
                      onPressed: onLiberar,
                      icon: Icon(
                        Icons.undo_rounded,
                        size: 16,
                        color: useRedLiberarButton
                            ? const Color(0xFFDC2626)
                            : AppColors.slate800,
                      ),
                      label: Text(
                        'Liberar al Taller',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: useRedLiberarButton
                              ? const Color(0xFFDC2626)
                              : AppColors.slate800,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: useRedLiberarButton
                            ? const Color(0xFFFEF2F2)
                            : Colors.white,
                        side: BorderSide(
                          color: useRedLiberarButton
                              ? const Color(0xFFFCA5A5)
                              : AppColors.slate200,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.slate50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.slate200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Text(
                    'Reserva protegida de otro técnico',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
