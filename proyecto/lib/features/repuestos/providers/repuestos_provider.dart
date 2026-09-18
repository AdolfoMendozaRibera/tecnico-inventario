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
    _lastError = null; // Reset error state on every fetch attempt
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
      _lastError = 'No se pudo conectar al inventario. Revisa tu conexión e intenta de nuevo.';
      debugPrint('Error fetching repuestos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Realiza la reserva de [cantidad] unidades de un repuesto disponible.
  /// Si la cantidad reservada es igual al stock disponible -> actualiza el registro a 'reservado'.
  /// Si la cantidad reservada es menor al stock disponible -> descuenta stock del registro disponible
  /// y crea una nueva fila con la cantidad reservada.
  Future<bool> reservarRepuesto(
    String repuestoId,
    String equipo,
    String motivo, {
    int cantidad = 1,
  }) async {
    _lastError = null;
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _lastError = 'No hay sesión de usuario activa.';
      return false;
    }

    try {
      final repuestoActual = _disponibles.firstWhere(
        (r) => r.id == repuestoId,
        orElse: () => _reservados.firstWhere((r) => r.id == repuestoId),
      );

      if (cantidad > repuestoActual.cantidad) {
        _lastError = 'No hay suficientes unidades disponibles (disponibles: ${repuestoActual.cantidad}).';
        return false;
      }

      if (cantidad >= repuestoActual.cantidad) {
        // Reserva total del registro existente
        final response = await _supabase.from('repuesto').update({
          'estado': 'reservado',
          'cantidad': repuestoActual.cantidad,
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
      } else {
        // Reserva parcial: descontar del disponible e insertar registro reservado
        final nuevoDisponible = repuestoActual.cantidad - cantidad;
        await _supabase.from('repuesto').update({
          'cantidad': nuevoDisponible,
        }).eq('id', repuestoId).eq('estado', 'disponible');

        await _supabase.from('repuesto').insert({
          'nombre': repuestoActual.nombre,
          'categoria': repuestoActual.categoria,
          'descripcion': repuestoActual.descripcion,
          'estado': 'reservado',
          'cantidad': cantidad,
          'equipo_destino': equipo,
          'motivo': motivo,
          'reservado_por': userId,
          'fecha_reserva': DateTime.now().toIso8601String(),
          'tienda_id': repuestoActual.tiendaId,
        });
      }

      await fetchRepuestos(); // Refrescar listas
      return true;
    } catch (e) {
      _lastError = 'No se pudo completar la reserva. Revisa tu conexión e inténtalo de nuevo.';
      debugPrint('Error reserving: $e');
      return false;
    }
  }

  /// Libera [cantidadALiberar] unidades de la reserva devolviéndolas al inventario del taller.
  /// Si la liberación es total -> la fila vuelve a estado='disponible'.
  /// Si es parcial -> decrementa la reserva e ingresa las unidades liberadas como disponibles.
  Future<bool> liberarRepuesto(String repuestoId, int cantidadALiberar) async {
    _lastError = null;
    try {
      final repuesto = _misReservas.firstWhere(
        (r) => r.id == repuestoId,
        orElse: () => _reservados.firstWhere((r) => r.id == repuestoId),
      );

      final nuevaCantidad = repuesto.cantidad - cantidadALiberar;

      // Buscar si ya existe una fila 'disponible' para este repuesto en el taller
      final existingDisponibles = await _supabase
          .from('repuesto')
          .select('id, cantidad')
          .eq('nombre', repuesto.nombre)
          .eq('estado', 'disponible')
          .eq('tienda_id', repuesto.tiendaId)
          .limit(1);

      final existingDisponible = existingDisponibles.isNotEmpty
          ? existingDisponibles.first
          : null;

      if (nuevaCantidad <= 0) {
        // Liberación total de la reserva
        if (existingDisponible != null && existingDisponible['id'] != repuestoId) {
          final currentStock = (existingDisponible['cantidad'] as int?) ?? 1;
          await _supabase.from('repuesto').update({
            'cantidad': currentStock + repuesto.cantidad,
          }).eq('id', existingDisponible['id']);

          await _supabase.from('repuesto').delete().eq('id', repuestoId);
        } else {
          await _supabase.from('repuesto').update({
            'estado': 'disponible',
            'equipo_destino': null,
            'motivo': null,
            'reservado_por': null,
            'fecha_reserva': null,
          }).eq('id', repuestoId);
        }
      } else {
        // Liberación parcial: decrementar reserva e incrementar/insertar en disponible
        await _supabase.from('repuesto').update({
          'cantidad': nuevaCantidad,
        }).eq('id', repuestoId);

        if (existingDisponible != null) {
          final currentStock = (existingDisponible['cantidad'] as int?) ?? 1;
          await _supabase.from('repuesto').update({
            'cantidad': currentStock + cantidadALiberar,
          }).eq('id', existingDisponible['id']);
        } else {
          await _supabase.from('repuesto').insert({
            'nombre': repuesto.nombre,
            'categoria': repuesto.categoria,
            'descripcion': repuesto.descripcion,
            'estado': 'disponible',
            'cantidad': cantidadALiberar,
            'tienda_id': repuesto.tiendaId,
          });
        }
      }

      await fetchRepuestos();
      return true;
    } catch (e) {
      _lastError = 'No se pudo liberar el repuesto. Revisa tu conexión e intenta de nuevo.';
      debugPrint('Error releasing: $e');
      return false;
    }
  }

  /// Marca [cantidadUsada] unidades como consumidas e instaladas en el equipo.
  /// Si el consumo es total -> la fila pasa a estado='usado'.
  /// Si es parcial -> decrementa la reserva e inserta registro con estado='usado'.
  Future<bool> marcarComoUsado(String repuestoId, int cantidadUsada) async {
    _lastError = null;
    try {
      final repuesto = _misReservas.firstWhere(
        (r) => r.id == repuestoId,
        orElse: () => _reservados.firstWhere((r) => r.id == repuestoId),
      );

      final nuevaCantidad = repuesto.cantidad - cantidadUsada;

      if (nuevaCantidad <= 0) {
        // Consumo total
        await _supabase.from('repuesto').update({
          'estado': 'usado',
        }).eq('id', repuestoId);
      } else {
        // Consumo parcial: decrementar reserva e insertar registro usado
        await _supabase.from('repuesto').update({
          'cantidad': nuevaCantidad,
        }).eq('id', repuestoId);

        await _supabase.from('repuesto').insert({
          'nombre': repuesto.nombre,
          'categoria': repuesto.categoria,
          'descripcion': repuesto.descripcion,
          'estado': 'usado',
          'cantidad': cantidadUsada,
          'equipo_destino': repuesto.equipoDestino,
          'motivo': repuesto.motivo,
          'reservado_por': repuesto.reservadoPor,
          'tienda_id': repuesto.tiendaId,
        });
      }

      await fetchRepuestos();
      return true;
    } catch (e) {
      _lastError = 'No se pudo marcar como usado. Revisa tu conexión e intenta de nuevo.';
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
      _lastError = 'No se pudo actualizar la reserva. Revisa tu conexión e intenta de nuevo.';
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
    int cantidad = 1,
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
          .maybeSingle();

      String tiendaId;
      if (tecnicoRow != null && tecnicoRow['tienda_id'] != null) {
        tiendaId = tecnicoRow['tienda_id'] as String;
      } else {
        // Fallback: tomar la primera tienda existente del taller
        final defaultTienda = await _supabase.from('tienda').select('id').limit(1).single();
        tiendaId = defaultTienda['id'] as String;
      }

      final response = await _supabase.from('repuesto').insert({
        'nombre': nombre.trim(),
        'categoria': categoria.trim(),
        'descripcion': descripcion?.trim(),
        'estado': 'disponible',
        'cantidad': cantidad > 0 ? cantidad : 1,
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

  // ── Flujo v0.4 — Edición / Reubicación y Baja por Merma ─────────────────────

  /// Actualiza los datos maestros y ubicación de un repuesto existente.
  Future<bool> editarRepuesto({
    required String repuestoId,
    required String nombre,
    required String categoria,
    String? descripcion,
    required int cantidad,
  }) async {
    _lastError = null;
    try {
      await _supabase.from('repuesto').update({
        'nombre': nombre.trim(),
        'categoria': categoria.trim(),
        'descripcion': descripcion?.trim(),
        'cantidad': cantidad > 0 ? cantidad : 1,
      }).eq('id', repuestoId);

      await fetchRepuestos();
      return true;
    } catch (e) {
      _lastError = 'No se pudo actualizar el repuesto. Revisa tu conexión e intenta de nuevo.';
      debugPrint('Error editing repuesto: $e');
      return false;
    }
  }

  /// Da de baja [cantidadABajar] unidades por daño, merma o rotura física.
  /// Si la baja es total -> la fila pasa a estado='baja' con motivo descriptivo.
  /// Si es parcial -> decrementa la cantidad disponible e inserta el registro con estado='baja'.
  Future<bool> darDeBajaRepuesto({
    required String repuestoId,
    required int cantidadABajar,
    required String motivoBaja,
    String? notas,
  }) async {
    _lastError = null;
    try {
      final repuesto = _disponibles.firstWhere(
        (r) => r.id == repuestoId,
        orElse: () => _reservados.firstWhere((r) => r.id == repuestoId),
      );

      final nuevaCantidad = repuesto.cantidad - cantidadABajar;
      final motivoCompleto = 'Baja: $motivoBaja${notas != null && notas.trim().isNotEmpty ? " • ${notas.trim()}" : ""}';

      if (nuevaCantidad <= 0) {
        // Baja total
        await _supabase.from('repuesto').update({
          'estado': 'baja',
          'motivo': motivoCompleto,
        }).eq('id', repuestoId);
      } else {
        // Baja parcial: decrementar disponible e insertar registro de baja
        await _supabase.from('repuesto').update({
          'cantidad': nuevaCantidad,
        }).eq('id', repuestoId);

        await _supabase.from('repuesto').insert({
          'nombre': repuesto.nombre,
          'categoria': repuesto.categoria,
          'descripcion': repuesto.descripcion,
          'estado': 'baja',
          'cantidad': cantidadABajar,
          'motivo': motivoCompleto,
          'tienda_id': repuesto.tiendaId,
        });
      }

      await fetchRepuestos();
      return true;
    } catch (e) {
      _lastError = 'No se pudo registrar la baja del repuesto. Revisa tu conexión e intenta de nuevo.';
      debugPrint('Error marking repuesto as baja: $e');
      return false;
    }
  }
}
