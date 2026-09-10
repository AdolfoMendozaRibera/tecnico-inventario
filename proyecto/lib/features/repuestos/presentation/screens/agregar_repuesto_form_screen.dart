import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'agregar_repuesto_preview_screen.dart';

/// Pantalla 1 del Flujo v0.4 — "Agregar un repuesto al inventario"
/// El técnico ingresa los datos del nuevo repuesto antes de revisarlos.
class AgregarRepuestoFormScreen extends StatefulWidget {
  const AgregarRepuestoFormScreen({super.key});

  @override
  State<AgregarRepuestoFormScreen> createState() =>
      _AgregarRepuestoFormScreenState();
}

class _AgregarRepuestoFormScreenState
    extends State<AgregarRepuestoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  /// Categoría seleccionada del menú desplegable
  String? _categoriaSeleccionada;

  static const List<String> _categorias = [
    'Pantallas',
    'Baterías',
    'Teclados',
    'Memorias RAM',
    'Almacenamiento',
    'Placas madre',
    'Fuentes de poder',
    'Cables y conectores',
    'Ventiladores / Cooling',
    'Cargadores',
    'Otros',
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _irAPreview() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AgregarRepuestoPreviewScreen(
        nombre: _nombreController.text.trim(),
        categoria: _categoriaSeleccionada!,
        descripcion: _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo Repuesto',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Encabezado descriptivo ─────────────────────────────────
                _HeaderCard(),
                const SizedBox(height: 28),

                // ── Campo: Nombre ──────────────────────────────────────────
                _SectionLabel(label: 'Nombre del repuesto *'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nombreController,
                  style: GoogleFonts.inter(fontSize: 15),
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(
                    hint: 'Ej. Pantalla LCD 15.6" FHD',
                    icon: Icons.build_outlined,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
                ),
                const SizedBox(height: 20),

                // ── Campo: Categoría (dropdown) ───────────────────────────
                _SectionLabel(label: 'Categoría *'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _categoriaSeleccionada,
                  isExpanded: true,
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black87),
                  decoration: _inputDecoration(
                    hint: 'Selecciona una categoría',
                    icon: Icons.category_outlined,
                  ),
                  items: _categorias
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _categoriaSeleccionada = v),
                  validator: (v) =>
                      v == null ? 'Selecciona una categoría' : null,
                ),
                const SizedBox(height: 20),

                // ── Campo: Descripción (opcional) ─────────────────────────
                _SectionLabel(label: 'Descripción (opcional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descripcionController,
                  style: GoogleFonts.inter(fontSize: 15),
                  maxLines: 3,
                  decoration: _inputDecoration(
                    hint: 'Ej. Compatible con modelos Dell 3510/3520, conector 30 pines',
                    icon: Icons.notes_outlined,
                  ),
                ),
                const SizedBox(height: 36),

                // ── Botón siguiente ───────────────────────────────────────
                ElevatedButton.icon(
                  onPressed: _irAPreview,
                  icon: const Icon(Icons.arrow_forward_rounded,
                      size: 20, color: Colors.black),
                  label: Text(
                    'Revisar antes de guardar',
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

                // ── Botón cancelar ────────────────────────────────────────
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text('Cancelar',
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade400),
      prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade500),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppColors.yellowDefault, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}

// ── Widgets privados auxiliares ─────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellowDefault.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.yellowDefault.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.yellowDefault,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add_box_outlined,
                size: 22, color: Colors.black),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingreso de pieza nueva',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Completa los datos y revisa antes de guardar al inventario.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
        letterSpacing: 0.2,
      ),
    );
  }
}
