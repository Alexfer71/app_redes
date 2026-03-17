import 'package:flutter/material.dart';

enum DeviceType {
  pc,
  laptop,
  phone,
  smartTv,
  printer,
  accessPoint,
  switchDevice,
  router,
  firewall,
  server,
  internet,
}

enum LinkType { wired, wifi }

extension DeviceTypeX on DeviceType {
  String get label {
    switch (this) {
      case DeviceType.pc:
        return 'PC';
      case DeviceType.laptop:
        return 'Laptop';
      case DeviceType.phone:
        return 'Celular';
      case DeviceType.smartTv:
        return 'Smart TV';
      case DeviceType.printer:
        return 'Impresora';
      case DeviceType.accessPoint:
        return 'Access Point';
      case DeviceType.switchDevice:
        return 'Switch';
      case DeviceType.router:
        return 'Router';
      case DeviceType.firewall:
        return 'Firewall';
      case DeviceType.server:
        return 'Servidor';
      case DeviceType.internet:
        return 'Internet';
    }
  }

  /// Ruta del asset (si existe). Si falta, se mostrará el ícono.
  String get assetPath {
    switch (this) {
      case DeviceType.pc:
        return 'assets/network_master/images/pc.png';
      case DeviceType.laptop:
        return 'assets/network_master/images/laptop.png';
      case DeviceType.phone:
        return 'assets/network_master/images/phone.png';
      case DeviceType.smartTv:
        return 'assets/network_master/images/smart_tv.png';
      case DeviceType.printer:
        return 'assets/network_master/images/printer.png';
      case DeviceType.accessPoint:
        return 'assets/network_master/images/access_point.png';
      case DeviceType.switchDevice:
        return 'assets/network_master/images/switch.png';
      case DeviceType.router:
        return 'assets/network_master/images/router.png';
      case DeviceType.firewall:
        return 'assets/network_master/images/firewall.png';
      case DeviceType.server:
        return 'assets/network_master/images/server.png';
      case DeviceType.internet:
        return 'assets/network_master/images/internet.png';
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceType.pc:
        return Icons.desktop_windows_rounded;
      case DeviceType.laptop:
        return Icons.laptop_rounded;
      case DeviceType.phone:
        return Icons.smartphone_rounded;
      case DeviceType.smartTv:
        return Icons.tv_rounded;
      case DeviceType.printer:
        return Icons.print_rounded;
      case DeviceType.accessPoint:
        return Icons.wifi_tethering_rounded;
      case DeviceType.switchDevice:
        return Icons.hub_rounded;
      case DeviceType.router:
        return Icons.settings_ethernet_rounded;
      case DeviceType.firewall:
        return Icons.shield_rounded;
      case DeviceType.server:
        return Icons.dns_rounded;
      case DeviceType.internet:
        return Icons.public_rounded;
    }
  }

  bool get isEndpoint {
    return this == DeviceType.pc ||
        this == DeviceType.laptop ||
        this == DeviceType.phone ||
        this == DeviceType.smartTv ||
        this == DeviceType.printer ||
        this == DeviceType.server;
  }

  bool get supportsWifi {
    return this == DeviceType.phone || this == DeviceType.laptop || this == DeviceType.smartTv;
  }
}

class DeviceInstance {
  DeviceInstance({required this.id, required this.type, this.linkType});

  final String id;
  final DeviceType type;
  LinkType? linkType;
}
