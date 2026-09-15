import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import '../data/repuesto_model.dart';

class RepuestosProvider extends ChangeNotifier {
  final _supabase = SupabaseService.client;
  
  List<Repuesto> _disponibles = [];
  List<Repuesto> _reservados = [];
  List<Repuesto> _misReservas = [];
  
  bool _isLoading = false;
  String? _lastError;

  List<Repuesto> get disponibles => _disponibles;
  List<Repuesto> get reservados => _reservados;
  List<Repuesto> get misReservas => _misReservas;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  Future<void> fetchRepuestos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser?.id;

      final response = await _supabase
          .from('repuesto')
          .select('*, tecnico:reservado_por(nombre)')
          .order('nombre');

      final allRepuestos = (response as List).map((e) => Repuesto.fromJson(e)).toList();

      _disponibles = allRepuestos.where((r) => r.estado == 'disponible').toList();
      _reservados = allRepuestos.where((r) => r.estado == 'reservado').toList();
      
      if (userId != null) {
        _misReservas = _reservados.where((r) => r.reservadoPor == userId).toList();
      }
    } catch (e) {
      debugPrint('Error fetching repuestos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> reservarRepuesto(String repuestoId, String equipo, String motivo) async {
    _lastError = null;
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _lastError = 'No hay sesión de usuario activa.';
      return false;
    }

    try {
      // RNF-06: Mutación atómica con filtro estricto de estado 'disponible'
      // Si otro técnico lo reservó simultáneamente, no actualizará ninguna fila.
      final response = await _supabase.from('repuesto').update({
        'estado': 'reservado',
        'equipo_destino': equipo,
        'motivo': motivo,
        'reservado_por': userId,
        'fecha_reserva': DateTime.now().toIso8601String(),
      }).eq('id', repuestoId).eq('estado', 'disponible').select('id');

      final updatedList = response as List;
      if (updatedList.isEmpty) {
        _lastError = 'Este repuesto ya fue reservado por otro técnico en el taller.';
        await fetchRepuestos();
        return false;
      }

      await fetchRepuestos(); // Refrescar listas
      return true;
    } catch (e) {
      _lastError = 'No se pudo completar la reserva. Revisa tu conexión e inténtalo de nuevo.';
      debugPrint('Error reserving: $e');
      return false;
    }
  }

  /// Libera [cantidadALiberar] unidades de la reserva al inventario disponible.
  /// Si [cantidadALiberar] >= cantidad reservada → liberación total (estado='disponible').
  /// Si [cantidadALiberar] < cantidad reservada → liberación parcial (solo decrementa cantidad).
  Future<bool> liberarRepuesto(String repuestoId, int cantidadALiberar) async {
    _lastError = null;
    try {
      // Buscar el repuesto actual para conocer su cantidad reservada
      final repuesto = _misReservas.firstWhere(
        (r) => r.id == repuestoId,
        orElse: () => _reservados.firstWhere((r) => r.id == repuestoId),
      );
      final cantidadActual = repuesto.cantidad;
      final nuevaCantidad = cantidadActual - cantidadALiberar;

      if (nuevaCantidad <= 0) {
        // Liberación total: devolver al taller como disponible
        await _supabase.from('repuesto').update({
          'estado': 'disponible',
          'cantidad': 1,
          'equipo_destino': null,
          'motivo': null,
          'reservado_por': null,
          'fecha_reserva': null,
        }).eq('id', repuestoId);
      } else {
        // Liberación parcial: solo decrementar cantidad
        await _supabase.from('repuesto').update({
          'cantidad': nuevaCantidad,
        }).eq('id', repuestoId);
      }

      await fetchRepuestos();
      return true;
    } catch (e) {
      _lastError = e.toString();
      debugPrint('Error releasing: $e');
      return false;
    }
  }

  /// Marca [cantidadUsada] unidades como consumidas y las descuenta del inventario.
  /// Si la cantidad restante llega a 0 → estado='usado'.
  /// Si queda stock → solo decrementa cantidad manteniendo estado='reservado'.
  Future<bool> marcarComoUsado(String repuestoId, int cantidadUsada) async {
    _lastError = null;
    try {
      final repuesto = _misReservas.firstWhere(
        (r) => r.id == repuestoId,
        orElse: () => _reservados.firstWhere((r) => r.id == repuestoId),
      );
      final cantidadActual = repuesto.cantidad;
      final nuevaCantidad = cantidadActual - cantidadUsada;

      if (nuevaCantidad <= 0) {
        // Consumo total: marcar como usado
        await _supabase.from('repuesto').update({
          'estado': 'usado',
          'cantidad': 0,
        }).eq('id', repuestoId);
      } else {
        // Consumo parcial: decrementar cantidad, mantener reservado
        await _supabase.from('repuesto').update({
          'cantidad': nuevaCantidad,
        }).eq('id', repuestoId);
      }

      await fetchRepuestos();
      return true;
    } catch (e) {
      _lastError = e.toString();
      debugPrint('Error marking as used: $e');
      return false;
    }
  }

  /// Actualiza el equipo destino y el motivo de una reserva activa.
  Future<bool> editarReserva(String repuestoId, String nuevoEquipo, String nuevoMotivo) async {
    _lastError = null;
    try {
      await _supabase.from('repuesto').update({
        'equipo_destino': nuevoEquipo.trim(),
        'motivo': nuevoMotivo.trim().isEmpty ? null : nuevoMotivo.trim(),
      }).eq('id', repuestoId).eq('estado', 'reservado');

      await fetchRepuestos();
      return true;
    } catch (e) {
      _lastError = e.toString();
      debugPrint('Error editing reservation: $e');
      return false;
    }
  }

  // ── Flujo v0.4 — Agregar repuesto ──────────────────────────────────────────

  /// ID del último repuesto ingresado. Permite destacarlo en el listado.
  String? _lastAddedId;
  String? get lastAddedId => _lastAddedId;

  /// Inserta un nuevo repuesto en Supabase con estado 'disponible'.
  /// Obtiene el tienda_id directamente desde la tabla `tecnico` del usuario actual.
  /// Retorna `true` si la operación fue exitosa.
  Future<bool> agregarRepuesto({
    required String nombre,
    required String categoria,
    String? descripcion,
  }) async {
    _lastError = null;
    _lastAddedId = null;
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        _lastError = 'No hay sesión activa.';
        return false;
      }

      // Obtenemos el tienda_id del técnico autenticado
      final tecnicoRow = await _supabase
          .from('tecnico')
          .select('tienda_id')
          .eq('id', userId)
          .single();

      final tiendaId = tecnicoRow['tienda_id'] as String;

      final response = await _supabase.from('repuesto').insert({
        'nombre': nombre.trim(),
        'categoria': categoria.trim(),
        'descripcion': descripcion?.trim(),
        'estado': 'disponible',
        'tienda_id': tiendaId,
      }).select('id').single();

      _lastAddedId = response['id'] as String?;
      await fetchRepuestos(); // Refrescar listas para reflejar el nuevo ítem
      return true;
    } catch (e) {
      _lastError = e.toString();
      debugPrint('Error adding repuesto: $e');
      return false;
    }
  }

  /// Limpia el ID del último repuesto agregado (evita resaltado persistente).
  void clearLastAddedId() {
    _lastAddedId = null;
    notifyListeners();
  }
}
