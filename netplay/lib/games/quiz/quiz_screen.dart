import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../data/game_data.dart';
import '../../data/questions.dart';
import '../../widgets/app_background.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Random _rand = Random();
  late List<Map<String, dynamic>> _levels;

  AudioPlayer? _player;

  int index = 0;
  int timeLeft = 20;
  int lives = 3;
  int score = 0;

  Timer? _timer;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _reset(full: true);
    _initMusic();
  }

  Future<void> _initMusic() async {
    try {
      _player?.dispose();
      _player = AudioPlayer();
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.play(AssetSource('music.mp3'));
    } catch (_) {
      // Si falta el asset o el paquete, el juego sigue funcionando sin música.
    }
  }

  void _goHome() {
    _player?.stop();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _reset({bool full = false}) {
    _timer?.cancel();

    if (full) {
      _levels = quizLevels.map((e) {
        final copy = Map<String, dynamic>.from(e);
        copy["options"] = List<String>.from(e["options"] as List);
        return copy;
      }).toList();

      _levels.shuffle(_rand);
      for (final q in _levels) {
        (q["options"] as List<String>).shuffle(_rand);
      }

      index = 0;
      lives = 3;
      score = 0;
    }

    timeLeft = 20;
    _startTimer();

    if (mounted) setState(() {});
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (timeLeft <= 1) {
        t.cancel();
        setState(() => timeLeft = 0);
        _onTimeout();
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  Future<void> _onTimeout() async {
    if (_locked || !mounted) return;
    _locked = true;

    lives--;

    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;

    if (lives <= 0) {
      await _finish(won: false, reason: "Te quedaste sin vidas.");
      return;
    }

    if (index >= _levels.length - 1) {
      await _finish(won: true, reason: "Quiz finalizado.");
      return;
    }

    _next();
  }

  Map<String, dynamic> get _q => _levels[index];

  Future<void> _choose(String option) async {
    if (_locked || !mounted) return;
    _locked = true;
    _timer?.cancel();

    final correct = _q["correct"] as String;
    final isCorrect = option == correct;

    if (isCorrect) {
      score += timeLeft;
      addXP(20);
    } else {
      lives--;
    }

    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;

    if (lives <= 0) {
      await _finish(won: false, reason: "Te quedaste sin vidas.");
      return;
    }

    if (index >= _levels.length - 1) {
      await _finish(won: true, reason: "¡Completaste el quiz!");
      return;
    }

    _next();
  }

  void _next() {
    index++;
    _locked = false;
    _reset(full: false);
  }

  Future<void> _finish({required bool won, required String reason}) async {
    _timer?.cancel();
    saveBestQuiz(score);

    final title = won ? "🎉 ¡Ganaste!" : "💥 Game Over";
    final subtitle =
        "$reason\n\nPuntaje: $score\nRécord: $bestQuiz\nNivel: $level  |  XP: $xp";

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
              onPressed: () async {
                await _player?.stop();
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
                  _locked = false;
                });
                _reset(full: true);
              },
              child: const Text("Reintentar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player?.stop();
    _player?.dispose();
    super.dispose();
  }

  Widget _hudChip(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color tint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.88),
        border: Border.all(color: const Color(0x140F172A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tint.withOpacity(0.12),
            ),
            child: Icon(icon, size: 18, color: tint),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
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
    );
  }

  Widget _sectionBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFEEF2FF),
        border: Border.all(color: const Color(0x224F46E5)),
      ),
      child: Text(
        "MODO QUIZ",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF4F46E5),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
      ),
    );
  }

  Widget _questionCard(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Container(
        key: ValueKey(index),
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
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
                    ),
                  ),
                  child: const Icon(
                    Icons.quiz_rounded,
                    color: Color(0xFF4F46E5),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _q["title"] as String,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0F172A),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: const Color(0x120F172A)),
              ),
              child: Text(
                _q["text"] as String,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFFFFFBEB),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_rounded,
                    color: Color(0xFFF59E0B),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _q["explanation"] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF92400E),
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
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

  Widget _optionTile(BuildContext context, String text, int optionIndex) {
    final disabled = _locked;
    const letters = ["A", "B", "C", "D", "E", "F"];

    return AnimatedOpacity(
      opacity: disabled ? 0.55 : 1,
      duration: const Duration(milliseconds: 160),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: disabled ? null : () => _choose(text),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
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
                color: Color(0x120F172A),
                blurRadius: 14,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letters[optionIndex],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                          height: 1.25,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.black.withOpacity(0.28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
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
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withOpacity(0.10),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Red en Peligro",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Responde con rapidez y protege la red antes de que se agote el tiempo.",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_levels.isEmpty) ? 0.0 : (index + 1) / _levels.length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz ${index + 1}/${_levels.length}"),
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
        child: Column(
          children: [
            _topHero(context),
            const SizedBox(height: 14),

            Row(
              children: [
                _sectionBadge(context),
                const Spacer(),
                Text(
                  "Pregunta ${index + 1} de ${_levels.length}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: const Color(0x1A0F172A),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _hudChip(
                    context,
                    label: "Tiempo",
                    value: "$timeLeft s",
                    icon: Icons.timer_rounded,
                    tint: const Color(0xFF06B6D4),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _hudChip(
                    context,
                    label: "Vidas",
                    value: "$lives",
                    icon: Icons.favorite_rounded,
                    tint: const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _hudChip(
                    context,
                    label: "Puntos",
                    value: "$score",
                    icon: Icons.star_rounded,
                    tint: const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _questionCard(context),
            const SizedBox(height: 14),

            Expanded(
              child: ListView.separated(
                itemCount: (_q["options"] as List<String>).length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final opt = (_q["options"] as List<String>)[i];
                  return _optionTile(context, opt, i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}