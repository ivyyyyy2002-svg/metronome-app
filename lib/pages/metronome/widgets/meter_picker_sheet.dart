import 'package:flutter/material.dart';

// Modal bottom sheet that allows users to pick the time signature and beat unit for the metronome
Future<void> showMeterPickerSheet({
  required BuildContext context,
  required List<String> timeSignatureOptions,
  required List<String> beatUnitLabels,
  required int initialTimeSignatureIndex,
  required int initialBeatUnitIndex,
  required ValueChanged<(int, int)> onSelectionChanged,
}) async {
  final tsController = FixedExtentScrollController(
    initialItem: initialTimeSignatureIndex,
  );
  final unitController = FixedExtentScrollController(
    initialItem: initialBeatUnitIndex,
  );
  int tsIndex = initialTimeSignatureIndex;
  int unitIndex = initialBeatUnitIndex;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final scheme = Theme.of(context).colorScheme;
          final previewText =
              '${timeSignatureOptions[tsIndex]} · ${beatUnitLabels[unitIndex]}';

          Widget pickerLabel(String text) {
            return SizedBox(
              width: 136,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          void applySelection() {
            onSelectionChanged((tsIndex, unitIndex));
          }

          return Container(
            height: 336,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: const Text('Close'),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: scheme.surfaceContainerHighest,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.tune_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        previewText,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      pickerLabel('Time Signature'),
                      const SizedBox(width: 1),
                      pickerLabel('Beat Unit'),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 290,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: scheme.surfaceContainerLow,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 136,
                              child: ListWheelScrollView.useDelegate(
                                controller: tsController,
                                itemExtent: 36,
                                diameterRatio: 1.7,
                                perspective: 0.003,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  setModalState(() {
                                    tsIndex = index;
                                    applySelection();
                                  });
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: timeSignatureOptions.length,
                                  builder: (context, index) {
                                    if (index < 0 ||
                                        index >= timeSignatureOptions.length) {
                                      return null;
                                    }
                                    final selected = index == tsIndex;
                                    return Center(
                                      child: Text(
                                        timeSignatureOptions[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: selected
                                                  ? FontWeight.w700
                                                  : FontWeight.w400,
                                              color: selected
                                                  ? scheme.onSurface
                                                  : scheme.onSurfaceVariant,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 132,
                              color: scheme.outlineVariant.withValues(
                                alpha: 0.55,
                              ),
                            ),
                            SizedBox(
                              width: 136,
                              child: ListWheelScrollView.useDelegate(
                                controller: unitController,
                                itemExtent: 36,
                                diameterRatio: 1.7,
                                perspective: 0.003,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  setModalState(() {
                                    unitIndex = index;
                                    applySelection();
                                  });
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: beatUnitLabels.length,
                                  builder: (context, index) {
                                    if (index < 0 ||
                                        index >= beatUnitLabels.length) {
                                      return null;
                                    }
                                    final selected = index == unitIndex;
                                    return Center(
                                      child: Text(
                                        beatUnitLabels[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: selected
                                                  ? FontWeight.w700
                                                  : FontWeight.w400,
                                              color: selected
                                                  ? scheme.onSurface
                                                  : scheme.onSurfaceVariant,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        IgnorePointer(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 136,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: scheme.primary.withValues(alpha: 0.06),
                                  border: Border(
                                    top: BorderSide(
                                      color: scheme.primary.withValues(
                                        alpha: 0.28,
                                      ),
                                    ),
                                    bottom: BorderSide(
                                      color: scheme.primary.withValues(
                                        alpha: 0.28,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 36,
                                color: scheme.outlineVariant.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              Container(
                                width: 136,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: scheme.primary.withValues(alpha: 0.06),
                                  border: Border(
                                    top: BorderSide(
                                      color: scheme.primary.withValues(
                                        alpha: 0.28,
                                      ),
                                    ),
                                    bottom: BorderSide(
                                      color: scheme.primary.withValues(
                                        alpha: 0.28,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  tsController.dispose();
  unitController.dispose();
}
