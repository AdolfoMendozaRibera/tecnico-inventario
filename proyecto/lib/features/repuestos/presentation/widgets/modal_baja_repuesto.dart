import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repuesto_model.dart';
import '../../providers/repuestos_provider.dart';

/// Modal destructivo para dar de baja piezas dañadas o defectuosas (merma de taller)
/// Cumple con la regla anti-double submit, feedback háptico y tokens VaultTecno.
class ModalBajaRepuesto extends StatefulWidget {
  final Repuesto repuesto;

  const ModalBajaRepuesto({
    super.key,
    required this.repuesto,
  });

  static Future<bool?> show(BuildContext context, Repuesto repuesto) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ModalBajaRepuesto(repuesto: repuesto),
    );
  }

  @override
  State<ModalBajaRepuesto> createState() => _ModalBajaRepuestoState();
}

class _ModalBajaRepuestoState extends State<ModalBajaRepuesto> {
  int _cantidadABajar = 1;
  String _motivoSeleccionado = 'Pieza Rota / Daño Físico';
  final _notasController = TextEditingController();
  bool _isConfirmando = false;

  static const List<String> _motivos = [
    'Pieza Rota / Daño Físico',
    'Falla Eléctrica / Cortocircuito',
    'Incompatible / Obsolescencia',
    'Defectuoso de Fábrica',
  ];

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _ejecutarBaja() async {
    HapticFeedback.lightImpact();
    setState(() => _isConfirmando = true);

    final provider = context.read<RepuestosProvider>();
    final exito = await provider.darDeBajaRepuesto(
      repuestoId: widget.repuesto.id,
      cantidadABajar: _cantidadABajar,
      motivoBaja: _motivoSeleccionado,
      notas: _notasController.text.trim().isEmpty ? null : _notasController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isConfirmando = false);

    if (exito) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Se registró la baja de $_cantidadABajar ${_cantidadABajar == 1 ? "unidad" : "unidades"} en el inventario.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.lastError ?? 'Error al dar de baja el repuesto.',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final repuesto = widget.repuesto;
    final maxCantidad = repuesto.cantidad > 0 ? repuesto.cantidad : 1;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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

              // Cabecera: Icono rojo + Título
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.errorBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.errorBorder, width: 1.2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete_sweep_rounded,
                        color: AppColors.error,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dar de Baja Repuesto',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Salida definitiva por daño o merma',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.slate500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Banner de advertencia (Acción irreversible de stock)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.errorBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Esta acción descontará las unidades físicas seleccionadas del inventario disponible del taller.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF991B1B),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Información del repuesto objetivo
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.slate50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slate200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.slate600),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repuesto.nombre,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Stock actual en taller: ${repuesto.cantidad} ${repuesto.cantidad == 1 ? "unidad" : "unidades"}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.slate500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stepper de cantidad a dar de baja (si stock > 1)
              if (maxCantidad > 1) ...[
                Text(
                  'CANTIDAD A DAR DE BAJA',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.slate50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.slate200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_cantidadABajar de $maxCantidad unidades',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate800,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _cantidadABajar > 1
                                ? () => setState(() => _cantidadABajar--)
                                : null,
                            icon: const Icon(Icons.remove_circle_outline, size: 22),
                            color: _cantidadABajar > 1 ? AppColors.slate700 : AppColors.slate300,
                          ),
                          Text(
                            '$_cantidadABajar',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.slate900,
                            ),
                          ),
                          IconButton(
                            onPressed: _cantidadABajar < maxCantidad
                                ? () => setState(() => _cantidadABajar++)
                                : null,
                            icon: const Icon(Icons.add_circle_outline, size: 22),
                            color: _cantidadABajar < maxCantidad ? AppColors.slate700 : AppColors.slate300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Motivo de baja (Chips)
              Text(
                'MOTIVO DE LA BAJA',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _motivos.map((m) {
                  final isSelected = _motivoSeleccionado == m;
                  return InkWell(
                    onTap: () => setState(() => _motivoSeleccionado = m),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.errorBg : AppColors.slate50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.error : AppColors.slate200,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        m,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? const Color(0xFF991B1B) : AppColors.slate700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Observaciones adicionales
              Text(
                'DETALLES / NOTAS DE DESCARTE (OPCIONAL)',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notasController,
                maxLines: 2,
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.slate900),
                decoration: InputDecoration(
                  hintText: 'Ej. Se rompió el flex al desmontar, terminal sulfatado...',
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.slate400),
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
                    borderSide: const BorderSide(color: AppColors.error, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botón Destructivo: "Confirmar Baja de Inventario"
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isConfirmando ? null : _ejecutarBaja,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isConfirmando
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
                              'Procesando baja...',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Confirmar Baja de Inventario',
                          style: GoogleFonts.inter(
                            fontSize: 14,
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
                  onPressed: () => Navigator.of(context).pop(false),
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
            ],
          ),
        ),
      ),
    );
  }
}
