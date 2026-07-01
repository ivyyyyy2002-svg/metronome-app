import 'package:flutter_test/flutter_test.dart';
import 'package:metronome_app/pages/metronome/metronome_music.dart';
import 'package:metronome_app/pages/metronome/note_sequence_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('selected notation resolves ambiguous Eastern note names', () {
    expect(parseNoteSequenceText('G D', notation: NoteNotation.eastern), [
      'E',
      'A',
    ]);
    expect(parseNoteSequenceText('G D', notation: NoteNotation.western), [
      'G',
      'D',
    ]);
  });

  test(
    'saved sequences preserve Eastern input for display and reload',
    () async {
      SharedPreferences.setMockInitialValues({});
      final controller = NoteSequenceController();
      await controller.load(fallbackSequence: ['C']);

      final applied = await controller.setSequenceFromText(
        "S R G M P D N'",
        notation: NoteNotation.eastern,
      );
      final saved = await controller.saveCurrentSequence('Raga');

      expect(applied, isTrue);
      expect(saved, isTrue);
      expect(controller.sequence, ['C', 'D', 'E', 'F', 'G', 'A', "B'"]);
      expect(controller.savedSequences.single.sequenceText, "S R G M P D N'");
      expect(controller.savedSequences.single.notation, NoteNotation.eastern);

      final reloadedController = NoteSequenceController();
      await reloadedController.load(fallbackSequence: ['C']);

      expect(
        reloadedController.savedSequences.single.sequenceText,
        "S R G M P D N'",
      );
      expect(reloadedController.savedSequences.single.sequence, [
        'C',
        'D',
        'E',
        'F',
        'G',
        'A',
        "B'",
      ]);
    },
  );
}
