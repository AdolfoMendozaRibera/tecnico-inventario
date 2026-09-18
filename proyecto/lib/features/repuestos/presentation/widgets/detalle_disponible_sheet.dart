import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/repuesto_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../reservas/presentation/screens/reservar_screen.dart';
import '../screens/editar_repuesto_screen.dart';
import 'modal_baja_repuesto.dart';

/// Modal Bottom Sheet para inspeccionar un repuesto disponible antes de reservarlo
/// y gestionar su ficha (Edición / Reubicación / Baja por merma) según el rol activo.
class DetalleDisponibleSheet extends StatefulWidget {
  final Repuesto repuesto;

  const DetalleDisponibleSheet({
    super.key,
    required this.repuesto,
  });

  static Future<void> show(BuildContext context, Repuesto repuesto) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetalleDisponibleSheet(repuesto: repuesto),
    );
  }

  @override
  State<DetalleDisponibleSheet> createState() => _DetalleDisponibleSheetState();
}

class _DetalleDisponibleSheetState extends State<DetalleDisponibleSheet> {
  bool _isPreparing = false;

  void _irAReservar() async {
    setState(() => _isPreparing = true);
    await Future.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;

    final navigator = Navigator.of(context);
    navigator.pop(); // Cierra el bottom sheet

    navigator.push(MaterialPageRoute(
      builder: (_) => ReservarScreen(
        repuestoId: widget.repuesto.id,
        repuestoNombre: widget.repuesto.nombre,
      ),
    ));
  }

  void _abrirEdicion() async {
    final navigator = Navigator.of(context);
    navigator.pop(); // Cierra el sheet

    navigator.push(MaterialPageRoute(
      builder: (_) => EditarRepuestoScreen(repuesto: widget.repuesto),
    ));
  }

  void _abrirModalBaja() async {
    final result = await ModalBajaRepuesto.show(context, widget.repuesto);
    if (result == true && mounted) {
      Navigator.of(context).pop(); // Cierra el sheet de detalle tras la baja
    }
  }

  @override
  Widget build(BuildContext context) {
    final repuesto = widget.repuesto;
    final authProvider = context.watch<AuthProvider>();
    final bool isAdmin = authProvider.isAdmin;

    final cod = repuesto.parsedSku != null && repuesto.parsedSku!.isNotEmpty
        ? 'SKU: ${repuesto.parsedSku}'
        : 'Cód: ${repuesto.categoria.toUpperCase().substring(0, repuesto.categoria.length > 3 ? 3 : repuesto.categoria.length)}-${repuesto.id.substring(0, 4).toUpperCase()}';
    final ubicacion = repuesto.parsedUbicacion;
    final estadoPieza = repuesto.parsedEstadoPieza;
    final notas = repuesto.parsedNotas;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar de arrastre
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

              // Título + Código + Badge "● Disponible"
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repuesto.nombre,
                          style: GoogleFonts.inter(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          cod,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.slate500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Badge verde "● Disponible"
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.emeraldBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.emeraldValue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Disponible',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emeraldLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(color: Color(0xFFF1F5F9), height: 1),
              ),

              // Fila 1: Categoría y Estado de la pieza
              Row(
                children: [
                  // Categoría
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3E8FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.stars_rounded,
                              size: 18,
                              color: Color(0xFF7E22CE),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CATEGORÍA',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                repuesto.categoria,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Estado de la pieza
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: estadoPieza == 'Nuevo' ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              estadoPieza == 'Nuevo' ? Icons.verified_outlined : Icons.recycling_rounded,
                              size: 18,
                              color: estadoPieza == 'Nuevo' ? const Color(0xFF047857) : const Color(0xFFB45309),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ESTADO',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                estadoPieza,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: estadoPieza == 'Nuevo' ? const Color(0xFF047857) : const Color(0xFFB45309),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Fila 2: Ubicación física en taller (Tarjeta destacada con botón de reubicar directo)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.slate50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF2563EB),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ubicación física en taller',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ubicacion,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Stock disponible badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.slate200),
                      ),
                      child: Text(
                        '${repuesto.cantidad} ${repuesto.cantidad == 1 ? "disp." : "disp."}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Fila 3: Notas / Compatibilidad si existen
              if (notas != null && notas.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.slate200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOTAS / COMPATIBILIDAD',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        notas,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // ── Botones de Gestión (Edición / Reubicación / Baja) ─────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _abrirEdicion,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: Text(
                        'Editar / Reubicar',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.slate800,
                        side: const BorderSide(color: AppColors.slate300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: _abrirModalBaja,
                      icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                      label: Text(
                        'Baja',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.errorBorder),
                        backgroundColor: AppColors.errorBg,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // ── Botón Primario: "Reservar para un Equipo" ─────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isPreparing ? null : _irAReservar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isPreparing
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
                              'Preparando formulario...',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Reservar para un Equipo',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),

              // Botón Secundario: "Cerrar"
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.slate500,
                  ),
                  child: Text(
                    'Cerrar',
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
