import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class HangmanScreen extends StatefulWidget {
  const HangmanScreen({Key? key}) : super(key: key);

  @override
  State<HangmanScreen> createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final List<Map<String, String>> wordsAndClues = [
    {
      "word": "VIRUS",
      "clue":
          "Es un tipo de software malicioso que se propaga de un equipo a otro."
    },
    {
      "word": "HACKER",
      "clue": "Es una persona que accede a sistemas sin autorización."
    },
    {
      "word": "FIREWALL",
      "clue":
          "Es un sistema de seguridad que filtra el tráfico entre dos redes."
    },
    {
      "word": "CIBERSEGURIDAD",
      "clue":
          "Es el conjunto de prácticas para proteger sistemas de información."
    },
    {
      "word": "REDES",
      "clue":
          "Es un conjunto de dispositivos conectados entre sí para compartir recursos."
    },
    {
      "word": "ANTIVIRUS",
      "clue": "Es un software que se utiliza para detectar y eliminar virus."
    },
    {
      "word": "PHISHING",
      "clue":
          "Es un ataque en línea donde se engaña al usuario para robar su información."
    },
    {
      "word": "ENCRIPTACION",
      "clue":
          "Es el proceso de convertir datos en un formato no legible sin una clave."
    },
    {
      "word": "PRIVACIDAD",
      "clue":
          "Es el derecho de las personas a controlar la información sobre ellas mismas."
    },
    {
      "word": "CONTRASEÑA",
      "clue":
          "Es una combinación de caracteres utilizada para autenticar a un usuario."
    },
  ];

  late String selectedWord;
  late String clue;
  List<String> guessedLetters = [];
  int wrongAttempts = 0;
  final int maxAttempts = 6;
  int lives = 1;
  int currentQuestionIndex = 0;

  late AudioPlayer _audioPlayer;
  bool _playedWinSound = false;
  bool _playedLoseSound = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _startGame();
  }

  void _startGame() {
    if (lives > 0) {
      selectedWord = wordsAndClues[currentQuestionIndex]["word"]!;
      clue = wordsAndClues[currentQuestionIndex]["clue"]!;
      guessedLetters.clear();
      wrongAttempts = 0;
      _playedWinSound = false;
      _playedLoseSound = false;
      setState(() {});
    } else {
      _resetGame();
    }
  }

  void _resetGame() {
    lives = 1;
    currentQuestionIndex = 0;
    selectedWord = wordsAndClues[currentQuestionIndex]["word"]!;
    clue = wordsAndClues[currentQuestionIndex]["clue"]!;
    guessedLetters.clear();
    wrongAttempts = 0;
    _playedWinSound = false;
    _playedLoseSound = false;
    setState(() {});
  }

  bool _isGameWon() {
    for (var l in selectedWord.split("")) {
      if (!guessedLetters.contains(l)) return false;
    }
    return true;
  }

  bool _isGameLost() => wrongAttempts >= maxAttempts;

  Future<void> _playSound(String soundPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (_) {}
  }

  void _goHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _guessLetter(String letter) {
    if (guessedLetters.contains(letter)) return;
    if (_isGameWon() || _isGameLost()) return;

    setState(() {
      guessedLetters.add(letter);

      if (!selectedWord.contains(letter)) {
        wrongAttempts++;
        if (wrongAttempts == maxAttempts) {
          lives--;
        }
      }
    });

    if (!selectedWord.contains(letter)) {
      _playSound('incorrect.mp3');
      HapticFeedback.mediumImpact();
    } else {
      _playSound('correct.mp3');
      HapticFeedback.selectionClick();
    }

    final isWon = _isGameWon();
    final isLost = _isGameLost();

    if (isWon && !_playedWinSound) {
      _playedWinSound = true;
      _playSound('victory.mp3');
    }

    if (isLost && !_playedLoseSound) {
      _playedLoseSound = true;
      _playSound('game_over.mp3');
      HapticFeedback.heavyImpact();
    }
  }

  void _nextRound() {
    if (_isGameWon()) {
      if (currentQuestionIndex < wordsAndClues.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedWord = wordsAndClues[currentQuestionIndex]["word"]!;
          clue = wordsAndClues[currentQuestionIndex]["clue"]!;
          guessedLetters.clear();
          wrongAttempts = 0;
          _playedWinSound = false;
          _playedLoseSound = false;
        });
      } else {
        _resetGame();
      }
    } else if (_isGameLost()) {
      if (lives <= 0) {
        _resetGame();
      } else {
        _startGame();
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
            blurRadius: 24,
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
              Icons.psychology_rounded,
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
                  "Ahorcado",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Adivina la palabra antes de agotar todos los intentos.",
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

  Widget _hudChip({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color tint,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.90),
          borderRadius: BorderRadius.circular(22),
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
                          color: const Color(0xFF64748B),
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

  Widget _clueCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.92),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
              ),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pista",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  clue,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hangmanBoard(BuildContext context, bool isLost) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF111827),
            Color(0xFF1F2937),
          ],
        ),
        border: Border.all(color: Colors.white10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F172A),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Panel del desafío",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
          ),
          const SizedBox(height: 14),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white.withOpacity(0.04),
              border: Border.all(color: Colors.white10),
            ),
            child: AnimatedBuilder(
              animation: AlwaysStoppedAnimation(0),
              builder: (context, child) {
                final double swing = isLost ? sin(2 * pi * 0.5) * 0.05 : 0;
                final double drop = isLost ? 10 : 0;

                return Transform.translate(
                  offset: Offset(0, drop),
                  child: Transform.rotate(
                    angle: swing,
                    child: CustomPaint(
                      size: const Size(220, 220),
                      painter: HangmanPainter(wrongAttempts, isLost),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _wordBoard(BuildContext context, bool isLost) {
    final letters = selectedWord.split("");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white.withOpacity(0.92),
        border: Border.all(color: const Color(0x140F172A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 10,
        children: letters.map((letter) {
          final visible = guessedLetters.contains(letter) || isLost;

          return AnimatedScale(
            scale: visible ? 1.05 : 1,
            duration: const Duration(milliseconds: 220),
            child: Container(
              width: 42,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: visible
                    ? const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                      ),
                border: Border.all(
                  color: visible ? Colors.transparent : const Color(0x180F172A),
                ),
              ),
              child: Text(
                visible ? letter : "_",
                style: TextStyle(
                  fontSize: 24,
                  color: visible ? Colors.white : const Color(0xFF475569),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _statusBanner(BuildContext context, bool isWon, bool isLost) {
    if (!isWon && !isLost) return const SizedBox.shrink();

    final bool success = isWon;
    final List<Color> colors = success
        ? const [Color(0xFF22C55E), Color(0xFF16A34A)]
        : const [Color(0xFFEF4444), Color(0xFFDC2626)];

    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 250),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(colors: colors),
          boxShadow: const [
            BoxShadow(
              color: Color(0x220F172A),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              success ? Icons.emoji_events_rounded : Icons.warning_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              success ? "¡GANASTE!" : "GAME OVER",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _letterKey(
    BuildContext context,
    String letter,
    bool isWon,
    bool isLost,
  ) {
    final used = guessedLetters.contains(letter);
    final correct = selectedWord.contains(letter);

    Color bgColor;
    Color textColor;

    if (used) {
      bgColor = correct ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
      textColor = Colors.white;
    } else {
      bgColor = Colors.white;
      textColor = const Color(0xFF0F172A);
    }

    return GestureDetector(
      onTap: isWon || isLost ? null : () => _guessLetter(letter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: used ? Colors.transparent : const Color(0x140F172A),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(used ? 0.10 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _keyboard(BuildContext context, bool isWon, bool isLost) {
    final letters = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ".split("");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.10),
        border: Border.all(color: Colors.white10),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: letters
            .map((letter) => _letterKey(context, letter, isWon, isLost))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLost = _isGameLost();
    final isWon = _isGameWon();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        title: const Text(
          "Ahorcado",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: "Inicio",
            onPressed: _goHome,
            icon: const Icon(Icons.home_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B1220),
                  Color(0xFF172554),
                  Color(0xFF1E293B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x334F46E5), Color(0x004F46E5)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x2206B6D4), Color(0x0006B6D4)],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isLost ? 0.28 : 0,
            child: Container(color: Colors.black),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: Column(
                children: [
                  _topHero(context),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _hudChip(
                        context: context,
                        label: "Vidas",
                        value: "$lives",
                        icon: Icons.favorite_rounded,
                        tint: const Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 10),
                      _hudChip(
                        context: context,
                        label: "Errores",
                        value: "$wrongAttempts/$maxAttempts",
                        icon: Icons.close_rounded,
                        tint: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 10),
                      _hudChip(
                        context: context,
                        label: "Ronda",
                        value:
                            "${currentQuestionIndex + 1}/${wordsAndClues.length}",
                        icon: Icons.flag_rounded,
                        tint: const Color(0xFF4F46E5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _clueCard(context),
                  const SizedBox(height: 14),
                  _hangmanBoard(context, isLost),
                  const SizedBox(height: 14),
                  _wordBoard(context, isLost),
                  const SizedBox(height: 14),
                  _statusBanner(context, isWon, isLost),
                  if (isWon || isLost) const SizedBox(height: 14),
                  if (isWon || isLost)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _nextRound,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(
                            isWon ? "Siguiente palabra" : "Jugar de nuevo"),
                      ),
                    ),
                  const SizedBox(height: 12),
                  _keyboard(context, isWon, isLost),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HangmanPainter extends CustomPainter {
  final int wrongAttempts;
  final bool isLost;

  HangmanPainter(this.wrongAttempts, this.isLost);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0x664F46E5)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final baseY = size.height - 10;

    if (wrongAttempts > 0) {
      canvas.drawLine(
        Offset(20, baseY),
        Offset(size.width - 20, baseY),
        glowPaint,
      );
      canvas.drawLine(Offset(20, baseY), Offset(size.width - 20, baseY), paint);
    }

    if (wrongAttempts > 1) {
      canvas.drawLine(Offset(60, baseY), Offset(60, 20), glowPaint);
      canvas.drawLine(Offset(60, baseY), Offset(60, 20), paint);
    }

    if (wrongAttempts > 2) {
      canvas.drawLine(Offset(60, 20), Offset(160, 20), glowPaint);
      canvas.drawLine(Offset(60, 20), Offset(160, 20), paint);
    }

    if (wrongAttempts > 3) {
      canvas.drawLine(Offset(160, 20), Offset(160, 50), glowPaint);
      canvas.drawLine(Offset(160, 20), Offset(160, 50), paint);

      canvas.drawCircle(Offset(160, 75), 20, glowPaint);
      canvas.drawCircle(Offset(160, 75), 20, paint);

      if (isLost) {
        canvas.drawLine(Offset(150, 70), Offset(158, 78), paint);
        canvas.drawLine(Offset(158, 70), Offset(150, 78), paint);
        canvas.drawLine(Offset(162, 70), Offset(170, 78), paint);
        canvas.drawLine(Offset(170, 70), Offset(162, 78), paint);
      } else {
        canvas.drawCircle(Offset(153, 75), 2, paint);
        canvas.drawCircle(Offset(167, 75), 2, paint);
      }
    }

    if (wrongAttempts > 4) {
      canvas.drawLine(Offset(160, 95), Offset(160, 145), glowPaint);
      canvas.drawLine(Offset(160, 95), Offset(160, 145), paint);
    }

    if (wrongAttempts > 5) {
      canvas.drawLine(Offset(160, 110), Offset(130, 130), glowPaint);
      canvas.drawLine(Offset(160, 110), Offset(130, 130), paint);

      canvas.drawLine(Offset(160, 110), Offset(190, 130), glowPaint);
      canvas.drawLine(Offset(160, 110), Offset(190, 130), paint);

      canvas.drawLine(Offset(160, 145), Offset(140, 180), glowPaint);
      canvas.drawLine(Offset(160, 145), Offset(140, 180), paint);

      canvas.drawLine(Offset(160, 145), Offset(180, 180), glowPaint);
      canvas.drawLine(Offset(160, 145), Offset(180, 180), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
