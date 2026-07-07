import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_settings_controller.dart';
import '../language/app_language_text.dart';
import '../language/app_text.dart';
import '../practice_history_controller.dart';
import 'note_sequence_controller.dart';
import 'metronome_music.dart';
import 'instrument_sf2_controller.dart';
import 'widgets/advanced_settings_drawer.dart';
import 'widgets/metronome_controls_panel.dart';
import 'widgets/meter_picker_sheet.dart';
import 'widgets/playback_status_panel.dart';
import 'widgets/transport_bar.dart';

enum ClickAccent { strong, secondary, weak }

enum _NoteSequenceEditorAction { applyText, saveText, importSaved }

class _NoteSequenceEditorResult {
  const _NoteSequenceEditorResult({
    required this.action,
    this.text,
    this.name,
    this.savedSequence,
    this.notation,
  });

  final _NoteSequenceEditorAction action;
  final String? text;
  final String? name;
  final SavedNoteSequence? savedSequence;
  final NoteNotation? notation;
}

// The MetronomeDemo widget
class MetronomeDemo extends StatefulWidget {
  const MetronomeDemo({
    super.key,
    required this.noteSequenceController,
    required this.appSettingsController,
    required this.practiceHistoryController,
  });

  final NoteSequenceController noteSequenceController;
  final AppSettingsController appSettingsController;
  final PracticeHistoryController practiceHistoryController;

  @override
  State<MetronomeDemo> createState() => _MetronomeDemoState();
}

// The state for the MetronomeDemo widget
class _MetronomeDemoState extends State<MetronomeDemo>
    with SingleTickerProviderStateMixin {
  static const String _asianDreamzSf2Path = 'assets/sf2/DSK Asian DreamZ.SF2';
  static const String _emuSf2Path =
      'assets/sf2/EMU_Liveware_ESC_SoundFont_Library_SF2';
  static const String _savedBpmKey = 'metronome_bpm';
  static const String _savedInstrumentKey = 'metronome_instrument';
  static const String _savedTimeSignatureBeatsKey =
      'metronome_time_signature_beats';
  static const String _savedTimeSignatureNoteKey =
      'metronome_time_signature_note';
  static const String _savedBeatUnitKey = 'metronome_beat_unit';
  static const String _defaultStrongClickAsset = 'assets/sounds/click_hi.wav';
  static const String _defaultWeakClickAsset = 'assets/sounds/click_lo.wav';
  static const int _initialBpm = 90;
  // Lower-bound floor for any instrument (A0). Each instrument's actual usable
  // range is read from its Sf2Spec at runtime via _instrumentMinOctave /
  // _instrumentMaxOctave below.
  static const int _absoluteMinOctave = 0;
  static const int _absoluteMaxOctave = 7;

  // Animation for pendulum swing
  late final AnimationController swingController;
  late Animation<double> swingAnim;

  // Metronome state
  int beat = 0;
  int bpm = _initialBpm; // Beats per minute
  Timer? timer;
  DateTime? practiceStartedAt;
  Uint8List? scoreImageBytes;
  String? scoreFileName;
  PdfDocument? scorePdfDocument;
  Uint8List? scorePdfPageBytes;
  int scorePdfPage = 1;
  int scorePdfPages = 0;
  bool isScorePdfPageLoading = false;
  int _scorePdfRenderRequestId = 0;
  final TransformationController _scoreTransformationController =
      TransformationController();
  double scoreZoom = 1;

  // just_audio players
  final AudioPlayer clickStrongPlayer = AudioPlayer();
  final AudioPlayer clickWeakPlayer = AudioPlayer();
  final InstrumentSf2Controller instrumentSf2Controller =
      InstrumentSf2Controller(
        channelCount: notePoolSize,
        assetSpecs: const {
          // Per-instrument min/max octave reflects the SF2's actual sampled
          // range. pipa caps at E6 (no full octave 6) so max=5; oud caps at
          // C#5 so max=4. Others have ~A1..A6 covered.
          'piano': Sf2Spec(
            assetPath: 'assets/sf2/piano.sf2',
            // program=0 is Pedal On (long sustain), program=1 is Pedal Off
            // (clean cut). Pedal On + a moderate gate gives a "half-pedal"
            // feel: the sample's natural decay rings out for a beat or so,
            // then is released cleanly before the next hit.
            bank: 0,
            program: 0,
            velocity: 92,
            volume: 100,
            expression: 112,
            // Allow the natural decay to ring longer than Pedal Off did,
            // but cap so it never fully bleeds across a slow beat.
            gateScale: 1.1,
            maxGateMs: 520,
            minOctave: 1,
            maxOctave: 6,
          ),
          'uprightPiano': Sf2Spec(
            assetPath: 'assets/sf2/UprightPianoKW-20220221.sf2',
            bank: 0,
            program: 0,
            velocity: 90,
            volume: 100,
            expression: 110,
            gateScale: 1.05,
            maxGateMs: 500,
            minOctave: 1,
            maxOctave: 6,
          ),
          'guzheng': Sf2Spec(
            assetPath: _asianDreamzSf2Path,
            bank: 0,
            program: 3,
            velocity: 86,
            volume: 100,
            expression: 108,
            maxGateMs: 240,
            minOctave: 1,
            maxOctave: 6,
          ),

          'flute': Sf2Spec(
            assetPath: _asianDreamzSf2Path,
            bank: 0,
            program: 5,
            velocity: 80,
            volume: 100,
            expression: 104,
            gateScale: 1.15,
            maxGateMs: 360,
            minOctave: 1,
            maxOctave: 6,
          ),
          'pipa': Sf2Spec(
            assetPath: _asianDreamzSf2Path,
            bank: 0,
            program: 0,
            velocity: 84,
            volume: 100,
            expression: 108,
            maxGateMs: 230,
            minOctave: 1,
            maxOctave: 5,
          ),
          'ruan': Sf2Spec(
            assetPath: _asianDreamzSf2Path,
            bank: 0,
            program: 2,
            velocity: 84,
            volume: 100,
            expression: 108,
            maxGateMs: 250,
            minOctave: 1,
            maxOctave: 6,
          ),
          'erhu': Sf2Spec(
            assetPath: _asianDreamzSf2Path,
            bank: 0,
            program: 4,
            velocity: 82,
            volume: 100,
            expression: 110,
            gateScale: 1.2,
            minGateMs: 120,
            maxGateMs: 430,
            overlapMs: 60,
            minOctave: 1,
            maxOctave: 6,
          ),
          'shamisen': Sf2Spec(
            assetPath: 'assets/sf2/shamisen.sf2',
            bank: 0,
            program: 0,
            velocity: 82,
            volume: 100,
            expression: 106,
            maxGateMs: 220,
            minOctave: 1,
            maxOctave: 6,
          ),
          'harmonium': Sf2Spec(
            assetPath: 'assets/sf2/harmonium.sf2',
            bank: 0,
            program: 0,
            velocity: 72,
            volume: 100,
            expression: 96,
            gateScale: 1.45,
            minGateMs: 140,
            maxGateMs: 520,
            overlapMs: 90,
            minOctave: 1,
            maxOctave: 6,
          ),
          'tabla': Sf2Spec(
            assetPath: 'assets/sf2/Tabla.sf2',
            bank: 0,
            program: 0,
            velocity: 96,
            volume: 100,
            expression: 110,
            noteOffset: 12,
            maxGateMs: 180,
            minOctave: 3,
            maxOctave: 4,
          ),
          // m3_Instruments.sf2 is a 63-preset Turkish/Arabic compilation.
          // Expose a focused set of its best-known traditional instruments.
          'oud': Sf2Spec(
            assetPath: 'assets/sf2/m3_Instruments.sf2',
            bank: 0,
            program: 11,
            velocity: 84,
            volume: 100,
            expression: 108,
            maxGateMs: 260,
            minOctave: 1,
            maxOctave: 4,
          ),
          'qanun': Sf2Spec(
            assetPath: 'assets/sf2/m3_Instruments.sf2',
            bank: 0,
            program: 2,
            velocity: 84,
            volume: 100,
            expression: 108,
            maxGateMs: 280,
            minOctave: 1,
            maxOctave: 6,
          ),
          'duduk': Sf2Spec(
            assetPath: 'assets/sf2/m3_Instruments.sf2',
            bank: 0,
            program: 31,
            velocity: 80,
            volume: 100,
            expression: 108,
            gateScale: 1.2,
            minGateMs: 120,
            maxGateMs: 430,
            overlapMs: 60,
            minOctave: 1,
            maxOctave: 6,
          ),
          'ney': Sf2Spec(
            assetPath: 'assets/sf2/m3_Instruments.sf2',
            bank: 0,
            program: 46,
            velocity: 80,
            volume: 100,
            expression: 108,
            gateScale: 1.2,
            minGateMs: 120,
            maxGateMs: 430,
            overlapMs: 60,
            minOctave: 1,
            maxOctave: 6,
          ),
          'tanbur': Sf2Spec(
            assetPath: 'assets/sf2/m3_Instruments.sf2',
            bank: 0,
            program: 47,
            velocity: 84,
            volume: 100,
            expression: 108,
            maxGateMs: 280,
            minOctave: 1,
            maxOctave: 6,
          ),
          'celesta': Sf2Spec(
            assetPath: '$_emuSf2Path/Celesta.sf2',
            bank: 0,
            program: 0,
            velocity: 80,
            volume: 100,
            expression: 108,
            maxGateMs: 300,
            minOctave: 1,
            maxOctave: 6,
          ),
          'harp': Sf2Spec(
            assetPath: '$_emuSf2Path/Harp.sf2',
            bank: 0,
            program: 0,
            velocity: 82,
            volume: 100,
            expression: 108,
            maxGateMs: 300,
            minOctave: 1,
            maxOctave: 6,
          ),
          'clarinet': Sf2Spec(
            assetPath: '$_emuSf2Path/Clarinet.sf2',
            bank: 0,
            program: 0,
            velocity: 78,
            volume: 100,
            expression: 106,
            gateScale: 1.2,
            minGateMs: 120,
            maxGateMs: 430,
            overlapMs: 60,
            minOctave: 3,
            maxOctave: 6,
          ),
          'oboe': Sf2Spec(
            assetPath: '$_emuSf2Path/Oboe.sf2',
            bank: 0,
            program: 0,
            velocity: 78,
            volume: 100,
            expression: 106,
            gateScale: 1.2,
            minGateMs: 120,
            maxGateMs: 430,
            overlapMs: 60,
            minOctave: 4,
            maxOctave: 6,
          ),
          'trumpet': Sf2Spec(
            assetPath: '$_emuSf2Path/Trumpet.sf2',
            bank: 0,
            program: 0,
            velocity: 82,
            volume: 100,
            expression: 108,
            gateScale: 1.15,
            maxGateMs: 400,
            overlapMs: 50,
            minOctave: 2,
            maxOctave: 5,
          ),
          'frenchHorn': Sf2Spec(
            assetPath: '$_emuSf2Path/French Horn 1.sf2',
            bank: 0,
            program: 0,
            velocity: 80,
            volume: 100,
            expression: 106,
            gateScale: 1.25,
            minGateMs: 120,
            maxGateMs: 440,
            overlapMs: 70,
            minOctave: 2,
            maxOctave: 5,
          ),
          'acousticGuitar': Sf2Spec(
            assetPath: '$_emuSf2Path/Acoustic Gtr.sf2',
            bank: 0,
            program: 0,
            velocity: 84,
            volume: 100,
            expression: 108,
            maxGateMs: 260,
            minOctave: 1,
            maxOctave: 6,
          ),
          'electricGuitar': Sf2Spec(
            assetPath: '$_emuSf2Path/El Guitar 1.sf2',
            bank: 0,
            program: 0,
            velocity: 84,
            volume: 100,
            expression: 108,
            maxGateMs: 280,
            minOctave: 1,
            maxOctave: 6,
          ),
          'acousticBass': Sf2Spec(
            assetPath: '$_emuSf2Path/Acoustic Bass.sf2',
            bank: 0,
            program: 0,
            velocity: 88,
            volume: 100,
            expression: 108,
            maxGateMs: 280,
            minOctave: 1,
            maxOctave: 4,
          ),
          'bianzhong': Sf2Spec(
            assetPath: '$_emuSf2Path/Bianzhong.sf2',
            bank: 0,
            program: 0,
            velocity: 86,
            volume: 100,
            expression: 110,
            maxGateMs: 360,
            minOctave: 3,
            maxOctave: 6,
          ),
          'marimba': Sf2Spec(
            assetPath: '$_emuSf2Path/Marimba.sf2',
            bank: 0,
            program: 0,
            velocity: 88,
            volume: 100,
            expression: 108,
            maxGateMs: 280,
            minOctave: 1,
            maxOctave: 6,
          ),
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
  // SF2-only mode: only list instruments that have a SoundFont in assetSpecs.
  final List<String> instruments = [
    'piano',
    'uprightPiano',
    'pipa',
    'ruan',
    'guzheng',
    'erhu',
    'flute',
    'shamisen',
    'harmonium',
    'tabla',
    'oud',
    'qanun',
    'duduk',
    'ney',
    'tanbur',
    'celesta',
    'harp',
    'clarinet',
    'oboe',
    'trumpet',
    'frenchHorn',
    'acousticGuitar',
    'electricGuitar',
    'acousticBass',
    'bianzhong',
    'marimba',
  ];
  final Map<String, bool> instrumentAvailability = {};
  String selectedInstrument = 'piano';

  // base octave
  int baseOctave = 3;
  // Initialised from the default Sf2Spec range (1..6); _syncOctaveBounds()
  // recomputes per active instrument once specs are loaded.
  int minOctave = 1;
  int maxOctave = 6;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initAudio(); // session setup
      _loadStartupData();
    });
  }

  Future<void> _loadStartupData() async {
    await loadConfig();
    await _loadSavedMetronomeSettings();
    await loadNoteSequence();
  }

  Future<void> _loadSavedMetronomeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedBpm = prefs.getInt(_savedBpmKey);
    final savedInstrument = prefs.getString(_savedInstrumentKey);
    final savedBeats = prefs.getInt(_savedTimeSignatureBeatsKey);
    final savedNote = prefs.getInt(_savedTimeSignatureNoteKey);
    final savedBeatUnit = prefs.getString(_savedBeatUnitKey);

    setState(() {
      if (savedBpm != null) {
        bpm = savedBpm.clamp(30, 240);
      }
      if (savedInstrument != null && instruments.contains(savedInstrument)) {
        selectedInstrument = savedInstrument;
      }
      if (savedBeats != null && savedNote != null) {
        final savedTimeSignature = '$savedBeats/$savedNote';
        if (timeSignatureOptions.contains(savedTimeSignature)) {
          timeSignatureBeats = savedBeats;
          timeSignatureNote = savedNote;
        }
      }
      if (savedBeatUnit != null) {
        beatUnit = parseBeatUnit(
          savedBeatUnit,
          fallbackBeats: timeSignatureBeats,
          fallbackNote: timeSignatureNote,
        );
      }
    });
    swingController.duration = Duration(milliseconds: _computeTickIntervalMs());
  }

  Future<void> _saveMetronomeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_savedBpmKey, bpm);
    await prefs.setString(_savedInstrumentKey, selectedInstrument);
    await prefs.setInt(_savedTimeSignatureBeatsKey, timeSignatureBeats);
    await prefs.setInt(_savedTimeSignatureNoteKey, timeSignatureNote);
    await prefs.setString(_savedBeatUnitKey, beatUnitConfigValue(beatUnit));
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

      unawaited(preloadClick());

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
      final defaultSequence = parseNoteSequenceText(text);

      await widget.noteSequenceController.load(
        fallbackSequence: defaultSequence,
      );

      final loadedSequence = widget.noteSequenceController.sequence;

      setState(() {
        noteSequence = loadedSequence;
        noteIndex = 0;
        _setBaseFromFrequencyNoSetState(baseFrequencyHz);
        _refreshCurrentSoundPreview();
      });
      await _refreshInstrumentAvailability(prepareCurrentInstrument: false);
      unawaited(_prepareCurrentInstrumentForStartup());
      if (_usePerNotePlayers) {
        unawaited(_preloadAllNotesForSequence());
      } else {
        unawaited(_precacheSourcesForSequence());
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

  // Per-instrument usable range derived from the active SF2 spec.
  int get _instrumentMinOctave =>
      instrumentSf2Controller.assetSpecs[selectedInstrument]?.minOctave ??
      _absoluteMinOctave;
  int get _instrumentMaxOctave =>
      instrumentSf2Controller.assetSpecs[selectedInstrument]?.maxOctave ??
      _absoluteMaxOctave;

  // Slider frequency bounds follow the active instrument's usable octave range.
  double get _minBaseFrequencyHz =>
      440.0 * math.pow(2.0, _instrumentMinOctave - 4).toDouble();
  double get _maxBaseFrequencyHz =>
      440.0 * math.pow(2.0, _instrumentMaxOctave - 4).toDouble();

  void _syncOctaveBounds() {
    final lo = _instrumentMinOctave;
    final hi = _instrumentMaxOctave;
    final maxCount = hi - lo + 1;
    octaveCount = octaveCount.clamp(1, maxCount).toInt();
    baseOctave = baseOctave.clamp(lo, hi).toInt();
    minOctave = lo;
    maxOctave = hi;
  }

  int _clampPlayableOctave(int octave) {
    return octave.clamp(minOctave, maxOctave).toInt();
  }

  String _anchorNoteToken() {
    if (noteSequence.isEmpty) return 'A';
    for (final token in noteSequence) {
      final atoms = notesInBeatToken(token);
      if (atoms.isNotEmpty) return atoms.first;
    }
    return 'A';
  }

  String _noteNameFromToken(String token) {
    final parsed = resolveSequenceNoteAtom(token, baseOctave);
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

  // Find the nearest base octave that allows the anchor note to be
  // as close as possible to the target frequency
  int _nearestBaseOctaveForFrequency(
    String note,
    double targetHz,
    int fallbackBase,
  ) {
    final semitone = noteToSemitone[note];
    if (semitone == null) return fallbackBase;

    final int lo = _instrumentMinOctave;
    final int hi = _instrumentMaxOctave;
    int bestOctave = fallbackBase.clamp(lo, hi).toInt();
    double bestDiff = double.infinity;

    for (int octave = lo; octave <= hi; octave++) {
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

  // Set base octave based on a target frequency for the anchor note, without
  // calling setState (used during config load and when changing base frequency)
  void _setBaseFromFrequencyNoSetState(double targetHz) {
    if (noteSequence.isEmpty) return;
    final anchorToken = _anchorNoteToken();
    final anchorNote = _noteNameFromToken(anchorToken);
    final parsedAnchor = resolveSequenceNoteAtom(anchorToken, baseOctave);
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

  // Resolve a full note name with octave based on
  // a token, base octave, and step number (for octave shifts)
  void _refreshCurrentSoundPreview() {
    if (noteSequence.isEmpty) {
      currentSound = '';
      currentSoundVN.value = currentSound;
      return;
    }

    currentSound = _resolveFullNoteName(_anchorNoteToken(), baseOctave);
    currentSoundVN.value = currentSound;
  }

  Future<void> _applyBaseFrequency(double newFrequencyHz) async {
    final clampedHz = newFrequencyHz
        .clamp(_minBaseFrequencyHz, _maxBaseFrequencyHz)
        .toDouble();
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

  // Check if the given instrument has at least one playable asset based on the current sequence (used to determine availability in the picker)
  Future<bool> _instrumentHasPlayableAsset(String instrument) async {
    // SF2-only mode: an instrument is playable iff it has a SoundFont asset.
    return instrumentSf2Controller.assetSpecs.containsKey(instrument);
  }

  Future<void> _refreshInstrumentAvailability({
    bool prepareCurrentInstrument = true,
  }) async {
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
        return;
      }
    }

    // SF2-only mode: ensure the SoundFont for the currently selected
    // instrument is loaded and ready, so notes play immediately.
    if (prepareCurrentInstrument &&
        (instrumentAvailability[selectedInstrument] ?? false)) {
      await instrumentSf2Controller.prepareForInstrument(selectedInstrument);
    }
  }

  Future<void> _prepareCurrentInstrumentForStartup() async {
    await instrumentSf2Controller.prepareForInstrument(selectedInstrument);
    if (!mounted) return;
    await _warmUpCurrentNote();
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

  String _localizedBeatUnitLabel(BeatUnit unit) {
    switch (unit) {
      case BeatUnit.half:
        return _text.subdivisionHalf;
      case BeatUnit.quarter:
        return _text.subdivisionQuarter;
      case BeatUnit.eighth:
        return _text.subdivisionEighth;
      case BeatUnit.sixteenth:
        return _text.subdivisionSixteenth;
      case BeatUnit.dottedHalf:
        return _text.subdivisionDottedHalf;
      case BeatUnit.dottedQuarter:
        return _text.subdivisionDottedQuarter;
      case BeatUnit.dottedEighth:
        return _text.subdivisionDottedEighth;
    }
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
    unawaited(_saveMetronomeSettings());
    _restartIfRunning();
  }

  // Open the bottom sheet for picking time signature and beat unit, with scrollable pickers and a preview of the current selection
  Future<void> _openMeterPickerSheet() async {
    await showMeterPickerSheet(
      context: context,
      timeSignatureOptions: timeSignatureOptions,
      beatUnitLabels: [
        for (final unit in BeatUnit.values) _localizedBeatUnitLabel(unit),
      ],
      initialTimeSignatureIndex: _timeSignatureIndex(),
      initialBeatUnitIndex: _beatUnitIndex(),
      closeLabel: _text.close,
      doneLabel: _text.done,
      timeSignatureLabel: _text.timeSignature,
      beatUnitLabel: _text.beatUnit,
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
  Future<void> _releaseAllNotePlayers({int releaseMs = 70}) async {
    for (int i = 0; i < notePlayers.length; i++) {
      playerTokens[i]++;
    }

    for (final key in _perNotePlayers.keys) {
      _perNoteTokens[key] = (_perNoteTokens[key] ?? 0) + 1;
    }

    await instrumentSf2Controller.stopAllNotes();
    activeSf2MidiNote = null;

    await Future.wait([
      for (final player in notePlayers)
        _fadeOutAndPause(player, releaseMs: releaseMs),
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
    final parsed = resolveSequenceNoteAtom(token, octaveFallback);
    if (parsed == null) return '';

    final adjustedOctave = _clampPlayableOctave(parsed.octave + octaveShift);
    return '${parsed.note}$adjustedOctave';
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
      for (final atom in notesInBeatToken(token)) {
        final full = _resolveFullNoteName(atom, baseOctave);
        if (full.isNotEmpty) unique.add(full);
      }
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
      for (final atom in notesInBeatToken(token)) {
        final full = _resolveFullNoteName(atom, baseOctave);
        if (full.isNotEmpty) {
          uniquePaths.add('assets/notes/$selectedInstrument/$full.wav');
        }
      }
    }

    for (final path in uniquePaths) {
      _noteSourceCache.putIfAbsent(path, () => AudioSource.asset(path));
    }
  }

  Future<void> _warmUpCurrentNote() async {
    if (currentSound.isEmpty ||
        _usePerNotePlayers ||
        _useSf2ForCurrentInstrument()) {
      return;
    }
    final player = notePlayers[notePoolIndex];
    notePoolIndex = (notePoolIndex + 1) % notePoolSize;
    await _prepareNoteIfNeeded(player, currentSound, preload: true);
  }

  // Play note by name and octave
  Future<void> playNoteByName(
    String note,
    int octave, {
    double durationBeats = 1.0,
  }) async {
    if (_useSf2ForCurrentInstrument()) {
      final midiNote = instrumentSf2Controller.midiNoteFor(
        note,
        octave,
        noteToSemitone,
      );
      if (midiNote == null) return;

      const int channel = 0;
      final int token = ++playerTokens[channel];
      final sf2Spec = instrumentSf2Controller.specFor(selectedInstrument);
      final int latencyOffsetMs = sf2Spec?.latencyOffsetMs ?? 55;
      final int overlapMs = sf2Spec?.overlapMs ?? 0;

      try {
        final previousMidiNote = activeSf2MidiNote;
        if (previousMidiNote != null && previousMidiNote == midiNote) {
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
          if (previousMidiNote != null && previousMidiNote != midiNote) {
            Timer(Duration(milliseconds: overlapMs), () async {
              try {
                await instrumentSf2Controller.stopNote(
                  midiNote: previousMidiNote,
                  channel: channel,
                );
              } catch (_) {}
            });
          }
        }

        if (latencyOffsetMs > 0) {
          Timer(Duration(milliseconds: latencyOffsetMs), firePlayNote);
        } else {
          await firePlayNote();
        }

        final int beatMs = _intervalMs;
        final int maxGateMs = durationBeats > 1
            ? math.max(
                sf2Spec?.maxGateMs ?? 320,
                (_intervalMs * durationBeats).round(),
              )
            : sf2Spec?.maxGateMs ?? 320;
        final int gateMs = math.max(
          sf2Spec?.minGateMs ?? 80,
          math.min(
            maxGateMs,
            (beatMs * durationBeats * noteGate * (sf2Spec?.gateScale ?? 1.0))
                .round(),
          ),
        );
        final int totalGateMs = gateMs + latencyOffsetMs;

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
        final int maxGateMs = durationBeats > 1
            ? math.max(220, (_intervalMs * durationBeats).round())
            : 220;
        final int gateMs = math.max(
          80,
          math.min(maxGateMs, (beatMs * durationBeats * noteGate).round()),
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
      final int maxGateMs = durationBeats > 1
          ? math.max(220, (_intervalMs * durationBeats).round())
          : 220;
      final int gateMs = math.max(
        80,
        math.min(maxGateMs, (beatMs * durationBeats * noteGate).round()),
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

  int _heldBeatsAfterIndex(int index) {
    var heldBeats = 0;
    var nextIndex = (index + 1) % noteSequence.length;

    while (heldBeats < noteSequence.length - 1 &&
        isHoldBeatToken(noteSequence[nextIndex])) {
      heldBeats++;
      nextIndex = (nextIndex + 1) % noteSequence.length;
    }

    return heldBeats;
  }

  // Play all notes inside one beat token, spacing grouped notes evenly.
  void _playBeatToken(String token, {required double durationBeats}) {
    final atoms = notesInBeatToken(token);
    if (atoms.isEmpty) return;

    final stepMs = atoms.length <= 1 ? 0 : (_intervalMs / atoms.length).round();

    for (int i = 0; i < atoms.length; i++) {
      void playAtom() {
        final resolved = resolveSequenceNoteAtom(atoms[i], baseOctave);
        if (resolved == null) return;

        final noteToPlay = resolved.note;
        final octaveToPlay = _clampPlayableOctave(
          resolved.octave + octaveShift,
        );

        playNoteByName(noteToPlay, octaveToPlay, durationBeats: durationBeats);
      }

      if (i == 0) {
        playAtom();
      } else {
        Timer(Duration(milliseconds: stepMs * i), playAtom);
      }
    }
  }

  // Handle instrument change: clear caches, dispose players, and preload for new instrument
  Future<void> _onInstrumentChanged(String newInstrument) async {
    if (instrumentAvailability.isNotEmpty &&
        !(instrumentAvailability[newInstrument] ?? false)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_text.noPlayableAssets(newInstrument))),
        );
      }
      return;
    }

    if (newInstrument == selectedInstrument) return;

    for (int i = 0; i < notePlayers.length; i++) {
      playerTokens[i]++;
    }
    activeSf2MidiNote = null;
    await instrumentSf2Controller.releaseCurrentInstrument();

    if (!mounted) return;
    setState(() {
      selectedInstrument = newInstrument;
      // Re-clamp octave settings to the new instrument's playable range,
      // then snap baseFrequencyHz to the nearest valid anchor frequency.
      _syncOctaveBounds();
      _setBaseFromFrequencyNoSetState(baseFrequencyHz);
      baseFrequencyHz = baseFrequencyHz.clamp(
        _minBaseFrequencyHz,
        _maxBaseFrequencyHz,
      );
    });
    unawaited(_saveMetronomeSettings());

    _noteReady = false;
    _noteSourceCache.clear();

    // SF2-only mode: load the SoundFont for the new instrument up front
    // so the first note plays without delay.
    await instrumentSf2Controller.prepareForInstrument(newInstrument);

    // Rebuild per-note players for the new instrument (only matters if the
    // wav fallback is ever re-enabled; harmless otherwise).
    if (_usePerNotePlayers) {
      await _disposePerNotePlayers();
      await _preloadAllNotesForSequence();
    } else {
      await _precacheSourcesForSequence();
    }

    // Warm up current sound again (wav path; skipped when SF2 is ready)
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
    unawaited(_saveMetronomeSettings());

    _restartIfRunning();
  }

  // Apply new BPM value, update animation and timer if running
  void _applyBpm(int newBpm) {
    setState(() {
      bpm = newBpm.clamp(30, 240);
    });
    unawaited(_saveMetronomeSettings());

    // Update swing animation duration
    swingController.duration = Duration(milliseconds: _computeTickIntervalMs());

    // If timer is running, restart it with new BPM
    _restartIfRunning();
  }

  void _onTick() {
    if (noteSequence.isEmpty) return;

    final token = noteSequence[noteIndex];
    final heldBeats = _heldBeatsAfterIndex(noteIndex);
    final atoms = notesInBeatToken(token);
    final currentFullNames = [
      for (final atom in atoms) _resolveFullNoteName(atom, baseOctave),
    ].where((fullName) => fullName.isNotEmpty).toList(growable: false);

    beat++;
    noteIndex = (noteIndex + 1) % noteSequence.length;
    final beatInBar = ((beat - 1) % timeSignatureBeats) + 1;

    currentSound = isHoldBeatToken(token) ? '-' : currentFullNames.join('/');
    currentSoundVN.value = currentSound;

    if (beat % uiUpdateEvery == 0) {
      setState(() {});
    }

    if (enableClick) {
      playClickForBeat(beatInBar);
    }
    if (enableSound && !isHoldBeatToken(token)) {
      _playBeatToken(token, durationBeats: 1.0 + heldBeats);
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
    practiceStartedAt = DateTime.now();

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
    final startedAt = practiceStartedAt;
    practiceStartedAt = null;

    setState(() {
      timer = null;
    });

    _tickGen++; // cancel any scheduled chain
    oldTimer?.cancel();
    swingController.stop();

    await _pauseClickPlayers();
    await _releaseAllNotePlayers(releaseMs: 60);

    if (oldTimer != null && startedAt != null) {
      await widget.practiceHistoryController.recordSession(
        duration: DateTime.now().difference(startedAt),
        bpm: bpm,
        sequenceText: noteSequence.join(' '),
        startedAt: startedAt,
      );
    }
  }

  // Reset to initial state
  Future<void> reset() async {
    await stop();
    swingController.reset();
    setState(() {
      bpm = _initialBpm;
      beat = 0;
      noteIndex = 0;
      _refreshCurrentSoundPreview();
    });
    unawaited(_saveMetronomeSettings());

    if (currentSound.isNotEmpty && !_usePerNotePlayers) {
      final player = notePlayers[notePoolIndex];
      notePoolIndex = (notePoolIndex + 1) % notePoolSize;
      await _prepareNoteIfNeeded(player, currentSound, preload: true);
    }
  }

  // ---------- UI ----------
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AppLanguageText get _text =>
      appTextFor(widget.appSettingsController.language);

  Widget _buildAdvancedSettingsDrawer({
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Drawer(
      backgroundColor: theme.brightness == Brightness.light
          ? Colors.white
          : colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      child: AdvancedSettingsDrawer(
        baseFrequencyHz: baseFrequencyHz,
        minBaseFrequencyHz: _minBaseFrequencyHz,
        maxBaseFrequencyHz: _maxBaseFrequencyHz,
        // Note-name labels for the slider edges.
        minBaseLabel: 'A$_instrumentMinOctave',
        maxBaseLabel: 'A$_instrumentMaxOctave',
        titleLabel: _text.advancedSettings,
        instrumentLabel: _text.instrument,
        instruments: instruments,
        instrumentAvailability: instrumentAvailability,
        selectedInstrument: selectedInstrument,
        missingInstrumentLabel: _text.missingInstrument,
        onInstrumentChanged: _onInstrumentChanged,
        onBaseFrequencyChanged: (v) {
          setState(() => baseFrequencyHz = v);
        },
        onBaseFrequencyChangeEnd: (v) => _applyBaseFrequency(v),
      ),
    );
  }

  // Build the content of the advanced settings panel, used in both drawer and dialog modes.
  Widget _buildAdvancedSettingsContent({
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return ColoredBox(
      color: theme.brightness == Brightness.light
          ? Colors.white
          : colorScheme.surface,
      child: AdvancedSettingsDrawer(
        baseFrequencyHz: baseFrequencyHz,
        minBaseFrequencyHz: _minBaseFrequencyHz,
        maxBaseFrequencyHz: _maxBaseFrequencyHz,
        minBaseLabel: 'A$_instrumentMinOctave',
        maxBaseLabel: 'A$_instrumentMaxOctave',
        titleLabel: _text.advancedSettings,
        instrumentLabel: _text.instrument,
        instruments: instruments,
        instrumentAvailability: instrumentAvailability,
        selectedInstrument: selectedInstrument,
        missingInstrumentLabel: _text.missingInstrument,
        onInstrumentChanged: _onInstrumentChanged,
        onBaseFrequencyChanged: (v) {
          setState(() => baseFrequencyHz = v);
        },
        onBaseFrequencyChangeEnd: (v) => _applyBaseFrequency(v),
      ),
    );
  }

  Future<void> _openAdvancedSettingsPanel({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool useDialog,
  }) async {
    if (!useDialog) {
      _scaffoldKey.currentState?.openEndDrawer();
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(28),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 420,
            height: 620,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _text.advancedSettings,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        label: Text(_text.close),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                Expanded(
                  child: _buildAdvancedSettingsContent(
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Apply a custom note sequence from text input, with parsing,
  // validation, and preparation of audio assets
  Future<void> _applyCustomNoteSequenceText(
    String text, {
    NoteNotation? notation,
  }) async {
    final saved = await widget.noteSequenceController.setSequenceFromText(
      text,
      notation: notation,
    );
    if (!saved) return;

    await _refreshAppliedNoteSequence();
  }

  Future<void> _applySavedNoteSequence(SavedNoteSequence savedSequence) async {
    final imported = await widget.noteSequenceController.importSavedSequence(
      savedSequence,
    );
    if (!imported) return;

    await _refreshAppliedNoteSequence();
  }

  Future<void> _refreshAppliedNoteSequence() async {
    await stop();

    setState(() {
      noteSequence = widget.noteSequenceController.sequence;
      noteIndex = 0;
      beat = 0;
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
  }

  SavedNoteSequence? _savedSequenceByName(String name) {
    final normalizedName = name.trim().toLowerCase();
    for (final savedSequence in widget.noteSequenceController.savedSequences) {
      if (savedSequence.name.toLowerCase() == normalizedName) {
        return savedSequence;
      }
    }
    return null;
  }

  bool _hasSameSequence(
    List<String> firstSequence,
    List<String> secondSequence,
  ) {
    if (firstSequence.length != secondSequence.length) return false;

    for (int index = 0; index < firstSequence.length; index++) {
      if (firstSequence[index] != secondSequence[index]) return false;
    }
    return true;
  }

  Future<bool> _confirmReplaceSavedSequence(String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_text.replaceSequenceQuestion(name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(_text.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(_text.replace),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<void> _saveEditedNoteSequence({
    required String text,
    required String name,
    required NoteNotation notation,
  }) async {
    final parsedSequence = parseNoteSequenceText(text, notation: notation);
    if (parsedSequence.isEmpty ||
        parsedSequence.length > maxNoteSequenceLength) {
      return;
    }

    final existingSequence = _savedSequenceByName(name);
    if (existingSequence != null) {
      if (_hasSameSequence(parsedSequence, existingSequence.sequence)) {
        final hasSameText = text.trim() == existingSequence.sequenceText.trim();
        if (!hasSameText) {
          final shouldReplace = await _confirmReplaceSavedSequence(name);
          if (!shouldReplace || !mounted) return;
        } else {
          await _applyCustomNoteSequenceText(text, notation: notation);
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_text.alreadySavedNotice)));
          return;
        }
      }

      if (!_hasSameSequence(parsedSequence, existingSequence.sequence)) {
        final shouldReplace = await _confirmReplaceSavedSequence(name);
        if (!shouldReplace || !mounted) return;
      }
    }

    await _applyCustomNoteSequenceText(text, notation: notation);
    final saved = await widget.noteSequenceController.saveCurrentSequence(name);
    if (!saved || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_text.sequenceSavedNotice)));
  }

  // Open the note sequence editor bottom sheet, allowing quick text edits
  // or importing from saved sequences, with validation and preparation of audio assets for the new sequence
  Future<void> _openNoteSequenceEditor() async {
    final sequenceController = TextEditingController(
      text: widget.noteSequenceController.sequenceText,
    );
    final nameController = TextEditingController();
    final searchController = TextEditingController();

    final result = await showModalBottomSheet<_NoteSequenceEditorResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        var filteredSequences = widget.noteSequenceController
            .searchSavedSequences(searchController.text);
        String? sequenceErrorText;
        String? sequenceNameErrorText;
        var quickEntryNotation =
            widget.noteSequenceController.notation ?? NoteNotation.western;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            void setSequenceEditorText(String text) {
              sequenceController.value = TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: text.length),
              );
              setDialogState(() {
                sequenceErrorText = null;
                sequenceNameErrorText = null;
              });
            }

            void appendQuickEditNote(String note) {
              final currentText = sequenceController.text.trim();
              final nextText = currentText.isEmpty
                  ? note
                  : currentText.endsWith('/')
                  ? '$currentText$note'
                  : '$currentText $note';
              setSequenceEditorText(nextText);
            }

            void appendQuickEditHold() {
              final currentText = sequenceController.text.trim();
              if (currentText.isEmpty || currentText.endsWith('/')) return;

              setSequenceEditorText('$currentText -');
            }

            void appendQuickEditGroupSeparator() {
              final currentText = sequenceController.text.trim();
              if (currentText.isEmpty ||
                  currentText.endsWith('/') ||
                  currentText.endsWith('-')) {
                return;
              }

              setSequenceEditorText('$currentText/');
            }

            void applyQuickEditOctaveMark(String mark) {
              final tokens = sequenceController.text.trim().split(
                RegExp(r'\s+'),
              );
              if (tokens.isEmpty || tokens.first.isEmpty) return;

              final lastToken = tokens.last;
              if (lastToken == '-' || lastToken.endsWith('/')) return;

              final baseToken = lastToken.replaceFirst(RegExp(r"[,']+$"), '');
              tokens[tokens.length - 1] = lastToken.endsWith(mark)
                  ? baseToken
                  : '$baseToken$mark';

              setSequenceEditorText(tokens.join(' '));
            }

            String? toggleEasternAccidentalToken(
              String token,
              String accidental,
            ) {
              final octaveSuffix =
                  RegExp(r"[,']+$").firstMatch(token)?.group(0) ?? '';
              final baseToken = token.replaceFirst(RegExp(r"[,']+$"), '');

              const flatNotes = {'R': 'Rb', 'G': 'Gb', 'D': 'Db', 'N': 'Nb'};
              if (accidental == 'b') {
                String? natural;
                for (final entry in flatNotes.entries) {
                  if (entry.value == baseToken) {
                    natural = entry.key;
                    break;
                  }
                }
                if (natural != null) return '$natural$octaveSuffix';

                final flat = flatNotes[baseToken];
                if (flat != null) return '$flat$octaveSuffix';
              }

              if (accidental == '#') {
                if (baseToken == 'M#') return 'M$octaveSuffix';
                if (baseToken == 'M') return 'M#$octaveSuffix';
              }

              return null;
            }

            void applyQuickEditAccidental(String accidental) {
              final tokens = sequenceController.text.trim().split(
                RegExp(r'\s+'),
              );
              if (tokens.isEmpty || tokens.first.isEmpty) return;

              final easternAccidentalToken = toggleEasternAccidentalToken(
                tokens.last,
                accidental,
              );
              if (easternAccidentalToken != null) {
                tokens[tokens.length - 1] = easternAccidentalToken;
                setSequenceEditorText(tokens.join(' '));
                return;
              }

              final parsedNotes = parseNoteSequenceText(tokens.last);
              if (parsedNotes.length != 1 || parsedNotes.first.contains('/')) {
                return;
              }

              final baseNote = parsedNotes.first.substring(0, 1);
              tokens[tokens.length - 1] = parsedNotes.first.endsWith(accidental)
                  ? baseNote
                  : '$baseNote$accidental';
              setSequenceEditorText(tokens.join(' '));
            }

            void deleteQuickEditNote() {
              final tokens = sequenceController.text.trim().split(
                RegExp(r'\s+'),
              );
              if (tokens.isEmpty || tokens.first.isEmpty) return;

              tokens.removeLast();
              setSequenceEditorText(tokens.join(' '));
            }

            void clearQuickEditNotes() {
              setSequenceEditorText('');
            }

            void refreshSearchResults() {
              setDialogState(() {
                filteredSequences = widget.noteSequenceController
                    .searchSavedSequences(searchController.text);
              });
            }

            return DefaultTabController(
              length: 2,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.72,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _text.editNoteSequence,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        TabBar(
                          tabs: [
                            Tab(text: _text.quickEdit),
                            Tab(text: _text.importSequence),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  const SizedBox(height: 4),
                                  TextField(
                                    controller: sequenceController,
                                    autofocus: true,
                                    textCapitalization: TextCapitalization.none,
                                    minLines: 4,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                      labelText: _text.notesToPlay,
                                      helperText: _text.noteInputHelper,
                                      errorText: sequenceErrorText,
                                      border: const OutlineInputBorder(),
                                    ),
                                    onChanged: (_) {
                                      setDialogState(() {
                                        sequenceErrorText = null;
                                      });
                                    },
                                  ),

                                  // Quick edit chips for notes, accidentals, and small edit actions.
                                  const SizedBox(height: 10),
                                  SegmentedButton<NoteNotation>(
                                    segments: [
                                      ButtonSegment(
                                        value: NoteNotation.western,
                                        label: Text(_text.westernNotation),
                                      ),
                                      ButtonSegment(
                                        value: NoteNotation.eastern,
                                        label: Text(_text.easternNotation),
                                      ),
                                    ],
                                    selected: {quickEntryNotation},
                                    onSelectionChanged: (selection) {
                                      setDialogState(() {
                                        quickEntryNotation = selection.first;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      for (final note
                                          in quickEntryNotation ==
                                                  NoteNotation.western
                                              ? const [
                                                  'A',
                                                  'B',
                                                  'C',
                                                  'D',
                                                  'E',
                                                  'F',
                                                  'G',
                                                ]
                                              : const [
                                                  'S',
                                                  'R',
                                                  'G',
                                                  'M',
                                                  'P',
                                                  'D',
                                                  'N',
                                                ])
                                        ActionChip(
                                          label: Text(note),
                                          onPressed: () =>
                                              appendQuickEditNote(note),
                                        ),
                                      ActionChip(
                                        label: const Text('#'),
                                        onPressed: () =>
                                            applyQuickEditAccidental('#'),
                                      ),
                                      ActionChip(
                                        label: const Text('b'),
                                        onPressed: () =>
                                            applyQuickEditAccidental('b'),
                                      ),
                                      ActionChip(
                                        label: const Text("'"),
                                        onPressed: () =>
                                            applyQuickEditOctaveMark("'"),
                                      ),
                                      ActionChip(
                                        label: const Text(','),
                                        onPressed: () =>
                                            applyQuickEditOctaveMark(','),
                                      ),
                                      ActionChip(
                                        label: const Text('/'),
                                        onPressed:
                                            appendQuickEditGroupSeparator,
                                      ),
                                      ActionChip(
                                        label: const Text('-'),
                                        onPressed: appendQuickEditHold,
                                      ),
                                      TextButton(
                                        onPressed: deleteQuickEditNote,
                                        child: Text(_text.deleteNote),
                                      ),
                                      TextButton(
                                        onPressed: clearQuickEditNotes,
                                        child: Text(_text.clearNotes),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${parseNoteSequenceText(sequenceController.text, notation: quickEntryNotation).length} / $maxNoteSequenceLength',
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: nameController,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            errorText: sequenceNameErrorText,
                                            labelText: _text.sequenceName,
                                          ),
                                          onChanged: (_) {
                                            if (sequenceNameErrorText == null) {
                                              return;
                                            }
                                            setDialogState(() {
                                              sequenceNameErrorText = null;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      FilledButton(
                                        onPressed: () {
                                          final parsedSequence =
                                              parseNoteSequenceText(
                                                sequenceController.text,
                                                notation: quickEntryNotation,
                                              );
                                          final name = nameController.text
                                              .trim();
                                          if (parsedSequence.isEmpty) {
                                            setDialogState(() {
                                              sequenceErrorText =
                                                  _text.sequenceError;
                                            });
                                            return;
                                          }
                                          if (parsedSequence.length >
                                              maxNoteSequenceLength) {
                                            setDialogState(() {
                                              sequenceErrorText = _text
                                                  .noteSequenceTooLong(
                                                    maxNoteSequenceLength,
                                                  );
                                            });
                                            return;
                                          }
                                          if (name.isEmpty) {
                                            setDialogState(() {
                                              sequenceNameErrorText =
                                                  _text.sequenceNameError;
                                            });
                                            return;
                                          }
                                          Navigator.of(context).pop(
                                            _NoteSequenceEditorResult(
                                              action: _NoteSequenceEditorAction
                                                  .saveText,
                                              text: sequenceController.text
                                                  .trim(),
                                              name: name,
                                              notation: quickEntryNotation,
                                            ),
                                          );
                                        },
                                        child: Text(_text.saveSequence),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(_text.cancel),
                                      ),
                                      const SizedBox(width: 8),
                                      FilledButton(
                                        onPressed: () {
                                          final parsedSequence =
                                              parseNoteSequenceText(
                                                sequenceController.text,
                                                notation: quickEntryNotation,
                                              );
                                          if (parsedSequence.isEmpty) {
                                            setDialogState(() {
                                              sequenceErrorText =
                                                  _text.sequenceError;
                                            });
                                            return;
                                          }
                                          if (parsedSequence.length >
                                              maxNoteSequenceLength) {
                                            setDialogState(() {
                                              sequenceErrorText = _text
                                                  .noteSequenceTooLong(
                                                    maxNoteSequenceLength,
                                                  );
                                            });
                                            return;
                                          }
                                          Navigator.of(context).pop(
                                            _NoteSequenceEditorResult(
                                              action: _NoteSequenceEditorAction
                                                  .applyText,
                                              text: sequenceController.text
                                                  .trim(),
                                              notation: quickEntryNotation,
                                            ),
                                          );
                                        },
                                        child: Text(_text.apply),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextField(
                                    controller: searchController,
                                    onChanged: (_) => refreshSearchResults(),
                                    decoration: InputDecoration(
                                      labelText: _text.searchSequences,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: filteredSequences.isEmpty
                                        ? Center(
                                            child: Text(_text.noSavedSequences),
                                          )
                                        : ListView.separated(
                                            itemCount: filteredSequences.length,
                                            separatorBuilder: (_, _) =>
                                                const Divider(height: 1),
                                            itemBuilder: (context, index) {
                                              final item =
                                                  filteredSequences[index];
                                              return ListTile(
                                                title: Text(item.name),
                                                subtitle: Text(
                                                  item.sequenceText,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).pop(
                                                    _NoteSequenceEditorResult(
                                                      action:
                                                          _NoteSequenceEditorAction
                                                              .importSaved,
                                                      savedSequence: item,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    await Future<void>.delayed(const Duration(milliseconds: 350));
    sequenceController.dispose();
    nameController.dispose();
    searchController.dispose();

    if (result == null) return;
    switch (result.action) {
      case _NoteSequenceEditorAction.applyText:
        final text = result.text;
        if (text == null) return;
        await _applyCustomNoteSequenceText(text, notation: result.notation);
        break;
      case _NoteSequenceEditorAction.saveText:
        final text = result.text;
        final name = result.name;
        final notation = result.notation;
        if (text == null || name == null || notation == null) return;
        await _saveEditedNoteSequence(
          text: text,
          name: name,
          notation: notation,
        );
        break;
      case _NoteSequenceEditorAction.importSaved:
        final savedSequence = result.savedSequence;
        if (savedSequence == null) return;
        await _applySavedNoteSequence(savedSequence);
        break;
    }
  }

  // Generate a preview string for the loaded note sequence,
  // showing the first few notes and total count
  String _sequencePreviewText() {
    if (noteSequence.isEmpty) return _text.noSequenceLoaded;
    const int previewLimit = 24;
    final originalSequence = widget.noteSequenceController.sequenceText
        .trim()
        .split(RegExp(r'\s+'));
    final preview = originalSequence.take(previewLimit).join(' ');
    if (originalSequence.length <= previewLimit) return preview;
    return '$preview ...';
  }

  // Reset the score zoom level to default (1.0) and reset
  // transformation matrices for both image and PDF views
  void _resetScoreZoom() {
    scoreZoom = 1;
    _scoreTransformationController.value = Matrix4.identity();
  }

  Future<void> _renderScorePdfPage(int pageNumber) async {
    final document = scorePdfDocument;
    if (document == null) return;

    final requestId = ++_scorePdfRenderRequestId;
    final nextPage = pageNumber.clamp(1, document.pagesCount);

    setState(() {
      isScorePdfPageLoading = true;
      scorePdfPage = nextPage;
      scorePdfPages = document.pagesCount;
      _resetScoreZoom();
    });

    PdfPage? page;
    try {
      page = await document.getPage(nextPage);
      final renderScale = math.min(3.0, 2200 / page.width);
      final renderedPage = await page.render(
        width: page.width * renderScale,
        height: page.height * renderScale,
        format: PdfPageImageFormat.png,
        backgroundColor: '#FFFFFF',
      );
      if (renderedPage == null ||
          !mounted ||
          requestId != _scorePdfRenderRequestId) {
        return;
      }

      setState(() {
        scorePdfPageBytes = renderedPage.bytes;
        isScorePdfPageLoading = false;
        scoreZoom = 1;
      });
    } catch (error) {
      if (!mounted || requestId != _scorePdfRenderRequestId) return;

      setState(() {
        isScorePdfPageLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      await page?.close();
    }
  }

  Future<void> _goToScorePdfPage(int pageNumber) async {
    final document = scorePdfDocument;
    if (document == null) return;

    final nextPage = pageNumber.clamp(1, document.pagesCount);
    if (nextPage == scorePdfPage && scorePdfPageBytes != null) return;

    await _renderScorePdfPage(nextPage);
  }

  Future<void> _pickScoreFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty || !mounted) return;

      final file = result.files.single;
      final extension = file.extension?.toLowerCase();
      if (extension == 'pdf') {
        final path = file.path;
        if (path == null) return;

        final previousDocument = scorePdfDocument;
        final nextDocument = await PdfDocument.openFile(path);

        setState(() {
          scorePdfDocument = nextDocument;
          scoreImageBytes = null;
          scorePdfPageBytes = null;
          scoreFileName = file.name;
          scorePdfPage = 1;
          scorePdfPages = nextDocument.pagesCount;
          _resetScoreZoom();
        });
        await previousDocument?.close();
        await _renderScorePdfPage(1);
        return;
      }

      final bytes = file.bytes;
      if (bytes == null || bytes.isEmpty) return;

      final previousDocument = scorePdfDocument;
      setState(() {
        scorePdfDocument = null;
        scorePdfPageBytes = null;
        scoreImageBytes = bytes;
        scoreFileName = file.name;
        scorePdfPage = 1;
        scorePdfPages = 0;
        _resetScoreZoom();
      });
      await previousDocument?.close();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _setScoreZoom(double nextZoom) {
    final clampedZoom = nextZoom.clamp(0.75, 4.0).toDouble();

    setState(() {
      scoreZoom = clampedZoom;
      _scoreTransformationController.value = Matrix4.identity()
        ..scaleByDouble(clampedZoom, clampedZoom, 1.0, 1.0);
    });
  }

  // Open the score preview in a fullscreen dialog,
  // allowing zooming and navigation for both image and PDF scores
  Future<void> _openScoreFullScreen({
    required AppLanguageText text,
    required ColorScheme colorScheme,
  }) async {
    final isPdfScore = scorePdfDocument != null;
    if (scoreImageBytes == null && scorePdfPageBytes == null) return;
    final fullscreenTransformationController = TransformationController();
    var fullscreenZoom = 1.0;

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              void setFullscreenZoom(double nextZoom) {
                final clampedZoom = nextZoom.clamp(0.75, 4.0).toDouble();
                setDialogState(() {
                  fullscreenZoom = clampedZoom;
                  fullscreenTransformationController.value = Matrix4.identity()
                    ..scaleByDouble(clampedZoom, clampedZoom, 1.0, 1.0);
                });
              }

              Future<void> goToFullscreenPdfPage(int pageNumber) async {
                await _goToScorePdfPage(pageNumber);
                fullscreenTransformationController.value = Matrix4.identity();
                setDialogState(() {
                  fullscreenZoom = 1;
                });
              }

              void handleFullscreenSwipe(DragEndDetails details) {
                if (!isPdfScore) return;

                final velocity = details.primaryVelocity ?? 0;
                if (velocity < -420 && scorePdfPage < scorePdfPages) {
                  unawaited(goToFullscreenPdfPage(scorePdfPage + 1));
                }
                if (velocity > 420 && scorePdfPage > 1) {
                  unawaited(goToFullscreenPdfPage(scorePdfPage - 1));
                }
              }

              return Dialog.fullscreen(
                backgroundColor: colorScheme.surface,
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Row(
                          children: [
                            FilledButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.fullscreen_exit_rounded),
                              label: Text(text.close),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(112, 48),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                scoreFileName ?? text.scorePreview,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            IconButton.filledTonal(
                              tooltip: 'Zoom out',
                              onPressed: () =>
                                  setFullscreenZoom(fullscreenZoom - 0.25),
                              icon: const Icon(Icons.zoom_out_rounded),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 48,
                              child: Text(
                                '${(fullscreenZoom * 100).round()}%',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filledTonal(
                              tooltip: 'Zoom in',
                              onPressed: () =>
                                  setFullscreenZoom(fullscreenZoom + 0.25),
                              icon: const Icon(Icons.zoom_in_rounded),
                            ),
                            if (isPdfScore) ...[
                              const SizedBox(width: 14),
                              SizedBox(
                                width: 72,
                                child: Text(
                                  scorePdfPages == 0
                                      ? '$scorePdfPage'
                                      : '$scorePdfPage/$scorePdfPages',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Divider(height: 1, color: colorScheme.outlineVariant),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onHorizontalDragEnd: handleFullscreenSwipe,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: _buildScoreImageView(
                                  scoreImageBytes ?? scorePdfPageBytes!,
                                  controller:
                                      fullscreenTransformationController,
                                  onZoomChanged: (zoom) {
                                    setDialogState(() {
                                      fullscreenZoom = zoom;
                                    });
                                  },
                                ),
                              ),
                              if (isPdfScore && scorePdfPage < scorePdfPages)
                                Positioned(
                                  right: 18,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.68,
                                        ),
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(
                                          color: Colors.black.withValues(
                                            alpha: 0.08,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.10,
                                            ),
                                            blurRadius: 14,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: () => goToFullscreenPdfPage(
                                          scorePdfPage + 1,
                                        ),
                                        icon: const Icon(
                                          Icons.chevron_right_rounded,
                                          size: 32,
                                        ),
                                        color: Colors.black87,
                                        style: IconButton.styleFrom(
                                          minimumSize: const Size(56, 72),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (isPdfScore && scorePdfPage > 1)
                                Positioned(
                                  left: 18,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.68,
                                        ),
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(
                                          color: Colors.black.withValues(
                                            alpha: 0.08,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.10,
                                            ),
                                            blurRadius: 14,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: () => goToFullscreenPdfPage(
                                          scorePdfPage - 1,
                                        ),
                                        icon: const Icon(
                                          Icons.chevron_left_rounded,
                                          size: 32,
                                        ),
                                        color: Colors.black87,
                                        style: IconButton.styleFrom(
                                          minimumSize: const Size(56, 72),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } finally {
      fullscreenTransformationController.dispose();
    }
  }

  Widget _buildMetronomeCore({
    required AppLanguageText text,
    required bool isRunning,
    required int beatNumerator,
    required int beatDenominator,
    required List<BeatIndicatorItem> beatIndicators,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 16,
    ),
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlaybackStatusPanel(
              anim: swingAnim,
              isRunning: isRunning,
              beatNumerator: beatNumerator,
              beatDenominator: beatDenominator,
              bpm: bpm,
              bpmLabel: text.bpm,
              beatIndicators: beatIndicators,
            ),
            const SizedBox(height: 14),

            // Metronome controls panel, including BPM slider,
            // click/sound toggles, meter picker, and instrument selector
            MetronomeControlsPanel(
              noteCount: noteSequence.length,
              currentSoundListenable: currentSoundVN,
              sequencePreviewText: _sequencePreviewText(),
              onSequenceTap: _openNoteSequenceEditor,
              notesLoadedLabel: text.notesLoaded,
              clickLabel: text.click,
              soundLabel: text.sound,
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
                  '$timeSignatureBeats/$timeSignatureNote · ${_localizedBeatUnitLabel(beatUnit)}',
            ),
          ],
        ),
      ),
    );
  }

  // Build the score practice panel, which displays the loaded score
  // as an image or PDF, and provides controls for zooming and navigation
  Widget _buildScorePracticePanel({
    required AppLanguageText text,
    required ColorScheme colorScheme,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scorePanelColor = isDark ? const Color(0xFF161616) : Colors.white;
    final scorePaperColor = isDark
        ? const Color(0xFF101010)
        : const Color(0xFFFFFEFB);
    final scoreOverlayColor = isDark
        ? const Color(0xFF1D1D1D).withValues(alpha: 0.94)
        : Colors.white.withValues(alpha: 0.96);
    final scoreBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : const Color(0xFFE7E0D4);
    final staffLineColor = isDark
        ? Colors.white.withValues(alpha: 0.22)
        : const Color(0xFFD8D1C5);
    final imageBytes = scoreImageBytes;
    final pdfPageBytes = scorePdfPageBytes;
    final isPdfScore = scorePdfDocument != null;
    final hasScoreFile = imageBytes != null || pdfPageBytes != null;

    return Container(
      decoration: BoxDecoration(
        color: scorePanelColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scoreBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 14, 12),
            child: Row(
              children: [
                Icon(Icons.library_music_rounded, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text.scorePreview,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _pickScoreFile,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(text.addScore),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scorePaperColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: scoreBorderColor),
                ),
                child: !hasScoreFile
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 36,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (int group = 0; group < 4; group++)
                                    Column(
                                      children: [
                                        for (int line = 0; line < 5; line++)
                                          Container(
                                            height: 1,
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            color: staffLineColor,
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 320),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: scoreOverlayColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: scoreBorderColor),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.picture_as_pdf_rounded,
                                        size: 34,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        text.scorePlaceholderTitle,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        text.scorePlaceholderBody,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: _buildScoreImageView(
                                    imageBytes ?? pdfPageBytes!,
                                    onZoomChanged: (zoom) {
                                      setState(() {
                                        scoreZoom = zoom;
                                      });
                                    },
                                  ),
                                ),
                                if (isScorePdfPageLoading)
                                  const Positioned.fill(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: scoreOverlayColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: scoreBorderColor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isPdfScore) ...[
                                    IconButton(
                                      tooltip: 'Previous page',
                                      onPressed: scorePdfPage <= 1
                                          ? null
                                          : () => _goToScorePdfPage(
                                              scorePdfPage - 1,
                                            ),
                                      icon: const Icon(
                                        Icons.chevron_left_rounded,
                                      ),
                                    ),
                                    Text(
                                      scorePdfPages == 0
                                          ? '$scorePdfPage'
                                          : '$scorePdfPage/$scorePdfPages',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    IconButton(
                                      tooltip: 'Next page',
                                      onPressed:
                                          scorePdfPages == 0 ||
                                              scorePdfPage >= scorePdfPages
                                          ? null
                                          : () => _goToScorePdfPage(
                                              scorePdfPage + 1,
                                            ),
                                      icon: const Icon(
                                        Icons.chevron_right_rounded,
                                      ),
                                    ),
                                  ],
                                  IconButton(
                                    tooltip: 'Zoom out',
                                    onPressed: () =>
                                        _setScoreZoom(scoreZoom - 0.25),
                                    icon: const Icon(Icons.zoom_out_rounded),
                                  ),
                                  Text(
                                    '${(scoreZoom * 100).round()}%',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                  IconButton(
                                    tooltip: 'Zoom in',
                                    onPressed: () =>
                                        _setScoreZoom(scoreZoom + 0.25),
                                    icon: const Icon(Icons.zoom_in_rounded),
                                  ),
                                  IconButton(
                                    tooltip: 'Fullscreen',
                                    onPressed: () => _openScoreFullScreen(
                                      text: text,
                                      colorScheme: colorScheme,
                                    ),
                                    icon: const Icon(Icons.fullscreen_rounded),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreImageView(
    Uint8List imageBytes, {
    TransformationController? controller,
    ValueChanged<double>? onZoomChanged,
  }) {
    final activeController = controller ?? _scoreTransformationController;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: InteractiveViewer(
        transformationController: activeController,
        minScale: 0.75,
        maxScale: 4,
        panEnabled: false,
        boundaryMargin: EdgeInsets.zero,
        onInteractionEnd: (_) {
          final nextZoom = activeController.value
              .getMaxScaleOnAxis()
              .clamp(0.75, 4.0)
              .toDouble();
          onZoomChanged?.call(nextZoom);
        },
        child: Center(
          child: Image.memory(
            imageBytes,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'This image could not be loaded.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Build the main body of the metronome page, including the metronome core
  Widget _buildMetronomeBody({
    required AppLanguageText text,
    required bool isRunning,
    required int beatNumerator,
    required int beatDenominator,
    required List<BeatIndicatorItem> beatIndicators,
    required ColorScheme colorScheme,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscapeTablet =
            constraints.maxWidth >= 840 &&
            constraints.maxWidth > constraints.maxHeight;

        if (!isLandscapeTablet) {
          return Column(
            children: [
              Expanded(
                child: _buildMetronomeCore(
                  text: text,
                  isRunning: isRunning,
                  beatNumerator: beatNumerator,
                  beatDenominator: beatDenominator,
                  beatIndicators: beatIndicators,
                ),
              ),
              TransportBar(
                isRunning: isRunning,
                onStart: start,
                onStop: () => stop(),
                onReset: reset,
                startLabel: text.start,
                stopLabel: text.stop,
                resetLabel: text.reset,
              ),
            ],
          );
        }

        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: math.min(430, constraints.maxWidth * 0.38),
                      child: _buildMetronomeCore(
                        text: text,
                        isRunning: isRunning,
                        beatNumerator: beatNumerator,
                        beatDenominator: beatDenominator,
                        beatIndicators: beatIndicators,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: _buildScorePracticePanel(
                        text: text,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TransportBar(
              isRunning: isRunning,
              onStart: start,
              onStop: () => stop(),
              onReset: reset,
              startLabel: text.start,
              stopLabel: text.stop,
              resetLabel: text.reset,
            ),
          ],
        );
      },
    );
  }

  // Build the main scaffold of the metronome page, including the app bar, body, and advanced settings drawer
  @override
  Widget build(BuildContext context) {
    final text = _text;
    final isRunning = timer != null;
    final inheritedTheme = Theme.of(context);
    final pageScheme = inheritedTheme.colorScheme;
    final pageBackground = inheritedTheme.brightness == Brightness.light
        ? Colors.white
        : inheritedTheme.scaffoldBackgroundColor;
    final mediaSize = MediaQuery.sizeOf(context);
    final isLandscapeTablet =
        mediaSize.width >= 840 && mediaSize.width > mediaSize.height;
    final int beatsForDisplay = timeSignatureBeats;
    final int beatInBar = (beat == 0) ? 1 : ((beat - 1) % beatsForDisplay) + 1;
    final int beatNumerator = beatInBar;
    final int beatDenominator = timeSignatureNote;
    final beatIndicators = List.generate(beatsForDisplay, (i) {
      final accent = _accentForBeatPosition(i + 1);
      final isActive = (i + 1) == beatInBar;
      final Color activeColor = switch (accent) {
        ClickAccent.strong => pageScheme.primary,
        ClickAccent.secondary => pageScheme.secondary,
        ClickAccent.weak => pageScheme.tertiary,
      };
      final Color idleColor = switch (accent) {
        ClickAccent.strong => pageScheme.primary.withValues(alpha: 0.35),
        ClickAccent.secondary => pageScheme.secondary.withValues(alpha: 0.28),
        ClickAccent.weak => pageScheme.outlineVariant,
      };
      return BeatIndicatorItem(
        isActive: isActive,
        activeColor: activeColor,
        idleColor: idleColor,
      );
    });
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        surfaceTintColor: Colors.transparent,
        title: Text(text.metronomeTitle),
        actions: [
          IconButton(
            tooltip: text.advanced,
            onPressed: () => _openAdvancedSettingsPanel(
              theme: inheritedTheme,
              colorScheme: pageScheme,
              useDialog: isLandscapeTablet,
            ),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      endDrawer: _buildAdvancedSettingsDrawer(
        theme: inheritedTheme,
        colorScheme: pageScheme,
      ),
      body: SafeArea(
        child: _buildMetronomeBody(
          text: text,
          isRunning: isRunning,
          beatNumerator: beatNumerator,
          beatDenominator: beatDenominator,
          beatIndicators: beatIndicators,
          colorScheme: pageScheme,
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
    unawaited(scorePdfDocument?.close());
    _scoreTransformationController.dispose();
    swingController.dispose();
    super.dispose();
  }
}
