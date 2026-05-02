// Core music theory definitions and utilities for the metronome page, including beat units, note-to-semitone mapping, and time signature options.
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
  'C#': 1,
  'Db': 1,
  'D': 2,
  'D#': 3,
  'Eb': 3,
  'E': 4,
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

String beatUnitLabel(BeatUnit unit) {
  switch (unit) {
    case BeatUnit.half:
      return '1/2';
    case BeatUnit.quarter:
      return '1/4';
    case BeatUnit.eighth:
      return '1/8';
    case BeatUnit.sixteenth:
      return '1/16';
    case BeatUnit.dottedHalf:
      return '1/2.';
    case BeatUnit.dottedQuarter:
      return '1/4.';
    case BeatUnit.dottedEighth:
      return '1/8.';
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
