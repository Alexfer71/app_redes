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
        return config.accepts.contains(data.type);
      },
      onAccept: onAccept,
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isHovering
                  ? [
                      const Color(0xFFE0F2FE),
                      const Color(0xFFEEF2FF),
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFF8FAFC),
                    ],
            ),
            border: Border.all(
              color: isHovering
                  ? const Color(0xFF06B6D4)
                  : const Color(0x160F172A),
              width: isHovering ? 1.8 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovering
                    ? const Color(0x2206B6D4)
                    : const Color(0x120F172A),
                blurRadius: isHovering ? 20 : 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _slotIcon(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      config.label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  if (devices.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: const Color(0xFFF1F5F9),
                      ),
                      child: Text(
                        "Vacío",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Acepta: ${config.accepts.map((e) => e.label).join(", ")}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              if (devices.isEmpty)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isHovering
                        ? const Color(0xFFE0F2FE)
                        : const Color(0xFFF8FAFC),
                    border: Border.all(
                      color: isHovering
                          ? const Color(0xFF06B6D4)
                          : const Color(0x140F172A),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isHovering
                            ? Icons.file_download_done_rounded
                            : Icons.add_to_photos_rounded,
                        color: isHovering
                            ? const Color(0xFF0891B2)
                            : const Color(0xFF64748B),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isHovering
                              ? "Suelta aquí el dispositivo"
                              : "Arrastra un dispositivo a este espacio",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: devices.map((device) {
                    return _deviceChip(context, device);
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _slotIcon() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
        ),
      ),
      child: const Icon(
        Icons.router_rounded,
        color: Color(0xFF4F46E5),
        size: 20,
      ),
    );
  }

  Widget _deviceChip(BuildContext context, DeviceInstance device) {
    final linkType = device.linkType;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0x140F172A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            device.type.icon,
            size: 18,
            color: const Color(0xFF4F46E5),
          ),
          const SizedBox(width: 8),
          Text(
            device.type.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
          ),
          if (linkType != null) ...[
            const SizedBox(width: 8),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onToggleLink(device),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: const Color(0xFFEEF2FF),
                ),
                child: Text(
                  linkType.name.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4F46E5),
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ),
          ],
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onRemove(device),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }
}