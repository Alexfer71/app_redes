import 'package:shared_preferences/shared_preferences.dart';

int xp = 0;
int level = 1;

int bestQuiz = 0;
int bestMatch = 0;
int bestNetworkMaster = 0;

/// Carga el progreso guardado (XP, nivel y récords).
Future<void> loadProgress() async {
  final prefs = await SharedPreferences.getInstance();
  xp = prefs.getInt('xp') ?? 0;
  level = prefs.getInt('level') ?? 1;
  bestQuiz = prefs.getInt('bestQuiz') ?? 0;
  bestMatch = prefs.getInt('bestMatch') ?? 0;
  bestNetworkMaster = prefs.getInt('bestNetworkMaster') ?? 0;
}

/// Guarda el progreso actual.
Future<void> saveProgress() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('xp', xp);
  await prefs.setInt('level', level);
  await prefs.setInt('bestQuiz', bestQuiz);
  await prefs.setInt('bestMatch', bestMatch);
  await prefs.setInt('bestNetworkMaster', bestNetworkMaster);
}

void addXP(int value) {
  xp += value;

  // Subida de nivel con "carry" (no pierde el sobrante)
  while (xp >= level * 100) {
    xp -= level * 100;
    level++;
  }

  // fire-and-forget
  saveProgress();
}

void saveBestQuiz(int score) {
  if (score > bestQuiz) {
    bestQuiz = score;
    saveProgress();
  }
}

void saveBestMatch(int score) {
  if (score > bestMatch) {
    bestMatch = score;
    saveProgress();
  }
}

void saveBestNetworkMaster(int score) {
  if (score > bestNetworkMaster) {
    bestNetworkMaster = score;
    saveProgress();
  }
}
