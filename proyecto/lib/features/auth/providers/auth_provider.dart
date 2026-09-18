import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase_client.dart';

/// Roles definidos en la Capa 0 del Roadmap
enum UserRole {
  admin,    // Encargado de taller / Administrador
  empleado, // Técnico de reparaciones
}

class AuthProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.empleado;
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  UserRole get currentRole => _currentRole;
  bool get isAdmin => _currentRole == UserRole.admin;
  bool get isEmpleado => _currentRole == UserRole.empleado;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  /// Nombre del técnico o encargado actual
  String get displayName {
    if (_currentUser?.email != null) {
      final name = _currentUser!.email!.split('@').first;
      return name[0].toUpperCase() + name.substring(1);
    }
    return isAdmin ? 'Encargado Taller' : 'Carlos (Técnico)';
  }

  AuthProvider() {
    _initSession();
  }

  void _initSession() {
    _currentUser = SupabaseService.client.auth.currentUser;
    _detectRoleFromUser();
  }

  void _detectRoleFromUser() {
    if (_currentUser == null) {
      _currentRole = UserRole.empleado;
      return;
    }
    final metadata = _currentUser!.userMetadata;
    final roleStr = metadata?['role']?.toString().toLowerCase() ?? '';
    if (roleStr == 'admin' || _currentUser!.email?.contains('admin') == true) {
      _currentRole = UserRole.admin;
    } else {
      _currentRole = UserRole.empleado;
    }
    notifyListeners();
  }

  /// Permite conmutar el rol en tiempo de ejecución (útil para pruebas y evaluación de flujos)
  void setRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  /// Iniciar sesión con email y contraseña
  Future<bool> signIn(String email, String password, {UserRole? preferredRole}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _currentUser = response.user;
      if (preferredRole != null) {
        _currentRole = preferredRole;
      } else {
        _detectRoleFromUser();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Credenciales incorrectas o error de conexión.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    try {
      await SupabaseService.client.auth.signOut();
      _currentUser = null;
      _currentRole = UserRole.empleado;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
