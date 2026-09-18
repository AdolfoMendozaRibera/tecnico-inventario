import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/disponible_card.dart';
import '../widgets/inventario_reservado_card.dart';
import '../widgets/detalle_reserva_sheet.dart';
import '../widgets/repuesto_skeleton_card.dart';
import '../widgets/repuesto_empty_state.dart';
import '../widgets/inventario_error_state.dart';
import '../widgets/taller_vacio_state.dart';
import '../../../reservas/presentation/screens/reservar_screen.dart';
import 'agregar_repuesto_form_screen.dart';

/// Pantalla principal del Flujo v0.1: "Consultar Estado" (Inventario del Taller).
/// Diseñada con fidelidad exacta a Figma, gestionando los estados de carga
/// con Shimmer/Skeleton, búsqueda instantánea y estados vacíos guiados.
class RepuestosListScreen extends StatelessWidget {
  const RepuestosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RepuestosProvider>(
      builder: (context, provider, child) {
        final int disponiblesCount = provider.disponibles.length;
        final int reservadosCount = provider.reservados.length;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.slate50,
            appBar: AppBar(
              backgroundColor: AppColors.slate50,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text(
                'Inventario del Taller',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.slate900,
                  letterSpacing: -0.4,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF2563EB), size: 26),
                  tooltip: 'Nuevo Repuesto',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const AgregarRepuestoFormScreen(),
                    ));
                  },
                ),
                const SizedBox(width: 8),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: TabBar(
                    indicatorColor: AppColors.slate800,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: AppColors.slate900,
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(text: 'Disponibles ($disponiblesCount)'),
                      Tab(text: 'Reservados ($reservadosCount)'),
                    ],
                  ),
                ),
              ),
            ),
            body: provider.isLoading
                // Loading: skeleton list para no causar salto de layout
                ? ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    itemCount: 5,
                    itemBuilder: (_, __) => const RepuestoSkeletonCard(),
                  )
                : provider.lastError != null
                    // Error: banner con mensaje humano + botón Reintentar
                    ? InventarioErrorState(
                        message: provider.lastError!,
                        onRetry: () => context.read<RepuestosProvider>().fetchRepuestos(),
                      )
                    // Success: pestañas normales
                    : TabBarView(
                        children: [
                          _ListaDisponibles(provider.disponibles),
                          _ListaReservados(provider.reservados),
                        ],
                      ),
          ),
        );
      },
    );
  }
}

// ── PESTAÑA: DISPONIBLES ───────────────────────────────────────────────────

class _ListaDisponibles extends StatefulWidget {
  final List repuestos;
  const _ListaDisponibles(this.repuestos);

  @override
  State<_ListaDisponibles> createState() => _ListaDisponiblesState();
}

class _ListaDisponiblesState extends State<_ListaDisponibles> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isDebouncing = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    setState(() {
      _isDebouncing = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = val.trim();
        _isDebouncing = false;
      });
    });
  }

  void _limpiarBusqueda() {
    _debounceTimer?.cancel();
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isDebouncing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.repuestos.where((r) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final nombre = (r.nombre ?? '').toLowerCase();
      final categoria = (r.categoria ?? '').toLowerCase();
      return nombre.contains(query) || categoria.contains(query);
    }).toList();

    return Column(
      children: [
        // Barra de búsqueda según Figma (Disponibles.png / Buscando Repuesto.png)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.slate900,
            ),
            decoration: InputDecoration(
              hintText: 'Buscar repuesto o categoría...',
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 14,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _isDebouncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF64748B),
                        ),
                      )
                    : const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF94A3B8),
                        size: 22,
                      ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF64748B)),
                      onPressed: _limpiarBusqueda,
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.slate800,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Subtítulo de estado de búsqueda ("Buscando repuestos...")
        if (_isDebouncing)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Buscando repuestos...',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        // Cuerpo: Skeletons o Resultados o Empty State
        Expanded(
          child: _isDebouncing
              ? ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  itemCount: 3,
                  itemBuilder: (_, __) => const RepuestoSkeletonCard(),
                )
              : filtered.isEmpty
                  ? _searchQuery.isNotEmpty
                      ? RepuestoEmptyState(
                          query: _searchQuery,
                          title: 'No encontramos ese repuesto',
                          message: '"$_searchQuery" no está registrado todavía en el inventario del taller.',
                          actionLabel: 'Registrar este Repuesto',
                          onAction: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => AgregarRepuestoFormScreen(
                                nombreInicial: _searchQuery,
                              ),
                            ));
                          },
                          onClearSearch: _limpiarBusqueda,
                        )
                      : TallerVacioState(
                          onAgregar: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AgregarRepuestoFormScreen(),
                            ),
                          ),
                        )
                  : RefreshIndicator(
                      color: AppColors.slate800,
                      onRefresh: () => context.read<RepuestosProvider>().fetchRepuestos(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final repuesto = filtered[index];
                          return DisponibleCard(
                            repuesto: repuesto,
                            onReservar: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ReservarScreen(
                                  repuestoId: repuesto.id,
                                  repuestoNombre: repuesto.nombre,
                                ),
                              ));
                            },
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}

// ── PESTAÑA: RESERVADOS ───────────────────────────────────────────────────

class _ListaReservados extends StatefulWidget {
  final List repuestos;
  const _ListaReservados(this.repuestos);

  @override
  State<_ListaReservados> createState() => _ListaReservadosState();
}

class _ListaReservadosState extends State<_ListaReservados> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isDebouncing = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    setState(() {
      _isDebouncing = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = val.trim();
        _isDebouncing = false;
      });
    });
  }

  void _limpiarBusqueda() {
    _debounceTimer?.cancel();
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isDebouncing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.repuestos.where((r) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final nombre = (r.nombre ?? '').toLowerCase();
      final categoria = (r.categoria ?? '').toLowerCase();
      final equipo = (r.equipoDestino ?? '').toLowerCase();
      final tecnico = (r.reservadoPorNombre ?? '').toLowerCase();
      return nombre.contains(query) ||
          categoria.contains(query) ||
          equipo.contains(query) ||
          tecnico.contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barra de búsqueda según Figma (Reservados.png / Buscando Reserva.png)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.slate900,
            ),
            decoration: InputDecoration(
              hintText: 'Buscar repuesto reservado...',
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 14,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _isDebouncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF64748B),
                        ),
                      )
                    : const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF94A3B8),
                        size: 22,
                      ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF64748B)),
                      onPressed: _limpiarBusqueda,
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.slate800,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Subtítulo de estado de búsqueda ("Buscando repuestos...")
        if (_isDebouncing)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
            child: Text(
              'Buscando repuestos...',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else if (filtered.isNotEmpty)
          // Overline Figma: "RESERVADO EN TALLER POR OTROS TÉCNICOS"
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            child: Text(
              'RESERVADO EN TALLER POR OTROS TÉCNICOS',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
                letterSpacing: 0.6,
              ),
            ),
          ),

        // Cuerpo: Skeletons o Resultados o Empty State
        Expanded(
          child: _isDebouncing
              ? ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  itemCount: 3,
                  itemBuilder: (_, __) => const RepuestoSkeletonCard(),
                )
              : filtered.isEmpty
                  ? _searchQuery.isNotEmpty
                      ? RepuestoEmptyState(
                          query: _searchQuery,
                          title: 'No encontramos esa reserva',
                          message: '"$_searchQuery" no está reservado todavía en el inventario del taller.',
                          actionLabel: 'Reservar este Repuesto',
                          onAction: () {
                            // Conduce a la pestaña Disponibles para reservar
                            DefaultTabController.of(context).animateTo(0);
                          },
                          onClearSearch: _limpiarBusqueda,
                        )
                      : const TallerVacioState(esReservados: true)
                  : RefreshIndicator(
                      color: AppColors.slate800,
                      onRefresh: () => context.read<RepuestosProvider>().fetchRepuestos(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final repuesto = filtered[index];
                          return InventarioReservadoCard(
                            repuesto: repuesto,
                            onTap: () {
                              DetalleReservaSheet.show(context, repuesto);
                            },
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}
