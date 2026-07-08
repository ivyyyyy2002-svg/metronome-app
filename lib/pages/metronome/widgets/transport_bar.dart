import 'package:flutter/material.dart';

// Widget that provides transport controls (start, stop, reset) for the metronome
class TransportBar extends StatelessWidget {
  const TransportBar({
    super.key,
    required this.isRunning,
    required this.onStart,
    required this.onStop,
    required this.onReset,
    required this.startLabel,
    required this.stopLabel,
    required this.resetLabel,
  });

  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onReset;
  final String startLabel;
  final String stopLabel;
  final String resetLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              tooltip: resetLabel,
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded),
              style: IconButton.styleFrom(
                minimumSize: const Size(52, 52),
                side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
              ),
            ),
            const SizedBox(width: 14),
            // Primary action: a large pill-shaped start button.
            FilledButton.icon(
              onPressed: isRunning ? null : onStart,
              style: FilledButton.styleFrom(
                minimumSize: const Size(150, 54),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 26),
              label: Text(startLabel),
            ),
            const SizedBox(width: 14),
            IconButton.filledTonal(
              tooltip: stopLabel,
              onPressed: isRunning ? onStop : null,
              icon: const Icon(Icons.stop_rounded),
              style: IconButton.styleFrom(
                minimumSize: const Size(52, 52),
                foregroundColor: scheme.error,
                side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
