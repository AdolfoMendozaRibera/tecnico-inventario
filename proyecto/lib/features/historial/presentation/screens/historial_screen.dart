import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../repuestos/presentation/widgets/repuesto_skeleton_card.dart';
import '../../providers/historial_provider.dart';
import '../widgets/historial_card.dart';
import '../widgets/historial_empty_state.dart';

/// Pantalla principal del Flujo 5: Historial y Trazabilidad de Reparaciones.
/// Ofrece una experiencia rápida, clara y a prueba de errores para consultar
/// repuestos instalados en equipos y bajas por merma con filtros en tiempo real.
class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarHistorial();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _cargarHistorial() {
    final auth = context.read<AuthProvider>();
    context.read<HistorialProvider>().fetchHistorial(
          userId: auth.currentUser?.id,
          isAdmin: auth.isAdmin,
        );
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 220), () {
      if (mounted) {
        context.read<HistorialProvider>().setSearchQuery(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final historial = context.watch<HistorialProvider>();
    final movimientos = historial.movimientosFiltrados;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Historial y Trazabilidad',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: auth.isAdmin ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: auth.isAdmin ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    auth.isAdmin ? 'ADMIN' : 'TÉCNICO',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: auth.isAdmin ? const Color(0xFF1D4ED8) : AppColors.slate600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              auth.isAdmin
                  ? 'Trazabilidad global de repuestos en el taller'
                  : 'Tus piezas instaladas y mermas registradas',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.slate500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _cargarHistorial(),
        color: AppColors.primary,
        child: Column(
          children: [
            // Cabecera interactiva con métricas y filtros
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Counters Banner
                  Row(
                    children: [
                      // Total Instalados
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFA7F3D0),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${historial.totalInstalados}',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF065F46),
                                      ),
                                    ),
                                    Text(
                                      'Instalados',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF047857),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Total Bajas / Mermas
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFECACA),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.remove_circle_outline_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${historial.totalBajas}',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF991B1B),
                                      ),
                                    ),
                                    Text(
                                      'Bajas / Merma',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFB91C1C),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Barra de búsqueda con limpieza instantánea
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar por pieza, equipo, motivo...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.slate400,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppColors.slate400,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.slate500),
                                onPressed: () {
                                  _searchController.clear();
                                  historial.setSearchQuery('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Filtro por Segmento de Tipo (Todos / Instalados / Bajas)
                  Row(
                    children: [
                      _buildTipoChip(
                        label: 'Todos',
                        tipo: TipoMovimientoFiltro.todos,
                        current: historial.tipo,
                        onTap: () => historial.setTipo(TipoMovimientoFiltro.todos),
                      ),
                      const SizedBox(width: 8),
                      _buildTipoChip(
                        label: 'Instalados',
                        tipo: TipoMovimientoFiltro.usados,
                        current: historial.tipo,
                        onTap: () => historial.setTipo(TipoMovimientoFiltro.usados),
                        dotColor: const Color(0xFF10B981),
                      ),
                      const SizedBox(width: 8),
                      _buildTipoChip(
                        label: 'Bajas',
                        tipo: TipoMovimientoFiltro.bajas,
                        current: historial.tipo,
                        onTap: () => historial.setTipo(TipoMovimientoFiltro.bajas),
                        dotColor: const Color(0xFFEF4444),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Filtro Horizontal de Período Temporal
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        Text(
                          'Período: ',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _buildPeriodoChip(
                          label: 'Todo',
                          periodo: PeriodoFiltro.todo,
                          current: historial.periodo,
                          onTap: () => historial.setPeriodo(PeriodoFiltro.todo),
                        ),
                        const SizedBox(width: 6),
                        _buildPeriodoChip(
                          label: 'Hoy',
                          periodo: PeriodoFiltro.hoy,
                          current: historial.periodo,
                          onTap: () => historial.setPeriodo(PeriodoFiltro.hoy),
                        ),
                        const SizedBox(width: 6),
                        _buildPeriodoChip(
                          label: 'Esta semana',
                          periodo: PeriodoFiltro.estaSemana,
                          current: historial.periodo,
                          onTap: () => historial.setPeriodo(PeriodoFiltro.estaSemana),
                        ),
                        const SizedBox(width: 6),
                        _buildPeriodoChip(
                          label: 'Este mes',
                          periodo: PeriodoFiltro.esteMes,
                          current: historial.periodo,
                          onTap: () => historial.setPeriodo(PeriodoFiltro.esteMes),
                        ),
                      ],
                    ),
                  ),

                  // Si es Admin y hay técnicos disponibles, mostrar filtro de técnico
                  if (auth.isAdmin && historial.tecnicosDisponibles.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          Text(
                            'Técnico: ',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          FilterChip(
                            label: const Text('Todos'),
                            selected: historial.tecnicoFilterId == null,
                            onSelected: (_) => historial.setTecnicoFilter(null),
                            selectedColor: AppColors.slate100,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: historial.tecnicoFilterId == null
                                  ? AppColors.primary
                                  : const Color(0xFFE2E8F0),
                            ),
                            labelStyle: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: historial.tecnicoFilterId == null
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: historial.tecnicoFilterId == null
                                  ? AppColors.primary
                                  : AppColors.slate600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          ...historial.tecnicosDisponibles.entries.map((entry) {
                            final isSelected = historial.tecnicoFilterId == entry.key;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: FilterChip(
                                label: Text(entry.value),
                                selected: isSelected,
                                onSelected: (_) => historial.setTecnicoFilter(isSelected ? null : entry.key),
                                selectedColor: const Color(0xFFEFF6FF),
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                ),
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? const Color(0xFF1D4ED8) : AppColors.slate600,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Lista de Movimientos / Estados de borde
            Expanded(
              child: Builder(
                builder: (context) {
                  // Estado 1: Loading
                  if (historial.isLoading && movimientos.isEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 4,
                      itemBuilder: (_, __) => const RepuestoSkeletonCard(),
                    );
                  }

                  // Estado 2: Error
                  if (historial.lastError != null && movimientos.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off_rounded,
                              size: 48,
                              color: Color(0xFFEF4444),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Error al cargar historial',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              historial.lastError!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.slate500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _cargarHistorial,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Reintentar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Estado 3: Vacío
                  if (movimientos.isEmpty) {
                    final tieneFiltrosActivos = historial.searchQuery.isNotEmpty ||
                        historial.periodo != PeriodoFiltro.todo ||
                        historial.tipo != TipoMovimientoFiltro.todos ||
                        historial.tecnicoFilterId != null;

                    return HistorialEmptyState(
                      tieneFiltros: tieneFiltrosActivos,
                      onLimpiarFiltros: () {
                        _searchController.clear();
                        historial.limpiarFiltros();
                      },
                    );
                  }

                  // Estado 4: Lista poblada
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                    itemCount: movimientos.length,
                    itemBuilder: (context, index) {
                      final item = movimientos[index];
                      return HistorialCard(
                        key: ValueKey('historial_${item.id}'),
                        repuesto: item,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoChip({
    required String label,
    required TipoMovimientoFiltro tipo,
    required TipoMovimientoFiltro current,
    required VoidCallback onTap,
    Color? dotColor,
  }) {
    final bool isSelected = tipo == current;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.slate600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodoChip({
    required String label,
    required PeriodoFiltro periodo,
    required PeriodoFiltro current,
    required VoidCallback onTap,
  }) {
    final bool isSelected = periodo == current;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1F5F9) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF94A3B8) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF0F172A) : AppColors.slate500,
          ),
        ),
      ),
    );
  }
}
