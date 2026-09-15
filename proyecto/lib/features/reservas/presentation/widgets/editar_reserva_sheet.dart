import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../repuestos/data/repuesto_model.dart';
import '../../../repuestos/providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// Bottom Sheet de pantalla completa — "Editar Reserva".
/// Pre-rellena los campos con los datos actuales y permite
/// corregir el equipo destino y el motivo de la reserva.
class EditarReservaSheet extends StatefulWidget {
  final Repuesto repuesto;
  final void Function(String mensaje) onConfirmar;

  const EditarReservaSheet({
    super.key,
    required this.repuesto,
    required this.onConfirmar,
  });

  @override
  State<EditarReservaSheet> createState() => _EditarReservaSheetState();
}

class _EditarReservaSheetState extends State<EditarReservaSheet> {
  late final TextEditingController _equipoCtrl;
  late final TextEditingController _motivoCtrl;
  final _formKey = GlobalKey<FormState>();
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _equipoCtrl = TextEditingController(text: widget.repuesto.equipoDestino ?? '');
    _motivoCtrl = TextEditingController(text: widget.repuesto.motivo ?? '');
  }

  @override
  void dispose() {
    _equipoCtrl.dispose();
    _motivoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _cargando = true);
    final provider = context.read<RepuestosProvider>();
    final exito = await provider.editarReserva(
      widget.repuesto.id,
      _equipoCtrl.text.trim(),
      _motivoCtrl.text.trim(),
    );
    if (!mounted) return;
    Navigator.pop(context);
    if (exito) widget.onConfirmar('Reserva actualizada correctamente');
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPadding + 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.slate200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cabecera con flecha + título
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.slate50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.slate200),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: AppColors.slate700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Editar Reserva',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Tarjeta del repuesto con badge "Reservado"
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.slate200, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        size: 20,
                        color: AppColors.slate500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REPUESTO SELECCIONADO',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate400,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.repuesto.nombre,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Reservado',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Campo Equipo Destino
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate700,
                  ),
                  children: const [
                    TextSpan(text: 'Equipo Destino '),
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: Color(0xFFEF4444)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _equipoCtrl,
                enabled: !_cargando,
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.slate900),
                decoration: InputDecoration(
                  hintText: 'Ej: Laptop Dell Inspiron 15',
                  hintStyle: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.slate200, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.slate800, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El equipo destino es obligatorio';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Campo Motivo (opcional)
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate700,
                  ),
                  children: [
                    const TextSpan(text: 'Motivo de la reserva '),
                    TextSpan(
                      text: '(Opcional)',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _motivoCtrl,
                enabled: !_cargando,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.slate900),
                decoration: InputDecoration(
                  hintText: 'Ej: Cambiar pantalla rota',
                  hintStyle: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.slate200, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.slate800, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botón Guardar Cambios
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cargando ? null : _guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.slate900,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _cargando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Guardar Cambios',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),

              // Cancelar
              Center(
                child: TextButton(
                  onPressed: _cargando ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: AppColors.slate500),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
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
