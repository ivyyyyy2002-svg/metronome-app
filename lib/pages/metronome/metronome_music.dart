// Core music theory definitions and utilities for the metronome page,
// including beat units, note-to-semitone mapping, and time signature options.
enum BeatUnit {
  half,
  quarter,
  eighth,
  sixteenth,
  dottedHalf,
  dottedQuarter,
  dottedEighth,
}

const Map<String, int> noteToSemitone = {
  'C': 0,
  'Cb': -1,
  'C#': 1,
  'Db': 1,
  'D': 2,
  'D#': 3,
  'Eb': 3,
  'E': 4,
  'E#': 5,
  'Fb': 4,
  'F': 5,
  'F#': 6,
  'Gb': 6,
  'G': 7,
  'G#': 8,
  'Ab': 8,
  'A': 9,
  'A#': 10,
  'Bb': 10,
  'B': 11,
  'B#': 12,
};

const int maxNoteSequenceLength = 128;

const Map<String, String> _easternShortNoteToWestern = {
  'S': 'C',
  'R': 'D',
  'Rb': 'Db',
  'G': 'E',
  'Gb': 'Eb',
  'M': 'F',
  'M#': 'F#',
  'P': 'G',
  'D': 'A',
  'Db': 'Ab',
  'N': 'B',
  'Nb': 'Bb',
};

const Map<String, String> _easternFullNoteToShort = {
  'sa': 'S',
  're': 'R',
  're-flat': 'Rb',
  'reb': 'Rb',
  'ga': 'G',
  'ga-flat': 'Gb',
  'gab': 'Gb',
  'ma': 'M',
  'ma-sharp': 'M#',
  'ma#': 'M#',
  'pa': 'P',
  'dha': 'D',
  'dha-flat': 'Db',
  'dhab': 'Db',
  'ni': 'N',
  'ni-flat': 'Nb',
  'nib': 'Nb',
};

const List<String> timeSignatureOptions = [
  '1/4',
  '2/4',
  '3/4',
  '4/4',
  '5/4',
  '6/4',
  '7/4',
  '2/2',
  '3/2',
  '4/2',
  '2/8',
  '3/8',
  '4/8',
  '5/8',
  '6/8',
  '7/8',
  '9/8',
  '12/8',
  '3/16',
  '5/16',
  '7/16',
  '9/16',
  '12/16',
];

// Parses a beat unit from a string, with fallbacks based on the time signature if the string is unrecognized.
BeatUnit parseBeatUnit(
  dynamic raw, {
  required int fallbackBeats,
  required int fallbackNote,
}) {
  final rawText = (raw is String) ? raw.trim().toLowerCase() : '';
  switch (rawText) {
    case 'half':
    case '1/2':
      return BeatUnit.half;
    case 'quarter':
    case '1/4':
      return BeatUnit.quarter;
    case 'eighth':
    case '1/8':
      return BeatUnit.eighth;
    case 'sixteenth':
    case '1/16':
      return BeatUnit.sixteenth;
    case 'dotted_half':
    case 'dotted-half':
    case 'dotted half':
    case '3/4':
      return BeatUnit.dottedHalf;
    case 'dotted_quarter':
    case 'dotted-quarter':
    case 'dotted quarter':
    case '3/8':
      return BeatUnit.dottedQuarter;
    case 'dotted_eighth':
    case 'dotted-eighth':
    case 'dotted eighth':
    case '3/16':
      return BeatUnit.dottedEighth;
    default:
      return defaultBeatUnitForSignature(fallbackBeats, fallbackNote);
  }
}

BeatUnit defaultBeatUnitForSignature(int beats, int note) {
  if (note == 8 && beats >= 6 && beats % 3 == 0) {
    return BeatUnit.dottedQuarter;
  }
  if (note == 16 && beats >= 6 && beats % 3 == 0) {
    return BeatUnit.dottedEighth;
  }
  return BeatUnit.quarter;
}

// Returns a compact label for the given subdivision.
String beatUnitLabel(BeatUnit unit) {
  switch (unit) {
    case BeatUnit.half:
      return 'Half';
    case BeatUnit.quarter:
      return 'Quarter';
    case BeatUnit.eighth:
      return 'Eighth';
    case BeatUnit.sixteenth:
      return 'Sixteenth';
    case BeatUnit.dottedHalf:
      return 'Dotted Half';
    case BeatUnit.dottedQuarter:
      return 'Dotted Quarter';
    case BeatUnit.dottedEighth:
      return 'Dotted Eighth';
  }
}

String beatUnitConfigValue(BeatUnit unit) {
  switch (unit) {
    case BeatUnit.half:
      return 'half';
    case BeatUnit.quarter:
      return 'quarter';
    case BeatUnit.eighth:
      return 'eighth';
    case BeatUnit.sixteenth:
      return 'sixteenth';
    case BeatUnit.dottedHalf:
      return 'dotted_half';
    case BeatUnit.dottedQuarter:
      return 'dotted_quarter';
    case BeatUnit.dottedEighth:
      return 'dotted_eighth';
  }
}

// Returns the length of the given beat unit in whole notes, e.g. 0.25 for quarter notes.
double beatUnitWholeNoteLength(BeatUnit unit) {
  switch (unit) {
    case BeatUnit.half:
      return 1.0 / 2.0;
    case BeatUnit.quarter:
      return 1.0 / 4.0;
    case BeatUnit.eighth:
      return 1.0 / 8.0;
    case BeatUnit.sixteenth:
      return 1.0 / 16.0;
    case BeatUnit.dottedHalf:
      return 3.0 / 4.0;
    case BeatUnit.dottedQuarter:
      return 3.0 / 8.0;
    case BeatUnit.dottedEighth:
      return 3.0 / 16.0;
  }
}

// Parses a sequence of musical notes from text, keeping each whitespace-separated
// token as one beat. Notes inside the same token are played within the same beat.
List<String> parseNoteSequenceText(String text) {
  final beats = <String>[];
  final useEasternNotation = _looksLikeEasternNotation(text);

  for (final rawToken in text.trim().split(RegExp(r'\s+'))) {
    if (rawToken.isEmpty) continue;

    if (rawToken == '-') {
      beats.add(rawToken);
      continue;
    }

    final atoms = _parseBeatToken(rawToken, useEasternNotation);
    if (atoms.isEmpty) continue;

    beats.add(atoms.join('/'));
  }

  return beats.toList(growable: false);
}

String formatNoteSequenceText(String text) {
  return parseNoteSequenceText(text).join(' ');
}

bool isHoldBeatToken(String token) {
  return token.trim() == '-';
}

List<String> notesInBeatToken(String token) {
  final trimmed = token.trim();
  if (trimmed.isEmpty || isHoldBeatToken(trimmed)) return const [];

  return trimmed
      .split('/')
      .where((atom) => atom.trim().isNotEmpty)
      .toList(growable: false);
}

// Resolves one parsed note atom to the western note name used by the audio files.
({String note, int octave})? resolveSequenceNoteAtom(
  String atom,
  int octaveFallback,
) {
  final match = RegExp(r"^([A-G](?:#|b)?)(\d+|[,']*)$").firstMatch(atom.trim());

  if (match == null) return null;

  final westernNote = match.group(1)!;
  final octaveSuffix = match.group(2)!;
  final explicitOctave = int.tryParse(octaveSuffix);

  if (explicitOctave != null) {
    return (note: westernNote, octave: explicitOctave);
  }

  final octaveDelta = octaveSuffix.split('').fold<int>(0, (delta, mark) {
    if (mark == "'") return delta + 1;
    if (mark == ',') return delta - 1;
    return delta;
  });

  return (note: westernNote, octave: octaveFallback + octaveDelta);
}

bool _looksLikeEasternNotation(String text) {
  final lower = text.toLowerCase();
  if (RegExp(
    r'\b(?:sa|re|ga|ma|pa|dha|ni)(?:-(?:flat|sharp))?\b',
  ).hasMatch(lower)) {
    return true;
  }

  return RegExp(
    r"(^|\s)[SRMPNsrmpn](?:#|b|♯|♭|[,'])*(?=\s|$|[A-Za-z])",
  ).hasMatch(text);
}

List<String> _parseBeatToken(String token, bool useEasternNotation) {
  final atoms = <String>[];
  int i = 0;

  while (i < token.length) {
    if (token[i] == '/') {
      i++;
      continue;
    }

    final parsed = _parseNoteAtom(token, i, useEasternNotation);
    if (parsed == null) return const [];

    atoms.add(parsed.atom);
    i = parsed.nextIndex;
  }

  return atoms.toList(growable: false);
}

({String atom, int nextIndex})? _parseNoteAtom(
  String token,
  int start,
  bool useEasternNotation,
) {
  if (useEasternNotation) {
    final eastern = _parseEasternNoteAtom(token, start);
    if (eastern != null) return eastern;
  }

  final western = _parseWesternNoteAtom(token, start);
  if (western != null) return western;

  if (!useEasternNotation) {
    return _parseEasternNoteAtom(token, start);
  }

  return null;
}

({String atom, int nextIndex})? _parseWesternNoteAtom(String token, int start) {
  final noteMatch = RegExp(
    r'^[A-Ga-g](?:#|b|♯|♭)?',
  ).firstMatch(token.substring(start));
  if (noteMatch == null) return null;

  final raw = noteMatch.group(0)!;
  final base = raw[0].toUpperCase();
  final accidental = raw.length > 1 ? _normalizeAccidental(raw[1]) : '';
  final suffix = _readOctaveSuffix(token, start + raw.length);

  return (
    atom: '$base$accidental${suffix.suffix}',
    nextIndex: suffix.nextIndex,
  );
}

({String atom, int nextIndex})? _parseEasternNoteAtom(String token, int start) {
  final rest = token.substring(start);
  final fullMatch = _matchEasternFullName(rest);

  if (fullMatch != null) {
    final suffix = _readOctaveSuffix(token, start + fullMatch.rawLength);
    return (
      atom: '${_easternShortNoteToWestern[fullMatch.note]!}${suffix.suffix}',
      nextIndex: suffix.nextIndex,
    );
  }

  final base = token[start].toUpperCase();
  if (!RegExp(r'[SRGMPDN]').hasMatch(base)) return null;

  var nextIndex = start + 1;
  var accidental = '';
  if (nextIndex < token.length) {
    final mark = _normalizeAccidental(token[nextIndex]);
    if (mark.isNotEmpty) {
      accidental = mark;
      nextIndex++;
    }
  }

  final note = '$base$accidental';
  if (!_easternShortNoteToWestern.containsKey(note)) return null;

  final suffix = _readOctaveSuffix(token, nextIndex);
  return (
    atom: '${_easternShortNoteToWestern[note]!}${suffix.suffix}',
    nextIndex: suffix.nextIndex,
  );
}

({String note, int rawLength})? _matchEasternFullName(String rest) {
  final entries = _easternFullNoteToShort.entries.toList()
    ..sort((a, b) => b.key.length.compareTo(a.key.length));

  for (final entry in entries) {
    if (rest.toLowerCase().startsWith(entry.key)) {
      return (note: entry.value, rawLength: entry.key.length);
    }
  }

  return null;
}

({String suffix, int nextIndex}) _readOctaveSuffix(String token, int start) {
  if (start >= token.length) return (suffix: '', nextIndex: start);

  if (RegExp(r'\d').hasMatch(token[start])) {
    var i = start;
    while (i < token.length && RegExp(r'\d').hasMatch(token[i])) {
      i++;
    }
    return (suffix: token.substring(start, i), nextIndex: i);
  }

  var i = start;
  while (i < token.length && (token[i] == "'" || token[i] == ',')) {
    i++;
  }

  return (suffix: token.substring(start, i), nextIndex: i);
}

String _normalizeAccidental(String char) {
  if (char == '#' || char == '♯') return '#';
  if (char == 'b' || char == '♭') return 'b';
  return '';
}
