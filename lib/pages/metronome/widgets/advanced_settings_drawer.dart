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
    required this.onBaseFrequencyChanged,
    required this.onBaseFrequencyChangeEnd,
    required this.onDecreaseOctaveCount,
    required this.onIncreaseOctaveCount,
  });

  final double baseFrequencyHz;
  final int octaveCount;
  final int minOctave;
  final int maxOctave;
  final int maxOctaveCount;
  final ValueChanged<double> onBaseFrequencyChanged;
  final ValueChanged<double> onBaseFrequencyChangeEnd;
  final VoidCallback? onDecreaseOctaveCount;
  final VoidCallback? onIncreaseOctaveCount;

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
          Row(
            children: [
              const SizedBox(width: 8),
              Text('Base Pitch', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              Text('${baseFrequencyHz.toStringAsFixed(1)} Hz'),
            ],
          ),
          Slider(
            value: baseFrequencyHz,
            min: 55,
            max: 880,
            divisions: 825,
            label: baseFrequencyHz.toStringAsFixed(1),
            onChanged: onBaseFrequencyChanged,
            onChangeEnd: onBaseFrequencyChangeEnd,
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
              child: Text('Range: $minOctave-$maxOctave'),
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
