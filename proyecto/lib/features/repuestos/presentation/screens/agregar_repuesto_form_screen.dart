import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'agregar_repuesto_preview_screen.dart';

/// Pantalla 1 del Flujo v0.4 — "Nuevo Repuesto (Ingreso directo al inventario del taller)"
/// Diseñada con fidelidad exacta a Figma (Frame 5, Frame (3) para validaciones y Frame (4) para error de conexión).
class AgregarRepuestoFormScreen extends StatefulWidget {
  final String? nombreInicial;

  const AgregarRepuestoFormScreen({
    super.key,
    this.nombreInicial,
  });

  @override
  State<AgregarRepuestoFormScreen> createState() =>
      _AgregarRepuestoFormScreenState();
}

class _AgregarRepuestoFormScreenState extends State<AgregarRepuestoFormScreen> {
  final _skuController = TextEditingController();
  late final TextEditingController _nombreController;
  final _ubicacionController = TextEditingController(text: 'Estante B - Cajón 2');
  final _notasController = TextEditingController();

  String _categoriaSeleccionada = 'Pantallas';
  String _estadoPieza = 'Nuevo'; // 'Nuevo' | 'Usado / Recupero'
  int _cantidad = 1;

  // Estados de validación visual explícita según Frame (3)
  bool _mostrarErrores = false;
  bool _errorConexion = false; // Simulación / control de banner de error Frame (4)

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
    _nombreController = TextEditingController(text: widget.nombreInicial ?? '');
    _skuController.text = 'REP-8849-LCD';
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
  bool get _isEstadoValido => _estadoPieza.isNotEmpty;
  bool get _isCantidadValida => _cantidad > 0;
  bool get _isUbicacionValida => _ubicacionController.text.trim().isNotEmpty;

  void _validarYContinuar() {
    setState(() {
      _mostrarErrores = true;
    });

    if (!_isNombreValido || !_isEstadoValido || !_isCantidadValida || !_isUbicacionValida) {
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AgregarRepuestoPreviewScreen(
        nombre: _nombreController.text.trim(),
        categoria: _categoriaSeleccionada,
        sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
        estadoPieza: _estadoPieza,
        ubicacion: _ubicacionController.text.trim(),
        cantidad: _cantidad,
        notas: _notasController.text.trim().isEmpty ? null : _notasController.text.trim(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bool errorNombre = _mostrarErrores && !_isNombreValido;
    final bool errorEstado = _mostrarErrores && !_isEstadoValido;
    final bool errorCantidad = _mostrarErrores && !_isCantidadValida;
    final bool errorUbicacion = _mostrarErrores && !_isUbicacionValida;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header con Botón Volver y Badge de Técnico ─────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).maybePop(),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.slate200),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.slate700,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.slate500),
                        const SizedBox(width: 4),
                        Text(
                          'Carlos (Técnico)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Título y Subtítulo ─────────────────────────────────────
              Text(
                'Nuevo Repuesto',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slate900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ingreso directo al inventario del taller',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.slate500,
                ),
              ),
              const SizedBox(height: 20),

              // ── Banner de Error de Conexión (Frame 4) ──────────────────
              if (_errorConexion) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.wifi_off_rounded,
                            color: Color(0xFFDC2626),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Error de Conexión',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF991B1B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'No se pudo verificar la base de datos. Comprueba tu red WiFi del taller.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFFB91C1C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _errorConexion = false),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Color(0xFF991B1B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _validarYContinuar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Reintentar',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Campo: Código SKU / Serie (Opcional) + Botón Escanear ─────
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Código SKU / Serie (Opcional)',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _skuController,
                            style: GoogleFonts.inter(fontSize: 14, color: AppColors.slate900),
                            decoration: InputDecoration(
                              hintText: 'REP-8849-LCD',
                              hintStyle: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
                              filled: true,
                              fillColor: AppColors.slate50,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                                borderSide: const BorderSide(color: AppColors.slate800, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Escáner de código de barras listo (cámara activa).'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.qr_code_scanner_rounded, size: 18, color: Colors.white),
                          label: Text(
                            'Escanear',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB), // Azul vibrante de Figma
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
              const SizedBox(height: 14),

              // ── Campo: Nombre del Repuesto * ──────────────────────────────
              _buildCardContainer(
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
                            style: TextStyle(color: Color(0xFFEF4444)),
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
                        hintText: 'Pantalla LCD 15.6" FHD Slim 30 Pines',
                        hintStyle: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
                        filled: true,
                        fillColor: errorNombre ? const Color(0xFFFEF2F2) : Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: errorNombre ? const Color(0xFFEF4444) : const Color(0xFF3B82F6),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: errorNombre ? const Color(0xFFEF4444) : const Color(0xFF3B82F6),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: errorNombre ? const Color(0xFFEF4444) : const Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    if (errorNombre) ...[
                      const SizedBox(height: 6),
                      _buildErrorMessage('Este campo es obligatorio'),
                    ],

                    const SizedBox(height: 16),

                    // ── Categoría * (Chips) ──────────────────────────────────
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate700,
                        ),
                        children: const [
                          TextSpan(text: 'Categoría '),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Color(0xFFEF4444)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categorias.map((cat) {
                          final bool isSelected = _categoriaSeleccionada == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () => setState(() => _categoriaSeleccionada = cat),
                              borderRadius: BorderRadius.circular(20),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFEFF6FF) : AppColors.slate50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF2563EB) : AppColors.slate200,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSelected) ...[
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF2563EB),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    Text(
                                      cat,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        color: isSelected ? const Color(0xFF1D4ED8) : AppColors.slate500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Estado de la Pieza * (Segmented Selector) ─────────────
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate700,
                        ),
                        children: const [
                          TextSpan(text: 'Estado de la Pieza '),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Color(0xFFEF4444)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(12),
                        border: errorEstado ? Border.all(color: const Color(0xFFEF4444), width: 1.5) : null,
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
                    if (errorEstado) ...[
                      const SizedBox(height: 6),
                      _buildErrorMessage('Selecciona el estado de la pieza'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Fila: Ubicación en Taller * y Cantidad (Stepper) ───────────
              _buildCardContainer(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ubicación
                    Expanded(
                      flex: 3,
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
                                TextSpan(text: 'Ubicación en Taller '),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Color(0xFFEF4444)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _ubicacionController,
                            onChanged: (_) {
                              if (_mostrarErrores) setState(() {});
                            },
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.slate900,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ej. Estante B - Cajón 2',
                              hintStyle: GoogleFonts.inter(color: AppColors.slate400, fontSize: 13),
                              filled: true,
                              fillColor: errorUbicacion ? const Color(0xFFFEF2F2) : AppColors.slate50,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: errorUbicacion ? const Color(0xFFEF4444) : AppColors.slate200,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: errorUbicacion ? const Color(0xFFEF4444) : AppColors.slate200,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: errorUbicacion ? const Color(0xFFEF4444) : AppColors.slate800,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          if (errorUbicacion) ...[
                            const SizedBox(height: 6),
                            _buildErrorMessage('Ingresa la ubicación física'),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Cantidad (Stepper)
                    Expanded(
                      flex: 2,
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
                                TextSpan(text: 'Cantidad '),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Color(0xFFEF4444)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.slate50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: errorCantidad ? const Color(0xFFEF4444) : AppColors.slate200,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: _cantidad > 1
                                      ? () => setState(() => _cantidad--)
                                      : null,
                                  icon: const Icon(Icons.remove, size: 16),
                                  splashRadius: 18,
                                  color: _cantidad > 1 ? AppColors.slate700 : AppColors.slate300,
                                ),
                                Text(
                                  '$_cantidad',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate900,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => setState(() => _cantidad++),
                                  icon: const Icon(Icons.add, size: 16),
                                  splashRadius: 18,
                                  color: AppColors.slate700,
                                ),
                              ],
                            ),
                          ),
                          if (errorCantidad) ...[
                            const SizedBox(height: 6),
                            _buildErrorMessage('Mínimo 1 unidad'),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Campo: Notas del Repuesto (Opcional) ───────────────────────
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notas del Repuesto (Opcional)',
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
                        hintText: 'Detalles adicionales, proveedor de origen, compatibilidad específica...',
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
                          borderSide: const BorderSide(color: AppColors.slate800, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Botón Principal de Acción ────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _validarYContinuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB), // Azul primario vibrante
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Guardar e Ingresar Repuesto',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Botón Cancelar ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.slate500,
                  ),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child, bool isError = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isError ? const Color(0xFFFCA5A5) : AppColors.slate200,
          width: isError ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: AppColors.slate200, width: 1.2) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.slate900 : AppColors.slate500,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Color(0xFFEF4444),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.priority_high_rounded, size: 10, color: Colors.white),
        ),
        const SizedBox(width: 5),
        Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFEF4444),
          ),
        ),
      ],
    );
  }
}
