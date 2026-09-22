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

  Future<void> _detectRoleFromUser() async {
    if (_currentUser == null) {
      _currentRole = UserRole.empleado;
      return;
    }

    try {
      final data = await SupabaseService.client
          .from('tecnico')
          .select('rol')
          .eq('auth_id', _currentUser!.id)
          .maybeSingle();

      if (data != null && data['rol'] != null) {
        final rolStr = data['rol'].toString().toLowerCase();
        _currentRole = (rolStr == 'admin') ? UserRole.admin : UserRole.empleado;
      } else {
        final metadataRole = _currentUser!.userMetadata?['role']?.toString().toLowerCase();
        if (metadataRole == 'admin' || _currentUser!.email?.contains('admin') == true) {
          _currentRole = UserRole.admin;
        } else {
          _currentRole = UserRole.empleado;
        }
      }
    } catch (_) {
      if (_currentUser!.email?.contains('admin') == true) {
        _currentRole = UserRole.admin;
      } else {
        _currentRole = UserRole.empleado;
      }
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
      await _detectRoleFromUser();

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

  /// Solicita restablecimiento de contraseña por correo electrónico
  Future<String?> resetPassword(String email) async {
    try {
      await SupabaseService.client.auth.resetPasswordForEmail(email.trim());
      return null; // null = éxito
    } catch (e) {
      return 'No se pudo enviar el correo. Verifica que el correo sea correcto.';
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
