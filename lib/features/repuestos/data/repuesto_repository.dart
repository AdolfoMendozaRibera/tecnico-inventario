import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import 'repuesto_model.dart';

/// Repositorio para consultar inventario de repuestos.
///
/// Cumple con RF-01, RF-02, RF-03, RF-08 y RNF-02.
/// Es el contrato de datos que consumirá la UI (Marco).
class RepuestoRepository {
  final SupabaseClient _client;

  RepuestoRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// RF-01: Obtener lista completa de repuestos por tienda.
  Future<List<Repuesto>> getRepuestos({required String tiendaId}) async {
    final response = await _client
        .from(AppConstants.tableRepuestos)
        .select()
        .eq('tienda_id', tiendaId)
        .order('nombre', ascending: true);

    return (response as List)
        .map((e) => Repuesto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// RF-01: Buscar repuestos por nombre o categoría dentro de una tienda.
  Future<List<Repuesto>> buscarRepuestos({
    required String tiendaId,
    required String query,
  }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return getRepuestos(tiendaId: tiendaId);
    }

    final response = await _client
        .from(AppConstants.tableRepuestos)
        .select()
        .eq('tienda_id', tiendaId)
        .or('nombre.ilike.%$cleanQuery%,categoria.ilike.%$cleanQuery%')
        .order('nombre', ascending: true);

    return (response as List)
        .map((e) => Repuesto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// RF-02, RF-03: Obtener el detalle de un repuesto específico por su ID.
  Future<Repuesto?> getRepuestoById(String id) async {
    final response = await _client
        .from(AppConstants.tableRepuestos)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Repuesto.fromJson(response as Map<String, dynamic>);
  }

  /// RF-08: Conteo de repuestos disponibles y reservados para el resumen de inicio.
  Future<Map<String, int>> getConteoResumen({required String tiendaId}) async {
    final repuestos = await getRepuestos(tiendaId: tiendaId);

    int disponibles = 0;
    int reservados = 0;

    for (final r in repuestos) {
      if (r.esDisponible) {
        disponibles++;
      } else if (r.esReservado) {
        reservados++;
      }
    }

    return {
      'disponibles': disponibles,
      'reservados': reservados,
    };
  }

  /// RNF-02: Escuchar cambios en tiempo real en la tabla de repuestos.
  Stream<List<Repuesto>> escucharRepuestosRealtime({required String tiendaId}) {
    return _client
        .from(AppConstants.tableRepuestos)
        .stream(primaryKey: ['id'])
        .eq('tienda_id', tiendaId)
        .order('nombre', ascending: true)
        .map((list) => list.map((json) => Repuesto.fromJson(json)).toList());
  }
}
