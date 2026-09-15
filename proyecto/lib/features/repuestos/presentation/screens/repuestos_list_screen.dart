import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/reservation_card.dart';
import '../../../../core/widgets/disponible_card.dart';
import '../../../reservas/presentation/screens/reservar_screen.dart';
import '../../../../core/supabase_client.dart';
import 'agregar_repuesto_form_screen.dart';

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
              title: Text(
                'Inventario del Taller',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.slate900,
                  letterSpacing: -0.4,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.slate200,
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
                    unselectedLabelColor: AppColors.slate500,
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
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const AgregarRepuestoFormScreen(),
                ));
              },
              backgroundColor: AppColors.slate800,
              foregroundColor: Colors.white,
              elevation: 3,
              icon: const Icon(Icons.add_rounded, size: 22),
              label: Text(
                'Agregar repuesto',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            body: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.slate800,
                    ),
                  )
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

class _ListaDisponibles extends StatefulWidget {
  final List repuestos;
  const _ListaDisponibles(this.repuestos);

  @override
  State<_ListaDisponibles> createState() => _ListaDisponiblesState();
}

class _ListaDisponiblesState extends State<_ListaDisponibles> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        // Barra de búsqueda según Figma
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim();
              });
            },
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.slate900,
            ),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o categoría...',
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.slate500),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
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
        ),

        // Lista de Repuestos Disponibles
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 56,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'No se encontraron repuestos con "$_searchQuery"'
                            : 'No hay repuestos disponibles en el taller',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.slate500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
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
      ],
    );
  }
}

class _ListaReservados extends StatefulWidget {
  final List repuestos;
  const _ListaReservados(this.repuestos);

  @override
  State<_ListaReservados> createState() => _ListaReservadosState();
}

class _ListaReservadosState extends State<_ListaReservados> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = SupabaseService.client.auth.currentUser?.id;

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
      children: [
        // Barra de búsqueda según Figma
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim();
              });
            },
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.slate900,
            ),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre, equipo o técnico...',
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.slate500),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
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
        ),

        // Lista de Repuestos Reservados
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_open_rounded,
                        size: 56,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'No se encontraron reservas con "$_searchQuery"'
                            : 'No hay repuestos reservados en el taller',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.slate500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final repuesto = filtered[index];
                    final esMiReserva = repuesto.reservadoPor == currentUserId;

                    return ReservationCard(
                      repuesto: repuesto,
                      isMiReserva: esMiReserva,
                      onMarcarUsado: esMiReserva
                          ? () async {
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    'Marcar como Usado',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: AppColors.slate900,
                                    ),
                                  ),
                                  content: Text(
                                    '¿Confirmas que se utilizó "${repuesto.nombre}" para el equipo "${repuesto.equipoDestino ?? 'asignado'}"?\n\nEsta pieza se descontará permanentemente del inventario.',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text(
                                        'Cancelar',
                                        style: GoogleFonts.inter(color: AppColors.slate500),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.slate800,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Confirmar Uso'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmar != true || !context.mounted) return;

                              final provider = context.read<RepuestosProvider>();
                              final exito = await provider.marcarComoUsado(repuesto.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(exito
                                        ? 'Repuesto marcado como usado con éxito'
                                        : 'Error al marcar como usado: ${provider.lastError ?? "Rechazado"}'),
                                    backgroundColor: exito ? AppColors.slate800 : Theme.of(context).colorScheme.error,
                                  ),
                                );
                              }
                            }
                          : null,
                      onLiberar: esMiReserva
                          ? () async {
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    'Liberar al Taller',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: AppColors.slate900,
                                    ),
                                  ),
                                  content: Text(
                                    '¿Deseas devolver "${repuesto.nombre}" al inventario disponible para cualquier técnico?',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text(
                                        'Cancelar',
                                        style: GoogleFonts.inter(color: AppColors.slate500),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.slate800,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Liberar Repuesto'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmar != true || !context.mounted) return;

                              final provider = context.read<RepuestosProvider>();
                              final exito = await provider.liberarRepuesto(repuesto.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(exito
                                        ? 'Repuesto liberado y devuelto a disponibles'
                                        : 'Error al liberar el repuesto.'),
                                    backgroundColor: exito ? AppColors.slate800 : Theme.of(context).colorScheme.error,
                                  ),
                                );
                              }
                            }
                          : null,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
