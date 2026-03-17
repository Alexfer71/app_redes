import '../models/device.dart';
import '../models/level_config.dart';

class ValidationContext {
  const ValidationContext({
    required this.level,
    required this.slotDevices,
    required this.wifiSecure,
  });

  final LevelConfig level;

  /// index -> devices placed in that slot
  final List<List<DeviceInstance>> slotDevices;

  final bool wifiSecure;
}

class ValidationResult {
  const ValidationResult(this.errors);
  final List<String> errors;
  bool get ok => errors.isEmpty;
}

ValidationResult validateNetwork(ValidationContext ctx) {
  final errors = <String>[];

  // Required devices present somewhere
  final placedTypes = <DeviceType>{};
  for (final slot in ctx.slotDevices) {
    for (final d in slot) {
      placedTypes.add(d.type);
    }
  }
  for (final req in ctx.level.requiredDevices) {
    if (!placedTypes.contains(req)) {
      if (req == DeviceType.switchDevice) {
        errors.add('missing_switch');
      } else if (req == DeviceType.router) {
        errors.add('missing_router');
      } else if (req == DeviceType.internet) {
        errors.add('missing_internet');
      } else if (req == DeviceType.firewall) {
        errors.add('missing_firewall');
      } else {
        errors.add('missing_${req.name}');
      }
    }
  }

  // Slot acceptance & order correctness
  for (var i = 0; i < ctx.level.slots.length; i++) {
    final slotCfg = ctx.level.slots[i];
    final slot = ctx.slotDevices[i];
    if (slot.isEmpty) continue;
    for (final d in slot) {
      if (!slotCfg.accepts.contains(d.type)) {
        errors.add('wrong_order');
        break;
      }
    }
  }

  // WiFi security rule
  if (ctx.level.requiresWifiSecurity && !ctx.wifiSecure) {
    errors.add('wifi_security');
  }

  // Server stability rule
  if (ctx.level.requiresWiredServer) {
    for (final slot in ctx.slotDevices) {
      for (final d in slot) {
        if (d.type == DeviceType.server && d.linkType == LinkType.wifi) {
          errors.add('server_wired');
        }
      }
    }
  }

  return ValidationResult(_unique(errors));
}

List<String> _unique(List<String> xs) {
  final seen = <String>{};
  final out = <String>[];
  for (final x in xs) {
    if (seen.add(x)) out.add(x);
  }
  return out;
}
