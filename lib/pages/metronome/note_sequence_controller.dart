import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'metronome_music.dart';

// Model class representing a saved note sequence, with methods for JSON serialization
class SavedNoteSequence {
  const SavedNoteSequence({
    required this.name,
    required this.sequence,
    this.originalText,
    this.notation,
  });

  final String name;
  final List<String> sequence;
  final String? originalText;
  final NoteNotation? notation;

  String get sequenceText => originalText ?? sequence.join(' ');

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sequence': sequenceText,
      if (notation != null) 'notation': notation!.name,
    };
  }

  static SavedNoteSequence? fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final sequenceText = json['sequence'];
    final notationName = json['notation'];

    if (name is! String || name.trim().isEmpty || sequenceText is! String) {
      return null;
    }

    final notation = NoteNotation.values
        .where((value) => value.name == notationName)
        .firstOrNull;
    final sequence = parseNoteSequenceText(sequenceText, notation: notation);
    if (sequence.isEmpty) return null;

    return SavedNoteSequence(
      name: name.trim(),
      sequence: sequence,
      originalText: sequenceText.trim(),
      notation: notation,
    );
  }
}

// Controller class for managing the note sequence used in the metronome demo,
// including loading/saving from persistent storage and parsing from text input.
class NoteSequenceController extends ChangeNotifier {
  static const String _storageKey = 'custom_note_sequence';
  static const String _notationStorageKey = 'custom_note_sequence_notation';
  static const String _savedSequencesStorageKey = 'saved_note_sequences';

  List<String> _sequence = [];
  String _sequenceInputText = '';
  NoteNotation? _notation;
  List<SavedNoteSequence> _savedSequences = [];
  bool _isLoaded = false;

  List<String> get sequence => List.unmodifiable(_sequence);
  List<SavedNoteSequence> get savedSequences =>
      List.unmodifiable(_savedSequences);
  bool get isLoaded => _isLoaded;
  bool get hasSequence => _sequence.isNotEmpty;
  String get sequenceText => _sequenceInputText;
  NoteNotation? get notation => _notation;

  Future<void> load({required List<String> fallbackSequence}) async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final savedText = prefs.getString(_storageKey);
    final savedNotationName = prefs.getString(_notationStorageKey);
    final savedNotation = NoteNotation.values
        .where((value) => value.name == savedNotationName)
        .firstOrNull;
    final savedSequence = savedText == null
        ? <String>[]
        : parseNoteSequenceText(savedText, notation: savedNotation);
    _savedSequences = _decodeSavedSequences(
      prefs.getString(_savedSequencesStorageKey),
    );

    _sequence = savedSequence.isNotEmpty
        ? savedSequence
        : List<String>.from(fallbackSequence);
    _sequenceInputText = savedSequence.isNotEmpty
        ? savedText!.trim()
        : _sequence.join(' ');
    _notation = savedSequence.isNotEmpty ? savedNotation : null;
    _isLoaded = true;
    notifyListeners();
  }

  Future<bool> setSequenceFromText(
    String text, {
    NoteNotation? notation,
  }) async {
    final parsedSequence = parseNoteSequenceText(text, notation: notation);
    if (parsedSequence.isEmpty ||
        parsedSequence.length > maxNoteSequenceLength) {
      return false;
    }

    _sequence = parsedSequence;
    _sequenceInputText = text.trim();
    _notation = notation;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, sequenceText);
    if (notation == null) {
      await prefs.remove(_notationStorageKey);
    } else {
      await prefs.setString(_notationStorageKey, notation.name);
    }

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
      originalText: _sequenceInputText,
      notation: _notation,
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
    _sequenceInputText = savedSequence.sequenceText;
    _notation = savedSequence.notation;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, sequenceText);
    if (_notation == null) {
      await prefs.remove(_notationStorageKey);
    } else {
      await prefs.setString(_notationStorageKey, _notation!.name);
    }

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
    _sequenceInputText = _sequence.join(' ');
    _notation = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    await prefs.remove(_notationStorageKey);

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
