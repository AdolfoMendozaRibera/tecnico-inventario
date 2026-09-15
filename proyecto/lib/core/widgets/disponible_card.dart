import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/repuestos/data/repuesto_model.dart';
import '../../features/repuestos/presentation/widgets/detalle_disponible_sheet.dart';
import '../theme/app_colors.dart';

/// Tarjeta de repuesto disponible con layout horizontal compacto
/// fiel al diseño de Figma (Disponibles.png y Repuesto Encontrado.png).
/// Al presionar la tarjeta se abre DetalleDisponibleSheet (Flujo 2).
/// El botón "Reservar" abre directamente el formulario de reserva.
class DisponibleCard extends StatelessWidget {
  final Repuesto repuesto;
  final VoidCallback onReservar;
  final VoidCallback? onTap;

  const DisponibleCard({
    super.key,
    required this.repuesto,
    required this.onReservar,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ?? () => DetalleDisponibleSheet.show(context, repuesto),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Columna Izquierda: Información del Repuesto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Nombre del repuesto
                      Text(
                        repuesto.nombre,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate900,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Categoría con icono decorativo
                      Row(
                        children: [
                          const Icon(
                            Icons.category_outlined,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Categoría: ${repuesto.categoria}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Stock disponible
                      Text(
                        'Stock: 1 unidad en taller',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Columna Derecha: Badge Disponible + Botón Reservar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge verde "Disponible"
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Disponible',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF047857),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botón oscuro "Reservar"
                    ElevatedButton(
                      onPressed: onReservar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.slate800,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        minimumSize: const Size(82, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Reservar',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
