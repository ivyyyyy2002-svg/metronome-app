import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../theme/glass.dart';

// Main control panel for the metronome page, containing BPM slider, click/sound toggles, meter picker, and instrument selector
class MetronomeControlsPanel extends StatelessWidget {
  const MetronomeControlsPanel({
    super.key,
    required this.noteCount,
    required this.currentSoundListenable,
    required this.sequencePreviewText,
    required this.onSequenceTap,
    this.sequenceKey,
    this.bpmKey,
    this.toggleKey,
    this.meterKey,
    required this.notesLoadedLabel,
    required this.clickLabel,
    required this.soundLabel,
    required this.bpm,
    required this.enableClick,
    required this.enableSound,
    required this.onBpmChanged,
    required this.onBpmChangeEnd,
    required this.onClickToggle,
    required this.onSoundToggle,
    required this.onMeterTap,
    required this.meterLabel,
  });

  final int noteCount;
  final ValueListenable<String> currentSoundListenable;
  final String sequencePreviewText;
  final VoidCallback onSequenceTap;
  final Key? sequenceKey;
  final Key? bpmKey;
  final Key? toggleKey;
  final Key? meterKey;
  final String notesLoadedLabel;
  final String clickLabel;
  final String soundLabel;
  final int bpm;
  final bool enableClick;
  final bool enableSound;
  final ValueChanged<double> onBpmChanged;
  final ValueChanged<double> onBpmChangeEnd;
  final ValueChanged<bool> onClickToggle;
  final ValueChanged<bool> onSoundToggle;
  final VoidCallback onMeterTap;
  final String meterLabel;

  // Builds the UI for the metronome controls panel,
  // including BPM slider, click/sound toggles, meter picker, and instrument selector.
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Sequence display and tap area
        InkWell(
          key: sequenceKey,
          borderRadius: BorderRadius.circular(16),
          onTap: onSequenceTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: glassInnerDecoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.library_music_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$noteCount $notesLoadedLabel',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    ValueListenableBuilder<String>(
                      valueListenable: currentSoundListenable,
                      builder: (context, sound, _) {
                        return Text(
                          sound.isEmpty ? '--' : sound,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  sequencePreviewText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          key: bpmKey,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Slider(
                value: bpm.toDouble(),
                min: 30,
                max: 240,
                divisions: 210,
                label: '$bpm',
                onChanged: onBpmChanged,
                onChangeEnd: onBpmChangeEnd,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text('30'), Text('240')],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          key: toggleKey,
          spacing: 8,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            FilterChip(
              label: Text(clickLabel),
              avatar: const Icon(Icons.volume_up, size: 18),
              selected: enableClick,
              showCheckmark: false,
              selectedColor: null,
              labelStyle: TextStyle(
                color: enableClick ? null : scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              // Always-visible border so the toggle reads clearly against
              // the near-plain page background.
              side: BorderSide(
                color: enableClick
                    ? scheme.primary.withValues(alpha: 0.65)
                    : scheme.outline,
              ),
              onSelected: onClickToggle,
            ),
            FilterChip(
              label: Text(soundLabel),
              avatar: const Icon(Icons.graphic_eq_rounded, size: 18),
              selected: enableSound,
              showCheckmark: false,
              selectedColor: null,
              labelStyle: TextStyle(
                color: enableSound ? null : scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: enableSound
                    ? scheme.primary.withValues(alpha: 0.65)
                    : scheme.outline,
              ),
              onSelected: onSoundToggle,
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          key: meterKey,
          borderRadius: BorderRadius.circular(999),
          onTap: onMeterTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: glassInnerDecoration(context, borderRadius: 999),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.tune_rounded, size: 18),
                const SizedBox(width: 8),
                Text(meterLabel, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 6),
                const Icon(Icons.expand_more_rounded, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
