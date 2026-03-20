import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    super.key,
    required this.type,
    this.count,
    this.compact = false,
  });

  final DeviceType type;
  final int? count;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final label = count == null ? type.label : '${type.label} x$count';

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: compact ? 10 : 14,
        horizontal: compact ? 12 : 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF8FAFC)],
        ),
        border: Border.all(color: const Color(0x140F172A)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 8),
            color: Color(0x120F172A),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 34 : 42,
            height: compact ? 34 : 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
              ),
            ),
            child: Center(
              child: Image.asset(
                type.assetPath,
                width: compact ? 18 : 24,
                height: compact ? 18 : 24,
                errorBuilder: (_, __, ___) => Icon(
                  type.icon,
                  size: compact ? 18 : 22,
                  color: const Color(0xFF4F46E5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
          ),
        ],
      ),
    );
  }
}