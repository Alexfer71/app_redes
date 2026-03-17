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
      // Copia profunda para poder mezclar opciones sin tocar el original.
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
    final subtitle = "$reason\n\nPuntaje: $score\nRécord: $bestQuiz\nNivel: $level  |  XP: $xp";

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
              onPressed: () async {
                await _player?.stop();
                Navigator.pop(context); // dialog
                Navigator.pop(this.context); // vuelve al menú
              },
              child: const Text("Menú"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // dialog
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

  Widget _chip(BuildContext context, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile(BuildContext context, String text) {
    final disabled = _locked;
    return AnimatedOpacity(
      opacity: disabled ? 0.55 : 1,
      duration: const Duration(milliseconds: 160),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: disabled ? null : () => _choose(text),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.90),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.black.withOpacity(0.35)),
            ],
          ),
        ),
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
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Barra de progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.black12,
              ),
            ),
            const SizedBox(height: 14),

            // Stats
            Row(
              children: [
                Expanded(child: _chip(context, "$timeLeft s", Icons.timer_rounded)),
                const SizedBox(width: 10),
                Expanded(child: _chip(context, "$lives", Icons.favorite_rounded)),
                const SizedBox(width: 10),
                Expanded(child: _chip(context, "$score", Icons.star_rounded)),
              ],
            ),
            const SizedBox(height: 16),

            // Pregunta
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Card(
                key: ValueKey(index),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.black12),
                    color: Colors.white.withOpacity(0.88),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _q["title"] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _q["text"] as String,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _q["explanation"] as String,
                        textAlign: TextAlign.center,
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

            const SizedBox(height: 14),

            // Opciones
            Expanded(
              child: ListView.separated(
                itemCount: (_q["options"] as List<String>).length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final opt = (_q["options"] as List<String>)[i];
                  return _optionTile(context, opt);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
