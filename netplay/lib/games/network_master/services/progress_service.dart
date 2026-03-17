import 'package:shared_preferences/shared_preferences.dart';

class NetworkProgressService {
  static const _kUnlockedLevel = 'nm_unlocked_level';

  static Future<int> getUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kUnlockedLevel) ?? 1;
  }

  static Future<void> setUnlockedLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kUnlockedLevel, level);
  }

  static Future<void> unlockNext(int currentLevel) async {
    final unlocked = await getUnlockedLevel();
    final next = currentLevel + 1;
    if (next > unlocked) {
      await setUnlockedLevel(next);
    }
  }

  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kUnlockedLevel, 1);
  }
}
