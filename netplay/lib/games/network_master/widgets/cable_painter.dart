import 'package:flutter/material.dart';

class CablePainter extends CustomPainter {
  CablePainter({required this.connected});

  /// connected[i] means link from slot i -> slot i+1 is active
  final List<bool> connected;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF22C55E)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = const Color(0xFF3B82F6);

    final n = connected.length;
    if (n <= 0) return;

    // Dibujamos líneas horizontales simples, asumiendo que los slots están en fila.
    final y = size.height / 2;
    final step = size.width / (n + 1);
    for (var i = 0; i < n; i++) {
      if (!connected[i]) continue;
      final x1 = step * (i + 1);
      final x2 = step * (i + 2);
      canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);

      // Paquete de datos (punto)
      final dotX = (x1 + x2) / 2;
      canvas.drawCircle(Offset(dotX, y), 4.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CablePainter oldDelegate) {
    if (oldDelegate.connected.length != connected.length) return true;
    for (var i = 0; i < connected.length; i++) {
      if (oldDelegate.connected[i] != connected[i]) return true;
    }
    return false;
  }
}
