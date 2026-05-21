import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'metronome_music.dart';

// Controller class for managing the note sequence used in the metronome demo, 
// including loading/saving from persistent storage and parsing from text input.
class NoteSequenceController extends ChangeNotifier {
  static const String _storageKey = 'custom_note_sequence';

  List<String> _sequence = [];
  bool _isLoaded = false;

  List<String> get sequence => List.unmodifiable(_sequence);
  bool get isLoaded => _isLoaded;
  bool get hasSequence => _sequence.isNotEmpty;
  String get sequenceText => _sequence.join();

  Future<void> load({required List<String> fallbackSequence}) async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final savedText = prefs.getString(_storageKey);
    final savedSequence = savedText == null
        ? <String>[]
        : parseNoteSequenceText(savedText);

    _sequence = savedSequence.isNotEmpty
        ? savedSequence
        : List<String>.from(fallbackSequence);
    _isLoaded = true;
    notifyListeners();
  }

  Future<bool> setSequenceFromText(String text) async {
    final parsedSequence = parseNoteSequenceText(text);
    if (parsedSequence.isEmpty) return false;

    _sequence = parsedSequence;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, _sequence.join());

    notifyListeners();
    return true;
  }

  Future<void> resetToDefault(List<String> defaultSequence) async {
    if (defaultSequence.isEmpty) return;

    _sequence = List<String>.from(defaultSequence);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);

    notifyListeners();
  }
}
