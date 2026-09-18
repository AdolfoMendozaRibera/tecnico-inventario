import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../repuestos/data/repuesto_model.dart';

/// Modal Bottom Sheet de Solo Lectura para ver la ficha completa de trazabilidad
/// de un repuesto instalado o dado de baja en el taller.
class DetalleHistorialSheet extends StatelessWidget {
  final Repuesto repuesto;

  const DetalleHistorialSheet({
    super.key,
    required this.repuesto,
  });

  static Future<void> show(BuildContext context, Repuesto repuesto) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetalleHistorialSheet(repuesto: repuesto),
    );
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'Fecha no registrada';
    final local = fecha.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year;
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$d/$m/$y a las $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final bool esUsado = repuesto.estado == 'usado';
    final fecha = repuesto.fechaReserva ?? repuesto.createdAt;
    final tecnico = repuesto.reservadoPorNombre ?? 'Técnico de turno';
    final sku = repuesto.parsedSku;
    final notas = repuesto.parsedNotas;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.slate300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Cabecera: Título + Badge Semántico
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ficha de Trazabilidad',
                          style: GoogleFonts.inter(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          repuesto.nombre,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Badge Semántico (Verde = Instalado / Rojo = Baja)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: esUsado ? AppColors.emeraldBg : AppColors.errorBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: esUsado ? AppColors.emeraldBorder : AppColors.errorBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          esUsado ? Icons.check_circle_rounded : Icons.delete_outline_rounded,
                          size: 13,
                          color: esUsado ? AppColors.emeraldValue : AppColors.error,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          esUsado ? 'Instalado' : 'Baja / Merma',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: esUsado ? AppColors.emeraldLabel : const Color(0xFF991B1B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Fila de Chips Rápidos (Categoría, SKU, Cantidad)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFDBEAFE)),
                    ),
                    child: Text(
                      repuesto.categoria.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                  if (sku != null && sku.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.slate200),
                      ),
                      child: Text(
                        'SKU: $sku',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate700,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.slate200),
                    ),
                    child: Text(
                      '${repuesto.cantidad} ${repuesto.cantidad == 1 ? "unidad" : "unidades"}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tarjeta 1: Registro de la Reparación / Salida
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
                    // Destino
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          esUsado ? Icons.laptop_chromebook_rounded : Icons.report_problem_outlined,
                          size: 18,
                          color: esUsado ? const Color(0xFF2563EB) : AppColors.error,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                esUsado ? 'EQUIPO / DISPOSITIVO DESTINO' : 'TIPO DE SALIDA',
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
                                    : (esUsado ? 'Equipo de taller' : 'Descarte por daño'),
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
                                'MOTIVO REGISTRADO',
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
                                    : 'Sin observaciones adicionales',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.slate800,
                                  fontWeight: FontWeight.w500,
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

                    // Responsable y Fecha
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 16,
                          color: AppColors.slate600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Por: $tecnico',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.slate500,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatearFecha(fecha),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tarjeta 2: Notas Técnicas adicionales si existen
              if (notas != null && notas.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.slate200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOTAS TÉCNICAS Y COMPATIBILIDAD',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notas,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.slate700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Botón Cerrar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Entendido / Cerrar',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
