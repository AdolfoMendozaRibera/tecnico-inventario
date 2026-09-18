import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repuesto_model.dart';
import '../../providers/repuestos_provider.dart';

/// Pantalla de Edición de Datos Maestros y Reubicación Física en Taller
/// Cumple con la tokenización de VaultTecno, tipografía Inter y anti-double submit.
class EditarRepuestoScreen extends StatefulWidget {
  final Repuesto repuesto;

  const EditarRepuestoScreen({
    super.key,
    required this.repuesto,
  });

  @override
  State<EditarRepuestoScreen> createState() => _EditarRepuestoScreenState();
}

class _EditarRepuestoScreenState extends State<EditarRepuestoScreen> {
  late final TextEditingController _skuController;
  late final TextEditingController _nombreController;
  late final TextEditingController _ubicacionController;
  late final TextEditingController _notasController;

  late String _categoriaSeleccionada;
  late String _estadoPieza;
  late int _cantidad;

  bool _mostrarErrores = false;
  bool _isGuardando = false;

  static const List<String> _categorias = [
    'Pantallas',
    'Placas',
    'Memorias',
    'Baterías',
    'Teclados',
    'Discos / SSD',
    'Cargadores',
    'Otros',
  ];

  @override
  void initState() {
    super.initState();
    final r = widget.repuesto;
    _skuController = TextEditingController(text: r.parsedSku ?? '');
    _nombreController = TextEditingController(text: r.nombre);
    _ubicacionController = TextEditingController(text: r.parsedUbicacion);
    _notasController = TextEditingController(text: r.parsedNotas ?? '');

    _categoriaSeleccionada = _categorias.contains(r.categoria) ? r.categoria : 'Otros';
    _estadoPieza = r.parsedEstadoPieza;
    _cantidad = r.cantidad > 0 ? r.cantidad : 1;
  }

  @override
  void dispose() {
    _skuController.dispose();
    _nombreController.dispose();
    _ubicacionController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  bool get _isNombreValido => _nombreController.text.trim().isNotEmpty;
  bool get _isUbicacionValida => _ubicacionController.text.trim().isNotEmpty;
  bool get _isCantidadValida => _cantidad > 0;

  Future<void> _guardarCambios() async {
    HapticFeedback.lightImpact();
    setState(() => _mostrarErrores = true);

    if (!_isNombreValido || !_isUbicacionValida || !_isCantidadValida) {
      return;
    }

    setState(() => _isGuardando = true);

    // Reconstruimos la descripción con los metadatos serializados
    final buffer = StringBuffer();
    if (_skuController.text.trim().isNotEmpty) {
      buffer.writeln('SKU: ${_skuController.text.trim()}');
    }
    buffer.writeln('Estado de pieza: $_estadoPieza');
    buffer.writeln('Ubicación: ${_ubicacionController.text.trim()}');
    if (_notasController.text.trim().isNotEmpty) {
      buffer.writeln('Notas: ${_notasController.text.trim()}');
    }

    final provider = context.read<RepuestosProvider>();
    final exito = await provider.editarRepuesto(
      repuestoId: widget.repuesto.id,
      nombre: _nombreController.text.trim(),
      categoria: _categoriaSeleccionada,
      descripcion: buffer.toString().trim(),
      cantidad: _cantidad,
    );

    if (!mounted) return;
    setState(() => _isGuardando = false);

    if (exito) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Repuesto y ubicación actualizados con éxito!',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.lastError ?? 'Error al actualizar el repuesto.',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool errorNombre = _mostrarErrores && !_isNombreValido;
    final bool errorUbicacion = _mostrarErrores && !_isUbicacionValida;
    final bool errorCantidad = _mostrarErrores && !_isCantidadValida;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.slate800),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Editar Ficha / Reubicar',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.slate900,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner de contexto
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.infoAura,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_note_rounded, color: AppColors.infoIcon, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Actualiza la ubicación física en taller o corrige los datos del repuesto.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF1E40AF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Campo: Código SKU / Serie ─────────────────────────────────
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Código SKU / Serie',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _skuController,
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.slate900),
                      decoration: InputDecoration(
                        hintText: 'Ej. REP-8849-LCD',
                        hintStyle: GoogleFonts.inter(color: AppColors.slate400, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.slate50,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.slate200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.slate200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Campo: Nombre del Repuesto * ──────────────────────────────
              _buildCard(
                isError: errorNombre,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate700,
                        ),
                        children: const [
                          TextSpan(text: 'Nombre del Repuesto '),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nombreController,
                      onChanged: (_) {
                        if (_mostrarErrores) setState(() {});
                      },
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate900,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nombre descriptivo del repuesto',
                        hintStyle: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
                        filled: true,
                        fillColor: errorNombre ? AppColors.errorBg : Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: errorNombre ? AppColors.error : AppColors.slate200,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: errorNombre ? AppColors.error : AppColors.slate200,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                    if (errorNombre) ...[
                      const SizedBox(height: 6),
                      _buildErrorMessage('El nombre no puede quedar vacío'),
                    ],

                    const SizedBox(height: 16),

                    // Categoría (Chips)
                    Text(
                      'Categoría',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categorias.map((cat) {
                          final isSelected = _categoriaSeleccionada == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () => setState(() => _categoriaSeleccionada = cat),
                              borderRadius: BorderRadius.circular(20),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFEFF6FF) : AppColors.slate50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF2563EB) : AppColors.slate200,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                  cat,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? const Color(0xFF1D4ED8) : AppColors.slate600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Estado de la pieza (Segmented selector)
                    Text(
                      'Estado de la Pieza',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSegmentOption(
                              label: '✨ Nuevo',
                              value: 'Nuevo',
                              isSelected: _estadoPieza == 'Nuevo',
                              onTap: () => setState(() => _estadoPieza = 'Nuevo'),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: _buildSegmentOption(
                              label: '♻ Usado / Recupero',
                              value: 'Usado / Recupero',
                              isSelected: _estadoPieza == 'Usado / Recupero',
                              onTap: () => setState(() => _estadoPieza = 'Usado / Recupero'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Campo: Ubicación en Taller (Destacado) y Cantidad ─────────
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ubicación con llamada visual
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: Color(0xFF2563EB), size: 18),
                        const SizedBox(width: 6),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1D4ED8),
                            ),
                            children: const [
                              TextSpan(text: 'Ubicación Física en Taller '),
                              TextSpan(
                                text: '*',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _ubicacionController,
                      onChanged: (_) {
                        if (_mostrarErrores) setState(() {});
                      },
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ej. Estantería A3 — Nivel 2',
                        hintStyle: GoogleFonts.inter(color: AppColors.slate400, fontSize: 13),
                        filled: true,
                        fillColor: errorUbicacion ? AppColors.errorBg : const Color(0xFFF0FDF4),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: errorUbicacion ? AppColors.error : const Color(0xFF86EFAC),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: errorUbicacion ? AppColors.error : const Color(0xFF86EFAC),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xFF16A34A), width: 1.5),
                        ),
                      ),
                    ),
                    if (errorUbicacion) ...[
                      const SizedBox(height: 6),
                      _buildErrorMessage('Ingresa la ubicación física del taller'),
                    ],

                    const SizedBox(height: 16),

                    // Cantidad (Stepper)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cantidad Disponible:',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate700,
                          ),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.slate50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: errorCantidad ? AppColors.error : AppColors.slate200,
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: _cantidad > 1
                                    ? () => setState(() => _cantidad--)
                                    : null,
                                icon: const Icon(Icons.remove, size: 16),
                                splashRadius: 16,
                                color: _cantidad > 1 ? AppColors.slate700 : AppColors.slate300,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '$_cantidad',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate900,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _cantidad++),
                                icon: const Icon(Icons.add, size: 16),
                                splashRadius: 16,
                                color: AppColors.slate700,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Campo: Notas / Compatibilidad ────────────────────────────
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notas / Compatibilidad (Opcional)',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notasController,
                      maxLines: 3,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.slate900),
                      decoration: InputDecoration(
                        hintText: 'Detalles específicos, modelos compatibles o precauciones...',
                        hintStyle: GoogleFonts.inter(color: AppColors.slate400, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.slate50,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.slate200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.slate200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Botón: Guardar Cambios ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isGuardando ? null : _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isGuardando
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Guardando cambios...',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Guardar Cambios',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),

              // Botón Cancelar
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, bool isError = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isError ? AppColors.errorBorder : AppColors.slate200,
          width: isError ? 1.5 : 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildSegmentOption({
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.slate900 : AppColors.slate500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String msg) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.error),
        const SizedBox(width: 4),
        Text(
          msg,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}
