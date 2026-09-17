import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'agregar_repuesto_exito_screen.dart';

/// Pantalla 2 del Flujo v0.4 — "Confirmar Repuesto (Revisa los datos antes de guardar)"
/// Diseñada con fidelidad exacta a Figma (Frame 6).
class AgregarRepuestoPreviewScreen extends StatefulWidget {
  final String nombre;
  final String categoria;
  final String? sku;
  final String estadoPieza;
  final String ubicacion;
  final int cantidad;
  final String? notas;

  const AgregarRepuestoPreviewScreen({
    super.key,
    required this.nombre,
    required this.categoria,
    this.sku,
    required this.estadoPieza,
    required this.ubicacion,
    required this.cantidad,
    this.notas,
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

    // Unimos los metadatos enriquecidos en la descripción si existen
    final buffer = StringBuffer();
    if (widget.sku != null && widget.sku!.isNotEmpty) {
      buffer.writeln('SKU: ${widget.sku}');
    }
    buffer.writeln('Estado de pieza: ${widget.estadoPieza}');
    buffer.writeln('Ubicación: ${widget.ubicacion}');
    if (widget.notas != null && widget.notas!.isNotEmpty) {
      buffer.writeln('Notas: ${widget.notas}');
    }

    final provider = context.read<RepuestosProvider>();
    final exito = await provider.agregarRepuesto(
      nombre: widget.nombre,
      categoria: widget.categoria,
      descripcion: buffer.toString().trim(),
    );

    if (!mounted) return;
    setState(() => _isGuardando = false);

    if (exito) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => AgregarRepuestoExitoScreen(
          nombre: widget.nombre,
          categoria: widget.categoria,
          sku: widget.sku,
          estadoPieza: widget.estadoPieza,
          ubicacion: widget.ubicacion,
          cantidad: widget.cantidad,
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
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'pantallas':
        return Icons.laptop_chromebook_rounded;
      case 'placas':
      case 'placas madre':
        return Icons.developer_board_rounded;
      case 'memorias':
      case 'memorias ram':
        return Icons.memory_rounded;
      case 'baterías':
        return Icons.battery_charging_full_rounded;
      case 'teclados':
        return Icons.keyboard_rounded;
      case 'almacenamiento':
      case 'discos / ssd':
        return Icons.storage_rounded;
      case 'cargadores':
        return Icons.power_rounded;
      default:
        return Icons.build_circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Cabecera: Botón Volver + Título (Frame 6) ─────────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: AppColors.slate200, width: 1.2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: AppColors.slate800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                'Confirmar Repuesto',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slate900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Revisa los datos antes de guardar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.slate500,
                ),
              ),
              const SizedBox(height: 20),

              // ── Card de Resumen Detallada (Figma Frame 6) ─────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.slate200, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila: Ícono de categoría + Nombre + SKU
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFDBEAFE), width: 1.2),
                          ),
                          child: Center(
                            child: Icon(
                              _getCategoryIcon(widget.categoria),
                              color: const Color(0xFF2563EB),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.nombre,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate900,
                                  letterSpacing: -0.3,
                                  height: 1.25,
                                ),
                              ),
                              if (widget.sku != null && widget.sku!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'SKU: ${widget.sku}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.slate500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.slate100, height: 1, thickness: 1),
                    const SizedBox(height: 14),

                    // Fila: Categoría y Estado de la pieza
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CATEGORÍA',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.categoria,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1D4ED8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ESTADO',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: widget.estadoPieza == 'Nuevo'
                                      ? const Color(0xFFECFDF5)
                                      : const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.estadoPieza,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: widget.estadoPieza == 'Nuevo'
                                        ? const Color(0xFF047857)
                                        : const Color(0xFFB45309),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.slate100, height: 1, thickness: 1),
                    const SizedBox(height: 14),

                    // Fila: Ubicación en Taller y Cantidad
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UBICACIÓN EN TALLER',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.ubicacion,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CANTIDAD',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.cantidad == 1 ? '1 Unidad' : '${widget.cantidad} Unidades',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Notas / Compatibilidad
                    if (widget.notas != null && widget.notas!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.slate100, height: 1, thickness: 1),
                      const SizedBox(height: 14),
                      Text(
                        'NOTAS / COMPATIBILIDAD',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate400,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.notas!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Banner Ámbar: Verifica antes de continuar (Frame 6) ───────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.priority_high_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verifica antes de continuar',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Estos datos se guardarán en el inventario del taller.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Card: Registrado por Carlos (Técnico) (Frame 6) ───────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.slate200, width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E293B),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'CT',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTRADO POR',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate400,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Carlos (Técnico)',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Botón: Confirmar y Guardar (Frame 6) ──────────────────────
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isGuardando ? null : _confirmarGuardado,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isGuardando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Confirmar y Guardar',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Botón: Editar Datos (Frame 6) ─────────────────────────────
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: _isGuardando ? null : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.slate800,
                    side: const BorderSide(color: AppColors.slate200, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Editar Datos',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate800,
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
}

