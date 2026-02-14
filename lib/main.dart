import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:math' as math;

enum ClickAccent { strong, secondary, weak }

enum BeatUnit {
  half,
  quarter,
  eighth,
  sixteenth,
  dottedHalf,
  dottedQuarter,
  dottedEighth,
}

void main() {
  runApp(const MyApp());
}

// The main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metronome Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MetronomeDemo(),
    );
  }
}

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
  static const Map<String, int> _noteToSemitone = {
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
  static const List<String> _timeSignatureOptions = [
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

  // Musical scale and patterns
  List<String> scale = [];
  List<int> ascending = [];
  List<int> descending = [];

  List<int> playPattern = [];
  int playIndex = 0;
  int stepCounter = 0;

  int stepsUp = 0;
  int stepsDown = 0;
  bool useDescending = false;

  String currentSound = '';
  bool configLoaded = false;

  // preload flags
  bool clickReady = false;
  Future<void>? _clickPreloadFuture;

  // Available instruments
  final List<String> instruments = ['piano', 'flute', 'sine'];
  final Map<String, bool> instrumentAvailability = {};
  String selectedInstrument = 'piano';

  // base octave
  int baseOctave = 3;
  int minOctave = _assetMinOctave;
  int maxOctave = _assetMaxOctave;
  int octaveCount = 2;
  int octaveShift = 0;
  int _octaveStepSpan = 1;
  double baseFrequencyHz = 220.0;

  // --- cache to avoid rebuilding/setting source every beat ---
  String? _lastNotePath;
  final Map<String, AudioSource> _noteSourceCache = {};
  bool _noteReady = false;

  // --- timing state for stable ticks (avoid Timer.periodic jitter) ---
  int _tickGen = 0;
  int _intervalMs = 1000;

  // --- Per-note preloaded players to avoid setAudioSource on every beat ---
  final Map<String, AudioPlayer> _perNotePlayers = {};
  final Map<String, int> _perNoteTokens = {};
  bool _usePerNotePlayers = false;

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
    loadConfig();
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

      final loadedScale = List<String>.from(data['scale'] ?? const <String>[]);
      final loadedAsc = List<int>.from(data['ascending'] ?? const <int>[]);
      final loadedDesc = List<int>.from(data['descending'] ?? const <int>[]);
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

      // safer: if steps missing or <=0, fall back to pattern length
      final rawStepsUp = data['stepsUp'];
      final rawStepsDown = data['stepsDown'];
      final rawSequenceLength = data['sequenceLength'];

      final loadedStepsUp = (rawSequenceLength is int && rawSequenceLength > 0)
          ? rawSequenceLength
          : (rawStepsUp is int && rawStepsUp > 0)
          ? rawStepsUp
          : loadedAsc.length;
      final loadedStepsDown = (rawStepsDown is int && rawStepsDown > 0)
          ? rawStepsDown
          : loadedDesc.length;

      final loadedUseDescending = (data['useDescending'] ?? true) as bool;
      final loadedTimeSignature = _parseTimeSignature(
        data['timeSignature'],
        fallbackBeats: 4,
        fallbackNote: 4,
      );
      final loadedClickAssets = _parseClickAssets(data['clickAssets']);
      final loadedBeatUnit = _parseBeatUnit(
        data['beatUnit'],
        fallbackBeats: loadedTimeSignature.$1,
        fallbackNote: loadedTimeSignature.$2,
      );

      // Debug print loaded values before applying
      setState(() {
        scale = loadedScale;
        ascending = loadedAsc;
        descending = loadedDesc;

        stepsUp = loadedStepsUp;
        stepsDown = loadedStepsDown;
        useDescending = loadedUseDescending;
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
        buildPlayPattern();
        _refreshCurrentSoundPreview();
      });

      await _refreshInstrumentAvailability();
      await preloadClick();

      // Warm up first note to reduce first-hit latency
      if (configLoaded && playPattern.isNotEmpty) {
        final idx = playPattern[0];
        if (idx >= 0 && idx < scale.length) {
          final token = scale[idx];
          final warmName = _resolveFullNoteName(
            token,
            baseOctave,
            stepNumber: 0,
          );

          if (_usePerNotePlayers) {
            await _ensurePerNotePlayerReady(warmName);
          } else {
            final player = notePlayers[notePoolIndex];
            notePoolIndex = (notePoolIndex + 1) % notePoolSize;
            await _prepareNoteIfNeeded(player, warmName, preload: true);
          }
        }
      }

      // Preload all unique notes referenced by playPattern (reduces high-BPM stutter)
      if (_usePerNotePlayers) {
        await _preloadAllNotesForPattern();
      } else {
        await _precacheSourcesForPattern();
      }

      // Debug once (helps verify pattern is not stuck)
      debugPrint(
        'Loaded config: scale=$scale ascending=$ascending descending=$descending stepsUp=$stepsUp stepsDown=$stepsDown useDescending=$useDescending baseOctave=$baseOctave octaveCount=$octaveCount baseFrequencyHz=${baseFrequencyHz.toStringAsFixed(2)} timeSignature=$timeSignatureBeats/$timeSignatureNote beatUnit=${_beatUnitToConfigValue(beatUnit)} clickAssets=[$clickStrongAsset,$clickWeakAsset]',
      );
      debugPrint('playPattern=$playPattern');
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

  // Build the play pattern based on ascending/descending arrays and steps
  void buildPlayPattern() {
    playPattern = [];
    if (ascending.isEmpty) return;
    _octaveStepSpan = math.max(1, ascending.length);

    // Up
    for (int i = 0; i < stepsUp; i++) {
      playPattern.add(ascending[i % ascending.length]);
    }

    // Down
    if (useDescending && descending.isNotEmpty) {
      for (int i = 0; i < stepsDown; i++) {
        playPattern.add(descending[i % descending.length]);
      }
    }

    playIndex = 0;
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

  String _anchorScaleToken() {
    if (scale.isEmpty) return 'A';
    if (ascending.isNotEmpty) {
      final idx = ascending.first;
      if (idx >= 0 && idx < scale.length) return scale[idx];
    }
    return scale.first;
  }

  String _noteNameFromToken(String token) {
    final parsed = _parseNoteWithOctave(token);
    return parsed?.note ?? token.trim();
  }

  double? _frequencyForNote(String note, int octave) {
    final semitone = _noteToSemitone[note];
    if (semitone == null) return null;
    final midi = (octave + 1) * 12 + semitone;
    return 440.0 * math.pow(2.0, (midi - 69) / 12.0).toDouble();
  }

  int _nearestBaseOctaveForFrequency(
    String note,
    double targetHz,
    int fallbackBase,
  ) {
    final semitone = _noteToSemitone[note];
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
    if (scale.isEmpty) return;
    final anchorToken = _anchorScaleToken();
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
    if (scale.isEmpty) return;
    final anchorToken = _anchorScaleToken();
    final full = _resolveFullNoteName(anchorToken, baseOctave, stepNumber: 0);
    final parsed = _parseNoteWithOctave(full);
    if (parsed == null) return;
    final anchorHz = _frequencyForNote(parsed.note, parsed.octave);
    if (anchorHz != null) {
      baseFrequencyHz = anchorHz;
    }
  }

  // Resolve a full note name with octave based on a token, base octave, and step number (for octave shifts)
  void _refreshCurrentSoundPreview() {
    if (scale.isEmpty || playPattern.isEmpty) {
      currentSound = '';
      currentSoundVN.value = currentSound;
      return;
    }

    final firstIdx = playPattern.first;
    if (firstIdx < 0 || firstIdx >= scale.length) {
      currentSound = '';
      currentSoundVN.value = currentSound;
      return;
    }

    currentSound = _resolveFullNoteName(
      scale[firstIdx],
      baseOctave,
      stepNumber: 0,
    );
    currentSoundVN.value = currentSound;
  }

  // Resolve a full note name with octave based on a token, base octave, and step number (for octave shifts)
  Future<void> _setSequenceLength(int newLength) async {
    final safeLength = newLength.clamp(1, 128).toInt();
    setState(() {
      stepsUp = safeLength;
      beat = 0;
      playIndex = 0;
      stepCounter = 0;
      buildPlayPattern();
      _refreshCurrentSoundPreview();
    });
    await _refreshInstrumentAvailability();
    _restartIfRunning();
  }

  Future<void> _setOctaveCount(int newCount) async {
    final safeCount = newCount
        .clamp(1, _assetMaxOctave - _assetMinOctave + 1)
        .toInt();
    if (safeCount == octaveCount) return;
    setState(() {
      octaveCount = safeCount;
      _setBaseFromFrequencyNoSetState(baseFrequencyHz);
      beat = 0;
      playIndex = 0;
      stepCounter = 0;
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
      playIndex = 0;
      stepCounter = 0;
      _refreshCurrentSoundPreview();
    });
    await _refreshInstrumentAvailability();
    _restartIfRunning();
  }

  List<String> _samplePatternNotesForProbe({int maxNotes = 12}) {
    final notes = <String>{};
    if (playPattern.isNotEmpty && scale.isNotEmpty) {
      final limit = math.min(maxNotes, playPattern.length);
      for (int step = 0; step < limit; step++) {
        final idx = playPattern[step];
        if (idx < 0 || idx >= scale.length) continue;
        notes.add(
          _resolveFullNoteName(scale[idx], baseOctave, stepNumber: step),
        );
      }
    }

    if (notes.isEmpty && scale.isNotEmpty) {
      notes.add(_resolveFullNoteName(scale.first, baseOctave, stepNumber: 0));
    }
    return notes.toList(growable: false);
  }

  // Check if the given instrument has at least one playable asset based on the current pattern (used to determine availability in the picker)
  Future<bool> _instrumentHasPlayableAsset(String instrument) async {
    final probeNotes = _samplePatternNotesForProbe();
    for (final fullNote in probeNotes) {
      final path = 'assets/notes/$instrument/$fullNote.wav';
      try {
        await rootBundle.load(path);
        return true;
      } catch (_) {}
    }
    return false;
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

  // Parse beat unit from config, with validation and fallbacks based on time signature
  BeatUnit _parseBeatUnit(
    dynamic raw, {
    required int fallbackBeats,
    required int fallbackNote,
  }) {
    final rawText = (raw is String) ? raw.trim().toLowerCase() : '';
    // Recognize common beat unit names and fractions, with some flexibility
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
        return _defaultBeatUnitForSignature(fallbackBeats, fallbackNote);
    }
  }

  BeatUnit _defaultBeatUnitForSignature(int beats, int note) {
    if (note == 8 && beats >= 6 && beats % 3 == 0) {
      return BeatUnit.dottedQuarter;
    }
    if (note == 16 && beats >= 6 && beats % 3 == 0) {
      return BeatUnit.dottedEighth;
    }
    return BeatUnit.quarter;
  }

  // Get a user-friendly label for a beat unit (for display in the meter picker)
  String _beatUnitLabel(BeatUnit unit) {
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

  String _beatUnitToConfigValue(BeatUnit unit) {
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

  double _beatUnitWholeNoteLength(BeatUnit unit) {
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

  // Get the index of the current time signature in the options list, for initializing the picker
  int _timeSignatureIndex() {
    final key = '$timeSignatureBeats/$timeSignatureNote';
    final idx = _timeSignatureOptions.indexOf(key);
    return idx >= 0 ? idx : _timeSignatureOptions.indexOf('4/4');
  }

  int _beatUnitIndex() {
    final idx = BeatUnit.values.indexOf(beatUnit);
    return idx >= 0 ? idx : BeatUnit.values.indexOf(BeatUnit.quarter);
  }

  Future<void> _openMeterPickerSheet() async {
    final tsController = FixedExtentScrollController(
      initialItem: _timeSignatureIndex(),
    );
    final unitController = FixedExtentScrollController(
      initialItem: _beatUnitIndex(),
    );
    int tsIndex = _timeSignatureIndex();
    int unitIndex = _beatUnitIndex();

    final result = await showModalBottomSheet<(int, int)>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final scheme = Theme.of(context).colorScheme;
            final previewText =
                '${_timeSignatureOptions[tsIndex]} · ${_beatUnitLabel(BeatUnit.values[unitIndex])}';

            return Container(
              height: 306,
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: const Text('Cancel'),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.of(
                            sheetContext,
                          ).pop((tsIndex, unitIndex)),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: scheme.surfaceContainerHighest,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.tune_rounded, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          previewText,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 290,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: scheme.surfaceContainerLow,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 136,
                                child: ListWheelScrollView.useDelegate(
                                  controller: tsController,
                                  itemExtent: 36,
                                  diameterRatio: 1.7,
                                  perspective: 0.003,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (index) {
                                    setModalState(() => tsIndex = index);
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: _timeSignatureOptions.length,
                                    builder: (context, index) {
                                      if (index < 0 ||
                                          index >=
                                              _timeSignatureOptions.length) {
                                        return null;
                                      }
                                      final selected = index == tsIndex;
                                      return Center(
                                        child: Text(
                                          _timeSignatureOptions[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: selected
                                                    ? FontWeight.w700
                                                    : FontWeight.w400,
                                                color: selected
                                                    ? scheme.onSurface
                                                    : scheme.onSurfaceVariant,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 132,
                                color: scheme.outlineVariant.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                              SizedBox(
                                width: 136,
                                child: ListWheelScrollView.useDelegate(
                                  controller: unitController,
                                  itemExtent: 36,
                                  diameterRatio: 1.7,
                                  perspective: 0.003,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (index) {
                                    setModalState(() => unitIndex = index);
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: BeatUnit.values.length,
                                    builder: (context, index) {
                                      if (index < 0 ||
                                          index >= BeatUnit.values.length) {
                                        return null;
                                      }
                                      final selected = index == unitIndex;
                                      return Center(
                                        child: Text(
                                          _beatUnitLabel(
                                            BeatUnit.values[index],
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: selected
                                                    ? FontWeight.w700
                                                    : FontWeight.w400,
                                                color: selected
                                                    ? scheme.onSurface
                                                    : scheme.onSurfaceVariant,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IgnorePointer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 136,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: scheme.primary.withValues(
                                      alpha: 0.06,
                                    ),
                                    border: Border(
                                      top: BorderSide(
                                        color: scheme.primary.withValues(
                                          alpha: 0.28,
                                        ),
                                      ),
                                      bottom: BorderSide(
                                        color: scheme.primary.withValues(
                                          alpha: 0.28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 1),
                                Container(
                                  width: 136,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: scheme.primary.withValues(
                                      alpha: 0.06,
                                    ),
                                    border: Border(
                                      top: BorderSide(
                                        color: scheme.primary.withValues(
                                          alpha: 0.28,
                                        ),
                                      ),
                                      bottom: BorderSide(
                                        color: scheme.primary.withValues(
                                          alpha: 0.28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    tsController.dispose();
    unitController.dispose();

    if (result == null) return;
    final selectedTimeSignature = _timeSignatureOptions[result.$1];
    final parts = selectedTimeSignature.split('/');
    if (parts.length != 2) return;
    final parsedBeats = int.tryParse(parts[0]);
    final parsedNote = int.tryParse(parts[1]);
    if (parsedBeats == null || parsedNote == null) return;

    // Debug print selected values before applying
    debugPrint(
      'Selected time signature: $parsedBeats/$parsedNote, beat unit: ${BeatUnit.values[result.$2]}',
    );
    setState(() {
      timeSignatureBeats = parsedBeats;
      timeSignatureNote = parsedNote;
      beatUnit = BeatUnit.values[result.$2];
      beat = 0;
    });
    _restartIfRunning();
  }

  int _computeTickIntervalMs() {
    final double displayedBeatLength = 1.0 / timeSignatureNote;
    final double beatUnitLength = _beatUnitWholeNoteLength(beatUnit);
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
      _lastNotePath = path;
    } catch (e, st) {
      _noteReady = false;
      debugPrint('Prepare note failed: $fullNoteName ($path) -> $e');
      debugPrintStack(stackTrace: st);
    }
  }

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

  // Parse a token like "Bb2", "C#4", "F3" into (note, octave).
  // Returns null if the token does not contain an octave suffix.
  ({String note, int octave})? _parseNoteWithOctave(String token) {
    final m = RegExp(r'^([A-G](?:#|b)?)(\d+)$').firstMatch(token.trim());
    if (m == null) return null;
    return (note: m.group(1)!, octave: int.parse(m.group(2)!));
  }

  // Resolve a scale token to a full note name like "Bb2".
  String _resolveFullNoteName(
    String token,
    int octaveFallback, {
    int stepNumber = 0,
  }) {
    final parsed = _parseNoteWithOctave(token);
    if (parsed != null) {
      final adjustedOctave = _clampPlayableOctave(parsed.octave + octaveShift);
      return '${parsed.note}$adjustedOctave';
    }

    final span = math.max(1, _octaveStepSpan);
    final octaveOffset = stepNumber ~/ span;
    final resolvedOctave = _clampPlayableOctave(
      octaveFallback + octaveOffset + octaveShift,
    );
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

  // Preload all unique notes referenced by playPattern into per-note players.
  Future<void> _preloadAllNotesForPattern() async {
    if (!configLoaded || playPattern.isEmpty || scale.isEmpty) return;

    final unique = <String>{};
    for (int step = 0; step < playPattern.length; step++) {
      final idx = playPattern[step];
      if (idx < 0 || idx >= scale.length) continue;
      final token = scale[idx];
      unique.add(_resolveFullNoteName(token, baseOctave, stepNumber: step));
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

  // Precache AudioSources for all unique notes in the pattern (for non-per-note player mode).
  Future<void> _precacheSourcesForPattern() async {
    if (!configLoaded || playPattern.isEmpty || scale.isEmpty) return;

    final uniquePaths = <String>{};
    for (int step = 0; step < playPattern.length; step++) {
      final idx = playPattern[step];
      if (idx < 0 || idx >= scale.length) continue;
      final token = scale[idx];
      final full = _resolveFullNoteName(token, baseOctave, stepNumber: step);
      uniquePaths.add('assets/notes/$selectedInstrument/$full.wav');
    }

    for (final path in uniquePaths) {
      _noteSourceCache.putIfAbsent(path, () => AudioSource.asset(path));
    }
  }

  // Play note by name and octave
  Future<void> playNoteByName(String note, int octave) async {
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

    _lastNotePath = null;
    _noteReady = false;
    _noteSourceCache.clear();

    // Rebuild per-note players for the new instrument
    if (_usePerNotePlayers) {
      await _disposePerNotePlayers();
      await _preloadAllNotesForPattern();
    } else {
      await _precacheSourcesForPattern();
    }

    // Warm up current sound again
    if (currentSound.isNotEmpty && !_usePerNotePlayers) {
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
    if (playPattern.isEmpty) return;

    final idx = playPattern[playIndex];
    if (idx < 0 || idx >= scale.length) return;

    final token = scale[idx]; // could be "Bb" or "Bb2"
    final parsedToken = _parseNoteWithOctave(token);
    final resolvedFull = _resolveFullNoteName(
      token,
      baseOctave,
      stepNumber: stepCounter,
    );
    final resolvedParsed = _parseNoteWithOctave(resolvedFull);
    if (resolvedParsed == null) return;

    final String noteToPlay = resolvedParsed.note;
    final int octaveToPlay = resolvedParsed.octave;

    beat++;
    playIndex = (playIndex + 1) % playPattern.length;
    final beatInBar = ((beat - 1) % timeSignatureBeats) + 1;

    // Only advance stepCounter when octave is generated from the pattern.
    if (parsedToken == null) {
      stepCounter++;
    }

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
    if (scale.isEmpty || playPattern.isEmpty) return;

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

    // Invalidate scheduled gate timers and stop notes
    for (int i = 0; i < notePlayers.length; i++) {
      playerTokens[i]++;
      try {
        await notePlayers[i].pause();
        await notePlayers[i].seek(Duration.zero);
        notePlayers[i].setVolume(1.0);
      } catch (_) {}
    }

    // Stop per-note players
    for (final key in _perNotePlayers.keys.toList()) {
      _perNoteTokens[key] = (_perNoteTokens[key] ?? 0) + 1;
      final p = _perNotePlayers[key]!;
      try {
        await p.pause();
        await p.seek(Duration.zero);
        p.setVolume(1.0);
      } catch (_) {}
    }
  }

  // Reset to initial state
  Future<void> reset() async {
    await stop();
    swingController.reset();
    setState(() {
      beat = 0;
      playIndex = 0;
      stepCounter = 0;
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

  // Build the content of the advanced settings drawer
  Widget _buildAdvancedSettingsContent(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded),
              const SizedBox(width: 8),
              Text(
                'Advanced Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 8),
              Text('Base Pitch', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              Text('${baseFrequencyHz.toStringAsFixed(1)} Hz'),
            ],
          ),
          Slider(
            value: baseFrequencyHz,
            min: 55,
            max: 880,
            divisions: 825,
            label: baseFrequencyHz.toStringAsFixed(1),
            onChanged: (v) {
              setState(() => baseFrequencyHz = v);
            },
            onChangeEnd: (v) => _applyBaseFrequency(v),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 8),
              Text('Octaves', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: octaveCount <= 1
                    ? null
                    : () => _setOctaveCount(octaveCount - 1),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$octaveCount'),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed:
                    octaveCount >= (_assetMaxOctave - _assetMinOctave + 1)
                    ? null
                    : () => _setOctaveCount(octaveCount + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Range: $minOctave-$maxOctave'),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const SizedBox(width: 8),
              Text(
                'Sequence Length',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Text('$stepsUp'),
            ],
          ),
          Slider(
            value: stepsUp.clamp(1, 128).toDouble(),
            min: 1,
            max: 128,
            divisions: 127,
            label: '$stepsUp',
            onChanged: (v) {
              setState(() => stepsUp = v.round());
            },
            onChangeEnd: (v) => _setSequenceLength(v.round()),
          ),
        ],
      ),
    );
  }

  // Build the transport control bar with Start, Stop, and Reset buttons
  Widget _buildTransportBar(bool isRunning) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: isRunning ? null : start,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: isRunning ? () => stop() : null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
            ),
            const SizedBox(width: 10),
            TextButton.icon(
              onPressed: reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = timer != null;
    final int beatsForDisplay = timeSignatureBeats;
    final int beatInBar = (beat == 0) ? 1 : ((beat - 1) % beatsForDisplay) + 1;
    final int beatNumerator = beatInBar;
    final int beatDenominator = timeSignatureNote;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Metronome'),
        actions: [
          IconButton(
            tooltip: 'Advanced',
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      endDrawer: Drawer(child: _buildAdvancedSettingsContent(context)),
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
                      // Swing animation
                      MetronomeSwing(
                        anim: swingAnim,
                        isRunning: isRunning,
                        amplitudeDeg: 18,
                      ),
                      const SizedBox(height: 12),

                      // Beat display (center, modern)
                      Column(
                        children: [
                          Text(
                            '$beatNumerator/$beatDenominator',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Generate beat indicators based on time signature, with accent colors and active beat scaling
                              children: List.generate(beatsForDisplay, (i) {
                                final accent = _accentForBeatPosition(i + 1);
                                final isActive = (i + 1) == beatInBar;
                                final Color activeColor = switch (accent) {
                                  ClickAccent.strong => Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  ClickAccent.secondary => Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  ClickAccent.weak => Theme.of(
                                    context,
                                  ).colorScheme.tertiary,
                                };
                                final Color idleColor = switch (accent) {
                                  ClickAccent.strong => Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.35),
                                  ClickAccent.secondary =>
                                    Theme.of(context).colorScheme.secondary
                                        .withValues(alpha: 0.28),
                                  ClickAccent.weak => Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                };
                                return SizedBox(
                                  width: 18,
                                  height: 16,
                                  child: Center(
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        end: isActive ? 1.0 : 0.66,
                                      ),
                                      duration: const Duration(
                                        milliseconds: 140,
                                      ),
                                      curve: Curves.easeOut,
                                      builder: (context, scale, child) {
                                        return Transform.scale(
                                          scale: scale,
                                          child: child,
                                        );
                                      },
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isActive
                                              ? activeColor
                                              : idleColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$bpm',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'BPM',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Slider for BPM (30-240)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Slider(
                              value: bpm.toDouble(),
                              min: 30,
                              max: 240,
                              divisions: 210,
                              label: '$bpm',
                              onChanged: (v) {
                                setState(() => bpm = v.round());
                              },
                              onChangeEnd: (v) {
                                _applyBpm(v.round());
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [Text('30'), Text('240')],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Compact toggles
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: [
                          FilterChip(
                            label: const Text('Click'),
                            avatar: const Icon(Icons.volume_up, size: 18),
                            selected: enableClick,
                            onSelected: (v) async {
                              setState(() => enableClick = v);
                              if (!v) {
                                await _pauseClickPlayers();
                              }
                            },
                          ),
                          FilterChip(
                            label: const Text('Sound'),
                            avatar: const Icon(
                              Icons.graphic_eq_rounded,
                              size: 18,
                            ),
                            selected: enableSound,
                            onSelected: (v) async {
                              setState(() => enableSound = v);
                              if (!v) {
                                try {} catch (_) {}
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Compact meter control: one container, tap to expand dual wheel picker.
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _openMeterPickerSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.tune_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                '$timeSignatureBeats/$timeSignatureNote · ${_beatUnitLabel(beatUnit)}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.expand_more_rounded, size: 18),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Instrument
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Instrument: '),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: selectedInstrument,
                            items: instruments.map((ins) {
                              final hasAssets =
                                  instrumentAvailability[ins] ?? true;
                              final label = hasAssets ? ins : '$ins (missing)';
                              return DropdownMenuItem(
                                value: ins,
                                enabled: hasAssets,
                                child: Text(label),
                              );
                            }).toList(),
                            onChanged: (v) {
                              if (v == null) return;
                              _onInstrumentChanged(v);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildTransportBar(isRunning),
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
    for (final p in notePlayers) {
      p.dispose();
    }
    _disposePerNotePlayers();
    currentSoundVN.dispose();
    swingController.dispose();
    super.dispose();
  }
}

// A simple widget to visualize the metronome swing based on the current beat
class MetronomeSwing extends StatelessWidget {
  final Animation<double> anim; // -1 ~ 1
  final double amplitudeDeg; // amplitude in degrees for max swing
  final bool isRunning;

  const MetronomeSwing({
    super.key,
    required this.anim,
    this.amplitudeDeg = 18,
    required this.isRunning,
  });

  @override
  // Build a pendulum-like swing animation using rotation and stacking
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 220,
      child: AnimatedBuilder(
        animation: anim,
        builder: (context, _) {
          final scheme = Theme.of(context).colorScheme;
          final angle = (amplitudeDeg * math.pi / 180.0) * anim.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 16,
                child: Container(
                  width: 188,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: scheme.surfaceContainerHighest,
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                child: Container(
                  width: 136,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: scheme.surfaceContainerLow,
                  ),
                ),
              ),

              // Pendulum
              Transform.rotate(
                angle: angle,
                alignment: const Alignment(0, -1), // rotate around top center
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // center pivot point
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRunning
                            ? scheme.primary
                            : scheme.outlineVariant,
                      ),
                    ),
                    // rod
                    Container(
                      width: 5,
                      height: 146,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            scheme.onSurface.withValues(alpha: 0.85),
                            scheme.onSurface.withValues(alpha: 0.62),
                          ],
                        ),
                      ),
                    ),
                    // weight
                    Container(
                      width: 54,
                      height: 32,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            scheme.primaryContainer,
                            scheme.surfaceContainerHigh,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.shadow.withValues(
                              alpha: isRunning ? 0.14 : 0.08,
                            ),
                            blurRadius: isRunning ? 9 : 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
