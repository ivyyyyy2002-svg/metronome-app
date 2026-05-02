import 'package:flutter/material.dart';

import 'metronome_swing.dart';

// Panel that displays the current time signature, BPM, and beat indicators
class BeatIndicatorItem {
  const BeatIndicatorItem({
    required this.isActive,
    required this.activeColor,
    required this.idleColor,
  });

  final bool isActive;
  final Color activeColor;
  final Color idleColor;
}

class PlaybackStatusPanel extends StatelessWidget {
  const PlaybackStatusPanel({
    super.key,
    required this.anim,
    required this.isRunning,
    required this.beatNumerator,
    required this.beatDenominator,
    required this.bpm,
    required this.beatIndicators,
  });

  final Animation<double> anim;
  final bool isRunning;
  final int beatNumerator;
  final int beatDenominator;
  final int bpm;
  final List<BeatIndicatorItem> beatIndicators;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MetronomeSwing(
          anim: anim,
          isRunning: isRunning,
          amplitudeDeg: 18,
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            Text(
              '$beatNumerator/$beatDenominator',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: beatIndicators.map((indicator) {
                  return SizedBox(
                    width: 18,
                    height: 16,
                    child: Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          end: indicator.isActive ? 1.0 : 0.66,
                        ),
                        duration: const Duration(milliseconds: 140),
                        curve: Curves.easeOut,
                        builder: (context, scale, child) {
                          return Transform.scale(scale: scale, child: child);
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: indicator.isActive
                                ? indicator.activeColor
                                : indicator.idleColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(growable: false),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$bpm',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 6),
                Text(
                  'BPM',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
