import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Estado vacío amigable para el Flujo 5: Historial y Trazabilidad.
class HistorialEmptyState extends StatelessWidget {
  final bool tieneFiltros;
  final VoidCallback onLimpiarFiltros;

  const HistorialEmptyState({
    super.key,
    required this.tieneFiltros,
    required this.onLimpiarFiltros,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.slate100,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.manage_history_rounded,
                  size: 36,
                  color: AppColors.slate400,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              tieneFiltros
                  ? 'Sin resultados para este filtro'
                  : 'Sin movimientos registrados',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.slate900,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              tieneFiltros
                  ? 'Prueba cambiando el rango de fechas o limpiando los términos de búsqueda.'
                  : 'Los repuestos consumidos en reparaciones o dados de baja por daño aparecerán aquí para auditoría y garantías.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.slate500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (tieneFiltros) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onLimpiarFiltros,
                icon: const Icon(Icons.clear_all_rounded, size: 18),
                label: const Text('Limpiar Filtros'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.slate800,
                  side: const BorderSide(color: AppColors.slate300),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
