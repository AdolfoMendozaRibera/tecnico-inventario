import 'package:flutter/material.dart';

/// Paleta de colores extraída fielmente de las variables y tokens de Figma
class AppColors {
  AppColors._();

  // Amarillo / Dorado (Tokens principales de botones y estados)
  static const Color yellowHighlight = Color(0xFFFFCC00); // Colors/Yellow
  static const Color yellowDefault = Color(0xFFFFD400);   // buttom Default
  static const Color yellowHover = Color(0xFFFFBF00);     // buttom Hover
  static const Color yellowPressed = Color(0xFFE5D271);   // buttom Pressed
  static const Color pressedText = Color(0xFF393131);     // Texto pressed

  // Tarjetas y Superficies
  static const Color cardBg = Colors.white;
  static const Color cardBorder = Color(0xFFE0E0E0);      // Borde tarjetas Default
  static const Color cardDetailBg = Color(0xFF696565);    // Card Detalle expandida
  static const Color cardDetailText = Colors.white;
  static const Color descriptionBg = Color(0xFFE5E5EA);   // Placeholder description pill
  static const Color textPlaceholder = Color(0xFFC7C7CC); // Placeholder text lines

  // Stat Cards de Inicio
  static const Color statGreenBg = Color(0xFFDCF7DC);     // Disponibles fondo
  static const Color statGreenBorder = Color(0xFF9DCB9D); // Disponibles borde
  static const Color statGreenText = Color(0xFF2E7D32);   // Verde oscuro para texto/icono

  static const Color statOrangeBg = Color(0xFFFFECDD);    // Reservados fondo
  static const Color statOrangeBorder = Color(0xFFFACCA9);// Reservados borde
  static const Color statOrangeText = Color(0xFFD85A00);  // Naranja oscuro para texto/icono

  // Neutros y Textos
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF7B7B7B);
  static const Color background = Color(0xFFF8F9FA);
  static const Color tabInactive = Color(0xFFEEEEEE);
  static const Color tabActive = Color(0xFFF2F2F7);

  // Tokens de Diseño Figma (Login & Dashboard)
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);


  static const Color loginBackground = Color(0xFFF8FAFC);
  static const Color loginAura = Color(0xFFEFF6FF);
  static const Color loginTitle = Color(0xFF0F172A);
  static const Color loginSubtitle = Color(0xFF64748B);
  static const Color loginInputBorder = Color(0xFFE2E8F0);
  static const Color loginButtonBg = Color(0xFF1E293B);

  // Dashboard Stat Card - Disponibles (Emerald)
  static const Color emeraldBg = Color(0xFFECFDF5);
  static const Color emeraldBorder = Color(0xFFA7F3D0);
  static const Color emeraldBadge = Color(0xFF10B981);
  static const Color emeraldValue = Color(0xFF047857);
  static const Color emeraldLabel = Color(0xFF065F46);

  // Dashboard Stat Card - Reservados (Amber)
  static const Color amberBg = Color(0xFFFFFBEB);
  static const Color amberBorder = Color(0xFFFDE68A);
  static const Color amberBadge = Color(0xFFF59E0B);
  static const Color amberValue = Color(0xFFB45309);
  static const Color amberLabel = Color(0xFF92400E);

  // Info Banner
  static const Color infoAura = Color(0xFFEFF6FF);
  static const Color infoBorder = Color(0xFF3B82F6);
  static const Color infoIcon = Color(0xFF2563EB);
}
