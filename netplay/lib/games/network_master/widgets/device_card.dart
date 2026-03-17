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
        vertical: compact ? 8 : 12,
        horizontal: compact ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 6),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            type.assetPath,
            width: compact ? 20 : 26,
            height: compact ? 20 : 26,
            errorBuilder: (_, __, ___) => Icon(type.icon, size: compact ? 18 : 22),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
