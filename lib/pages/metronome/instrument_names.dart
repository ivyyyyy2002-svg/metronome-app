/// Shared display names for instrument keys, used by the instrument picker
/// and the practice-history "favorite instrument" stat.
const Map<String, String> instrumentDisplayNames = {
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

String instrumentDisplayName(String instrument) {
  final displayName = instrumentDisplayNames[instrument];
  if (displayName != null) return displayName;
  if (instrument.isEmpty) return instrument;
  return '${instrument[0].toUpperCase()}${instrument.substring(1)}';
}
