import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum CoachMarkTutorialResult { completed, skipped }

/// Lets app widgets report user actions (slider dragged, tab tapped, start
/// pressed...) to a running tutorial. Pages keep one long-lived instance and
/// call [notify] from their normal handlers; when no tutorial is listening
/// the call is a no-op.
class CoachMarkActionNotifier {
  void Function(String actionId)? _listener;

  void notify(String actionId) => _listener?.call(actionId);
}

class CoachMarkStep {
  const CoachMarkStep({
    required this.targetKey,
    required this.title,
    required this.body,
    required this.icon,
    this.example,
    this.actionId,
    this.actionHint,
    this.onEnter,
  });

  final GlobalKey targetKey;
  final String title;
  final String body;
  final IconData icon;

  /// Optional short example rendered in a tinted box under the body.
  final String? example;

  /// Called when the step becomes current, before the target is framed.
  /// Use it to put the app in the right state (e.g. switch to the tab that
  /// hosts the target), which also keeps skipped interactive steps safe.
  final Future<void> Function()? onEnter;

  /// When set, the step is interactive: the highlighted area stays tappable
  /// and the tutorial advances once the app reports this action id.
  final String? actionId;

  /// Instruction shown for interactive steps ("Try it: drag the slider...").
  final String? actionHint;

  bool get isInteractive => actionId != null;
}

Future<CoachMarkTutorialResult> showCoachMarkTutorial({
  required BuildContext context,
  required List<CoachMarkStep> steps,
  required String nextLabel,
  required String doneLabel,
  required String skipLabel,
  required String tryItLabel,
  String? skipStepLabel,
  required String wellDoneLabel,
  required String Function(int current, int total) stepCountLabel,
  CoachMarkActionNotifier? actions,
}) async {
  final overlay = Overlay.of(context, rootOverlay: true);
  final completer = Completer<CoachMarkTutorialResult>();
  late OverlayEntry entry;

  void finish(CoachMarkTutorialResult result) {
    if (completer.isCompleted) return;
    entry.remove();
    completer.complete(result);
  }

  entry = OverlayEntry(
    builder: (context) {
      return _CoachMarkFlow(
        steps: steps,
        nextLabel: nextLabel,
        doneLabel: doneLabel,
        skipLabel: skipLabel,
        tryItLabel: tryItLabel,
        wellDoneLabel: wellDoneLabel,
        stepCountLabel: stepCountLabel,
        actions: actions,
        onFinish: finish,
      );
    },
  );

  overlay.insert(entry);
  return completer.future;
}

class _CoachMarkFlow extends StatefulWidget {
  const _CoachMarkFlow({
    required this.steps,
    required this.nextLabel,
    required this.doneLabel,
    required this.skipLabel,
    required this.tryItLabel,
    required this.wellDoneLabel,
    required this.stepCountLabel,
    required this.actions,
    required this.onFinish,
  });

  final List<CoachMarkStep> steps;
  final String nextLabel;
  final String doneLabel;
  final String skipLabel;
  final String tryItLabel;
  final String wellDoneLabel;
  final String Function(int current, int total) stepCountLabel;
  final CoachMarkActionNotifier? actions;
  final void Function(CoachMarkTutorialResult result) onFinish;

  @override
  State<_CoachMarkFlow> createState() => _CoachMarkFlowState();
}

class _CoachMarkFlowState extends State<_CoachMarkFlow>
    with SingleTickerProviderStateMixin {
  static const double _highlightPadding = 6;
  static const double _screenMargin = 12;
  static const double _arrowGap = 40;

  late final Ticker _ticker;
  Timer? _advanceTimer;
  int _stepIndex = 0;
  bool _actionSatisfied = false;
  Rect? _targetRect;
  int _alignRequestId = 0;

  CoachMarkStep get _step => widget.steps[_stepIndex];

  @override
  void initState() {
    super.initState();
    widget.actions?._listener = _handleAction;
    // Track the target every frame so the highlight never drifts when the
    // page scrolls, animates, or reflows underneath the tutorial.
    _ticker = createTicker((_) => _refreshTargetRect())..start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_enterStep());
    });
  }

  Future<void> _enterStep() async {
    final step = _step;
    await step.onEnter?.call();
    if (!mounted) return;
    await _alignToTarget();
  }

  @override
  void dispose() {
    if (widget.actions?._listener == _handleAction) {
      widget.actions!._listener = null;
    }
    _advanceTimer?.cancel();
    _ticker.dispose();
    super.dispose();
  }

  Rect? _computeTargetRect() {
    final targetContext = _step.targetKey.currentContext;
    final renderObject = targetContext?.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return null;
    }

    final origin = renderObject.localToGlobal(Offset.zero);
    final rawRect = (origin & renderObject.size).inflate(_highlightPadding);
    final screen = Offset.zero & MediaQuery.sizeOf(context);
    final visible = rawRect.intersect(screen.deflate(_screenMargin));
    if (visible.width <= 0 || visible.height <= 0) return null;
    return visible;
  }

  void _refreshTargetRect() {
    if (!mounted) return;
    final nextRect = _computeTargetRect();
    if (_rectsDiffer(nextRect, _targetRect)) {
      setState(() {
        _targetRect = nextRect;
      });
    }
  }

  bool _rectsDiffer(Rect? a, Rect? b) {
    if (a == null || b == null) return a != b;
    return (a.left - b.left).abs() > 0.5 ||
        (a.top - b.top).abs() > 0.5 ||
        (a.right - b.right).abs() > 0.5 ||
        (a.bottom - b.bottom).abs() > 0.5;
  }

  // Scroll the current target into a comfortable position before
  // highlighting it, so off-screen targets are never framed wrongly.
  Future<void> _alignToTarget() async {
    final requestId = ++_alignRequestId;
    // Give the page a frame to settle (e.g. right after a tab switch).
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || requestId != _alignRequestId) return;

    final targetContext = _step.targetKey.currentContext;
    if (targetContext == null || !targetContext.mounted) return;
    await Scrollable.ensureVisible(
      targetContext,
      alignment: 0.35,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
    if (mounted) _refreshTargetRect();
  }

  void _handleAction(String actionId) {
    if (!mounted || _actionSatisfied) return;
    if (!_step.isInteractive || actionId != _step.actionId) return;

    setState(() {
      _actionSatisfied = true;
    });
    _advanceTimer?.cancel();
    _advanceTimer = Timer(const Duration(milliseconds: 850), () {
      if (mounted) _next();
    });
  }

  void _goToStep(int index) {
    _advanceTimer?.cancel();
    setState(() {
      _stepIndex = index;
      _actionSatisfied = false;
      _targetRect = _computeTargetRect();
    });
    unawaited(_enterStep());
  }

  void _next() {
    if (_stepIndex < widget.steps.length - 1) {
      _goToStep(_stepIndex + 1);
      return;
    }
    widget.onFinish(CoachMarkTutorialResult.completed);
  }

  void _skipAll() {
    widget.onFinish(CoachMarkTutorialResult.skipped);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mediaSize = MediaQuery.sizeOf(context);
    final step = _step;
    final holeRect =
        _targetRect ??
        Rect.fromCenter(
          center: mediaSize.center(Offset.zero),
          width: mediaSize.width * 0.72,
          height: 96,
        );
    final allowTargetTaps = step.isInteractive && !_actionSatisfied;
    final isLastStep = _stepIndex == widget.steps.length - 1;

    // Card geometry: measured via layout delegate; the below/above choice is
    // shared between the delegate and the arrow rendering.
    final cardWidth = math.min(380.0, mediaSize.width - 32);
    final spaceBelow = mediaSize.height - holeRect.bottom;
    final spaceAbove = holeRect.top;
    final placeBelow = spaceBelow >= spaceAbove;
    final cardLeft = (holeRect.center.dx - cardWidth / 2)
        .clamp(16.0, math.max(16.0, mediaSize.width - cardWidth - 16.0))
        .toDouble();
    final arrowInset = (holeRect.center.dx - cardLeft - 17)
        .clamp(10.0, cardWidth - 44.0)
        .toDouble();

    // MaterialType.transparency keeps this layer hit-test transparent, so
    // the cut-out over the target lets real taps through to the app.
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Dimmed scrim with a cut-out over the target (paint only).
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _CoachMarkScrimPainter(holeRect)),
            ),
          ),
          // Tap barrier: four panels around the hole. For interactive steps
          // the hole stays open so the user can actually use the control;
          // for info steps a fifth panel closes the hole too.
          ..._buildBarrier(mediaSize, holeRect, allowTargetTaps),
          // Highlight ring.
          Positioned.fromRect(
            rect: holeRect,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _actionSatisfied && step.isInteractive
                        ? const Color(0xFF7BE495)
                        : Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_actionSatisfied && step.isInteractive
                                  ? const Color(0xFF7BE495)
                                  : Colors.white)
                              .withValues(alpha: 0.35),
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Explanation card, positioned by measured size.
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: CustomSingleChildLayout(
                delegate: _CoachMarkCardLayoutDelegate(
                  holeRect: holeRect,
                  placeBelow: placeBelow,
                  cardWidth: cardWidth,
                  cardLeft: cardLeft,
                  arrowGap: _arrowGap,
                ),
                child: SizedBox(
                  width: cardWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (placeBelow)
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: arrowInset,
                          ),
                          child: const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      _buildCard(context, scheme, textTheme, step, isLastStep),
                      if (!placeBelow)
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: arrowInset,
                          ),
                          child: const Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBarrier(Size mediaSize, Rect holeRect, bool keepHoleOpen) {
    Widget blocker({
      double? left,
      double? top,
      double? right,
      double? bottom,
      double? width,
      double? height,
    }) {
      return Positioned(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: const SizedBox.expand(),
        ),
      );
    }

    if (!keepHoleOpen) {
      return [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: const SizedBox.expand(),
          ),
        ),
      ];
    }

    return [
      if (holeRect.top > 0)
        blocker(left: 0, top: 0, right: 0, height: holeRect.top),
      if (holeRect.bottom < mediaSize.height)
        blocker(left: 0, top: holeRect.bottom, right: 0, bottom: 0),
      if (holeRect.left > 0)
        blocker(
          left: 0,
          top: holeRect.top,
          width: holeRect.left,
          height: holeRect.height,
        ),
      if (holeRect.right < mediaSize.width)
        blocker(
          left: holeRect.right,
          top: holeRect.top,
          right: 0,
          height: holeRect.height,
        ),
    ];
  }

  Widget _buildCard(
    BuildContext context,
    ColorScheme scheme,
    TextTheme textTheme,
    CoachMarkStep step,
    bool isLastStep,
  ) {
    final mediaSize = MediaQuery.sizeOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(step.icon, color: scheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    step.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _skipAll,
                  tooltip: widget.skipLabel,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: mediaSize.height * 0.38),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.body,
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    if (step.example != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer.withValues(
                            alpha: 0.45,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: scheme.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          step.example!,
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    if (step.isInteractive) ...[
                      const SizedBox(height: 10),
                      _buildTryItRow(scheme, textTheme, step),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // OverflowBar wraps to two lines when labels are long, so this
            // footer can never overflow like a plain Row would.
            OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              overflowAlignment: OverflowBarAlignment.end,
              overflowSpacing: 2,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.stepCountLabel(
                        _stepIndex + 1,
                        widget.steps.length,
                      ),
                      style: textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: _skipAll,
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: scheme.onSurfaceVariant,
                      ),
                      child: Text(widget.skipLabel),
                    ),
                  ],
                ),
                if (!step.isInteractive)
                  FilledButton(
                    onPressed: _next,
                    child: Text(
                      isLastStep ? widget.doneLabel : widget.nextLabel,
                    ),
                  )
                else if (_actionSatisfied)
                  FilledButton.icon(
                    onPressed: _next,
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: Text(widget.wellDoneLabel),
                  )
                else
                  TextButton(
                    onPressed: _next,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(widget.nextLabel),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTryItRow(
    ColorScheme scheme,
    TextTheme textTheme,
    CoachMarkStep step,
  ) {
    final satisfied = _actionSatisfied;
    final color = satisfied ? const Color(0xFF2E7D32) : scheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            satisfied ? Icons.check_circle_rounded : Icons.touch_app_rounded,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              satisfied
                  ? widget.wellDoneLabel
                  : '${widget.tryItLabel} ${step.actionHint ?? ''}'.trim(),
              style: textTheme.bodySmall?.copyWith(
                color: satisfied ? color : scheme.onSurface,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Positions the explanation card (with its arrow) near the hole using the
// card's measured size, instead of guessing with fixed offsets.
class _CoachMarkCardLayoutDelegate extends SingleChildLayoutDelegate {
  const _CoachMarkCardLayoutDelegate({
    required this.holeRect,
    required this.placeBelow,
    required this.cardWidth,
    required this.cardLeft,
    required this.arrowGap,
  });

  final Rect holeRect;
  final bool placeBelow;
  final double cardWidth;
  final double cardLeft;
  final double arrowGap;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      maxWidth: cardWidth,
      maxHeight: math.max(0.0, constraints.maxHeight - 24),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double top;
    if (placeBelow) {
      top = holeRect.bottom + 8;
      top = math.min(top, size.height - childSize.height - 12);
    } else {
      top = holeRect.top - 8 - childSize.height;
      top = math.max(12.0, top);
    }
    return Offset(cardLeft, top);
  }

  @override
  bool shouldRelayout(_CoachMarkCardLayoutDelegate oldDelegate) {
    return holeRect != oldDelegate.holeRect ||
        placeBelow != oldDelegate.placeBelow ||
        cardWidth != oldDelegate.cardWidth ||
        cardLeft != oldDelegate.cardLeft;
  }
}

class _CoachMarkScrimPainter extends CustomPainter {
  const _CoachMarkScrimPainter(this.targetRect);

  final Rect targetRect;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(
        RRect.fromRectAndRadius(targetRect, const Radius.circular(18)),
      );
    canvas.drawPath(
      overlayPath,
      Paint()..color = Colors.black.withValues(alpha: 0.72),
    );
  }

  @override
  bool shouldRepaint(_CoachMarkScrimPainter oldDelegate) =>
      oldDelegate.targetRect != targetRect;
}
