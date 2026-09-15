import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../repuestos/providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/reservation_card.dart';
import '../widgets/gestionar_reserva_sheet.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key});

  @override
  State<MisReservasScreen> createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  /// Mensaje de éxito a mostrar como banner verde en la parte superior.
  /// null = no mostrar banner.
  String? _bannerMensaje;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Abre el GestionarReservaSheet y registra el callback de éxito.
  void _abrirGestionSheet(BuildContext ctx, dynamic repuesto) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GestionarReservaSheet(
        repuesto: repuesto,
        onAccionExitosa: (mensaje) {
          if (!mounted) return;
          setState(() => _bannerMensaje = mensaje);
          // Auto-ocultar el banner tras 3 segundos
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _bannerMensaje = null);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        backgroundColor: AppColors.slate50,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Mis Reservas',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.slate900,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<RepuestosProvider>(
          builder: (context, provider, child) {
            final repuestos = provider.misReservas;
            final int count = repuestos.length;

            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.slate800),
              );
            }

            final filtered = repuestos.where((r) {
              if (_searchQuery.isEmpty) return true;
              final query = _searchQuery.toLowerCase();
              return r.nombre.toLowerCase().contains(query) ||
                  r.categoria.toLowerCase().contains(query) ||
                  (r.equipoDestino ?? '').toLowerCase().contains(query) ||
                  (r.motivo ?? '').toLowerCase().contains(query);
            }).toList();

            return Column(
              children: [
                // ─── Banner verde de éxito (auto-hide) ───────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _bannerMensaje != null
                      ? Container(
                          key: const ValueKey('banner'),
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _bannerMensaje!,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _bannerMensaje = null),
                                child: const Icon(Icons.close_rounded,
                                    color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('no-banner')),
                ),

                // ─── Lista principal ──────────────────────────────────────────
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.slate800,
                    onRefresh: () => provider.fetchRepuestos(),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                      children: [
                        // Subtítulo dinámico
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 2),
                          child: Text(
                            count == 0
                                ? 'No tienes repuestos pendientes por usar'
                                : 'Tienes $count repuesto${count != 1 ? 's' : ''} reservado${count != 1 ? 's' : ''} listo${count != 1 ? 's' : ''} para usar',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.slate500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Barra de búsqueda
                        if (repuestos.isNotEmpty) ...[
                          TextField(
                            controller: _searchController,
                            onChanged: (val) =>
                                setState(() => _searchQuery = val.trim()),
                            style: GoogleFonts.inter(
                                fontSize: 14, color: AppColors.slate900),
                            decoration: InputDecoration(
                              hintText: 'Buscar en mis reservas...',
                              hintStyle: GoogleFonts.inter(
                                  color: AppColors.slate400, fontSize: 14),
                              prefixIcon: const Icon(Icons.search_rounded,
                                  color: AppColors.slate400, size: 20),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded,
                                          size: 18, color: AppColors.slate500),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.slate200, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.slate800, width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Estado vacío mejorado (¡Todo al día!)
                        if (repuestos.isEmpty) ...[
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40, horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.slate200, width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.bookmark_added_rounded,
                                    size: 32,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '¡Todo al día!',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Has marcado y consumido todos los repuestos\nque tenías reservados para tus trabajos.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.slate500,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search_rounded,
                                      size: 16),
                                  label: const Text('Ir al Catálogo de Repuestos'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.slate900,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Sin resultados de búsqueda
                        if (repuestos.isNotEmpty && filtered.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                'No se encontraron reservas con "$_searchQuery"',
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: AppColors.slate500),
                              ),
                            ),
                          ),

                        // Lista de tarjetas — tap abre GestionarReservaSheet
                        if (filtered.isNotEmpty)
                          ...filtered.map((repuesto) {
                            return GestureDetector(
                              onTap: () =>
                                  _abrirGestionSheet(context, repuesto),
                              child: ReservationCard(
                                repuesto: repuesto,
                                isMiReserva: true,
                                useRedLiberarButton: true,
                                onMarcarUsado: () =>
                                    _abrirGestionSheet(context, repuesto),
                                onLiberar: () =>
                                    _abrirGestionSheet(context, repuesto),
                              ),
                            );
                          }),

                        // Sección CTA "¿Necesitas otro repuesto?"
                        if (repuestos.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.slate50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.slate200, width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '¿Necesitas otro repuesto?',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.slate900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Busca en la pestaña Repuestos →',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFF1E3A5F),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
