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
    required this.bpmLabel,
    required this.beatIndicators,
  });

  final Animation<double> anim;
  final bool isRunning;
  final int beatNumerator;
  final int beatDenominator;
  final int bpm;
  final String bpmLabel;
  final List<BeatIndicatorItem> beatIndicators;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MetronomeSwing(anim: anim, isRunning: isRunning, amplitudeDeg: 18),
        const SizedBox(height: 14),
        // Oversized BPM readout as the visual anchor of the page.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$bpm',
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -2.5,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              bpmLabel.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '$beatNumerator/$beatDenominator',
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: beatIndicators
                .map((indicator) {
                  return SizedBox(
                    width: 22,
                    height: 20,
                    child: Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          end: indicator.isActive ? 1.0 : 0.62,
                        ),
                        duration: const Duration(milliseconds: 140),
                        curve: Curves.easeOut,
                        builder: (context, scale, _) {
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: indicator.isActive
                                    ? indicator.activeColor
                                    : indicator.idleColor,
                                boxShadow: indicator.isActive
                                    ? [
                                        BoxShadow(
                                          color: indicator.activeColor
                                              .withValues(alpha: 0.55),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
