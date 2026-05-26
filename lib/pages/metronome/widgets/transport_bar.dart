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
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: isRunning ? null : onStart,
              icon: const Icon(Icons.play_arrow),
              label: Text(startLabel),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: isRunning ? onStop : null,
              icon: const Icon(Icons.stop),
              label: Text(stopLabel),
            ),
            const SizedBox(width: 10),
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: Text(resetLabel),
            ),
          ],
        ),
      ),
    );
  }
}
