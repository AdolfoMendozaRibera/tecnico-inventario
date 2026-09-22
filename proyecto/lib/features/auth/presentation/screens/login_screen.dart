import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

/// Pantalla de Autenticación Oficial — VaultTecno
/// Incluye isotipo de la marca, selector de rol para evaluación (Técnico vs Admin)
/// y cumplimiento estricto de la escala tipográfica y paleta de colores.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'carlos.tecnico@taller.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.empleado;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRoleChanged(UserRole role) {
    setState(() {
      _selectedRole = role;
      if (role == UserRole.admin) {
        _emailController.text = 'admin.taller@taller.com';
      } else {
        _emailController.text = 'carlos.tecnico@taller.com';
      }
    });
  }

  Future<void> _ejecutarLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa tu correo y contraseña.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final exito = await authProvider.signIn(
      email,
      password,
      preferredRole: _selectedRole,
    );

    if (!mounted) return;

    if (exito) {
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Error al iniciar sesión.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bool isLoading = authProvider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ─── LOGO OFICIAL VAULTTECNO ─────────────────────────────
                  Center(
                    child: Image.asset(
                      'assets/icono.png',
                      width: 88,
                      height: 88,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ─── TÍTULO Y SUBTÍTULO VAULTTECNO ────────────────────────
                  Text(
                    'VaultTecno',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textNight,
                      letterSpacing: -0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gestión de Inventario y Control de Taller',
                    style: AppTextStyles.caption(color: AppColors.slate500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // ─── SELECTOR DE ROL PARA EVALUACIÓN (Capa 0) ─────────────
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.slate200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _RoleTabButton(
                            label: 'Técnico',
                            icon: Icons.handyman_outlined,
                            isSelected: _selectedRole == UserRole.empleado,
                            onTap: () => _onRoleChanged(UserRole.empleado),
                          ),
                        ),
                        Expanded(
                          child: _RoleTabButton(
                            label: 'Encargado (Admin)',
                            icon: Icons.admin_panel_settings_outlined,
                            isSelected: _selectedRole == UserRole.admin,
                            onTap: () => _onRoleChanged(UserRole.admin),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── CAMPO: CORREO ELECTRÓNICO ────────────────────────────
                  Text(
                    'Correo Electrónico',
                    style: AppTextStyles.labelOverline(color: AppColors.slate700),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.body(color: AppColors.textNight),
                    decoration: const InputDecoration(
                      hintText: 'ejemplo@taller.com',
                      prefixIcon: Icon(
                        Icons.mail_outline_rounded,
                        color: AppColors.slate400,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ─── CAMPO: CONTRASEÑA ────────────────────────────────────
                  Text(
                    'Contraseña',
                    style: AppTextStyles.labelOverline(color: AppColors.slate700),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: AppTextStyles.body(color: AppColors.textNight),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.slate400,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.slate400,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── BOTÓN PRINCIPAL INGRESAR ─────────────────────────────
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _ejecutarLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.login_rounded, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Ingresar a VaultTecno',
                                  style: AppTextStyles.button(color: Colors.white),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ─── AYUDA / RECUPERACIÓN ─────────────────────────────────
                  Center(
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Contacta al encargado del taller para restablecer o solicitar credenciales.',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleTabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: AppColors.slate200, width: 1.2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.slate400,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.textNight : AppColors.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
