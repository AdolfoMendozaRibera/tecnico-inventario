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
      appBar: AppBar(
        title: Text(
          'Reservar Repuesto',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.yellowDefault.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.yellowDefault.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repuesto seleccionado:',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.repuestoNombre,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _equipoController,
                style: GoogleFonts.inter(),
                decoration: InputDecoration(
                  labelText: 'Equipo Destino (Requerido)',
                  labelStyle: GoogleFonts.inter(),
                  hintText: 'Ej. Dell Inspiron 15 de Juan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.devices),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _motivoController,
                style: GoogleFonts.inter(),
                decoration: InputDecoration(
                  labelText: 'Motivo de la reserva (Opcional)',
                  labelStyle: GoogleFonts.inter(),
                  hintText: 'Ej. Cambio de pantalla rota',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _confirmarReserva,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellowDefault,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Text(
                        'Confirmar Reserva',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
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
        const SnackBar(content: Text('El equipo destino es requerido')),
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
          const SnackBar(content: Text('¡Reserva confirmada con éxito!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al reservar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
