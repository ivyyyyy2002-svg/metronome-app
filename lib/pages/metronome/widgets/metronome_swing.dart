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
          final weightColor = isRunning
              ? scheme.primary
              : scheme.primary.withValues(alpha: 0.72);

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _SwingGuidePainter(
                    color: scheme.onSurface.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: 26,
                child: Transform.rotate(
                  angle: angle,
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 72,
                    height: 166,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          bottom: 8,
                          child: Container(
                            width: 4,
                            height: 140,
                            decoration: BoxDecoration(
                              color: scheme.onSurface.withValues(alpha: 0.64),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            width: 34,
                            height: 50,
                            decoration: BoxDecoration(
                              color: weightColor,
                              borderRadius: BorderRadius.circular(17),
                              boxShadow: [
                                BoxShadow(
                                  color: scheme.primary.withValues(alpha: 0.18),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 18,
                child: Container(
                  width: 158,
                  height: 14,
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.76),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SwingGuidePainter extends CustomPainter {
  const _SwingGuidePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final center = Offset(size.width / 2, size.height - 30);
    final guide = Rect.fromCircle(center: center, radius: 140);

    canvas.drawArc(guide, -math.pi / 2 - 0.38, 0.76, false, paint);
  }

  @override
  bool shouldRepaint(covariant _SwingGuidePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
