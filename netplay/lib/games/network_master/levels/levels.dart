import '../models/device.dart';
import '../models/level_config.dart';

/// Network Master: niveles más difíciles + slots genéricos (Inicio → Pasos → Fin).
///
/// Importante:
/// - Los slots NO revelan qué dispositivo va en cada paso.
/// - La bandeja muestra TODOS los dispositivos (algunos con 0 disponibles).
/// - Los niveles 2..5 quedan bloqueados hasta pasar el 1 (y así sucesivamente).

const List<LevelConfig> networkLevels = [
  // -------------------- NIVEL 1 --------------------
  LevelConfig(
    id: 1,
    title: 'Nivel 1: Casa (básico)',
    scene: 'Casa',
    objective: 'Conecta una PC a Internet (Inicio → Fin).',
    slots: [
      SlotConfig(
        label: 'Inicio',
        accepts: [DeviceType.pc, DeviceType.laptop, DeviceType.phone, DeviceType.smartTv],
        multiple: false,
      ),
      SlotConfig(
        label: 'Paso 1',
        accepts: [DeviceType.router],
      ),
      SlotConfig(
        label: 'Fin',
        accepts: [DeviceType.internet],
      ),
    ],
    // más “ruido” para que el juego no sea obvio
    availableCounts: {
      DeviceType.pc: 1,
      DeviceType.laptop: 1,
      DeviceType.phone: 1,
      DeviceType.smartTv: 1,
      DeviceType.router: 1,
      DeviceType.internet: 1,
      DeviceType.switchDevice: 1,
      DeviceType.firewall: 1,
      DeviceType.accessPoint: 1,
      DeviceType.printer: 1,
      DeviceType.server: 0,
    },
    requiredDevices: {DeviceType.router, DeviceType.internet},
    timeLimitSeconds: 35,
    educationOnFail: {
      'missing_router': 'Sin router no hay salida correcta: conecta la LAN (Inicio) con la WAN (Internet).',
      'missing_internet': 'Para completar la red debe existir el punto “Internet” en el Fin.',
      'wrong_order': 'Piensa como técnico: Inicio (LAN) → Router → Internet (WAN).',
    },
  ),

  // -------------------- NIVEL 2 --------------------
  LevelConfig(
    id: 2,
    title: 'Nivel 2: Casa (completa)',
    scene: 'Casa',
    objective: 'Conecta la red con un “paso extra” sin equivocarte.',
    slots: [
      SlotConfig(
        label: 'Inicio',
        accepts: [DeviceType.pc, DeviceType.laptop, DeviceType.phone, DeviceType.smartTv],
        multiple: true,
      ),
      SlotConfig(
        label: 'Paso 1',
        accepts: [DeviceType.switchDevice],
      ),
      SlotConfig(
        label: 'Paso 2',
        accepts: [DeviceType.router],
      ),
      SlotConfig(
        label: 'Fin',
        accepts: [DeviceType.internet],
      ),
    ],
    availableCounts: {
      DeviceType.pc: 1,
      DeviceType.laptop: 1,
      DeviceType.phone: 1,
      DeviceType.smartTv: 1,
      DeviceType.switchDevice: 1,
      DeviceType.router: 1,
      DeviceType.internet: 1,
      // distractores
      DeviceType.firewall: 1,
      DeviceType.accessPoint: 1,
      DeviceType.printer: 1,
      DeviceType.server: 0,
    },
    requiredDevices: {DeviceType.switchDevice, DeviceType.router, DeviceType.internet},
    timeLimitSeconds: 45,
    educationOnFail: {
      'missing_switch': 'Un switch ayuda a concentrar varios equipos dentro de la LAN.',
      'wrong_order': 'Regla: equipos (LAN) → Switch → Router → Internet (WAN).',
    },
  ),

  // -------------------- NIVEL 3 --------------------
  LevelConfig(
    id: 3,
    title: 'Nivel 3: Oficina (WiFi + impresora)',
    scene: 'Oficina',
    objective: 'Conecta usuarios y una impresora. Evita errores de estabilidad.',
    slots: [
      SlotConfig(
        label: 'Inicio',
        accepts: [DeviceType.pc, DeviceType.laptop, DeviceType.phone, DeviceType.printer],
        multiple: true,
      ),
      SlotConfig(
        label: 'Paso 1',
        accepts: [DeviceType.switchDevice],
      ),
      SlotConfig(
        label: 'Paso 2',
        accepts: [DeviceType.accessPoint],
      ),
      SlotConfig(
        label: 'Paso 3',
        accepts: [DeviceType.router],
      ),
      SlotConfig(
        label: 'Fin',
        accepts: [DeviceType.internet],
      ),
    ],
    availableCounts: {
      DeviceType.pc: 2,
      DeviceType.laptop: 1,
      DeviceType.phone: 1,
      DeviceType.printer: 1,
      DeviceType.switchDevice: 1,
      DeviceType.accessPoint: 1,
      DeviceType.router: 1,
      DeviceType.internet: 1,
      // distractores
      DeviceType.firewall: 1,
      DeviceType.server: 0,
      DeviceType.smartTv: 0,
    },
    requiredDevices: {DeviceType.switchDevice, DeviceType.accessPoint, DeviceType.router, DeviceType.internet},
    timeLimitSeconds: 60,
    educationOnFail: {
      'wrong_order': 'Piensa en capas: LAN → Switch → (WiFi/AP) → Router → Internet.',
      'wifi_tip': 'El Access Point crea la red WiFi dentro de la LAN. No reemplaza al router.',
      'printer_wired': 'La impresora debe ir cableada para evitar cortes y colas de impresión.',
    },
  ),

  // -------------------- NIVEL 4 --------------------
  LevelConfig(
    id: 4,
    title: 'Nivel 4: Empresa (servidor crítico)',
    scene: 'Empresa',
    objective: 'Conecta la red y mantén el servidor estable (cableado).',
    slots: [
      SlotConfig(
        label: 'Inicio',
        accepts: [DeviceType.pc, DeviceType.laptop, DeviceType.server],
        multiple: true,
      ),
      SlotConfig(
        label: 'Paso 1',
        accepts: [DeviceType.switchDevice],
      ),
      SlotConfig(
        label: 'Paso 2',
        accepts: [DeviceType.firewall],
      ),
      SlotConfig(
        label: 'Paso 3',
        accepts: [DeviceType.router],
      ),
      SlotConfig(
        label: 'Fin',
        accepts: [DeviceType.internet],
      ),
    ],
    availableCounts: {
      DeviceType.pc: 2,
      DeviceType.laptop: 1,
      DeviceType.server: 1,
      DeviceType.switchDevice: 1,
      DeviceType.firewall: 1,
      DeviceType.router: 1,
      DeviceType.internet: 1,
      // distractores
      DeviceType.accessPoint: 1,
      DeviceType.phone: 1,
      DeviceType.printer: 1,
      DeviceType.smartTv: 0,
    },
    requiredDevices: {DeviceType.switchDevice, DeviceType.firewall, DeviceType.router, DeviceType.internet, DeviceType.server},
    requiresWiredServer: true,
    timeLimitSeconds: 70,
    educationOnFail: {
      'server_wired': 'Servidor por cable = menos latencia, más estabilidad y menos pérdidas.',
      'lan_wan': 'LAN: red interna. WAN: red externa. El router conecta LAN↔WAN.',
    },
  ),

  // -------------------- NIVEL 5 --------------------
  LevelConfig(
    id: 5,
    title: 'Nivel 5: Banco (ataque hacker)',
    scene: 'Banco',
    objective: 'Seguridad alta: firewall + WiFi seguro. Sin margen de error.',
    slots: [
      SlotConfig(
        label: 'Inicio',
        accepts: [DeviceType.pc, DeviceType.laptop, DeviceType.phone],
        multiple: true,
      ),
      SlotConfig(
        label: 'Paso 1',
        accepts: [DeviceType.switchDevice],
      ),
      SlotConfig(
        label: 'Paso 2',
        accepts: [DeviceType.firewall],
      ),
      SlotConfig(
        label: 'Paso 3',
        accepts: [DeviceType.router],
      ),
      SlotConfig(
        label: 'Fin',
        accepts: [DeviceType.internet],
      ),
    ],
    availableCounts: {
      DeviceType.pc: 1,
      DeviceType.laptop: 1,
      DeviceType.phone: 1,
      DeviceType.switchDevice: 1,
      DeviceType.firewall: 1,
      DeviceType.router: 1,
      DeviceType.internet: 1,
      // distractores
      DeviceType.accessPoint: 1,
      DeviceType.printer: 1,
      DeviceType.server: 1,
      DeviceType.smartTv: 0,
    },
    requiredDevices: {DeviceType.switchDevice, DeviceType.firewall, DeviceType.router, DeviceType.internet},
    requiresWifiSecurity: true,
    timeLimitSeconds: 60,
    educationOnFail: {
      'missing_firewall': 'El firewall filtra tráfico y bloquea accesos no autorizados. Debe estar antes del router/salida.',
      'wifi_security': 'WiFi debe ser seguro (WPA2/WPA3). En un banco, nunca WiFi abierto.',
      'router_switch': 'Switch: conecta equipos en LAN. Router: conecta LAN con WAN.',
    },
  ),
];
