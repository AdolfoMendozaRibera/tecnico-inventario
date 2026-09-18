import 'package:flutter/material.dart';

/// Paleta de colores oficial de VaultTecno
/// Basada en los tokens y estándares de diseño del proyecto
class AppColors {
  AppColors._();

  // ─── Colores Principales de Marca / Rol ────────────────────────────────────
  /// Azul Oscuro Técnico (#1E293B) - Botones principales, barras de navegación, encabezados clave
  static const Color primary = Color(0xFF1E293B);

  /// Naranja Cálido / Ámbar (#F59E0B) - Botones de acción secundaria, destacar repuestos reservados, acentos
  static const Color secondary = Color(0xFFF59E0B);
  static const Color accent = Color(0xFFF59E0B);

  /// Gris Noche (#0F172A) - Textos principales sobre fondo claro (alto contraste asegurado)
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textNight = Color(0xFF0F172A);

  // ─── Superficies y Fondos ──────────────────────────────────────────────────
  /// Blanco Puro (#FFFFFF) - Fondo de tarjetas y componentes
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);

  /// Gris Claro (#F8FAFC) - Fondo de pantalla principal y contenedores
  static const Color background = Color(0xFFF8FAFC);
  static const Color surfaceMuted = Color(0xFFF8FAFC);

  // ─── Estados Semánticos ────────────────────────────────────────────────────
  /// Verde Esmeralda (#10B981) - Disponibilidad de stock, confirmaciones exitosas
  static const Color success = Color(0xFF10B981);
  static const Color statGreenText = Color(0xFF10B981);
  static const Color emeraldBadge = Color(0xFF10B981);
  static const Color emeraldBg = Color(0xFFECFDF5);
  static const Color emeraldBorder = Color(0xFFA7F3D0);
  static const Color emeraldValue = Color(0xFF047857);
  static const Color emeraldLabel = Color(0xFF065F46);

  /// Ámbar / Amarillo (#FBBF24) - Reservas pendientes, alertas de stock bajo
  static const Color warning = Color(0xFFFBBF24);
  static const Color amberBg = Color(0xFFFFFBEB);
  static const Color amberBorder = Color(0xFFFDE68A);
  static const Color amberBadge = Color(0xFFF59E0B);
  static const Color amberValue = Color(0xFFB45309);
  static const Color amberLabel = Color(0xFF92400E);

  /// Rojo Coral (#EF4444) - Cancelaciones, errores de formulario, alertas críticas
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color errorBorder = Color(0xFFFCA5A5);

  // ─── Escala Slate de Neutros ───────────────────────────────────────────────
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B); // Caption / Helper / Subtítulos
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // ─── Tokens de Soporte Login & Dashboard ───────────────────────────────────
  static const Color loginBackground = Color(0xFFF8FAFC);
  static const Color loginAura = Color(0xFFEFF6FF);
  static const Color loginTitle = Color(0xFF0F172A);
  static const Color loginSubtitle = Color(0xFF64748B);
  static const Color loginInputBorder = Color(0xFFE2E8F0);
  static const Color loginButtonBg = Color(0xFF1E293B);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF64748B);

  // ─── Info Banner Tokens ────────────────────────────────────────────────────
  static const Color infoAura = Color(0xFFEFF6FF);
  static const Color infoBorder = Color(0xFF3B82F6);
  static const Color infoIcon = Color(0xFF2563EB);

  // ─── Tokens heredados para compatibilidad de badges ─────────────────────────
  static const Color yellowHighlight = Color(0xFFFFCC00);
  static const Color yellowDefault = Color(0xFFFFD400);
  static const Color yellowHover = Color(0xFFFFBF00);
  static const Color yellowPressed = Color(0xFFE5D271);
  static const Color pressedText = Color(0xFF393131);
}
