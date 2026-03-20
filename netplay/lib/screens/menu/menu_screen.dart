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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        title: const Text(
          "Centro de Juegos",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF0F172A),
        ),
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
            Expanded(
              child: ListView(
                children: [
                  _gameCard(
                    context,
                    icon: Icons.shield_rounded,
                    title: "Red en Peligro",
                    subtitle: "Responde rápido y protege la red",
                    badge: "Quiz",
                    record: bestQuiz,
                    gradient: const [
                      Color(0xFF2563EB),
                      Color(0xFF7C3AED),
                    ],
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizScreen()),
                      );
                      if (mounted) setState(() {});
                    },
                  ),
                  const SizedBox(height: 14),
                  _gameCard(
                    context,
                    icon: Icons.category_rounded,
                    title: "Clasifica la Situación",
                    subtitle: "Amenaza, protección o error",
                    badge: "Match",
                    record: bestMatch,
                    gradient: const [
                      Color(0xFF10B981),
                      Color(0xFF06B6D4),
                    ],
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MatchScreen()),
                      );
                      if (mounted) setState(() {});
                    },
                  ),
                  const SizedBox(height: 14),
                  _gameCard(
                    context,
                    icon: Icons.psychology_rounded,
                    title: "Ahorcado",
                    subtitle: "Adivina la palabra antes de perder",
                    badge: "Word Game",
                    record: 0,
                    gradient: const [
                      Color(0xFF8B5CF6),
                      Color(0xFF4F46E5),
                    ],
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HangmanScreen(),
                        ),
                      );
                      if (mounted) setState(() {});
                    },
                  ),
                  const SizedBox(height: 14),
                  _gameCard(
                    context,
                    icon: Icons.hub_rounded,
                    title: "Network Master",
                    subtitle: "Construye la red arrastrando dispositivos",
                    badge: "Builder",
                    record: bestNetworkMaster,
                    gradient: const [
                      Color(0xFFF59E0B),
                      Color(0xFFEF4444),
                    ],
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NetworkMasterScreen(),
                        ),
                      );
                      if (mounted) setState(() {});
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Aprende jugando y mejora tus récords en cada reto.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stats(BuildContext context) {
    final totalRecords = bestQuiz + bestMatch + bestNetworkMaster;

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.white.withOpacity(0.88),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Panel del jugador",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: const Color(0xFFEEF2FF),
                  ),
                  child: Text(
                    "Activo",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF4F46E5),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _statChip(
                  context,
                  icon: Icons.trending_up_rounded,
                  label: "Nivel",
                  value: "$level",
                ),
                const SizedBox(width: 10),
                _statChip(
                  context,
                  icon: Icons.bolt_rounded,
                  label: "XP",
                  value: "$xp",
                ),
                const SizedBox(width: 10),
                _statChip(
                  context,
                  icon: Icons.emoji_events_rounded,
                  label: "Récords",
                  value: "$totalRecords",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: const Color(0x140F172A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF4F46E5)),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF475569),
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
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
    required String badge,
    required int record,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.22),
              blurRadius: 26,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.78),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFF0F172A),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.white.withOpacity(0.82),
                          ),
                          child: Text(
                            badge,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF0F172A),
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.4,
                                    ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: const Color(0xFF0F172A),
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF334155),
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF0F172A),
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _miniInfo(
                    context,
                    icon: Icons.emoji_events_rounded,
                    label: "Récord",
                    value: "$record",
                  ),
                  const SizedBox(width: 10),
                  _miniInfo(
                    context,
                    icon: Icons.sports_esports_rounded,
                    label: "Modo",
                    value: badge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniInfo(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.78),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0F172A), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF0F172A),
                          fontWeight: FontWeight.w900,
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
}
