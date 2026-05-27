import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'metronome_music.dart';

// Model class representing a saved note sequence, with methods for JSON serialization
class SavedNoteSequence {
  const SavedNoteSequence({required this.name, required this.sequence});

  final String name;
  final List<String> sequence;

  String get sequenceText => sequence.join(' ');

  Map<String, dynamic> toJson() {
    return {'name': name, 'sequence': sequenceText};
  }

  static SavedNoteSequence? fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final sequenceText = json['sequence'];

    if (name is! String || name.trim().isEmpty || sequenceText is! String) {
      return null;
    }

    final sequence = parseNoteSequenceText(sequenceText);
    if (sequence.isEmpty) return null;

    return SavedNoteSequence(name: name.trim(), sequence: sequence);
  }
}

// Controller class for managing the note sequence used in the metronome demo,
// including loading/saving from persistent storage and parsing from text input.
class NoteSequenceController extends ChangeNotifier {
  static const String _storageKey = 'custom_note_sequence';
  static const String _savedSequencesStorageKey = 'saved_note_sequences';

  List<String> _sequence = [];
  List<SavedNoteSequence> _savedSequences = [];
  bool _isLoaded = false;

  List<String> get sequence => List.unmodifiable(_sequence);
  List<SavedNoteSequence> get savedSequences =>
      List.unmodifiable(_savedSequences);
  bool get isLoaded => _isLoaded;
  bool get hasSequence => _sequence.isNotEmpty;
  String get sequenceText => _sequence.join(' ');

  Future<void> load({required List<String> fallbackSequence}) async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final savedText = prefs.getString(_storageKey);
    final savedSequence = savedText == null
        ? <String>[]
        : parseNoteSequenceText(savedText);
    _savedSequences = _decodeSavedSequences(
      prefs.getString(_savedSequencesStorageKey),
    );

    _sequence = savedSequence.isNotEmpty
        ? savedSequence
        : List<String>.from(fallbackSequence);
    _isLoaded = true;
    notifyListeners();
  }

  Future<bool> setSequenceFromText(String text) async {
    final parsedSequence = parseNoteSequenceText(text);
    if (parsedSequence.isEmpty ||
        parsedSequence.length > maxNoteSequenceLength) {
      return false;
    }

    _sequence = parsedSequence;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, sequenceText);

    notifyListeners();
    return true;
  }

  Future<bool> saveCurrentSequence(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty || _sequence.isEmpty) return false;

    final nextSavedSequences = List<SavedNoteSequence>.from(_savedSequences);
    final existingIndex = nextSavedSequences.indexWhere(
      (item) => item.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    final savedSequence = SavedNoteSequence(
      name: trimmedName,
      sequence: List<String>.from(_sequence),
    );

    if (existingIndex == -1) {
      nextSavedSequences.add(savedSequence);
    } else {
      nextSavedSequences[existingIndex] = savedSequence;
    }

    _savedSequences = nextSavedSequences
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    await _saveSavedSequences();
    notifyListeners();
    return true;
  }

  Future<bool> importSavedSequence(SavedNoteSequence savedSequence) async {
    if (savedSequence.sequence.isEmpty) return false;

    _sequence = List<String>.from(savedSequence.sequence);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, sequenceText);

    notifyListeners();
    return true;
  }

  Future<bool> deleteSavedSequence(String name) async {
    final beforeCount = _savedSequences.length;
    _savedSequences = _savedSequences
        .where((item) => item.name.toLowerCase() != name.trim().toLowerCase())
        .toList(growable: false);

    if (_savedSequences.length == beforeCount) return false;

    await _saveSavedSequences();
    notifyListeners();
    return true;
  }

  List<SavedNoteSequence> searchSavedSequences(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return savedSequences;

    return _savedSequences
        .where((item) => item.name.toLowerCase().contains(normalizedQuery))
        .toList(growable: false);
  }

  Future<void> resetToDefault(List<String> defaultSequence) async {
    if (defaultSequence.isEmpty) return;

    _sequence = List<String>.from(defaultSequence);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);

    notifyListeners();
  }

  List<SavedNoteSequence> _decodeSavedSequences(String? rawJson) {
    if (rawJson == null || rawJson.isEmpty) return [];

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! List) return [];

      final savedSequences = <SavedNoteSequence>[];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) continue;
        final savedSequence = SavedNoteSequence.fromJson(item);
        if (savedSequence == null) continue;
        savedSequences.add(savedSequence);
      }

      savedSequences.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      return savedSequences;
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveSavedSequences() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _savedSequences.map((item) => item.toJson()).toList(growable: false),
    );
    await prefs.setString(_savedSequencesStorageKey, encoded);
  }
}
