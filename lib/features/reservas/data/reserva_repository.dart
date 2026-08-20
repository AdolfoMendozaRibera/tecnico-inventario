import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../repuestos/data/repuesto_model.dart';

/// Repositorio para operaciones de reserva y liberación.
///
/// Cumple con RF-04, RF-05, RF-06, RF-07 y RNF-06.
/// Es el contrato de datos que consumirá la UI (Marco).
class ReservaRepository {
  final SupabaseClient _client;

  ReservaRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// RF-04, RF-05: Reservar un repuesto indicando equipo de destino y motivo.
  /// RNF-06: Debe ser atómico. Actualiza estado a 'reservado' solo si estaba 'disponible'.
  Future<void> reservarRepuesto({
    required String repuestoId,
    required String equipoDestino,
    required String motivo,
    required String tecnicoId,
  }) async {
    // RNF-06: Filtramos por estado == 'disponible' al actualizar para prevenir condición de carrera.
    final updatedRows = await _client
        .from(AppConstants.tableRepuestos)
        .update({
          'estado': AppConstants.estadoReservado,
          'equipo_destino': equipoDestino.trim(),
          'motivo': motivo.trim(),
          'reservado_por': tecnicoId,
          'fecha_reserva': DateTime.now().toIso8601String(),
        })
        .eq('id', repuestoId)
        .eq('estado', AppConstants.estadoDisponible)
        .select();

    if ((updatedRows as List).isEmpty) {
      throw Exception(
        'No se pudo completar la reserva. Es posible que el repuesto ya haya sido reservado por otro técnico.',
      );
    }
  }

  /// RF-07: Liberar un repuesto (vuelve a estado disponible).
  Future<void> liberarRepuesto(String repuestoId) async {
    await _client.from(AppConstants.tableRepuestos).update({
      'estado': AppConstants.estadoDisponible,
      'equipo_destino': null,
      'motivo': null,
      'reservado_por': null,
      'fecha_reserva': null,
    }).eq('id', repuestoId);
  }

  /// RF-07: Marcar un repuesto como usado (devuelve a disponible o procesa su consumo).
  Future<void> marcarComoUsado(String repuestoId) async {
    // De acuerdo a RF-07, marcar como usado lo devuelve a estado disponible / consumido.
    await liberarRepuesto(repuestoId);
  }

  /// RF-06: Obtener ÚNICAMENTE las reservas realizadas por el técnico logueado.
  Future<List<Repuesto>> getMisReservas({required String tecnicoId}) async {
    final response = await _client
        .from(AppConstants.tableRepuestos)
        .select()
        .eq('estado', AppConstants.estadoReservado)
        .eq('reservado_por', tecnicoId)
        .order('fecha_reserva', ascending: false);

    return (response as List)
        .map((e) => Repuesto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
