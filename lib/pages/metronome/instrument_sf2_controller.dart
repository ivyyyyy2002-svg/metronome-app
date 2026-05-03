import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_midi_pro/flutter_midi_pro.dart';

// Specifies which preset to load from a SoundFont (.sf2) file.
class Sf2Spec {
  final String assetPath;
  final int bank;
  final int program;
  // Semitones added to the requested MIDI note before playback.
  // Use +/-12 to shift one octave when the SF2 doesn't match the
  // scientific pitch convention (MIDI 60 = C4) used by the rest of the app.
  final int noteOffset;
  const Sf2Spec({
    required this.assetPath,
    this.bank = 0,
    this.program = 0,
    this.noteOffset = 0,
  });
}

// Controller for managing instrument soundfont playback using flutter_midi_pro
class InstrumentSf2Controller {
  InstrumentSf2Controller({
    required this.channelCount,
    required this.assetSpecs,
  });

  final MidiPro _midiPro = MidiPro();
  final int channelCount;
  final Map<String, Sf2Spec> assetSpecs;

  final Map<String, bool> _assetAvailability = {};
  final Map<String, int> _soundfontIds = {};
  String? _loadedInstrument;

  bool isReadyFor(String instrument) => _loadedInstrument == instrument;

  Future<bool> hasSoundfontAsset(String instrument) async {
    final cached = _assetAvailability[instrument];
    if (cached != null) return cached;

    final spec = assetSpecs[instrument];
    if (spec == null) {
      _assetAvailability[instrument] = false;
      return false;
    }

    bool available = false;
    try {
      await rootBundle.load(spec.assetPath);
      available = true;
    } catch (_) {}

    debugPrint(
      'SF2 asset check for $instrument at ${spec.assetPath} -> ${available ? 'found' : 'missing'}',
    );
    _assetAvailability[instrument] = available;
    return available;
  }

  Future<void> prepareForInstrument(String instrument) async {
    if (_loadedInstrument == instrument) return;

    final spec = assetSpecs[instrument];
    if (spec == null || !await hasSoundfontAsset(instrument)) {
      debugPrint('SF2 prepare skipped for $instrument');
      await unload();
      return;
    }

    try {
      int? sfId = _soundfontIds[instrument];
      if (sfId == null) {
        sfId = await _midiPro.loadSoundfontAsset(
          assetPath: spec.assetPath,
          bank: spec.bank,
          program: spec.program,
        );
        _soundfontIds[instrument] = sfId;
      }

      for (int channel = 0; channel < channelCount; channel++) {
        await _midiPro.selectInstrument(
          sfId: sfId,
          channel: channel,
          bank: spec.bank,
          program: spec.program,
        );
      }

      _loadedInstrument = instrument;
      debugPrint(
        'SF2 ready for $instrument using ${spec.assetPath} '
        '(sfId=$sfId bank=${spec.bank} program=${spec.program})',
      );
    } catch (e, st) {
      _loadedInstrument = null;
      debugPrint('Failed to prepare $instrument SF2: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  int? midiNoteFor(
    String note,
    int octave,
    Map<String, int> noteToSemitone,
  ) {
    final semitone = noteToSemitone[note];
    if (semitone == null) return null;
    final base = (octave + 1) * 12 + semitone;
    final spec = assetSpecs[_loadedInstrument];
    final shifted = base + (spec?.noteOffset ?? 0);
    // Clamp to valid MIDI range.
    if (shifted < 0 || shifted > 127) return null;
    return shifted;
  }

  Future<void> playNote({
    required int midiNote,
    required int channel,
    int velocity = 96,
  }) async {
    final instrument = _loadedInstrument;
    if (instrument == null) return;
    final sfId = _soundfontIds[instrument];
    if (sfId == null) return;
    await _midiPro.playNote(
      sfId: sfId,
      channel: channel,
      key: midiNote,
      velocity: velocity,
    );
  }

  Future<void> stopNote({
    required int midiNote,
    required int channel,
  }) async {
    final instrument = _loadedInstrument;
    if (instrument == null) return;
    final sfId = _soundfontIds[instrument];
    if (sfId == null) return;
    await _midiPro.stopNote(
      sfId: sfId,
      channel: channel,
      key: midiNote,
    );
  }

  Future<void> stopAllNotes() async {
    for (final sfId in _soundfontIds.values) {
      try {
        await _midiPro.stopAllNotes(sfId: sfId);
      } catch (_) {}
    }
  }

  Future<void> unload() async {
    await stopAllNotes();
    _loadedInstrument = null;
  }

  Future<void> dispose() async {
    await stopAllNotes();
    for (final sfId in _soundfontIds.values.toList()) {
      try {
        await _midiPro.unloadSoundfont(sfId);
      } catch (_) {}
    }
    _soundfontIds.clear();
    _loadedInstrument = null;
    try {
      await _midiPro.dispose();
    } catch (_) {}
  }
}
