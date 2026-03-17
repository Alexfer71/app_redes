import '../models/result.dart';

AttemptResult computeResult({
  required bool success,
  required List<String> errors,
  required int levelId,
  required int attemptsUsed,
  required int secondsRemaining,
  required bool wifiSecure,
  required bool serverWiredOk,
}) {
  if (!success) {
    return AttemptResult(
      isSuccess: false,
      errors: errors,
      scoreDelta: 0,
      stars: 0,
    );
  }

  // Estrellas: 3 categorías (Eficiencia, Seguridad, Estabilidad)
  var stars = 0;

  // Eficiencia
  if (attemptsUsed <= 1) {
    stars++;
  }

  // Seguridad
  if (wifiSecure) {
    stars++;
  }

  // Estabilidad
  if (serverWiredOk) {
    stars++;
  }

  // Score
  var score = 100 * levelId;
  score += stars * 50;
  if (secondsRemaining > 0) {
    score += (secondsRemaining ~/ 3);
  }

  return AttemptResult(
    isSuccess: true,
    errors: const [],
    scoreDelta: score,
    stars: stars.clamp(0, 3),
  );
}
