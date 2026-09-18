import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../home/providers/navigation_provider.dart';
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

  /// 0 = Mis Reservas, 1 = Reservas del Taller (solo para admin)
  int _adminTab = 0;

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
    final authProvider = context.watch<AuthProvider>();
    final isAdmin = authProvider.isAdmin;
    final currentUserId = authProvider.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        backgroundColor: AppColors.slate50,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          isAdmin && _adminTab == 1 ? 'Reservas del Taller' : 'Mis Reservas',
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
            final isViewingAll = isAdmin && _adminTab == 1;
            final repuestos = isViewingAll ? provider.reservados : provider.misReservas;
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
                  (r.motivo ?? '').toLowerCase().contains(query) ||
                  (r.reservadoPorNombre ?? '').toLowerCase().contains(query);
            }).toList();

            return Column(
              children: [
                // ─── Selector de Vista para Administradores ───────────────────
                if (isAdmin)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildAdminTabButton(
                              label: 'Mis Reservas (${provider.misReservas.length})',
                              isSelected: _adminTab == 0,
                              onTap: () => setState(() => _adminTab = 0),
                            ),
                          ),
                          Expanded(
                            child: _buildAdminTabButton(
                              label: 'Taller (${provider.reservados.length})',
                              isSelected: _adminTab == 1,
                              onTap: () => setState(() => _adminTab = 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ─── Banner verde de éxito (auto-hide) ───────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _bannerMensaje != null
                      ? Container(
                          key: const ValueKey('banner'),
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981), // Verde Esmeralda Figma
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 15),
                              ),
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
                                    color: Colors.white70, size: 18),
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
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                      children: [
                        // Subtítulo dinámico
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 2),
                          child: Text(
                            isViewingAll
                                ? (count == 0
                                    ? 'No hay repuestos reservados en el taller'
                                    : 'Hay $count repuesto${count != 1 ? 's' : ''} reservado${count != 1 ? 's' : ''} en todo el taller')
                                : (count == 0
                                    ? 'No tienes repuestos pendientes por usar'
                                    : 'Tienes $count repuesto${count != 1 ? 's' : ''} reservado${count != 1 ? 's' : ''} listo${count != 1 ? 's' : ''} para usar'),
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
                              hintText: isViewingAll
                                  ? 'Buscar por pieza, equipo o técnico...'
                                  : 'Buscar en mis reservas...',
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
                                  isViewingAll
                                      ? '¡Todo el taller al día!'
                                      : '¡Todo al día!',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isViewingAll
                                      ? 'No hay repuestos reservados actualmente en el inventario del taller.'
                                      : 'Has marcado y consumido todos los repuestos\nque tenías reservados para tus trabajos.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.slate500,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.read<NavigationProvider>().setTab(1);
                                  },
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
                            final isOwn = repuesto.reservadoPor == currentUserId;
                            return GestureDetector(
                              onTap: () =>
                                  _abrirGestionSheet(context, repuesto),
                              child: ReservationCard(
                                repuesto: repuesto,
                                isMiReserva: isOwn,
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
                          Material(
                            color: AppColors.slate50,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () {
                                context.read<NavigationProvider>().setTab(1);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
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

  Widget _buildAdminTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.slate900 : AppColors.slate500,
            ),
          ),
        ),
      ),
    );
  }
}
