import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final _emailController = TextEditingController(text: 'tecnico@taller.com');
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
        _emailController.text = 'admin@taller.com';
      } else {
        _emailController.text = 'tecnico@taller.com';
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

  Future<void> _abrirUrl(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      final lanzada = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!lanzada) {
        await launchUrl(uri);
      }
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (e) {
        if (context.mounted) {
          _copiarAlPortapapeles(context, urlString, 'No se pudo abrir el navegador. Enlace copiado.');
        }
      }
    }
  }

  void _copiarAlPortapapeles(BuildContext context, String texto, String mensaje) {
    Clipboard.setData(ClipboardData(text: texto));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: AppColors.slate900,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _mostrarDialogoRestablecimiento(BuildContext context) async {
    final emailController = TextEditingController(text: _emailController.text);
    bool enviando = false;
    bool enviado = false;
    String? errorMsg;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Restablecer contraseña',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.textNight,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!enviado) ...[
                    Text(
                      'Ingresa tu correo registrado y te enviaremos un enlace para restablecer tu contraseña.',
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.slate500),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !enviando,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        hintText: 'ej: usuario@correo.com',
                        prefixIcon: const Icon(Icons.mail_outline_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    if (errorMsg != null) ...[
                      const SizedBox(height: 8),
                      Text(errorMsg!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.error)),
                    ],
                  ] else ...[
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '¡Correo enviado! Revisa tu bandeja de entrada y sigue las instrucciones.',
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textNight),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              actions: enviado
                  ? [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cerrar'),
                      ),
                    ]
                  : [
                      TextButton(
                        onPressed: enviando ? null : () => Navigator.of(ctx).pop(),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: enviando
                            ? null
                            : () async {
                                setDialogState(() {
                                  enviando = true;
                                  errorMsg = null;
                                });
                                final authProvider = context.read<AuthProvider>();
                                final error = await authProvider.resetPassword(emailController.text);
                                setDialogState(() {
                                  enviando = false;
                                  if (error == null) {
                                    enviado = true;
                                  } else {
                                    errorMsg = error;
                                  }
                                });
                              },
                        child: enviando
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Enviar instrucciones'),
                      ),
                    ],
            );
          },
        );
      },
    );
    emailController.dispose();
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
                      onPressed: () => _mostrarDialogoRestablecimiento(context),
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
                  const SizedBox(height: 12),

                  // ─── INFORMACIÓN DE SOPORTE / CONTACTO ────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.slate50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.slate200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.help_outline_rounded,
                              size: 16,
                              color: AppColors.slate500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '¿Necesitas ayuda o más información?',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Botón táctil para Abrir la Página Web
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () => _abrirUrl(context, 'https://tecnico-inventario.vercel.app'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.language_rounded,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Visitar sitio web oficial',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.slate900,
                                          ),
                                        ),
                                        Text(
                                          'tecnico-inventario.vercel.app',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.slate400),
                                    tooltip: 'Copiar enlace',
                                    onPressed: () => _copiarAlPortapapeles(
                                      context,
                                      'https://tecnico-inventario.vercel.app',
                                      'Enlace web copiado al portapapeles',
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.open_in_new_rounded,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Fila interactiva para el Correo (tocar para copiar / abrir correo)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _copiarAlPortapapeles(
                              context,
                              'adolfomendozaribera30@gmail.com',
                              'Correo copiado al portapapeles',
                            ),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.mail_outline_rounded, size: 14, color: AppColors.slate500),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'adolfomendozaribera30@gmail.com',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.slate600,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.slate400,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.copy_rounded, size: 12, color: AppColors.slate400),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
