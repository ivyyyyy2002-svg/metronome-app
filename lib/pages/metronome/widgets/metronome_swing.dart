import 'dart:math' as math;

import 'package:flutter/material.dart';

// Widget that visually represents the swinging pendulum of a metronome
class MetronomeSwing extends StatelessWidget {
  const MetronomeSwing({
    super.key,
    required this.anim,
    required this.isRunning,
    this.amplitudeDeg = 18,
  });

  final Animation<double> anim;
  final double amplitudeDeg;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 220,
      child: AnimatedBuilder(
        animation: anim,
        builder: (context, _) {
          final scheme = Theme.of(context).colorScheme;
          final angle = (amplitudeDeg * math.pi / 180.0) * anim.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 16,
                child: Container(
                  width: 188,
                  height: 28,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Transform.rotate(
                angle: angle,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 128,
                      decoration: BoxDecoration(
                        color: scheme.onSurface,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isRunning
                            ? scheme.primary
                            : scheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(color: scheme.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.shadow.withValues(alpha: 0.12),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
