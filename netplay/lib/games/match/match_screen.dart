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
          title: Text(title),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // dialog
                Navigator.pop(this.context); // vuelve al menú
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

  Widget _chip(BuildContext context, String text, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.88),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectBtn({
    required String text,
    required IconData icon,
    required List<Color> gradient,
  }) {
    final disabled = _locked;

    return Expanded(
      child: AnimatedOpacity(
        opacity: disabled ? 0.55 : 1,
        duration: const Duration(milliseconds: 160),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: disabled ? null : () => _check(text),
          child: Container(
            height: 76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
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
      appBar: AppBar(
        title: const Text("Clasifica la Situación"),
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
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.black12,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _chip(context, "$lives", Icons.favorite_rounded),
                const SizedBox(width: 10),
                _chip(context, "$score", Icons.star_rounded),
                const SizedBox(width: 10),
                _chip(context, "${safeIndex + 1}/${cases.length}", Icons.flag_rounded),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Card(
                  key: ValueKey(safeIndex),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.black12),
                      color: Colors.white.withOpacity(0.88),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lightbulb_rounded, size: 34),
                        const SizedBox(height: 12),
                        Text(
                          current["text"]!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Elige la categoría correcta.",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _selectBtn(
                  text: "PROTECCIÓN",
                  icon: Icons.verified_user_rounded,
                  gradient: const [Color(0xFF22C55E), Color(0xFF16A34A)],
                ),
                const SizedBox(width: 10),
                _selectBtn(
                  text: "AMENAZA",
                  icon: Icons.warning_rounded,
                  gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
                ),
                const SizedBox(width: 10),
                _selectBtn(
                  text: "ERROR",
                  icon: Icons.bug_report_rounded,
                  gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
