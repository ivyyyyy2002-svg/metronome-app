import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:math' as math;

import 'metronome/metronome_music.dart';
import 'metronome/instrument_sf2_controller.dart';
import 'metronome/widgets/advanced_settings_drawer.dart';
import 'metronome/widgets/metronome_controls_panel.dart';
import 'metronome/widgets/meter_picker_sheet.dart';
import 'metronome/widgets/playback_status_panel.dart';
import 'metronome/widgets/transport_bar.dart';

enum ClickAccent { strong, secondary, weak }

// The MetronomeDemo widget
class MetronomeDemo extends StatefulWidget {
  const MetronomeDemo({super.key});
  @override
  State<MetronomeDemo> createState() => _MetronomeDemoState();
}

// The state for the MetronomeDemo widget
class _MetronomeDemoState extends State<MetronomeDemo>
    with SingleTickerProviderStateMixin {
  static const String _defaultStrongClickAsset = 'assets/sounds/click_hi.wav';
  static const String _defaultWeakClickAsset = 'assets/sounds/click_lo.wav';
  static const int _assetMinOctave = 2;
  static const int _assetMaxOctave = 6;

  // Animation for pendulum swing
  late final AnimationController swingController;
  late Animation<double> swingAnim;

  // Metronome state
  int beat = 0;
  int bpm = 60; // Beats per minute
  Timer? timer;

  // just_audio players
  final AudioPlayer clickStrongPlayer = AudioPlayer();
  final AudioPlayer clickWeakPlayer = AudioPlayer();
  final InstrumentSf2Controller instrumentSf2Controller = InstrumentSf2Controller(
    channelCount: notePoolSize,
    assetSpecs: const {
      'piano': Sf2Spec(assetPath: 'assets/sf2/piano.sf2', bank: 0, program: 0),
      'guzheng': Sf2Spec(assetPath: 'assets/sf2/guzheng.sf2', bank: 1, program: 107),
    },
  );
  String clickStrongAsset = _defaultStrongClickAsset;
  String clickWeakAsset = _defaultWeakClickAsset;

  // Note player pool to allow overlapping notes without cutting off
  static const int notePoolSize = 12;
  late final List<AudioPlayer> notePlayers;
  int notePoolIndex = 0;
  double noteGate = 0.9; // how long the note plays before cutting off
  final List<int> playerTokens = List.filled(
    notePoolSize,
    0,
  ); // for tracking which player is playing which note

  bool enableClick = true; // Enable click sound
  bool enableSound = true; // Enable musical sound

  // Musical note sequence
  List<String> noteSequence = [];
  int noteIndex = 0;

  String currentSound = '';
  bool configLoaded = false;

  // preload flags
  bool clickReady = false;
  Future<void>? _clickPreloadFuture;

  // Available instruments
  final List<String> instruments = ['piano', 'harmonium', 'guzheng'];
  final Map<String, bool> instrumentAvailability = {};
  String selectedInstrument = 'piano';

  // base octave
  int baseOctave = 3;
  int minOctave = _assetMinOctave;
  int maxOctave = _assetMaxOctave;
  int octaveCount = 2;
  int octaveShift = 0;
  double baseFrequencyHz = 220.0;

  // --- cache to avoid rebuilding/setting source every beat ---
  final Map<String, AudioSource> _noteSourceCache = {};
  bool _noteReady = false;

  // --- timing state for stable ticks (avoid Timer.periodic jitter) ---
  int _tickGen = 0;
  int _intervalMs = 1000;

  // --- Per-note preloaded players to avoid setAudioSource on every beat ---
  final Map<String, AudioPlayer> _perNotePlayers = {};
  final Map<String, int> _perNoteTokens = {};
  final bool _usePerNotePlayers = false;
  int? activeSf2MidiNote;
  bool _sf2TestInProgress = false;

  // SF2 (flutter_midi_pro) reaches the speakers faster than just_audio clicks
  // on iOS, which makes notes sound like they "rush" the beat. Delay SF2
  // triggers slightly to compensate. Tune if click/SF2 still feel misaligned.
  static const int sf2LatencyOffsetMs = 55;

  int uiUpdateEvery = 4;

  // Time signature (meter): beats per bar / beat unit
  int timeSignatureBeats = 4;
  int timeSignatureNote = 4;
  BeatUnit beatUnit = BeatUnit.quarter;

  // --- UI-only notifier to refresh the current note every tick without rebuilding the whole widget tree ---
  final ValueNotifier<String> currentSoundVN = ValueNotifier<String>('');

  // ---------- Initialization ----------
  @override
  void initState() {
    super.initState();
    // Initialize the swing animation controller and animation
    swingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (60000 / bpm).round()),
    );

    swingAnim = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: swingController, curve: Curves.easeInOut),
    );

    // Initialize the note players pool
    notePlayers = List.generate(notePoolSize, (_) => AudioPlayer());
    for (int i = 0; i < notePoolSize; i++) {
      notePlayers[i].playerStateStream.listen((state) {
        // (kept) listener exists, but we don't reset tokens here;
        // tokens are used to cancel scheduled gates safely.
      });
    }

    _initAudio(); // session setup
    _loadStartupData();
  }

  Future<void> _loadStartupData() async {
    await loadConfig();
    await loadNoteSequence();
  }

  // ---------- Audio Session ----------
  Future<void> _initAudio() async {
    // Make iOS allow 2 players (click + note) without one stealing the session
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: false,
      ),
    );
  }

  // ---------- Config ----------
  Future<void> loadConfig() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/config/scale_config.json',
      );
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      final loadedBaseOctave = (data['baseoctave'] is int)
          ? data['baseoctave'] as int
          : baseOctave;
      final loadedOctaveCount =
          (data['octaveCount'] is int && data['octaveCount'] > 0)
          ? data['octaveCount'] as int
          : octaveCount;
      final loadedBaseFrequencyHz = _parsePositiveDouble(
        data['baseFrequencyHz'],
      );

      final loadedTimeSignature = _parseTimeSignature(
        data['timeSignature'],
        fallbackBeats: 4,
        fallbackNote: 4,
      );
      final loadedClickAssets = _parseClickAssets(data['clickAssets']);
      final loadedBeatUnit = parseBeatUnit(
        data['beatUnit'],
        fallbackBeats: loadedTimeSignature.$1,
        fallbackNote: loadedTimeSignature.$2,
      );

      // Debug print loaded values before applying
      setState(() {
        baseOctave = loadedBaseOctave;
        octaveCount = loadedOctaveCount;
        octaveShift = 0;
        _syncOctaveBounds();
        timeSignatureBeats = loadedTimeSignature.$1;
        timeSignatureNote = loadedTimeSignature.$2;
        beatUnit = loadedBeatUnit;
        clickStrongAsset = loadedClickAssets.$1;
        clickWeakAsset = loadedClickAssets.$2;
        uiUpdateEvery = 1;

        if (loadedBaseFrequencyHz != null) {
          baseFrequencyHz = loadedBaseFrequencyHz;
          _setBaseFromFrequencyNoSetState(baseFrequencyHz);
        } else {
          _syncBaseFrequencyFromAnchor();
        }

        configLoaded = true;
        _refreshCurrentSoundPreview();
      });

      await preloadClick();

      // Debug once (helps verify pattern is not stuck)
      debugPrint(
        'Loaded config: baseOctave=$baseOctave octaveCount=$octaveCount baseFrequencyHz=${baseFrequencyHz.toStringAsFixed(2)} timeSignature=$timeSignatureBeats/$timeSignatureNote beatUnit=${beatUnitConfigValue(beatUnit)} clickAssets=[$clickStrongAsset,$clickWeakAsset]',
      );
    } catch (e, st) {
      debugPrint('Failed to load config: $e');
      debugPrintStack(stackTrace: st);
      setState(() {
        configLoaded = false;
        currentSound = 'Config load failed';
      });
      currentSoundVN.value = currentSound;
    }
  }

  // Load note sequence from a text file, filtering for valid note letters (A-G)
  Future<void> loadNoteSequence() async {
    try {
      final text = await rootBundle.loadString(
        'assets/config/noteSequence.txt',
      );
      final loadedSequence = text
          .toUpperCase()
          .split('')
          .where((letter) => RegExp(r'[A-G]').hasMatch(letter))
          .toList(growable: false);
      setState(() {
        noteSequence = loadedSequence;
        noteIndex = 0;
        _setBaseFromFrequencyNoSetState(baseFrequencyHz);
        _refreshCurrentSoundPreview();
      });
      await _refreshInstrumentAvailability();
      await _warmUpCurrentNote();
      if (_usePerNotePlayers) {
        await _preloadAllNotesForSequence();
      } else {
        await _precacheSourcesForSequence();
      }
      debugPrint('Loaded note sequence: $noteSequence');
    } catch (e, st) {
      debugPrint('Failed to load note sequence: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  double? _parsePositiveDouble(dynamic raw) {
    if (raw is num && raw > 0) return raw.toDouble();
    return null;
  }

  void _syncOctaveBounds() {
    final maxCount = _assetMaxOctave - _assetMinOctave + 1;
    octaveCount = octaveCount.clamp(1, maxCount).toInt();
    final maxBase = _assetMaxOctave - octaveCount + 1;
    baseOctave = baseOctave.clamp(_assetMinOctave, maxBase).toInt();
    minOctave = baseOctave;
    maxOctave = baseOctave + octaveCount - 1;
  }

  int _clampPlayableOctave(int octave) {
    return octave.clamp(minOctave, maxOctave).toInt();
  }

  String _anchorNoteToken() {
    if (noteSequence.isEmpty) return 'A';
    return noteSequence.first;
  }

  String _noteNameFromToken(String token) {
    final parsed = _parseNoteWithOctave(token);
    return parsed?.note ?? token.trim();
  }

  double? _frequencyForNote(String note, int octave) {
    final semitone = noteToSemitone[note];
    if (semitone == null) return null;
    final midi = (octave + 1) * 12 + semitone;
    return 440.0 * math.pow(2.0, (midi - 69) / 12.0).toDouble();
  }

  bool _useSf2ForCurrentInstrument() {
    return instrumentSf2Controller.isReadyFor(selectedInstrument);
  }

  // Find the nearest base octave that allows the anchor note to be as close as possible to the target frequency
  int _nearestBaseOctaveForFrequency(
    String note,
    double targetHz,
    int fallbackBase,
  ) {
    final semitone = noteToSemitone[note];
    if (semitone == null) return fallbackBase;

    final int maxBase = _assetMaxOctave - octaveCount + 1;
    int bestOctave = fallbackBase.clamp(_assetMinOctave, maxBase).toInt();
    double bestDiff = double.infinity;

    for (int octave = _assetMinOctave; octave <= maxBase; octave++) {
      final freq = _frequencyForNote(note, octave);
      if (freq == null) continue;
      final diff = (freq - targetHz).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        bestOctave = octave;
      }
    }
    return bestOctave;
  }

  // Set base octave based on a target frequency for the anchor note, without calling setState (used during config load and when changing base frequency)
  void _setBaseFromFrequencyNoSetState(double targetHz) {
    if (noteSequence.isEmpty) return;
    final anchorToken = _anchorNoteToken();
    final anchorNote = _noteNameFromToken(anchorToken);
    final parsedAnchor = _parseNoteWithOctave(anchorToken);
    final targetBase = _nearestBaseOctaveForFrequency(
      anchorNote,
      targetHz,
      baseOctave,
    );

    baseOctave = targetBase;
    _syncOctaveBounds();
    octaveShift = parsedAnchor != null ? (baseOctave - parsedAnchor.octave) : 0;
  }

  void _syncBaseFrequencyFromAnchor() {
    if (noteSequence.isEmpty) return;
    final anchorToken = _anchorNoteToken();
    final full = _resolveFullNoteName(anchorToken, baseOctave);
    final parsed = _parseNoteWithOctave(full);
    if (parsed == null) return;
    final anchorHz = _frequencyForNote(parsed.note, parsed.octave);
    if (anchorHz != null) {
      baseFrequencyHz = anchorHz;
    }
  }

  // Resolve a full note name with octave based on a token, base octave, and step number (for octave shifts)
  void _refreshCurrentSoundPreview() {
    if (noteSequence.isEmpty) {
      currentSound = '';
      currentSoundVN.value = currentSound;
      return;
    }

    currentSound = _resolveFullNoteName(noteSequence.first, baseOctave);
    currentSoundVN.value = currentSound;
  }

  // Change the number of octaves in the playable range, adjusting the base octave if necessary to stay within asset limits, and refreshing the current sound preview
  Future<void> _setOctaveCount(int newCount) async {
    final safeCount = newCount
        .clamp(1, _assetMaxOctave - _assetMinOctave + 1)
        .toInt();
    if (safeCount == octaveCount) return;
    setState(() {
      octaveCount = safeCount;
      _setBaseFromFrequencyNoSetState(baseFrequencyHz);
      beat = 0;
      noteIndex = 0;
      _refreshCurrentSoundPreview();
    });
    await _refreshInstrumentAvailability();
    _restartIfRunning();
  }

  Future<void> _applyBaseFrequency(double newFrequencyHz) async {
    final clampedHz = newFrequencyHz.clamp(55.0, 880.0).toDouble();
    setState(() {
      baseFrequencyHz = clampedHz;
      _setBaseFromFrequencyNoSetState(baseFrequencyHz);
      beat = 0;
      noteIndex = 0;
      _refreshCurrentSoundPreview();
    });
    await _refreshInstrumentAvailability();
    _restartIfRunning();
  }

  List<String> _sampleSequenceNotesForProbe({int maxNotes = 12}) {
    final notes = <String>{};
    if (noteSequence.isNotEmpty) {
      final limit = math.min(maxNotes, noteSequence.length);
      for (int step = 0; step < limit; step++) {
        notes.add(_resolveFullNoteName(noteSequence[step], baseOctave));
      }
    }

    return notes.toList(growable: false);
  }

  // Check if the given instrument has at least one playable asset based on the current sequence (used to determine availability in the picker)
  Future<bool> _instrumentHasPlayableAsset(String instrument) async {
    if (await instrumentSf2Controller.hasSoundfontAsset(instrument)) {
      return true;
    }

    final probeNotes = _sampleSequenceNotesForProbe();
    for (final fullNote in probeNotes) {
      final path = 'assets/notes/$instrument/$fullNote.wav';
      try {
        await rootBundle.load(path);
        return true;
      } catch (_) {}
    }
    return false;
  }

  Future<void> _runSf2SmokeTest() async {
    if (_sf2TestInProgress) return;

    setState(() => _sf2TestInProgress = true);
    try {
      final hasSoundfont = await instrumentSf2Controller.hasSoundfontAsset(
        selectedInstrument,
      );
      if (!hasSoundfont) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No SF2 asset found for $selectedInstrument'),
          ),
        );
        return;
      }

      await instrumentSf2Controller.prepareForInstrument(selectedInstrument);
      if (!instrumentSf2Controller.isReadyFor(selectedInstrument)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SF2 did not become ready for $selectedInstrument'),
          ),
        );
        return;
      }

      const int midiNote = 60; // C4
      await instrumentSf2Controller.playNote(
        midiNote: midiNote,
        channel: 0,
        velocity: 108,
      );
      await Future.delayed(const Duration(milliseconds: 700));
      await instrumentSf2Controller.stopNote(
        midiNote: midiNote,
        channel: 0,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SF2 test played C4 for $selectedInstrument'),
        ),
      );
    } catch (e, st) {
      debugPrint('SF2 smoke test failed: $e');
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SF2 test failed for $selectedInstrument'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sf2TestInProgress = false);
      }
    }
  }

  Future<void> _refreshInstrumentAvailability() async {
    final nextAvailability = <String, bool>{};
    for (final instrument in instruments) {
      nextAvailability[instrument] = await _instrumentHasPlayableAsset(
        instrument,
      );
    }

    if (!mounted) return;
    setState(() {
      instrumentAvailability
        ..clear()
        ..addAll(nextAvailability);
    });

    if (!(instrumentAvailability[selectedInstrument] ?? false)) {
      String? fallback;
      for (final entry in instrumentAvailability.entries) {
        if (entry.value) {
          fallback = entry.key;
          break;
        }
      }
      if (fallback != null) {
        await _onInstrumentChanged(fallback);
      }
    }
  }

  // Parse time signature from config, with validation and fallbacks
  (int, int) _parseTimeSignature(
    dynamic raw, {
    required int fallbackBeats,
    required int fallbackNote,
  }) {
    if (raw is Map<String, dynamic>) {
      final beats = raw['beats'];
      final note = raw['note'];
      final b = (beats is int && beats > 0) ? beats : fallbackBeats;
      final n = (note is int && note > 0) ? note : fallbackNote;
      return (b, n);
    }
    return (fallbackBeats, fallbackNote);
  }

  // Parse click asset paths from config, with validation and fallbacks
  (String, String) _parseClickAssets(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final strong = raw['strong'];
      final weak = raw['weak'];
      return (
        strong is String && strong.isNotEmpty
            ? strong
            : _defaultStrongClickAsset,
        weak is String && weak.isNotEmpty ? weak : _defaultWeakClickAsset,
      );
    }
    return (_defaultStrongClickAsset, _defaultWeakClickAsset);
  }

  // Get the index of the current time signature in the options list, for initializing the picker
  int _timeSignatureIndex() {
    final key = '$timeSignatureBeats/$timeSignatureNote';
    final idx = timeSignatureOptions.indexOf(key);
    return idx >= 0 ? idx : timeSignatureOptions.indexOf('4/4');
  }

  int _beatUnitIndex() {
    final idx = BeatUnit.values.indexOf(beatUnit);
    return idx >= 0 ? idx : BeatUnit.values.indexOf(BeatUnit.quarter);
  }

  void _applyMeterSelection(int tsIndex, int unitIndex) {
    final selectedTimeSignature = timeSignatureOptions[tsIndex];
    final parts = selectedTimeSignature.split('/');
    if (parts.length != 2) return;
    final parsedBeats = int.tryParse(parts[0]);
    final parsedNote = int.tryParse(parts[1]);
    if (parsedBeats == null || parsedNote == null) return;

    debugPrint(
      'Selected time signature: $parsedBeats/$parsedNote, beat unit: ${BeatUnit.values[unitIndex]}',
    );
    setState(() {
      timeSignatureBeats = parsedBeats;
      timeSignatureNote = parsedNote;
      beatUnit = BeatUnit.values[unitIndex];
      beat = 0;
    });
    _restartIfRunning();
  }

  // Open the bottom sheet for picking time signature and beat unit, with scrollable pickers and a preview of the current selection
  Future<void> _openMeterPickerSheet() async {
    await showMeterPickerSheet(
      context: context,
      timeSignatureOptions: timeSignatureOptions,
      beatUnitLabels: [
        for (final unit in BeatUnit.values) beatUnitLabel(unit),
      ],
      initialTimeSignatureIndex: _timeSignatureIndex(),
      initialBeatUnitIndex: _beatUnitIndex(),
      onSelectionChanged: (selection) {
        _applyMeterSelection(selection.$1, selection.$2);
      },
    );
  }

  int _computeTickIntervalMs() {
    final double displayedBeatLength = 1.0 / timeSignatureNote;
    final double beatUnitLength = beatUnitWholeNoteLength(beatUnit);
    final double intervalMs =
        (60000.0 / bpm) * (displayedBeatLength / beatUnitLength);
    return intervalMs.round().clamp(40, 4000);
  }

  void _restartIfRunning() {
    if (timer != null) {
      stop().then((_) {
        if (mounted) start();
      });
    }
  }

  // ---------- Audio (just_audio) ----------
  Future<void> preloadClick() async {
    if (_clickPreloadFuture != null) {
      await _clickPreloadFuture;
      return;
    }
    final completer = Completer<void>();
    _clickPreloadFuture = completer.future;
    try {
      await _loadClickWithFallback(clickStrongPlayer, clickStrongAsset);
      await _loadClickWithFallback(clickWeakPlayer, clickWeakAsset);
      clickStrongPlayer.setVolume(1.0);
      clickWeakPlayer.setVolume(0.65);
      clickReady = true;
    } catch (e, st) {
      debugPrint('Click preload failed: $e');
      debugPrintStack(stackTrace: st);
      clickReady = false;
    } finally {
      completer.complete();
      _clickPreloadFuture = null;
      if (mounted) setState(() {});
    }
  }

  Future<void> _loadClickWithFallback(
    AudioPlayer player,
    String preferredAsset,
  ) async {
    try {
      await player.setAsset(preferredAsset);
      return;
    } catch (_) {
      try {
        await player.setAsset(_defaultWeakClickAsset);
        return;
      } catch (_) {
        await player.setAsset(_defaultStrongClickAsset);
      }
    }
  }

  // Determine the accent type for a given beat position in the bar
  ClickAccent _accentForBeatPosition(int beatInBar) {
    if (beatInBar == 1) return ClickAccent.strong;

    // Compound meters: 6/8, 9/8, 12/8 and 6/16, 9/16, 12/16
    if ((timeSignatureNote == 8 || timeSignatureNote == 16) &&
        timeSignatureBeats >= 6 &&
        timeSignatureBeats % 3 == 0) {
      return ((beatInBar - 1) % 3 == 0)
          ? ClickAccent.secondary
          : ClickAccent.weak;
    }

    if (timeSignatureBeats == 4) {
      return beatInBar == 3 ? ClickAccent.secondary : ClickAccent.weak;
    }

    if (timeSignatureBeats == 5) {
      return beatInBar == 4 ? ClickAccent.secondary : ClickAccent.weak;
    }

    if (timeSignatureBeats == 7) {
      return beatInBar == 5 ? ClickAccent.secondary : ClickAccent.weak;
    }

    if (timeSignatureBeats >= 6 && timeSignatureBeats.isEven) {
      return beatInBar == (timeSignatureBeats ~/ 2) + 1
          ? ClickAccent.secondary
          : ClickAccent.weak;
    }

    return ClickAccent.weak;
  }

  Future<void> _pauseClickPlayers() async {
    for (final p in [clickStrongPlayer, clickWeakPlayer]) {
      try {
        await p.pause();
        await p.seek(Duration.zero);
      } catch (_) {}
    }
  }

  Future<void> playClickForBeat(int beatInBar) async {
    if (!clickReady) {
      await preloadClick();
      if (!clickReady) return;
    }

    final accent = _accentForBeatPosition(beatInBar);
    final (AudioPlayer player, double volume) = switch (accent) {
      ClickAccent.strong => (clickStrongPlayer, 1.0),
      ClickAccent.secondary => (clickStrongPlayer, 0.82),
      ClickAccent.weak => (clickWeakPlayer, 0.65),
    };

    try {
      // more reliable for short sounds than just seek+play
      player.setVolume(volume);
      await player.seek(Duration.zero);
      await player.play();
    } catch (e, st) {
      debugPrint('Failed to play click: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  // Prepare and cache AudioSource for a note, only set when path changes.
  Future<void> _prepareNoteIfNeeded(
    AudioPlayer player,
    String fullNoteName, {
    bool preload = false,
  }) async {
    final path = 'assets/notes/$selectedInstrument/$fullNoteName.wav';

    try {
      final source = _noteSourceCache.putIfAbsent(
        path,
        () => AudioSource.asset(path),
      );

      // Only set when this player is not already using this source
      if (player.audioSource != source) {
        await player.setAudioSource(source, preload: preload);
      }

      _noteReady = true;
    } catch (e, st) {
      _noteReady = false;
      debugPrint('Prepare note failed: $fullNoteName ($path) -> $e');
      debugPrintStack(stackTrace: st);
    }
  }

  // Fade out the player volume over releaseMs milliseconds, then pause and reset it
  Future<void> _fadeOutAndPause(
    AudioPlayer player, {
    int releaseMs = 40,
  }) async {
    try {
      const int steps = 5;
      final double startVol = player.volume;
      for (int i = 1; i <= steps; i++) {
        await Future.delayed(
          Duration(milliseconds: (releaseMs / steps).round()),
        );
        player.setVolume(startVol * (1.0 - i / steps));
      }
      await player.pause();
      await player.seek(Duration.zero);
      player.setVolume(1.0);
    } catch (_) {}
  }

  // Release all note players by fading out and pausing
  Future<void> _releaseAllNotePlayers({
    int releaseMs = 70,
  }) async {
    for (int i = 0; i < notePlayers.length; i++) {
      playerTokens[i]++;
    }

    for (final key in _perNotePlayers.keys) {
      _perNoteTokens[key] = (_perNoteTokens[key] ?? 0) + 1;
    }

    await instrumentSf2Controller.stopAllNotes();
    activeSf2MidiNote = null;

    await Future.wait([
      for (final player in notePlayers) _fadeOutAndPause(player, releaseMs: releaseMs),
      for (final player in _perNotePlayers.values)
        _fadeOutAndPause(player, releaseMs: releaseMs),
    ]);
  }

  // Parse a token like "Bb2", "C#4", "F3" into (note, octave).
  // Returns null if the token does not contain an octave suffix.
  ({String note, int octave})? _parseNoteWithOctave(String token) {
    final m = RegExp(r'^([A-G](?:#|b)?)(\d+)$').firstMatch(token.trim());
    if (m == null) return null;
    return (note: m.group(1)!, octave: int.parse(m.group(2)!));
  }

  // Resolve a note token to a full note name like "Bb2".
  String _resolveFullNoteName(String token, int octaveFallback) {
    final parsed = _parseNoteWithOctave(token);
    if (parsed != null) {
      final adjustedOctave = _clampPlayableOctave(parsed.octave + octaveShift);
      return '${parsed.note}$adjustedOctave';
    }

    final resolvedOctave = _clampPlayableOctave(octaveFallback + octaveShift);
    return '$token$resolvedOctave';
  }

  // Ensure a per-note AudioPlayer is ready for the given full note name.
  Future<void> _ensurePerNotePlayerReady(String fullNoteName) async {
    final existing = _perNotePlayers[fullNoteName];
    if (existing != null) return;

    final p = AudioPlayer();
    final path = 'assets/notes/$selectedInstrument/$fullNoteName.wav';
    try {
      await p.setAsset(path);
      _perNotePlayers[fullNoteName] = p;
      _perNoteTokens[fullNoteName] = 0;
    } catch (e, st) {
      debugPrint('Per-note preload failed: $fullNoteName ($path) -> $e');
      debugPrintStack(stackTrace: st);
      try {
        await p.dispose();
      } catch (_) {}
    }
  }

  // Preload all unique notes referenced by noteSequence into per-note players.
  Future<void> _preloadAllNotesForSequence() async {
    if (!configLoaded || noteSequence.isEmpty) return;

    final unique = <String>{};
    for (final token in noteSequence) {
      unique.add(_resolveFullNoteName(token, baseOctave));
    }

    for (final full in unique) {
      await _ensurePerNotePlayerReady(full);
    }
  }

  Future<void> _disposePerNotePlayers() async {
    final players = _perNotePlayers.values.toList();
    _perNotePlayers.clear();
    _perNoteTokens.clear();
    for (final p in players) {
      try {
        await p.dispose();
      } catch (_) {}
    }
  }

  // Precache AudioSources for all unique notes in the sequence (for non-per-note player mode).
  Future<void> _precacheSourcesForSequence() async {
    if (!configLoaded || noteSequence.isEmpty) return;

    final uniquePaths = <String>{};
    for (final token in noteSequence) {
      final full = _resolveFullNoteName(token, baseOctave);
      uniquePaths.add('assets/notes/$selectedInstrument/$full.wav');
    }

    for (final path in uniquePaths) {
      _noteSourceCache.putIfAbsent(path, () => AudioSource.asset(path));
    }
  }

  Future<void> _warmUpCurrentNote() async {
    if (currentSound.isEmpty || _usePerNotePlayers || _useSf2ForCurrentInstrument()) {
      return;
    }
    final player = notePlayers[notePoolIndex];
    notePoolIndex = (notePoolIndex + 1) % notePoolSize;
    await _prepareNoteIfNeeded(player, currentSound, preload: true);
  }

  // Play note by name and octave
  Future<void> playNoteByName(String note, int octave) async {
    if (_useSf2ForCurrentInstrument()) {
      final midiNote = instrumentSf2Controller.midiNoteFor(
        note,
        octave,
        noteToSemitone,
      );
      if (midiNote == null) return;

      const int channel = 0;
      final int token = ++playerTokens[channel];

      try {
        final previousMidiNote = activeSf2MidiNote;
        if (previousMidiNote != null && previousMidiNote != midiNote) {
          try {
            await instrumentSf2Controller.stopNote(
              midiNote: previousMidiNote,
              channel: channel,
            );
          } catch (_) {}
        }

        // Delay SF2 trigger to align with the slower just_audio click path.
        Future<void> firePlayNote() async {
          if (playerTokens[channel] != token) return;
          await instrumentSf2Controller.playNote(
            midiNote: midiNote,
            channel: channel,
          );
          activeSf2MidiNote = midiNote;
        }

        if (sf2LatencyOffsetMs > 0) {
          Timer(Duration(milliseconds: sf2LatencyOffsetMs), firePlayNote);
        } else {
          await firePlayNote();
        }

        final int beatMs = _intervalMs;
        final int gateMs = math.max(
          80,
          math.min(320, (beatMs * noteGate).round()),
        );
        final int totalGateMs = gateMs + sf2LatencyOffsetMs;

        Timer(Duration(milliseconds: totalGateMs), () async {
          if (playerTokens[channel] != token) return;
          try {
            await instrumentSf2Controller.stopNote(
              midiNote: midiNote,
              channel: channel,
            );
            if (activeSf2MidiNote == midiNote) {
              activeSf2MidiNote = null;
            }
          } catch (_) {}
        });
      } catch (e, st) {
        debugPrint('Failed to play SF2 note $note$octave (midi=$midiNote): $e');
        debugPrintStack(stackTrace: st);
      }
      return;
    }

    // Prefer per-note players: avoids setAudioSource each tick at high BPM
    if (_usePerNotePlayers) {
      final fullNoteName = '$note$octave';
      await _ensurePerNotePlayerReady(fullNoteName);
      final player = _perNotePlayers[fullNoteName];
      if (player == null) return;

      final int token = (_perNoteTokens[fullNoteName] ?? 0) + 1;
      _perNoteTokens[fullNoteName] = token;

      try {
        await player.seek(Duration.zero);
        await player.play();

        // Schedule stop after gate duration
        final int beatMs = _intervalMs;
        final int gateMs = math.max(
          80,
          math.min(220, (beatMs * noteGate).round()),
        );

        Timer(Duration(milliseconds: gateMs), () {
          if ((_perNoteTokens[fullNoteName] ?? 0) != token) return;
          _fadeOutAndPause(player);
        });
      } catch (e, st) {
        final path = 'assets/notes/$selectedInstrument/$note$octave.wav';
        debugPrint('Failed to play note $note$octave ($path): $e');
        debugPrintStack(stackTrace: st);
      }
      return;
    }

    final int playerIndex = notePoolIndex;
    notePoolIndex = (notePoolIndex + 1) % notePoolSize;
    final AudioPlayer player = notePlayers[playerIndex];

    // Increment token for this player
    final int token = ++playerTokens[playerIndex];

    try {
      // No stop: allows overlapping notes without cutting off
      await _prepareNoteIfNeeded(player, '$note$octave', preload: false);
      if (!_noteReady) return;

      await player.seek(Duration.zero);
      await player.play();

      // Schedule stop after gate duration
      final int beatMs = _intervalMs;
      final int gateMs = math.max(
        80,
        math.min(220, (beatMs * noteGate).round()),
      );

      Timer(Duration(milliseconds: gateMs), () {
        // Only stop if this player is still playing the same note (token matches)
        if (playerTokens[playerIndex] != token) return;
        _fadeOutAndPause(player);
      });
    } catch (e, st) {
      final path = 'assets/notes/$selectedInstrument/$note$octave.wav';
      debugPrint('Failed to play note $note$octave ($path): $e');
      debugPrintStack(stackTrace: st);
    }
  }

  // Handle instrument change: clear caches, dispose players, and preload for new instrument
  Future<void> _onInstrumentChanged(String newInstrument) async {
    if (instrumentAvailability.isNotEmpty &&
        !(instrumentAvailability[newInstrument] ?? false)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No playable assets found for $newInstrument'),
          ),
        );
      }
      return;
    }

    setState(() => selectedInstrument = newInstrument);

    _noteReady = false;
    _noteSourceCache.clear();

    // Rebuild per-note players for the new instrument
    if (_usePerNotePlayers) {
      await _disposePerNotePlayers();
      await _preloadAllNotesForSequence();
    } else {
      await _precacheSourcesForSequence();
    }

    // Warm up current sound again
    if (currentSound.isNotEmpty &&
        !_usePerNotePlayers &&
        !_useSf2ForCurrentInstrument()) {
      final player = notePlayers[notePoolIndex];
      notePoolIndex = (notePoolIndex + 1) % notePoolSize;
      await _prepareNoteIfNeeded(player, currentSound, preload: true);
    }
  }

  // ---------- Control ----------
  void changeBPM(int delta) {
    // Apply delta and clamp BPM within 30-240
    setState(() {
      bpm += delta;
      if (bpm < 30) bpm = 30;
      if (bpm > 240) bpm = 240;
    });

    _restartIfRunning();
  }

  // Apply new BPM value, update animation and timer if running
  void _applyBpm(int newBpm) {
    setState(() {
      bpm = newBpm.clamp(30, 240);
    });

    // Update swing animation duration
    swingController.duration = Duration(milliseconds: _computeTickIntervalMs());

    // If timer is running, restart it with new BPM
    _restartIfRunning();
  }

  void _onTick() {
    if (noteSequence.isEmpty) return;

    final token = noteSequence[noteIndex];
    final resolvedFull = _resolveFullNoteName(token, baseOctave);
    final resolvedParsed = _parseNoteWithOctave(resolvedFull);
    if (resolvedParsed == null) return;

    final String noteToPlay = resolvedParsed.note;
    final int octaveToPlay = resolvedParsed.octave;

    beat++;
    noteIndex = (noteIndex + 1) % noteSequence.length;
    final beatInBar = ((beat - 1) % timeSignatureBeats) + 1;

    currentSound = '$noteToPlay$octaveToPlay';
    currentSoundVN.value = currentSound;

    if (beat % uiUpdateEvery == 0) {
      setState(() {});
    }

    if (enableClick) {
      playClickForBeat(beatInBar);
    }
    if (enableSound) {
      playNoteByName(noteToPlay, octaveToPlay);
    }
  }

  // Start the metronome
  void start() {
    if (timer != null) return;
    if (!configLoaded) return;
    if (noteSequence.isEmpty) return;

    _intervalMs = _computeTickIntervalMs();
    final int gen = ++_tickGen;

    // Start the swing animation
    swingController.duration = Duration(milliseconds: _intervalMs);
    swingController.repeat(reverse: true);

    // Stable tick scheduling (avoids Timer.periodic jitter)
    final sw = Stopwatch()..start();
    int tickCount = 0;

    void scheduleNext() {
      if (_tickGen != gen) return;

      final int targetMs = tickCount * _intervalMs;
      final int nowMs = sw.elapsedMilliseconds;
      final int delayMs = math.max(0, targetMs - nowMs);

      timer = Timer(Duration(milliseconds: delayMs), () {
        if (_tickGen != gen) return;
        _onTick();
        tickCount++;
        scheduleNext();
      });
    }

    scheduleNext();
  }

  // Stop the metronome
  Future<void> stop() async {
    final oldTimer = timer;

    setState(() {
      timer = null;
    });

    _tickGen++; // cancel any scheduled chain
    oldTimer?.cancel();
    swingController.stop();

    await _pauseClickPlayers();
    await _releaseAllNotePlayers(releaseMs: 60);
  }

  // Reset to initial state
  Future<void> reset() async {
    await stop();
    swingController.reset();
    setState(() {
      beat = 0;
      noteIndex = 0;
      _refreshCurrentSoundPreview();
    });

    if (currentSound.isNotEmpty && !_usePerNotePlayers) {
      final player = notePlayers[notePoolIndex];
      notePoolIndex = (notePoolIndex + 1) % notePoolSize;
      await _prepareNoteIfNeeded(player, currentSound, preload: true);
    }
  }

  // ---------- UI ----------
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Generate a preview string for the loaded note sequence, showing the first few notes and total count
  String _sequencePreviewText() {
    if (noteSequence.isEmpty) return 'No sequence loaded';
    const int previewLimit = 24;
    final preview = noteSequence.take(previewLimit).join(' ');
    if (noteSequence.length <= previewLimit) return preview;
    return '$preview ...';
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = timer != null;
    final int beatsForDisplay = timeSignatureBeats;
    final int beatInBar = (beat == 0) ? 1 : ((beat - 1) % beatsForDisplay) + 1;
    final int beatNumerator = beatInBar;
    final int beatDenominator = timeSignatureNote;
    final beatIndicators = List.generate(beatsForDisplay, (i) {
      final accent = _accentForBeatPosition(i + 1);
      final isActive = (i + 1) == beatInBar;
      final Color activeColor = switch (accent) {
        ClickAccent.strong => Theme.of(context).colorScheme.primary,
        ClickAccent.secondary => Theme.of(context).colorScheme.secondary,
        ClickAccent.weak => Theme.of(context).colorScheme.tertiary,
      };
      final Color idleColor = switch (accent) {
        ClickAccent.strong => Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.35),
        ClickAccent.secondary => Theme.of(
          context,
        ).colorScheme.secondary.withValues(alpha: 0.28),
        ClickAccent.weak => Theme.of(context).colorScheme.outlineVariant,
      };
      return BeatIndicatorItem(
        isActive: isActive,
        activeColor: activeColor,
        idleColor: idleColor,
      );
    });
    final instrumentItems = instruments.map((ins) {
      final hasAssets = instrumentAvailability[ins] ?? true;
      final label = hasAssets ? ins : '$ins (missing)';
      return DropdownMenuItem(
        value: ins,
        enabled: hasAssets,
        child: Text(label),
      );
    }).toList(growable: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Metronome'),
        actions: [
          TextButton.icon(
            onPressed: _sf2TestInProgress ? null : _runSf2SmokeTest,
            icon: const Icon(Icons.music_note_rounded),
            label: Text(_sf2TestInProgress ? 'Testing...' : 'SF2 Test'),
          ),
          IconButton(
            tooltip: 'Advanced',
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: AdvancedSettingsDrawer(
          baseFrequencyHz: baseFrequencyHz,
          octaveCount: octaveCount,
          minOctave: minOctave,
          maxOctave: maxOctave,
          maxOctaveCount: _assetMaxOctave - _assetMinOctave + 1,
          onBaseFrequencyChanged: (v) {
            setState(() => baseFrequencyHz = v);
          },
          onBaseFrequencyChangeEnd: (v) => _applyBaseFrequency(v),
          onDecreaseOctaveCount: octaveCount <= 1
              ? null
              : () => _setOctaveCount(octaveCount - 1),
          onIncreaseOctaveCount:
              octaveCount >= (_assetMaxOctave - _assetMinOctave + 1)
              ? null
              : () => _setOctaveCount(octaveCount + 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PlaybackStatusPanel(
                        anim: swingAnim,
                        isRunning: isRunning,
                        beatNumerator: beatNumerator,
                        beatDenominator: beatDenominator,
                        bpm: bpm,
                        beatIndicators: beatIndicators,
                      ),
                      const SizedBox(height: 14),
                      MetronomeControlsPanel(
                        noteCount: noteSequence.length,
                        currentSoundListenable: currentSoundVN,
                        sequencePreviewText: _sequencePreviewText(),
                        bpm: bpm,
                        enableClick: enableClick,
                        enableSound: enableSound,
                        onBpmChanged: (v) {
                          setState(() => bpm = v.round());
                        },
                        onBpmChangeEnd: (v) {
                          _applyBpm(v.round());
                        },
                        onClickToggle: (v) async {
                          setState(() => enableClick = v);
                          if (!v) {
                            await _pauseClickPlayers();
                          }
                        },
                        onSoundToggle: (v) async {
                          setState(() => enableSound = v);
                          if (!v) {
                            await _releaseAllNotePlayers();
                          }
                        },
                        onMeterTap: _openMeterPickerSheet,
                        meterLabel:
                            '$timeSignatureBeats/$timeSignatureNote · ${beatUnitLabel(beatUnit)}',
                        selectedInstrument: selectedInstrument,
                        instrumentItems: instrumentItems,
                        onInstrumentChanged: (v) {
                          if (v == null) return;
                          _onInstrumentChanged(v);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TransportBar(
              isRunning: isRunning,
              onStart: start,
              onStop: () => stop(),
              onReset: reset,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    clickStrongPlayer.dispose();
    clickWeakPlayer.dispose();
    instrumentSf2Controller.dispose();
    for (final p in notePlayers) {
      p.dispose();
    }
    _disposePerNotePlayers();
    currentSoundVN.dispose();
    swingController.dispose();
    super.dispose();
  }
}
