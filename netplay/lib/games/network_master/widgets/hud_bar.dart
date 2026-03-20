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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.88),
        border: Border.all(color: const Color(0x140F172A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _chip(
            context,
            icon: Icons.favorite_rounded,
            label: 'Vidas',
            value: '$lives',
            tint: const Color(0xFFEF4444),
          ),
          const SizedBox(width: 10),
          _chip(
            context,
            icon: Icons.emoji_events_rounded,
            label: 'Puntos',
            value: '$score',
            tint: const Color(0xFFF59E0B),
          ),
          const SizedBox(width: 10),
          _stars(context),
          const Spacer(),
          if (timeText != null)
            _chip(
              context,
              icon: Icons.timer_rounded,
              label: 'Tiempo',
              value: timeText!,
              tint: const Color(0xFF06B6D4),
            ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color tint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: tint.withOpacity(0.10),
        border: Border.all(color: tint.withOpacity(0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: tint),
          ),
          const SizedBox(width: 8),
          Column(
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
        ],
      ),
    );
  }

  Widget _stars(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFFFFBEB),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Estrellas',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF92400E),
                ),
          ),
          const SizedBox(width: 8),
          ...List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(
                i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                size: 18,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}