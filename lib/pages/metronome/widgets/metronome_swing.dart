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
    final scheme = Theme.of(context).colorScheme;
    final weightColor = isRunning
        ? scheme.primary
        : scheme.primary.withValues(alpha: 0.72);

    // The guide arc, base plate (with its blurred shadow) and pivot dot never
    // change during a swing, so they live OUTSIDE the AnimatedBuilder and are
    // rasterized once. Only the rotating arm below repaints each frame, which
    // avoids re-blurring the base-plate shadow 60 times a second.
    // A RepaintBoundary isolates the whole pendulum into its own layer so its
    // per-frame repaints never invalidate the surrounding page.
    return RepaintBoundary(
      child: SizedBox(
        height: 220,
        width: 220,
        child: Stack(
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
              child: AnimatedBuilder(
                animation: anim,
                builder: (context, _) {
                  final angle = (amplitudeDeg * math.pi / 180.0) * anim.value;
                  // Swing speed peaks as the pendulum sweeps through center
                  // (anim.value near 0); drive the pulsing glow from it.
                  final speedFactor = isRunning
                      ? (1.0 - anim.value.abs()).clamp(0.0, 1.0)
                      : 0.0;
                  return Transform.rotate(
                    angle: angle,
                    alignment: Alignment.bottomCenter,
                    child: _SwingArm(
                      weightColor: weightColor,
                      scheme: scheme,
                      speedFactor: speedFactor,
                    ),
                  );
                },
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
        ),
      ),
    );
  }
}

// The rotating arm (rod + weight). Built once per (weightColor, scheme) and
// reused as the AnimatedBuilder's cached child, so its blurred weight-glow is
// only re-rasterized when the pendulum actually moves — not rebuilt each frame.
class _SwingArm extends StatelessWidget {
  const _SwingArm({
    required this.weightColor,
    required this.scheme,
    required this.speedFactor,
  });

  final Color weightColor;
  final ColorScheme scheme;
  final double speedFactor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            child: Container(
              width: 34,
              height: 50,
              decoration: BoxDecoration(
                // Slight top highlight for a bit of depth.
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.alphaBlend(
                      Colors.white.withValues(alpha: 0.28),
                      weightColor,
                    ),
                    weightColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(17),
                // Glow pulses with swing speed (brightest through center).
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(
                      alpha: 0.18 + 0.28 * speedFactor,
                    ),
                    blurRadius: 12 + 10 * speedFactor,
                    spreadRadius: 2 * speedFactor,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
        ],
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
