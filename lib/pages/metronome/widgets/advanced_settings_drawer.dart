import 'package:flutter/material.dart';

// Drawer widget for advanced metronome settings like base pitch
class AdvancedSettingsDrawer extends StatelessWidget {
  const AdvancedSettingsDrawer({
    super.key,
    required this.baseFrequencyHz,
    required this.minBaseFrequencyHz,
    required this.maxBaseFrequencyHz,
    required this.onBaseFrequencyChanged,
    required this.onBaseFrequencyChangeEnd,
    required this.titleLabel,
    this.minBaseLabel,
    this.maxBaseLabel,
  });

  final double baseFrequencyHz;
  final double minBaseFrequencyHz;
  final double maxBaseFrequencyHz;
  final ValueChanged<double> onBaseFrequencyChanged;
  final ValueChanged<double> onBaseFrequencyChangeEnd;
  final String titleLabel;
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
              Text(titleLabel, style: Theme.of(context).textTheme.titleMedium),
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
        ],
      ),
    );
  }
}
