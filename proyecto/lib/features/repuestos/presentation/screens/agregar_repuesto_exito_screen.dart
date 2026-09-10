import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// Pantalla 3 del Flujo v0.4 — "Agregar un repuesto al inventario"
/// Muestra el listado actualizado de repuestos disponibles con
/// el ítem recién ingresado destacado visualmente.
class AgregarRepuestoExitoScreen extends StatefulWidget {
  final String nombre;
  final String categoria;
  final String? lastAddedId;

  const AgregarRepuestoExitoScreen({
    super.key,
    required this.nombre,
    required this.categoria,
    this.lastAddedId,
  });

  @override
  State<AgregarRepuestoExitoScreen> createState() =>
      _AgregarRepuestoExitoScreenState();
}

class _AgregarRepuestoExitoScreenState
    extends State<AgregarRepuestoExitoScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkController;
  late final Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    _checkController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // El técnico sale limpio hacia el inventario
        automaticallyImplyLeading: false,
        title: Text(
          'Inventario del Taller',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _volverAlInventario(context),
            icon: const Icon(Icons.done, size: 18, color: Colors.black),
            label: Text(
              'Listo',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700, color: Colors.black),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Banner de éxito animado ──────────────────────────────────
            _SuccessBanner(
              nombre: widget.nombre,
              checkScale: _checkScale,
            ),

            // ── Listado de disponibles con ítem destacado ────────────────
            Expanded(
              child: Consumer<RepuestosProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final disponibles = provider.disponibles;

                  if (disponibles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('El inventario se está actualizando…',
                              style: GoogleFonts.inter(
                                  color: Colors.grey.shade500, fontSize: 14)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    itemCount: disponibles.length,
                    itemBuilder: (ctx, index) {
                      final r = disponibles[index];
                      final esNuevo = r.id == widget.lastAddedId;
                      return _RepuestoRow(
                        nombre: r.nombre,
                        categoria: r.categoria,
                        esNuevo: esNuevo,
                      );
                    },
                  );
                },
              ),
            ),

            // ── Botón de acción final ────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _volverAlInventario(context),
                  icon: const Icon(Icons.inventory_2_outlined,
                      size: 20, color: Colors.black),
                  label: Text(
                    'Ver inventario completo',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowDefault,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Limpia el lastAddedId y saca todas las pantallas del flujo v0.4 de la pila.
  void _volverAlInventario(BuildContext context) {
    context.read<RepuestosProvider>().clearLastAddedId();
    // Pop hasta la raíz del stack de navegación para volver al inventario
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

// ── Widgets privados auxiliares ─────────────────────────────────────────────

class _SuccessBanner extends StatelessWidget {
  final String nombre;
  final Animation<double> checkScale;

  const _SuccessBanner({required this.nombre, required this.checkScale});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.statGreenBg,
        border: Border(
          bottom: BorderSide(color: AppColors.statGreenBorder),
        ),
      ),
      child: Row(
        children: [
          ScaleTransition(
            scale: checkScale,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.statGreenText,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Repuesto ingresado!',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.statGreenText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '"$nombre" ya está disponible en el inventario.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.statGreenText,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila de un repuesto en la lista de éxito.
/// El repuesto recién agregado se destaca con borde amarillo y chip "Nuevo".
class _RepuestoRow extends StatelessWidget {
  final String nombre;
  final String categoria;
  final bool esNuevo;

  const _RepuestoRow({
    required this.nombre,
    required this.categoria,
    required this.esNuevo,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: esNuevo
            ? AppColors.yellowDefault.withValues(alpha: 0.10)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: esNuevo ? AppColors.yellowDefault : AppColors.cardBorder,
          width: esNuevo ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: esNuevo
                  ? AppColors.yellowDefault
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.build_outlined,
              size: 16,
              color: esNuevo ? Colors.black : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  categoria,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          if (esNuevo)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.yellowDefault,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Nuevo',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
            )
          else
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.statGreenBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Disponible',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.statGreenText),
              ),
            ),
        ],
      ),
    );
  }
}
