import 'package:flutter/material.dart';

class HudBar extends StatelessWidget {
  const HudBar({
    super.key,
    required this.lives,
    required this.score,
    required this.stars,
    required this.timeText,
  });

  final int lives;
  final int score;
  final int stars;
  final String? timeText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip(context, Icons.favorite_rounded, '$lives'),
        const SizedBox(width: 8),
        _chip(context, Icons.emoji_events_rounded, '$score'),
        const SizedBox(width: 8),
        _stars(context),
        const Spacer(),
        if (timeText != null) _chip(context, Icons.timer_rounded, timeText!),
      ],
    );
  }

  Widget _chip(BuildContext context, IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }

  Widget _stars(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (i) => Icon(
            i < stars ? Icons.star_rounded : Icons.star_border_rounded,
            size: 18,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
