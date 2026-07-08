import 'package:flutter/material.dart';

import '../instrument_names.dart';

// Drawer widget for advanced metronome settings like base pitch
class AdvancedSettingsDrawer extends StatelessWidget {
  const AdvancedSettingsDrawer({
    super.key,
    required this.baseOctave,
    required this.minBaseOctave,
    required this.maxBaseOctave,
    required this.onBaseOctaveChanged,
    required this.titleLabel,
    required this.instrumentLabel,
    required this.instruments,
    required this.instrumentAvailability,
    required this.selectedInstrument,
    required this.onInstrumentChanged,
    required this.missingInstrumentLabel,
  });

  final int baseOctave;
  final int minBaseOctave;
  final int maxBaseOctave;
  final ValueChanged<int> onBaseOctaveChanged;
  final String titleLabel;
  final String instrumentLabel;
  final List<String> instruments;
  final Map<String, bool> instrumentAvailability;
  final String selectedInstrument;
  final ValueChanged<String> onInstrumentChanged;
  final String missingInstrumentLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final octaveOptions = [
      for (int octave = minBaseOctave; octave <= maxBaseOctave; octave++)
        octave,
    ];

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
          Text(
            'Base Pitch',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            "Choose the default pitch height for notes like C or S. Use ' or , in the sequence for higher or lower notes.",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final octave in octaveOptions)
                ChoiceChip(
                  label: Text('A$octave'),
                  selected: baseOctave == octave,
                  showCheckmark: false,
                  onSelected: (_) => onBaseOctaveChanged(octave),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Available pitch range: A$minBaseOctave - A$maxBaseOctave',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
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

  String _displayName(String instrument) => instrumentDisplayName(instrument);

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
