import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../repuestos/data/repuesto_model.dart';
import '../../../repuestos/providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// Bottom Sheet — "Liberar Repuesto al Taller".
/// Permite liberar parcial o totalmente las unidades reservadas,
/// devolviendo el stock al inventario disponible del taller.
class LiberarRepuestoSheet extends StatefulWidget {
  final Repuesto repuesto;
  final void Function(String mensaje) onConfirmar;

  const LiberarRepuestoSheet({
    super.key,
    required this.repuesto,
    required this.onConfirmar,
  });

  @override
  State<LiberarRepuestoSheet> createState() => _LiberarRepuestoSheetState();
}

class _LiberarRepuestoSheetState extends State<LiberarRepuestoSheet> {
  int _cantidad = 1;
  bool _cargando = false;

  int get _max => widget.repuesto.cantidad;
  int get _quedaraReservado => _max - _cantidad;

  void _decrement() {
    if (_cantidad > 1) setState(() => _cantidad--);
  }

  void _increment() {
    if (_cantidad < _max) setState(() => _cantidad++);
  }

  Future<void> _confirmar() async {
    setState(() => _cargando = true);
    final provider = context.read<RepuestosProvider>();
    final exito = await provider.liberarRepuesto(widget.repuesto.id, _cantidad);
    if (!mounted) return;
    Navigator.pop(context);
    if (exito) {
      HapticFeedback.lightImpact();
      final liberacionTotal = _quedaraReservado <= 0;
      final msg = liberacionTotal
          ? 'Repuesto liberado y devuelto al taller como disponible'
          : '$_cantidad unidad${_cantidad != 1 ? 'es' : ''} liberada${_cantidad != 1 ? 's' : ''} al taller';
      widget.onConfirmar(msg);
    }
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
          const SizedBox(height: 20),

          // Título
          Text(
            'Liberar Repuesto',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.slate900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.repuesto.nombre,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.slate500,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE2E8F0), height: 1),
          ),

          // Pregunta
          Text(
            '¿Cuántas unidades vas a\nliberar al taller?',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.slate900,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Stepper
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.slate200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón -
                _StepperButton(
                  icon: Icons.remove_rounded,
                  enabled: _cantidad > 1,
                  filled: false,
                  onTap: _decrement,
                ),

                // Número
                Text(
                  '$_cantidad',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),

                // Botón +
                _StepperButton(
                  icon: Icons.add_rounded,
                  enabled: _cantidad < _max,
                  filled: true,
                  onTap: _increment,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Caption máximo
          Center(
            child: Text(
              'Máximo: $_max unidades reservadas',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.slate400,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Preview dinámico
          Center(
            child: _quedaraReservado > 0
                ? RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.slate500),
                      children: [
                        const TextSpan(text: 'Quedará '),
                        TextSpan(
                          text:
                              '$_quedaraReservado unidad${_quedaraReservado != 1 ? 'es' : ''} reservada${_quedaraReservado != 1 ? 's' : ''}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    'Se liberará la reserva completa',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
                  ),
          ),

          const SizedBox(height: 24),

          // Botón Confirmar Liberación (outline rojo)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _cargando ? null : _confirmar,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                side: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
                backgroundColor: const Color(0xFFFFF5F5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _cargando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFDC2626),
                      ),
                    )
                  : Text(
                      'Confirmar Liberación',
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
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final bool filled;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: filled
              ? (enabled ? const Color(0xFFDC2626) : AppColors.slate200)
              : Colors.white,
          shape: BoxShape.circle,
          border: filled ? null : Border.all(color: AppColors.slate200, width: 1.5),
        ),
        child: Icon(
          icon,
          size: 22,
          color: filled
              ? Colors.white
              : (enabled ? AppColors.slate700 : AppColors.slate300),
        ),
      ),
    );
  }
}
