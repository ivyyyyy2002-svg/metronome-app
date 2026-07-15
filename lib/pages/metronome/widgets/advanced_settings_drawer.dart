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
    required this.clickSoundLabel,
    required this.currentClickSoundName,
    required this.onClickSoundTap,
    required this.volumeBalanceLabel,
    required this.clickVolumeLabel,
    required this.instrumentVolumeLabel,
    required this.clickVolume,
    required this.instrumentVolume,
    required this.onClickVolumeChanged,
    required this.onInstrumentVolumeChanged,
    required this.onVolumeChangeEnd,
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
  final String clickSoundLabel;
  final String currentClickSoundName;
  final VoidCallback onClickSoundTap;
  final String volumeBalanceLabel;
  final String clickVolumeLabel;
  final String instrumentVolumeLabel;
  final double clickVolume;
  final double instrumentVolume;
  final ValueChanged<double> onClickVolumeChanged;
  final ValueChanged<double> onInstrumentVolumeChanged;
  final VoidCallback onVolumeChangeEnd;
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
            volumeBalanceLabel,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _VolumeSlider(
                  icon: Icons.volume_up_rounded,
                  label: clickVolumeLabel,
                  value: clickVolume,
                  onChanged: onClickVolumeChanged,
                  onChangeEnd: onVolumeChangeEnd,
                ),
                const Divider(height: 18),
                _VolumeSlider(
                  icon: Icons.graphic_eq_rounded,
                  label: instrumentVolumeLabel,
                  value: instrumentVolume,
                  onChanged: onInstrumentVolumeChanged,
                  onChangeEnd: onVolumeChangeEnd,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.surround_sound_rounded),
            title: Text(
              clickSoundLabel,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(currentClickSoundName),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: onClickSoundTap,
          ),
          const SizedBox(height: 10),
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

class _VolumeSlider extends StatelessWidget {
  const _VolumeSlider({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final IconData icon;
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final VoidCallback onChangeEnd;

  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).round();
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 1,
          divisions: 20,
          label: '$percentage%',
          onChanged: onChanged,
          onChangeEnd: (_) => onChangeEnd(),
        ),
      ],
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
