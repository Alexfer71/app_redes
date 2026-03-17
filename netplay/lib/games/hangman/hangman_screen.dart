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
    } else {
      _resetGame();
    }
  }

  void _resetGame() {
    lives = 1;
    currentQuestionIndex = 0;
    _startGame();
  }

  bool _isGameWon() {
    for (var l in selectedWord.split("")) {
      if (!guessedLetters.contains(l)) return false;
    }
    return true;
  }

  bool _isGameLost() => wrongAttempts >= maxAttempts;

  Future<void> _playSound(String soundPath) async {
    await _audioPlayer.setSource(AssetSource(soundPath));
    _audioPlayer.play;
  }

  void _guessLetter(String letter) {
    if (guessedLetters.contains(letter)) return;

    setState(() {
      guessedLetters.add(letter);

      if (!selectedWord.contains(letter)) {
        wrongAttempts++;
        if (wrongAttempts == maxAttempts) {
          lives--;
        }
        _playSound('assets/incorrect.mp3');
        HapticFeedback.mediumImpact();
      } else {
        _playSound('assets/correct.mp3');
      }
    });

    if (_isGameWon()) {
      if (currentQuestionIndex < wordsAndClues.length - 1) {
        currentQuestionIndex++;
        _startGame();
      } else {
        _resetGame();
      }
    }

    if (lives == 0) {
      _resetGame();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLost = _isGameLost();
    final isWon = _isGameWon();

    if (isWon) {
      _playSound('assets/victory.mp3');
    }

    if (isLost) {
      _playSound('assets/game_over.mp3');
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF141E30), Color(0xFF243B55)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isLost ? 0.6 : 0,
            child: Container(color: Colors.black),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "AHORCADO",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  "Pista: $clue",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  "Pregunta: ${currentQuestionIndex + 1} de ${wordsAndClues.length}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: AlwaysStoppedAnimation(0),
                  builder: (context, child) {
                    double swing = isLost ? sin(2 * pi * 0.5) * 0.05 : 0;
                    double drop = isLost ? 10 : 0;
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
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: selectedWord.split("").map((letter) {
                    final visible = guessedLetters.contains(letter) || isLost;
                    return AnimatedScale(
                      scale: visible ? 1.2 : 1,
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        visible ? letter : "_",
                        style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                AnimatedScale(
                  scale: isLost || isWon ? 1.2 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    isWon
                        ? "¡GANASTE!"
                        : isLost
                            ? "GAME OVER"
                            : "",
                    style: TextStyle(
                        fontSize: 24,
                        color: isWon ? Colors.greenAccent : Colors.redAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 7,
                    children:
                        "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ".split("").map((letter) {
                      final used = guessedLetters.contains(letter);
                      return GestureDetector(
                        onTap:
                            isWon || isLost ? null : () => _guessLetter(letter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: used
                                ? (selectedWord.contains(letter)
                                    ? Colors.green
                                    : Colors.red)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(letter,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (isWon || isLost)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _startGame();
                      });
                    },
                    child: const Text("JUGAR DE NUEVO"),
                  ),
              ],
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
      ..style = PaintingStyle.stroke;

    final baseY = size.height - 10;

    if (wrongAttempts > 0) {
      canvas.drawLine(Offset(20, baseY), Offset(size.width - 20, baseY), paint);
    }

    if (wrongAttempts > 1) {
      canvas.drawLine(Offset(60, baseY), Offset(60, 20), paint);
    }

    if (wrongAttempts > 2) {
      canvas.drawLine(Offset(60, 20), Offset(160, 20), paint);
    }

    if (wrongAttempts > 3) {
      canvas.drawLine(Offset(160, 20), Offset(160, 50), paint);
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
      canvas.drawLine(Offset(160, 95), Offset(160, 145), paint);
    }

    if (wrongAttempts > 5) {
      canvas.drawLine(Offset(160, 110), Offset(130, 130), paint);
      canvas.drawLine(Offset(160, 110), Offset(190, 130), paint);
      canvas.drawLine(Offset(160, 145), Offset(140, 180), paint);
      canvas.drawLine(Offset(160, 145), Offset(180, 180), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
