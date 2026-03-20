import 'package:flutter/material.dart';

/// Fondo gamer/tech con capas suaves.
/// No toca lógica, solo presentación.
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8FBFF),
            Color(0xFFF3F4FF),
            Color(0xFFEEF7FF),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -70,
            left: -30,
            child: _GlowBubble(
              size: 220,
              colors: [Color(0x334F46E5), Color(0x114F46E5)],
            ),
          ),
          const Positioned(
            top: 90,
            right: -40,
            child: _GlowBubble(
              size: 180,
              colors: [Color(0x3306B6D4), Color(0x1106B6D4)],
            ),
          ),
          const Positioned(
            bottom: -80,
            left: -20,
            child: _GlowBubble(
              size: 210,
              colors: [Color(0x338B5CF6), Color(0x118B5CF6)],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GridPainter(),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBubble extends StatelessWidget {
  const _GlowBubble({
    required this.size,
    required this.colors,
  });

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x120F172A)
      ..strokeWidth = 1;

    const step = 32.0;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}