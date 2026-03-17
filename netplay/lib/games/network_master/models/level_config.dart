import 'device.dart';

class SlotConfig {
  const SlotConfig({
    required this.label,
    required this.accepts,
    this.multiple = false,
  });

  final String label;
  final List<DeviceType> accepts;
  final bool multiple;
}

class LevelConfig {
  const LevelConfig({
    required this.id,
    required this.title,
    required this.scene,
    required this.objective,
    required this.slots,
    required this.availableCounts,
    required this.requiredDevices,
    required this.educationOnFail,
    this.timeLimitSeconds,
    this.requiresWifiSecurity = false,
    this.requiresWiredServer = false,
  });

  final int id;
  final String title;
  final String scene;
  final String objective;
  final List<SlotConfig> slots;
  final Map<DeviceType, int> availableCounts;
  final Set<DeviceType> requiredDevices;
  final Map<String, String> educationOnFail;
  final int? timeLimitSeconds;
  final bool requiresWifiSecurity;
  final bool requiresWiredServer;
}
