import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../repuestos/providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';

class ReservarScreen extends StatefulWidget {
  final String repuestoId;
  final String repuestoNombre;

  const ReservarScreen({
    super.key,
    required this.repuestoId,
    required this.repuestoNombre,
  });

  @override
  State<ReservarScreen> createState() => _ReservarScreenState();
}

class _ReservarScreenState extends State<ReservarScreen> {
  final _equipoController = TextEditingController();
  final _motivoController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _equipoController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        backgroundColor: AppColors.slate50,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.slate900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Reservar Repuesto',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.slate900,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tarjeta Resumen del Repuesto Seleccionado (Figma Style)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.slate200, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.slate100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            size: 22,
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
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.slate500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.repuestoNombre,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate900,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Badge "Disponible"
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Disponible',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Campo: Equipo Destino
              Text(
                'Equipo Destino *',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _equipoController,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.slate900,
                ),
                decoration: InputDecoration(
                  hintText: 'Ej. Dell Latitude 5420 - N° 102',
                  hintStyle: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.devices_rounded,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.slate200,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.slate800,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Campo: Motivo de la reserva
              Text(
                'Motivo de la reserva (Opcional)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _motivoController,
                maxLines: 3,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.slate900,
                ),
                decoration: InputDecoration(
                  hintText: 'Ej. Mantenimiento programado o cambio de pantalla rota',
                  hintStyle: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 36.0),
                    child: Icon(
                      Icons.description_outlined,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.slate200,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.slate800,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Botón Primario Figma: Confirmar Reserva (#1E293B)
              ElevatedButton(
                onPressed: _isSubmitting ? null : _confirmarReserva,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.slate800,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Confirmar Reserva',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),

              const SizedBox(height: 12),

              // Botón Secundario: Cancelar
              TextButton(
                onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: AppColors.slate500,
                ),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarReserva() async {
    final equipo = _equipoController.text.trim();
    if (equipo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'El equipo destino es requerido',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await context.read<RepuestosProvider>().reservarRepuesto(
        widget.repuestoId,
        equipo,
        _motivoController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Reserva confirmada con éxito!',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: AppColors.slate800,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al reservar: $e',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
