import 'package:flutter/material.dart';
import '../../data/game_data.dart';
import '../../widgets/app_background.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int index = 0;
  int lives = 3;
  int score = 0;
  bool _locked = false;

  final List<Map<String, String>> cases = const [
    {
      "text": "Detectas muchos intentos de acceso desde IPs desconocidas.",
      "type": "AMENAZA",
    },
    {
      "text": "Configuras un firewall para proteger la red.",
      "type": "PROTECCIÓN",
    },
    {
      "text": "El router deja de funcionar por mala configuración.",
      "type": "ERROR",
    },
    {
      "text": "Instalas un IDS para monitorear tráfico sospechoso.",
      "type": "PROTECCIÓN",
    },
    {
      "text": "Un malware intenta robar credenciales.",
      "type": "AMENAZA",
    },
  ];

  void _goHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> _check(String selected) async {
    if (_locked || !mounted) return;
    if (index >= cases.length) return;

    setState(() => _locked = true);

    final correct = cases[index]["type"]!;
    final ok = selected == correct;

    if (ok) {
      score++;
      addXP(15);
    } else {
      lives--;
    }

    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;

    if (lives <= 0) {
      await _finish(won: false);
      return;
    }

    if (index >= cases.length - 1) {
      await _finish(won: true);
      return;
    }

    setState(() {
      index++;
      _locked = false;
    });
  }

  Future<void> _finish({required bool won}) async {
    saveBestMatch(score);

    final title = won ? "🎉 ¡Completado!" : "💥 Game Over";
    final subtitle =
        "Puntaje: $score/${cases.length}\nRécord: $bestMatch\nNivel: $level  |  XP: $xp";

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          title: Text(title),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(this.context);
              },
              child: const Text("Menú"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goHome();
              },
              child: const Text("Inicio"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  index = 0;
                  lives = 3;
                  score = 0;
                  _locked = false;
                });
              },
              child: const Text("Reintentar"),
            ),
          ],
        );
      },
    );
  }

  Widget _hudChip(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color tint,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.88),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x140F172A)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x120F172A),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tint.withOpacity(0.12),
              ),
              child: Icon(icon, size: 16, color: tint),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF64748B),
                        ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0F172A),
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

  Widget _topHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.10),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.category_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Clasifica la Situación",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Analiza cada caso y decide si es una amenaza, una protección o un error.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFEEF2FF),
        border: Border.all(color: const Color(0x224F46E5)),
      ),
      child: Text(
        "MATCH MODE",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF4F46E5),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
      ),
    );
  }

  Widget _caseCard(
    BuildContext context,
    Map<String, String> current,
    int safeIndex,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Container(
        key: ValueKey(safeIndex),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF8FAFC),
            ],
          ),
          border: Border.all(color: const Color(0x140F172A)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140F172A),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
                ),
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                size: 32,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Situación actual",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              current["text"]!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                    height: 1.25,
                  ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: const Color(0x120F172A)),
              ),
              child: Text(
                "Elige la categoría correcta para avanzar al siguiente reto.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF475569),
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectBtn({
    required BuildContext context,
    required String text,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
  }) {
    final disabled = _locked;

    return AnimatedOpacity(
      opacity: disabled ? 0.55 : 1,
      duration: const Duration(milliseconds: 160),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: disabled ? null : () => _check(text),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A0F172A),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeIndex = index.clamp(0, cases.length - 1);
    final current = cases[safeIndex];
    final progress = (safeIndex + 1) / cases.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        title: const Text(
          "Clasifica la Situación",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
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
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: ListView(
          children: [
            _topHero(context),
            const SizedBox(height: 12),
            Row(
              children: [
                _modeBadge(context),
                const Spacer(),
                Text(
                  "Caso ${safeIndex + 1} de ${cases.length}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: const Color(0x1A0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _hudChip(
                  context,
                  label: "Vidas",
                  value: "$lives",
                  icon: Icons.favorite_rounded,
                  tint: const Color(0xFFEF4444),
                ),
                const SizedBox(width: 8),
                _hudChip(
                  context,
                  label: "Puntos",
                  value: "$score",
                  icon: Icons.star_rounded,
                  tint: const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 8),
                _hudChip(
                  context,
                  label: "Progreso",
                  value: "${safeIndex + 1}/${cases.length}",
                  icon: Icons.flag_rounded,
                  tint: const Color(0xFF4F46E5),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _caseCard(context, current, safeIndex),
            const SizedBox(height: 14),
            _selectBtn(
              context: context,
              text: "PROTECCIÓN",
              subtitle: "Defensa y prevención",
              icon: Icons.verified_user_rounded,
              gradient: const [Color(0xFF22C55E), Color(0xFF16A34A)],
            ),
            const SizedBox(height: 10),
            _selectBtn(
              context: context,
              text: "AMENAZA",
              subtitle: "Riesgo o ataque",
              icon: Icons.warning_rounded,
              gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
            ),
            const SizedBox(height: 10),
            _selectBtn(
              context: context,
              text: "ERROR",
              subtitle: "Falla o mala acción",
              icon: Icons.bug_report_rounded,
              gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
