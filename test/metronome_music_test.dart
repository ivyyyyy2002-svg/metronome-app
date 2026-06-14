import 'package:flutter_test/flutter_test.dart';
import 'package:metronome_app/pages/metronome/metronome_music.dart';

void main() {
  test('parses eastern notation into western playback notes', () {
    expect(parseNoteSequenceText("S' S' S' S' N D N S' N D M GS G M D N"), [
      "C'",
      "C'",
      "C'",
      "C'",
      'B',
      'A',
      'B',
      "C'",
      'B',
      'A',
      'F',
      'E/C',
      'E',
      'F',
      'A',
      'B',
    ]);
  });

  test('keeps unspaced notes inside the same beat', () {
    expect(parseNoteSequenceText('C D E FG'), ['C', 'D', 'E', 'F/G']);
  });

  test('keeps dash tokens as held beats', () {
    expect(parseNoteSequenceText('C - D E'), ['C', '-', 'D', 'E']);
    expect(isHoldBeatToken('-'), isTrue);
  });

  test('resolves octave marks relative to the base octave', () {
    expect(resolveSequenceNoteAtom("C'", 4), (note: 'C', octave: 5));
    expect(resolveSequenceNoteAtom('C,', 4), (note: 'C', octave: 3));
  });
}
