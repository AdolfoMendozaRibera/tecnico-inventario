import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import '../../repuestos/data/repuesto_model.dart';

enum PeriodoFiltro {
  hoy,
  estaSemana,
  esteMes,
  todo,
}

enum TipoMovimientoFiltro {
  todos,
  usados, // Piezas instaladas en equipos
  bajas,  // Piezas descartadas por daño o merma
}

/// Provider para el Flujo 5: Historial y Trazabilidad de Reparaciones.
/// Gestiona la consulta de movimientos históricos (repuestos consumidos/dados de baja)
/// y provee filtrado reactivo en memoria por periodo, tipo y técnico.
class HistorialProvider extends ChangeNotifier {
  final _supabase = SupabaseService.client;

  List<Repuesto> _todosLosMovimientos = [];
  bool _isLoading = false;
  String? _lastError;

  // Filtros activos
  PeriodoFiltro _periodo = PeriodoFiltro.todo;
  TipoMovimientoFiltro _tipo = TipoMovimientoFiltro.todos;
  String _searchQuery = '';
  String? _tecnicoFilterId;

  bool get isLoading => _isLoading;
  String? get lastError => _lastError;
  PeriodoFiltro get periodo => _periodo;
  TipoMovimientoFiltro get tipo => _tipo;
  String get searchQuery => _searchQuery;
  String? get tecnicoFilterId => _tecnicoFilterId;

  /// Obtiene los movimientos filtrados según las selecciones del usuario
  List<Repuesto> get movimientosFiltrados {
    return _todosLosMovimientos.where((item) {
      // 1. Filtro por Tipo (Usado vs Baja)
      if (_tipo == TipoMovimientoFiltro.usados && item.estado != 'usado') {
        return false;
      }
      if (_tipo == TipoMovimientoFiltro.bajas && item.estado != 'baja') {
        return false;
      }

      // 2. Filtro por Periodo Temporal
      final fechaItem = item.fechaReserva ?? item.createdAt ?? DateTime.now();
      final ahora = DateTime.now();

      if (_periodo == PeriodoFiltro.hoy) {
        final esHoy = fechaItem.year == ahora.year &&
            fechaItem.month == ahora.month &&
            fechaItem.day == ahora.day;
        if (!esHoy) return false;
      } else if (_periodo == PeriodoFiltro.estaSemana) {
        final diferenciaDias = ahora.difference(fechaItem).inDays;
        if (diferenciaDias > 7) return false;
      } else if (_periodo == PeriodoFiltro.esteMes) {
        final diferenciaDias = ahora.difference(fechaItem).inDays;
        if (diferenciaDias > 30) return false;
      }

      // 3. Filtro por Técnico (para vista Admin)
      if (_tecnicoFilterId != null && _tecnicoFilterId!.isNotEmpty) {
        if (item.reservadoPor != _tecnicoFilterId) return false;
      }

      // 4. Filtro por Búsqueda de Texto (Repuesto, Destino, Motivo, Técnico)
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final nombre = item.nombre.toLowerCase();
        final categoria = item.categoria.toLowerCase();
        final destino = (item.equipoDestino ?? '').toLowerCase();
        final motivo = (item.motivo ?? '').toLowerCase();
        final tecnico = (item.reservadoPorNombre ?? '').toLowerCase();

        final match = nombre.contains(q) ||
            categoria.contains(q) ||
            destino.contains(q) ||
            motivo.contains(q) ||
            tecnico.contains(q);
        if (!match) return false;
      }

      return true;
    }).toList();
  }

  /// Lista de técnicos únicos presentes en el historial (útil para dropdowns de admin)
  Map<String, String> get tecnicosDisponibles {
    final Map<String, String> map = {};
    for (final m in _todosLosMovimientos) {
      if (m.reservadoPor != null && m.reservadoPorNombre != null) {
        map[m.reservadoPor!] = m.reservadoPorNombre!;
      }
    }
    return map;
  }

  /// Total de repuestos consumidos (instalados)
  int get totalInstalados =>
      _todosLosMovimientos.where((m) => m.estado == 'usado').fold<int>(0, (sum, r) => sum + r.cantidad);

  /// Total de repuestos dados de baja (mermas)
  int get totalBajas =>
      _todosLosMovimientos.where((m) => m.estado == 'baja').fold<int>(0, (sum, r) => sum + r.cantidad);

  /// Carga desde Supabase todos los repuestos con estado 'usado' o 'baja'
  Future<void> fetchHistorial({String? userId, bool isAdmin = false}) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      var query = _supabase
          .from('repuesto')
          .select('*, tecnico:reservado_por(nombre)')
          .inFilter('estado', ['usado', 'baja'])
          .order('created_at', ascending: false);

      // Si es empleado, filtrar en la consulta por su propio ID
      if (!isAdmin && userId != null) {
        query = _supabase
            .from('repuesto')
            .select('*, tecnico:reservado_por(nombre)')
            .inFilter('estado', ['usado', 'baja'])
            .eq('reservado_por', userId)
            .order('created_at', ascending: false);
      }

      final response = await query;
      final list = (response as List).map((e) => Repuesto.fromJson(e)).toList();

      _todosLosMovimientos = list;
    } catch (e) {
      _lastError = 'No se pudo cargar el historial de trazabilidad. Comprueba tu conexión.';
      debugPrint('Error fetching historial: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setPeriodo(PeriodoFiltro nuevoPeriodo) {
    _periodo = nuevoPeriodo;
    notifyListeners();
  }

  void setTipo(TipoMovimientoFiltro nuevoTipo) {
    _tipo = nuevoTipo;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setTecnicoFilter(String? tecnicoId) {
    _tecnicoFilterId = tecnicoId;
    notifyListeners();
  }

  void limpiarFiltros() {
    _periodo = PeriodoFiltro.todo;
    _tipo = TipoMovimientoFiltro.todos;
    _searchQuery = '';
    _tecnicoFilterId = null;
    notifyListeners();
  }
}
