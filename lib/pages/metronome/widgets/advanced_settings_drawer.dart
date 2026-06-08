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
    required this.instrumentLabel,
    required this.instruments,
    required this.instrumentAvailability,
    required this.selectedInstrument,
    required this.onInstrumentChanged,
    required this.missingInstrumentLabel,
    this.minBaseLabel,
    this.maxBaseLabel,
  });

  final double baseFrequencyHz;
  final double minBaseFrequencyHz;
  final double maxBaseFrequencyHz;
  final ValueChanged<double> onBaseFrequencyChanged;
  final ValueChanged<double> onBaseFrequencyChangeEnd;
  final String titleLabel;
  final String instrumentLabel;
  final List<String> instruments;
  final Map<String, bool> instrumentAvailability;
  final String selectedInstrument;
  final ValueChanged<String> onInstrumentChanged;
  final String missingInstrumentLabel;
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
          const SizedBox(height: 18),
          Text(
            instrumentLabel,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _InstrumentChipSelector(
            instruments: instruments,
            instrumentAvailability: instrumentAvailability,
            selectedInstrument: selectedInstrument,
            onInstrumentChanged: onInstrumentChanged,
            missingInstrumentLabel: missingInstrumentLabel,
          ),
        ],
      ),
    );
  }
}

class _InstrumentChipSelector extends StatelessWidget {
  const _InstrumentChipSelector({
    required this.instruments,
    required this.instrumentAvailability,
    required this.selectedInstrument,
    required this.onInstrumentChanged,
    required this.missingInstrumentLabel,
  });

  final List<String> instruments;
  final Map<String, bool> instrumentAvailability;
  final String selectedInstrument;
  final ValueChanged<String> onInstrumentChanged;
  final String missingInstrumentLabel;

  String _displayName(String instrument) {
    if (instrument.isEmpty) return instrument;
    return '${instrument[0].toUpperCase()}${instrument.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final instrument in instruments)
          Builder(
            builder: (context) {
              final selected = instrument == selectedInstrument;
              final available = instrumentAvailability[instrument] ?? true;
              final label = available
                  ? _displayName(instrument)
                  : '${_displayName(instrument)} ($missingInstrumentLabel)';

              return ChoiceChip(
                label: Text(label),
                selected: selected,
                showCheckmark: false,
                onSelected: available
                    ? (_) => onInstrumentChanged(instrument)
                    : null,
                selectedColor: null,
                backgroundColor: scheme.surfaceContainerLow,
                disabledColor: scheme.surfaceContainerLow.withValues(
                  alpha: 0.55,
                ),
                labelStyle: TextStyle(
                  color: !available
                      ? scheme.onSurfaceVariant.withValues(alpha: 0.45)
                      : selected
                      ? null
                      : scheme.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                side: BorderSide(
                  color: selected ? Colors.transparent : scheme.outlineVariant,
                ),
              );
            },
          ),
      ],
    );
  }
}
