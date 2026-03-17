import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardEntry {
  LeaderboardEntry({
    required this.name,
    required this.score,
    required this.stars,
    required this.millis,
    required this.timestampMillis,
  });

  final String name;
  final int score;
  final int stars;
  final int millis;
  final int timestampMillis;

  Map<String, Object> toJson() => {
        'name': name,
        'score': score,
        'stars': stars,
        'millis': millis,
        'ts': timestampMillis,
      };

  static LeaderboardEntry fromJson(Map<String, Object?> json) {
    return LeaderboardEntry(
      name: (json['name'] as String?) ?? 'Jugador',
      score: (json['score'] as int?) ?? 0,
      stars: (json['stars'] as int?) ?? 0,
      millis: (json['millis'] as int?) ?? 0,
      timestampMillis: (json['ts'] as int?) ?? 0,
    );
  }
}

/// Ranking local (sin internet). Guarda TOP 10 en SharedPreferences.
class LocalLeaderboardService {
  static const _key = 'networkMasterLeaderboardV1';

  Future<List<LeaderboardEntry>> getTop() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? <String>[];
    return raw.map((s) => _decode(s)).toList();
  }

  Future<void> submit(LeaderboardEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getTop();
    current.add(entry);

    // Orden: mayor score, luego más estrellas, luego menor tiempo
    current.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      final byStars = b.stars.compareTo(a.stars);
      if (byStars != 0) return byStars;
      return a.millis.compareTo(b.millis);
    });

    final top = current.take(10).toList();
    final encoded = top.map(_encode).toList();
    await prefs.setStringList(_key, encoded);
  }

  String _encode(LeaderboardEntry e) => [
        e.name,
        e.score.toString(),
        e.stars.toString(),
        e.millis.toString(),
        e.timestampMillis.toString(),
      ].join('|');

  LeaderboardEntry _decode(String s) {
    final parts = s.split('|');
    if (parts.length < 5) {
      return LeaderboardEntry(
        name: 'Jugador',
        score: 0,
        stars: 0,
        millis: 0,
        timestampMillis: 0,
      );
    }
    return LeaderboardEntry(
      name: parts[0],
      score: int.tryParse(parts[1]) ?? 0,
      stars: int.tryParse(parts[2]) ?? 0,
      millis: int.tryParse(parts[3]) ?? 0,
      timestampMillis: int.tryParse(parts[4]) ?? 0,
    );
  }
}
