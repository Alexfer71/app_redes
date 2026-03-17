import 'package:flutter/material.dart';

/// Fondo bonito con degradado + burbujas suaves.
/// Úsalo para que todas las pantallas se vean más "pro".
class AppBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AppBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Degradado base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEEF2FF),
                Color(0xFFF5F3FF),
                Color(0xFFF8FAFC),
              ],
            ),
          ),
        ),

        // Burbujas (decorativas)
        Positioned(
          top: -60,
          left: -30,
          child: _bubble(160, const Color(0xFF8B5CF6).withOpacity(0.16)),
        ),
        Positioned(
          top: 120,
          right: -50,
          child: _bubble(190, const Color(0xFF3B82F6).withOpacity(0.14)),
        ),
        Positioned(
          bottom: -80,
          left: 40,
          child: _bubble(220, const Color(0xFF22C55E).withOpacity(0.10)),
        ),

        SafeArea(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _bubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
