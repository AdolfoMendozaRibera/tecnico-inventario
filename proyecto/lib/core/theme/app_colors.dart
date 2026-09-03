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
}
