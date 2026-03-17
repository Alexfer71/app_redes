class AttemptResult {
  const AttemptResult({
    required this.isSuccess,
    required this.errors,
    required this.scoreDelta,
    required this.stars,
  });

  final bool isSuccess;
  final List<String> errors;
  final int scoreDelta;

  /// 0..3
  final int stars;
}
