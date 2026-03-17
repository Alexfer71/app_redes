import 'package:flutter/material.dart';
import '../../data/game_data.dart';
import '../../widgets/app_background.dart';

import '../../games/quiz/quiz_screen.dart';
import '../../games/match/match_screen.dart';
import '../../games/hangman/hangman_screen.dart';
import '../../games/network_master/network_master_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  void _goHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Centro de Juegos"),
        actions: [
          IconButton(
            tooltip: "Inicio",
            onPressed: _goHome,
            icon: const Icon(Icons.home_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: AppBackground(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _stats(context),
            const SizedBox(height: 18),

            /// JUEGO 1
            _gameCard(
              context,
              icon: Icons.shield_rounded,
              title: "Juego 1: Red en Peligro",
              subtitle: "Responde rápido y suma puntos",
              record: bestQuiz,
              gradient: const [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                );
                if (mounted) setState(() {});
              },
            ),

            const SizedBox(height: 14),

            /// JUEGO 2
            _gameCard(
              context,
              icon: Icons.category_rounded,
              title: "Juego 2: Clasifica la Situación",
              subtitle: "AMENAZA / PROTECCIÓN / ERROR",
              record: bestMatch,
              gradient: const [Color(0xFF22C55E), Color(0xFF06B6D4)],
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MatchScreen()),
                );
                if (mounted) setState(() {});
              },
            ),

            const SizedBox(height: 14),

            /// ✅ JUEGO 3 - AHORCADO
            _gameCard(
              context,
              icon: Icons.psychology_rounded,
              title: "Juego 3: Ahorcado",
              subtitle: "Adivina la palabra antes de perder",
              record: 0, // puedes luego guardar récord si quieres
              gradient: const [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HangmanScreen()),
                );
                if (mounted) setState(() {});
              },
            ),

            const SizedBox(height: 14),

            /// ✅ JUEGO 4 - NETWORK MASTER
            _gameCard(
              context,
              icon: Icons.hub_rounded,
              title: "Juego 4: Network Master",
              subtitle: "Arrastra dispositivos y construye la red",
              record: bestNetworkMaster,
              gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NetworkMasterScreen()),
                );
                if (mounted) setState(() {});
              },
            ),

            const Spacer(),

            Text(
              "Tip: si te equivocas, no pasa nada. Aprende jugando 😄",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stats(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black12),
          color: Colors.white.withOpacity(0.85),
        ),
        child: Row(
          children: [
            _statChip(context,
                icon: Icons.trending_up_rounded,
                label: "Nivel",
                value: "$level"),
            const SizedBox(width: 10),
            _statChip(context,
                icon: Icons.bolt_rounded, label: "XP", value: "$xp"),
            const SizedBox(width: 10),
            _statChip(
              context,
              icon: Icons.emoji_events_rounded,
              label: "Récords",
              value: "${bestQuiz + bestMatch + bestNetworkMaster}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gameCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required int record,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "🏆 Récord: $record",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.92),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.95), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
