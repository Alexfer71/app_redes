import 'package:flutter/material.dart';
import '../../data/questions.dart';
import '../../widgets/app_background.dart';

class MatchDragScreen extends StatefulWidget {
  const MatchDragScreen({super.key});

  @override
  State<MatchDragScreen> createState() => _MatchDragScreenState();
}

class _MatchDragScreenState extends State<MatchDragScreen> {
  int done = 0;

  void _goHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final finished = done >= matchConcepts.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(finished ? "Emparejado" : "Arrastra y Empareja"),
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
        padding: const EdgeInsets.all(20),
        child: finished
            ? Center(
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.88),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Text(
                      "¡Excelente! ✅",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              )
            : _content(context),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final pair = matchConcepts[done].entries.first;

    return Column(
      children: [
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.88),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: const [
                Icon(Icons.touch_app_rounded, size: 34),
                SizedBox(height: 10),
                Text(
                  "Arrastra el concepto al cuadro correcto",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Draggable<String>(
          data: pair.key,
          feedback: Material(
            color: Colors.transparent,
            child: _chip(pair.key, elevated: true),
          ),
          childWhenDragging: Opacity(opacity: 0.35, child: _chip(pair.key)),
          child: _chip(pair.key),
        ),
        const SizedBox(height: 30),
        DragTarget<String>(
          onAccept: (value) {
            if (value == pair.key) {
              setState(() => done++);
            }
          },
          builder: (context, _, __) {
            return Container(
              height: 90,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                color: Colors.white.withOpacity(0.70),
              ),
              child: Text(
                pair.value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            );
          },
        ),
        const Spacer(),
        Text(
          "Progreso: ${done + 1}/${matchConcepts.length}",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _chip(String text, {bool elevated = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}
