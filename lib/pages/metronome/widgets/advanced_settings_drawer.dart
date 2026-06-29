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
              Expanded(
                child: Text(
                  titleLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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

  static const List<_InstrumentRegion> _instrumentRegions = [
    _InstrumentRegion(
      label: 'Western',
      instruments: [
        'piano',
        'uprightPiano',
        'celesta',
        'harp',
        'clarinet',
        'oboe',
        'trumpet',
        'frenchHorn',
        'acousticGuitar',
        'electricGuitar',
        'acousticBass',
        'marimba',
      ],
    ),
    _InstrumentRegion(
      label: 'East Asian',
      instruments: [
        'pipa',
        'ruan',
        'guzheng',
        'erhu',
        'flute',
        'shamisen',
        'bianzhong',
      ],
    ),
    _InstrumentRegion(
      label: 'Middle Eastern',
      instruments: ['oud', 'qanun', 'duduk', 'ney', 'tanbur'],
    ),
    _InstrumentRegion(
      label: 'South Asian',
      instruments: ['harmonium', 'tabla'],
    ),
  ];

  static const Map<String, String> _instrumentDisplayNames = {
    'piano': 'Piano A',
    'uprightPiano': 'Piano B',
    'pipa': 'Pipa',
    'ruan': 'Ruan',
    'guzheng': 'Guzheng',
    'erhu': 'Erhu',
    'flute': 'Bamboo Flute',
    'shamisen': 'Shamisen',
    'harmonium': 'Harmonium',
    'tabla': 'Tabla',
    'oud': 'Oud',
    'qanun': 'Qanun',
    'duduk': 'Duduk',
    'ney': 'Ney',
    'tanbur': 'Tanbur',
    'celesta': 'Celesta',
    'harp': 'Harp',
    'clarinet': 'Clarinet',
    'oboe': 'Oboe',
    'trumpet': 'Trumpet',
    'frenchHorn': 'French Horn',
    'acousticGuitar': 'Acoustic Guitar',
    'electricGuitar': 'Electric Guitar',
    'acousticBass': 'Acoustic Bass',
    'bianzhong': 'Bianzhong',
    'marimba': 'Marimba',
  };

  String _displayName(String instrument) {
    final displayName = _instrumentDisplayNames[instrument];
    if (displayName != null) return displayName;
    if (instrument.isEmpty) return instrument;
    return '${instrument[0].toUpperCase()}${instrument.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final categorizedInstruments = _instrumentRegions
        .expand((region) => region.instruments)
        .toSet();
    final uncategorizedInstruments = instruments
        .where((instrument) => !categorizedInstruments.contains(instrument))
        .toList();
    final regions = [
      ..._instrumentRegions,
      if (uncategorizedInstruments.isNotEmpty)
        _InstrumentRegion(
          label: 'Other',
          instruments: uncategorizedInstruments,
        ),
    ];

    return Column(
      children: [
        for (final region in regions) _buildRegion(context, scheme, region),
      ],
    );
  }

  Widget _buildRegion(
    BuildContext context,
    ColorScheme scheme,
    _InstrumentRegion region,
  ) {
    final visibleInstruments = region.instruments
        .where(instruments.contains)
        .toList();
    if (visibleInstruments.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      key: PageStorageKey<String>('instrument-region-${region.label}'),
      initiallyExpanded: visibleInstruments.contains(selectedInstrument),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      visualDensity: VisualDensity.compact,
      maintainState: true,
      shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      collapsedShape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      title: Row(
        children: [
          Expanded(
            child: Text(
              region.label,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            '${visibleInstruments.length}',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final instrument in visibleInstruments)
                _buildInstrumentChip(scheme, instrument),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstrumentChip(ColorScheme scheme, String instrument) {
    final selected = instrument == selectedInstrument;
    final available = instrumentAvailability[instrument] ?? true;
    final label = available
        ? _displayName(instrument)
        : '${_displayName(instrument)} ($missingInstrumentLabel)';

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: available ? (_) => onInstrumentChanged(instrument) : null,
      selectedColor: scheme.secondaryContainer,
      backgroundColor: scheme.brightness == Brightness.light
          ? Colors.white
          : scheme.surface,
      disabledColor: scheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: !available
            ? scheme.onSurfaceVariant.withValues(alpha: 0.45)
            : scheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(color: scheme.outlineVariant),
    );
  }
}

class _InstrumentRegion {
  const _InstrumentRegion({required this.label, required this.instruments});

  final String label;
  final List<String> instruments;
}
