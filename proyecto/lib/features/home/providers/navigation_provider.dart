import 'package:flutter/foundation.dart';

/// Provider que controla la pestaña activa del BottomNavigationBar en la aplicación.
///
/// Pestañas:
/// - 0: Inicio (Resumen del taller)
/// - 1: Repuestos (Inventario / Catálogo)
/// - 2: Reservas (Mis Reservas activas)
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
