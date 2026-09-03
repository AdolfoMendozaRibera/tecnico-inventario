import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Componente Figma: `buttom` (Badge "Activa" con 3 estados)
/// - Default: #FFD400, texto negro opacidad 0.8
/// - Hover:   #FFBF00, texto negro opacidad 1.0
/// - Pressed: #E5D271, texto #393131 opacidad 0.6
class ActiveBadge extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const ActiveBadge({
    super.key,
    this.label = 'Activa',
    this.onTap,
  });

  @override
  State<ActiveBadge> createState() => _ActiveBadgeState();
}

class _ActiveBadgeState extends State<ActiveBadge> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Determinar colores y opacidades según el estado interactivo
    Color bgColor;
    Color textColor;
    double textOpacity;

    if (_isPressed) {
      bgColor = AppColors.yellowPressed;
      textColor = AppColors.pressedText;
      textOpacity = 0.6;
    } else if (_isHovered) {
      bgColor = AppColors.yellowHover;
      textColor = AppColors.textPrimary;
      textOpacity = 1.0;
    } else {
      bgColor = AppColors.yellowDefault;
      textColor = AppColors.textPrimary;
      textOpacity = 0.8;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.yellowHover.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: textOpacity),
              letterSpacing: -0.2,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
