import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'agregar_repuesto_exito_screen.dart';

/// Pantalla 2 del Flujo v0.4 — "Agregar un repuesto al inventario"
/// El técnico revisa los datos antes de confirmar la inserción en Supabase.
class AgregarRepuestoPreviewScreen extends StatefulWidget {
  final String nombre;
  final String categoria;
  final String? descripcion;

  const AgregarRepuestoPreviewScreen({
    super.key,
    required this.nombre,
    required this.categoria,
    this.descripcion,
  });

  @override
  State<AgregarRepuestoPreviewScreen> createState() =>
      _AgregarRepuestoPreviewScreenState();
}

class _AgregarRepuestoPreviewScreenState
    extends State<AgregarRepuestoPreviewScreen> {
  bool _isGuardando = false;

  Future<void> _confirmarGuardado() async {
    setState(() => _isGuardando = true);

    final provider = context.read<RepuestosProvider>();
    final exito = await provider.agregarRepuesto(
      nombre: widget.nombre,
      categoria: widget.categoria,
      descripcion: widget.descripcion,
    );

    if (!mounted) return;
    setState(() => _isGuardando = false);

    if (exito) {
      // Navega a la pantalla de éxito reemplazando preview en la pila
      // para que "Atrás" lleve directamente al listado
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => AgregarRepuestoExitoScreen(
          nombre: widget.nombre,
          categoria: widget.categoria,
          lastAddedId: provider.lastAddedId,
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al guardar: ${provider.lastError ?? "Sin detalle"}',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Revisar Repuesto',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Indicador de paso ──────────────────────────────────────
              _StepIndicator(paso: 2),
              const SizedBox(height: 24),

              // ── Card de vista previa ───────────────────────────────────
              _PreviewCard(
                nombre: widget.nombre,
                categoria: widget.categoria,
                descripcion: widget.descripcion,
              ),
              const SizedBox(height: 20),

              // ── Info: estado inicial ───────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.statGreenBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.statGreenBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 18, color: AppColors.statGreenText),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Se ingresará al inventario como Disponible de inmediato.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.statGreenText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // ── Botón confirmar ────────────────────────────────────────
              ElevatedButton.icon(
                onPressed: _isGuardando ? null : _confirmarGuardado,
                icon: _isGuardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.black),
                      )
                    : const Icon(Icons.save_rounded,
                        size: 20, color: Colors.black),
                label: Text(
                  _isGuardando ? 'Guardando…' : 'Guardar en Inventario',
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
              const SizedBox(height: 12),

              // ── Botón volver a editar ──────────────────────────────────
              OutlinedButton.icon(
                onPressed:
                    _isGuardando ? null : () => Navigator.of(context).pop(),
                icon:
                    const Icon(Icons.edit_outlined, size: 18),
                label: Text('Volver a editar',
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widgets privados auxiliares ─────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int paso;
  const _StepIndicator({required this.paso});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final isActive = i < paso;
        final isCurrent = i == paso - 1;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isActive
                  ? (isCurrent
                      ? AppColors.yellowDefault
                      : AppColors.yellowPressed)
                  : Colors.grey.shade200,
            ),
          ),
        );
      }),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String nombre;
  final String categoria;
  final String? descripcion;

  const _PreviewCard({
    required this.nombre,
    required this.categoria,
    this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Etiqueta "Vista Previa" arriba a la izquierda ─────────
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF099),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Vista Previa',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD4A017),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Título centrado ──────────────────────────────────────
          Text(
            nombre,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 18),

          // ── Fila de Categoría ("Otros", etc.) y "Disponible" ─────
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC4C4C8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categoria,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A4A4A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA6F4A8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Disponible',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E8735),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Línea divisoria y Descripción centrada ───────────────
          if (descripcion != null && descripcion!.trim().isNotEmpty) ...[
            const SizedBox(height: 18),
            Divider(
              color: Colors.grey.shade200,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 14),
            Text(
              descripcion!.trim(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
