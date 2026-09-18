import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../repuestos/providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/supabase_client.dart';
import 'reserva_confirmada_screen.dart';

/// Pantalla de formulario de reserva según Figma (Reservar Repuesto 1.png / Frame.png).
/// Gestiona validación de equipo obligatorio, cantidad predeterminada,
/// banner de alerta con reintento ante errores de red o colisión de concurrencia (RNF-06),
/// y transición hacia la pantalla de confirmación exitosa.
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
  final _cantidadController = TextEditingController(text: '1');

  bool _isSubmitting = false;
  String? _errorMessage;

  int get _currentCantidad => int.tryParse(_cantidadController.text.trim()) ?? 1;

  void _incrementCantidad() {
    final current = int.tryParse(_cantidadController.text.trim()) ?? 0;
    final next = current + 1;
    _cantidadController.text = next.toString();
    setState(() {});
  }

  void _decrementCantidad() {
    final current = int.tryParse(_cantidadController.text.trim()) ?? 1;
    if (current > 1) {
      final next = current - 1;
      _cantidadController.text = next.toString();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _equipoController.dispose();
    _motivoController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _ejecutarReserva() async {
    final equipo = _equipoController.text.trim();
    if (equipo.isEmpty) {
      setState(() {
        _errorMessage = 'Debes ingresar el equipo de destino para completar la reserva.';
      });
      return;
    }

    final motivo = _motivoController.text.trim();
    final cantidadStr = _cantidadController.text.trim();
    final cantidadNum = int.tryParse(cantidadStr);
    if (cantidadNum == null || cantidadNum < 1) {
      setState(() {
        _errorMessage = 'La cantidad debe ser un número entero mayor o igual a 1.';
      });
      return;
    }
    final cantidad = cantidadNum.toString();

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final provider = context.read<RepuestosProvider>();
    final exito = await provider.reservarRepuesto(
      widget.repuestoId,
      equipo,
      motivo,
      cantidad: cantidadNum,
    );

    if (!mounted) return;

    if (exito) {
      // Pulso háptico suave: confirma al técnico que la acción fue exitosa
      // antes de que la pantalla cambie visualmente.
      HapticFeedback.lightImpact();

      final user = SupabaseService.client.auth.currentUser;
      final tecnicoNombre = user?.email?.split('@').first ?? 'Carlos';

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ReservaConfirmadaScreen(
            repuestoNombre: widget.repuestoNombre,
            equipoDestino: equipo,
            motivo: motivo.isNotEmpty ? motivo : null,
            cantidad: cantidad,
            tecnicoNombre: tecnicoNombre,
          ),
        ),
      );
    } else {
      setState(() {
        _errorMessage = provider.lastError ??
            'No se pudo completar la reserva. Revisa tu conexión e inténtalo de nuevo.';
        _isSubmitting = false;
      });
    }
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tarjeta Resumen del Repuesto Seleccionado (Figma Style)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            size: 22,
                            color: Color(0xFF64748B),
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
                                  color: const Color(0xFF64748B),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 3),
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
                        const SizedBox(width: 8),
                        // Badge verde "Disponible"
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
                  ),

                  const SizedBox(height: 24),

                  // Campo: Equipo Destino *
                  Text(
                    'Equipo Destino *',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
                        Icons.laptop_chromebook_rounded,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE2E8F0),
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

                  // Campo: Motivo de la reserva (Opcional)
                  Text(
                    'Motivo de la reserva (Opcional)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
                          color: Color(0xFFE2E8F0),
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

                  // Campo: Cantidad (Contador interactivo con botones +/- y entrada manual)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cantidad *',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate900,
                        ),
                      ),
                      Text(
                        'Mínimo: 1 unidad',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Botón Decrementar (-)
                        Material(
                          color: _currentCantidad > 1
                              ? const Color(0xFFF1F5F9)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: _currentCantidad > 1 ? _decrementCantidad : null,
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 42,
                              height: 42,
                              child: Icon(
                                Icons.remove_rounded,
                                size: 20,
                                color: _currentCantidad > 1
                                    ? AppColors.slate800
                                    : const Color(0xFFCBD5E1),
                              ),
                            ),
                          ),
                        ),

                        // Campo central para escribir directamente
                        Expanded(
                          child: TextField(
                            controller: _cantidadController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (_) => setState(() {}),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TextInputFormatter.withFunction((oldValue, newValue) {
                                if (newValue.text.isEmpty) return newValue;
                                final n = int.tryParse(newValue.text);
                                if (n == null || n < 1) return oldValue;
                                return newValue;
                              }),
                            ],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate900,
                            ),
                            decoration: const InputDecoration(
                              hintText: '1',
                              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                              isDense: true,
                            ),
                          ),
                        ),

                        // Botón Incrementar (+)
                        Material(
                          color: AppColors.slate800,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: _incrementCantidad,
                            borderRadius: BorderRadius.circular(8),
                            child: const SizedBox(
                              width: 42,
                              height: 42,
                              child: Icon(
                                Icons.add_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── BANNER DE ERROR REACTIVO (Figma: Frame.png) ───────────
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2), // Rosa/rojo suave Figma
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFECDD3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 22,
                            color: Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No se pudo completar la reserva',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF991B1B),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _errorMessage!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFFB91C1C),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),

                  // Botón Primario: Confirmar Reserva / Reintentar
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _ejecutarReserva,
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
                        : _errorMessage != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Reintentar',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
                      foregroundColor: const Color(0xFF64748B),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
