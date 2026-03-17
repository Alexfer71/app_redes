import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/level_config.dart';

class SlotTarget extends StatelessWidget {
  const SlotTarget({
    super.key,
    required this.config,
    required this.devices,
    required this.onAccept,
    required this.onRemove,
    required this.onToggleLink,
  });

  final SlotConfig config;
  final List<DeviceInstance> devices;
  final ValueChanged<DeviceInstance> onAccept;
  final ValueChanged<DeviceInstance> onRemove;
  final ValueChanged<DeviceInstance> onToggleLink;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DeviceInstance>(
      onWillAccept: (data) {
        if (data == null) return false;
        if (!config.accepts.contains(data.type)) return false;
        if (!config.multiple && devices.isNotEmpty) return false;
        return true;
      },
      onAccept: onAccept,
      builder: (context, candidateData, rejectedData) {
        final isHover = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isHover ? 0.95 : 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHover ? Theme.of(context).colorScheme.primary : Colors.black12,
              width: isHover ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.black54,
                    ),
              ),
              const SizedBox(height: 10),
              if (devices.isEmpty)
                Text(
                  'Arrastra aquí',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black38,
                        fontWeight: FontWeight.w700,
                      ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: devices.map((d) => _placedChip(context, d)).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _placedChip(BuildContext context, DeviceInstance d) {
    final showLink = d.type.isEndpoint && d.type.supportsWifi;
    final link = d.linkType ?? LinkType.wired;
    return InkWell(
      onLongPress: () => onRemove(d),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(d.type.icon, size: 18),
            const SizedBox(width: 6),
            Text(
              d.type.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            if (showLink) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: () => onToggleLink(d),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      link == LinkType.wifi ? Icons.wifi_rounded : Icons.cable_rounded,
                      size: 16,
                      color: link == LinkType.wifi ? Colors.orange : Colors.black54,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      link == LinkType.wifi ? 'WiFi' : 'Cable',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: link == LinkType.wifi ? Colors.orange : Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
