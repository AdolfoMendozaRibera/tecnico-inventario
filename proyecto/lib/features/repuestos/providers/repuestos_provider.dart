import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase_client.dart';
import '../data/repuesto_model.dart';

class RepuestosProvider extends ChangeNotifier {
  final _supabase = SupabaseService.client;
  
  List<Repuesto> _disponibles = [];
  List<Repuesto> _reservados = [];
  List<Repuesto> _misReservas = [];
  
  bool _isLoading = false;

  List<Repuesto> get disponibles => _disponibles;
  List<Repuesto> get reservados => _reservados;
  List<Repuesto> get misReservas => _misReservas;
  bool get isLoading => _isLoading;

  Future<void> fetchRepuestos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser?.id;

      final response = await _supabase
          .from('repuesto')
          .select()
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

  Future<void> reservarRepuesto(String repuestoId, String equipo, String motivo) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('repuesto').update({
        'estado': 'reservado',
        'equipo_destino': equipo,
        'motivo': motivo,
        'reservado_por': userId,
        'fecha_reserva': DateTime.now().toIso8601String(),
      }).eq('id', repuestoId);
      
      await fetchRepuestos(); // Refrescar listas
    } catch (e) {
      debugPrint('Error reserving: $e');
    }
  }

  Future<void> liberarRepuesto(String repuestoId) async {
    try {
      await _supabase.from('repuesto').update({
        'estado': 'disponible',
        'equipo_destino': null,
        'motivo': null,
        'reservado_por': null,
        'fecha_reserva': null,
      }).eq('id', repuestoId);
      
      await fetchRepuestos(); // Refrescar listas
    } catch (e) {
      debugPrint('Error releasing: $e');
    }
  }
}
