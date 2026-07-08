import 'dart:ui';

import 'package:flutter/material.dart';

/// Shared "glassmorphism" design language for the app.
///
/// Provides:
/// * [GlassCard] — a frosted, translucent card with a luminous border,
///   used for all top-level content cards.
/// * [glassInnerDecoration] — a lighter translucent decoration for tiles
///   nested inside a [GlassCard] (no blur, cheap to render).
/// * [GlassBackground] — a page background with a soft multi-stop gradient
///   and blurred color "blobs" that give the frosted panels something to
///   refract.

/// A frosted glass card with backdrop blur, translucent gradient fill,
/// a luminous hairline border and a soft ambient shadow.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 22,
    this.blur = true,
    this.clipBehavior,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  /// Backdrop blur is the expensive part of the effect; disable it for
  /// long lists if needed — the translucent fill still reads as glass.
  final bool blur;

  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(borderRadius);

    Widget content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.10),
                  Colors.white.withValues(alpha: 0.04),
                ]
              : [
                  Colors.white.withValues(alpha: 0.80),
                  Colors.white.withValues(alpha: 0.55),
                ],
        ),
        borderRadius: radius,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.90),
        ),
      ),
      child: child,
    );

    content = ClipRRect(
      borderRadius: radius,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: blur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: content,
            )
          : content,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.07),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: content,
    );
  }
}

/// Decoration for tiles nested inside a [GlassCard]: a lighter translucent
/// fill with a hairline border. No blur, so it is cheap to use in lists.
BoxDecoration glassInnerDecoration(
  BuildContext context, {
  double borderRadius = 16,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final scheme = Theme.of(context).colorScheme;

  return BoxDecoration(
    // A slightly darkened tint (instead of more white) so nested tiles stay
    // clearly visible against the white-ish glass card behind them.
    color: isDark
        ? Colors.white.withValues(alpha: 0.07)
        : scheme.onSurface.withValues(alpha: 0.04),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isDark
          ? Colors.white.withValues(alpha: 0.15)
          : scheme.outlineVariant.withValues(alpha: 0.8),
    ),
  );
}

/// A page background made of a soft diagonal gradient tinted by the current
/// color scheme, plus large blurred color blobs. Place page content in
/// [child]; frosted panels above it pick up the colors through their blur.
class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child, this.tint});

  final Widget child;

  /// Strength of the gradient tint. Defaults to a subtle value tuned per
  /// brightness; pass a custom value to intensify or soften the wash.
  final double? tint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final defaultTint = isDark ? 0.18 : 0.12;
    final gradientTint = tint ?? defaultTint;
    // Scale the color blobs along with the tint so a near-zero tint gives a
    // genuinely near-plain background instead of tinted blobs on white.
    final tintRatio = (gradientTint / defaultTint).clamp(0.0, 1.5);

    final gradientColors = [
      Color.alphaBlend(
        scheme.primary.withValues(alpha: gradientTint),
        backgroundColor,
      ),
      Color.alphaBlend(
        scheme.secondary.withValues(alpha: gradientTint * 0.85),
        backgroundColor,
      ),
      Color.alphaBlend(
        scheme.tertiary.withValues(alpha: gradientTint * 0.75),
        backgroundColor,
      ),
    ];

    final blobAlpha = (isDark ? 0.26 : 0.20) * tintRatio;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
        ),
        Positioned(
          top: -140,
          left: -100,
          child: _GlassBlob(color: scheme.primary, size: 340, alpha: blobAlpha),
        ),
        Positioned(
          top: 160,
          right: -120,
          child: _GlassBlob(
            color: scheme.tertiary,
            size: 300,
            alpha: blobAlpha * 0.9,
          ),
        ),
        Positioned(
          bottom: -120,
          left: 20,
          child: _GlassBlob(
            color: scheme.secondary,
            size: 320,
            alpha: blobAlpha * 0.8,
          ),
        ),
        child,
      ],
    );
  }
}

class _GlassBlob extends StatelessWidget {
  const _GlassBlob({
    required this.color,
    required this.size,
    required this.alpha,
  });

  final Color color;
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
