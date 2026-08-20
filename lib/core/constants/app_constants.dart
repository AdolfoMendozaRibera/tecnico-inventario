// core/constants/app_constants.dart
//
// Responsabilidad: constantes globales de la aplicación.
//
// TODO: Agregar nombres de tablas Supabase (evitar strings mágicos dispersos)
// TODO: Agregar valores de timeout, límites de paginación, etc.

class AppConstants {
  AppConstants._(); // No instanciable

  // Nombres de tablas Supabase
  static const String tableRepuestos = 'repuesto';
  static const String tableTecnicos  = 'tecnico';
  static const String tableTiendas   = 'tienda';

  // Estados posibles de un repuesto (deben coincidir con el enum/check en la BD)
  static const String estadoDisponible = 'disponible';
  static const String estadoReservado  = 'reservado';
}
