import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Main control panel for the metronome page, containing BPM slider, click/sound toggles, meter picker, and instrument selector
class MetronomeControlsPanel extends StatelessWidget {
  const MetronomeControlsPanel({
    super.key,
    required this.noteCount,
    required this.currentSoundListenable,
    required this.sequencePreviewText,
    required this.bpm,
    required this.enableClick,
    required this.enableSound,
    required this.onBpmChanged,
    required this.onBpmChangeEnd,
    required this.onClickToggle,
    required this.onSoundToggle,
    required this.onMeterTap,
    required this.meterLabel,
    required this.selectedInstrument,
    required this.instrumentItems,
    required this.onInstrumentChanged,
  });

  final int noteCount;
  final ValueListenable<String> currentSoundListenable;
  final String sequencePreviewText;
  final int bpm;
  final bool enableClick;
  final bool enableSound;
  final ValueChanged<double> onBpmChanged;
  final ValueChanged<double> onBpmChangeEnd;
  final ValueChanged<bool> onClickToggle;
  final ValueChanged<bool> onSoundToggle;
  final VoidCallback onMeterTap;
  final String meterLabel;
  final String selectedInstrument;
  final List<DropdownMenuItem<String>> instrumentItems;
  final ValueChanged<String?> onInstrumentChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
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
                    '$noteCount notes loaded',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<String>(
                    valueListenable: currentSoundListenable,
                    builder: (context, sound, _) {
                      return Text(
                        sound.isEmpty ? '--' : sound,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
        const SizedBox(height: 12),
        Padding(
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
          spacing: 8,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            FilterChip(
              label: const Text('Click'),
              avatar: const Icon(Icons.volume_up, size: 18),
              selected: enableClick,
              onSelected: onClickToggle,
            ),
            FilterChip(
              label: const Text('Sound'),
              avatar: const Icon(Icons.graphic_eq_rounded, size: 18),
              selected: enableSound,
              onSelected: onSoundToggle,
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onMeterTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.tune_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  meterLabel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 6),
                const Icon(Icons.expand_more_rounded, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Instrument: '),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedInstrument,
              items: instrumentItems,
              onChanged: onInstrumentChanged,
            ),
          ],
        ),
      ],
    );
  }
}
