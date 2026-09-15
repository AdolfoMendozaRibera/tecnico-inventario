import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/repuestos/data/repuesto_model.dart';
import '../theme/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final repuesto = widget.repuesto;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.slate200,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila Superior: Nombre del repuesto + Badge "Disponible"
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      repuesto.nombre,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Disponible',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emeraldValue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Categoría
              Row(
                children: [
                  const Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: AppColors.slate500,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Categoría: ${repuesto.categoria}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.slate500,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Stock / Ubicación
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: AppColors.slate500,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Stock: 1 unidad disponible',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.slate500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              // Descripción si existe o al expandir
              if (repuesto.descripcion != null && repuesto.descripcion!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.notes_rounded,
                      size: 16,
                      color: AppColors.slate500,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        repuesto.descripcion!,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.slate500,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: _isExpanded ? null : 1,
                        overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 14),

              // Fila Inferior: Botón de acción Reservar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: widget.onReservar,
                    icon: const Icon(
                      Icons.bookmark_add_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Reservar',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.slate800,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
