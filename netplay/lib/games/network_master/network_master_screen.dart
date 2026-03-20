import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/game_data.dart';
import '../../widgets/app_background.dart';
import 'levels/levels.dart';
import 'logic/scoring.dart';
import 'logic/validator.dart';
import 'models/device.dart';
import 'models/level_config.dart';
import 'services/leaderboard_service.dart';
import 'services/progress_service.dart';
import 'widgets/cable_painter.dart';
import 'widgets/device_card.dart';
import 'widgets/hud_bar.dart';
import 'widgets/slot_target.dart';

enum NetworkMode { standard }

class NetworkMasterScreen extends StatefulWidget {
  const NetworkMasterScreen({super.key});

  @override
  State<NetworkMasterScreen> createState() => _NetworkMasterScreenState();
}

class _NetworkMasterScreenState extends State<NetworkMasterScreen> {
  late Future<int> _unlockedFuture;

  @override
  void initState() {
    super.initState();
    _unlockedFuture = NetworkProgressService.getUnlockedLevel();
  }

  Future<void> _refreshUnlocked() async {
    setState(() {
      _unlockedFuture = NetworkProgressService.getUnlockedLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Master'),
        actions: [
          IconButton(
            tooltip: 'Ranking',
            icon: const Icon(Icons.leaderboard_rounded),
            onPressed: () => _openLeaderboard(context),
          ),
        ],
      ),
      body: FutureBuilder<int>(
        future: _unlockedFuture,
        builder: (context, snap) {
          final unlocked = snap.data ?? 1;

          return AppBackground(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: ListView(
              children: [
                _header(context),
                const SizedBox(height: 14),
                ...networkLevels.map((lvl) => _levelCard(context, lvl, unlocked)),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openLeaderboard(BuildContext context) async {
    final leaderboard = LocalLeaderboardService();
    final entries = await leaderboard.getTop();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ranking (Local)'),
          content: SizedBox(
            width: double.maxFinite,
            child: entries.isEmpty
                ? const Text('Aún no hay puntajes.\nJuega un nivel para registrar récords.')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const Divider(height: 10),
                    itemBuilder: (_, i) {
                      final e = entries[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                e.name,
                                style: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            Text('${e.score} pts'),
                            const SizedBox(width: 10),
                            Text('⭐ ${e.stars}'),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F172A),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white.withOpacity(0.10),
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(
                Icons.hub_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arquitecto de Redes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Arrastra dispositivos y construye conexiones correctas. '
                    'Gana estrellas por eficiencia, seguridad y estabilidad.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _levelCard(BuildContext context, LevelConfig lvl, int unlocked) {
    final locked = lvl.id > unlocked;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: locked
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bloqueado. Pasa el nivel $unlocked primero.'),
                  ),
                );
              }
            : () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NetworkPlayScreen(
                      level: lvl,
                      mode: NetworkMode.standard,
                    ),
                  ),
                );
                await _refreshUnlocked();
              },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: locked
                        ? const [Color(0xFFE5E7EB), Color(0xFFF3F4F6)]
                        : const [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
                  ),
                ),
                child: Icon(
                  locked ? Icons.lock_rounded : Icons.map_rounded,
                  color: locked ? const Color(0xFF6B7280) : const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lvl.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${lvl.scene} • ${lvl.objective}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF475569),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                locked ? Icons.lock_rounded : Icons.play_arrow_rounded,
                color: locked ? const Color(0xFF6B7280) : const Color(0xFF4F46E5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkPlayScreen extends StatefulWidget {
  const NetworkPlayScreen({
    super.key,
    required this.level,
    required this.mode,
  });

  final LevelConfig level;
  final NetworkMode mode;

  @override
  State<NetworkPlayScreen> createState() => _NetworkPlayScreenState();
}

class _NetworkPlayScreenState extends State<NetworkPlayScreen> {
  late Map<DeviceType, int> remaining;
  late List<List<DeviceInstance>> slots;

  int lives = 2;
  int score = 0;
  int stars = 0;
  int attempts = 0;
  bool wifiSecure = true;

  Timer? timer;
  int secondsLeft = 0;

  @override
  void initState() {
    super.initState();

    remaining = {
      for (final t in DeviceType.values) t: widget.level.availableCounts[t] ?? 0,
    };

    slots = List.generate(widget.level.slots.length, (_) => []);

    wifiSecure = !widget.level.requiresWifiSecurity;

    secondsLeft = widget.level.timeLimitSeconds ?? 0;
    if (secondsLeft > 0) _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        secondsLeft--;
        if (secondsLeft <= 0) {
          secondsLeft = 0;
          lives = 0;
        }
      });

      if (secondsLeft <= 0) {
        timer?.cancel();
        _showEndDialog(success: false, message: 'Se acabó el tiempo.');
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connected = <bool>[];
    for (var i = 0; i < slots.length - 1; i++) {
      connected.add(slots[i].isNotEmpty && slots[i + 1].isNotEmpty);
    }

    final timeText = secondsLeft > 0 ? _format(secondsLeft) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level.title),
      ),
      body: AppBackground(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          children: [
            HudBar(
              lives: lives,
              score: score,
              stars: stars,
              timeText: timeText,
            ),
            const SizedBox(height: 12),
            _objectiveCard(context),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.45),
                      ),
                      child: CustomPaint(
                        painter: CablePainter(connected: connected),
                        child: const SizedBox.expand(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _slotsBoard(context),
                    const SizedBox(height: 14),
                    _tray(context),
                    const SizedBox(height: 14),
                    _actions(context),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(0.75),
                        border: Border.all(color: const Color(0x140F172A)),
                      ),
                      child: Text(
                        'Tip: mantén presionado un dispositivo colocado para devolverlo a la bandeja.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w800,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _objectiveCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
                ),
              ),
              child: const Icon(
                Icons.assignment_turned_in_rounded,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.level.scene,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.level.objective,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ),
            if (widget.level.requiresWifiSecurity)
              Row(
                children: [
                  const Text('WiFi seguro'),
                  Switch(
                    value: wifiSecure,
                    onChanged: (v) => setState(() => wifiSecure = v),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _slotsBoard(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < widget.level.slots.length; i++) ...[
          SlotTarget(
            config: widget.level.slots[i],
            devices: slots[i],
            onAccept: (d) => _place(i, d),
            onRemove: (d) => _remove(i, d),
            onToggleLink: (d) {
              setState(() {
                final current = d.linkType ?? LinkType.wired;
                d.linkType =
                    current == LinkType.wired ? LinkType.wifi : LinkType.wired;
              });
            },
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _tray(BuildContext context) {
    final types = DeviceType.values;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
                    ),
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    color: Color(0xFF4F46E5),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Dispositivos disponibles',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: types.map((type) {
                final count = remaining[type] ?? 0;
                final canDrag = count > 0;

                final card = DeviceCard(
                  type: type,
                  count: count,
                  compact: true,
                );

                if (!canDrag) {
                  return Opacity(
                    opacity: 0.35,
                    child: card,
                  );
                }

                return Draggable<DeviceInstance>(
                  data: DeviceInstance(
                    id: _id(),
                    type: type,
                    linkType: type.isEndpoint
                        ? (type.supportsWifi ? LinkType.wifi : LinkType.wired)
                        : null,
                  ),
                  feedback: Material(
                    color: Colors.transparent,
                    child: Opacity(
                      opacity: 0.9,
                      child: card,
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.35,
                    child: card,
                  ),
                  onDragStarted: () {
                    if ((remaining[type] ?? 0) > 0) {
                      setState(() {
                        remaining[type] = (remaining[type] ?? 1) - 1;
                      });
                    }
                  },
                  onDraggableCanceled: (_, __) {
                    setState(() {
                      remaining[type] = (remaining[type] ?? 0) + 1;
                    });
                  },
                  child: card,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actions(BuildContext context) {
    final disabled = lives <= 0;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: disabled ? null : _reset,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reiniciar'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: disabled ? null : _check,
            icon: const Icon(Icons.play_circle_rounded),
            label: const Text('Probar red'),
          ),
        ),
      ],
    );
  }

  void _place(int slotIndex, DeviceInstance d) {
    setState(() {
      slots[slotIndex].add(d);
    });
  }

  void _remove(int slotIndex, DeviceInstance d) {
    setState(() {
      slots[slotIndex].removeWhere((x) => x.id == d.id);
      remaining[d.type] = (remaining[d.type] ?? 0) + 1;
    });
  }

  void _reset() {
    setState(() {
      remaining = {
        for (final t in DeviceType.values) t: widget.level.availableCounts[t] ?? 0,
      };
      slots = List.generate(widget.level.slots.length, (_) => []);
      lives = 2;
      attempts = 0;
      stars = 0;
      score = 0;
      wifiSecure = !widget.level.requiresWifiSecurity;
    });

    secondsLeft = widget.level.timeLimitSeconds ?? 0;
    if (secondsLeft > 0) _startTimer();
  }

  void _check() {
    attempts++;

    final result = validateNetwork(
      ValidationContext(
        level: widget.level,
        slotDevices: slots,
        wifiSecure: wifiSecure,
      ),
    );

    if (!result.ok) {
      final code = result.errors.first;
      final heavy = code == 'wrong_order' ||
          code == 'missing_router' ||
          code == 'missing_firewall' ||
          code == 'missing_switch';

      setState(() {
        lives = (lives - (heavy ? 2 : 1)).clamp(0, 99);
      });

      final edu = widget.level.educationOnFail[code] ??
          'Pista: revisa el orden y el rol de cada dispositivo (router, switch, firewall).';

      _showFailDialog(code, edu);

      if (lives <= 0) {
        _showEndDialog(success: false, message: 'Sin vidas.');
      }
      return;
    }

    final serverWiredOk =
        !widget.level.requiresWiredServer || _serverIsWired();
    final printerWiredOk = _printerIsWired();

    if (!printerWiredOk) {
      setState(() {
        lives = (lives - 1).clamp(0, 99);
      });

      _showFailDialog(
        'printer_wired',
        'La impresora debe ir cableada para mayor estabilidad.',
      );

      if (lives <= 0) {
        _showEndDialog(success: false, message: 'Sin vidas.');
      }
      return;
    }

    final secondsRemaining = secondsLeft;

    final attempt = computeResult(
      success: true,
      errors: const [],
      levelId: widget.level.id,
      attemptsUsed: attempts - 1,
      secondsRemaining: secondsRemaining,
      wifiSecure: !widget.level.requiresWifiSecurity || wifiSecure,
      serverWiredOk: serverWiredOk,
    );

    setState(() {
      stars = attempt.stars;
      score += attempt.scoreDelta;
    });

    addXP(25 + attempt.stars * 10);
    saveBestNetworkMaster(score);

    final millisUsed = widget.level.timeLimitSeconds == null
        ? 0
        : (widget.level.timeLimitSeconds! - secondsRemaining) * 1000;

    final leaderboard = LocalLeaderboardService();
    leaderboard.submit(
      LeaderboardEntry(
        name: 'Jugador',
        score: score,
        stars: attempt.stars,
        millis: millisUsed,
        timestampMillis: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    _showEndDialog(
      success: true,
      message: '¡Red correcta! +${attempt.scoreDelta} puntos',
    );
  }

  bool _printerIsWired() {
    for (final slot in slots) {
      for (final d in slot) {
        if (d.type == DeviceType.printer) {
          return (d.linkType ?? LinkType.wired) == LinkType.wired;
        }
      }
    }
    return true;
  }

  bool _serverIsWired() {
    for (final slot in slots) {
      for (final d in slot) {
        if (d.type == DeviceType.server) {
          return (d.linkType ?? LinkType.wired) == LinkType.wired;
        }
      }
    }
    return true;
  }

  void _showFailDialog(String code, String edu) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hay un error'),
        content: Text(edu),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showEndDialog({
    required bool success,
    required String message,
  }) {
    timer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(success ? '✅ Éxito' : '❌ Fallo'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () async {
              if (success) {
                await NetworkProgressService.unlockNext(widget.level.id);
              }
              if (!context.mounted) return;
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Volver'),
          ),
          if (success)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _reset();
              },
              child: const Text('Repetir'),
            ),
        ],
      ),
    );
  }

  String _id() => DateTime.now().microsecondsSinceEpoch.toString();

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}