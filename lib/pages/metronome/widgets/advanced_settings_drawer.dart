import 'package:flutter/material.dart';

// Drawer widget for advanced metronome settings like base pitch and octave range
class AdvancedSettingsDrawer extends StatelessWidget {
  const AdvancedSettingsDrawer({
    super.key,
    required this.baseFrequencyHz,
    required this.octaveCount,
    required this.minOctave,
    required this.maxOctave,
    required this.maxOctaveCount,
    required this.minBaseFrequencyHz,
    required this.maxBaseFrequencyHz,
    required this.onBaseFrequencyChanged,
    required this.onBaseFrequencyChangeEnd,
    required this.onDecreaseOctaveCount,
    required this.onIncreaseOctaveCount,
    this.minBaseLabel,
    this.maxBaseLabel,
  });

  final double baseFrequencyHz;
  final int octaveCount;
  final int minOctave;
  final int maxOctave;
  final int maxOctaveCount;
  final double minBaseFrequencyHz;
  final double maxBaseFrequencyHz;
  final ValueChanged<double> onBaseFrequencyChanged;
  final ValueChanged<double> onBaseFrequencyChangeEnd;
  final VoidCallback? onDecreaseOctaveCount;
  final VoidCallback? onIncreaseOctaveCount;
  // Note-name labels rendered at the slider edges (e.g. "A1" and "A6").
  final String? minBaseLabel;
  final String? maxBaseLabel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded),
              const SizedBox(width: 8),
              Text(
                'Advanced Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Pitch row: slider with note-name labels at the edges instead of
          // a raw frequency readout. The slider tooltip still shows Hz.
          Row(
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  minBaseLabel ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Expanded(
                child: Slider(
                  value: baseFrequencyHz.clamp(
                    minBaseFrequencyHz,
                    maxBaseFrequencyHz,
                  ),
                  min: minBaseFrequencyHz,
                  max: maxBaseFrequencyHz,
                  divisions: ((maxBaseFrequencyHz - minBaseFrequencyHz) * 2)
                      .round()
                      .clamp(1, 1 << 30),
                  label: '${baseFrequencyHz.toStringAsFixed(1)} Hz',
                  onChanged: onBaseFrequencyChanged,
                  onChangeEnd: onBaseFrequencyChangeEnd,
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  maxBaseLabel ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 8),
              Text('Octaves', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDecreaseOctaveCount,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$octaveCount'),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onIncreaseOctaveCount,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Range: A$minOctave - A$maxOctave'),
            ),
          ),
          if (octaveCount >= maxOctaveCount)
            const Padding(
              padding: EdgeInsets.only(left: 26, top: 4),
              child: Text('Maximum octave span reached'),
            ),
        ],
      ),
    );
  }
}
