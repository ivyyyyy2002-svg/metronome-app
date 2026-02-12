import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:math' as math;

enum ClickAccent {
  strong,
  secondary,
  weak,
}

enum BeatUnit {
  quarter,
  eighth,
  dottedQuarter,
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
class MetronomeDemo extends StatefulWidget  {
  const MetronomeDemo({super.key});
  @override
  State<MetronomeDemo> createState() => _MetronomeDemoState();
}

// The state for the MetronomeDemo widget
class _MetronomeDemoState extends State<MetronomeDemo> with SingleTickerProviderStateMixin {
  static const String _defaultStrongClickAsset = 'assets/sounds/click_hi.wav';
  static const String _defaultWeakClickAsset = 'assets/sounds/click_lo.wav';

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
  final List<int> playerTokens = List.filled(notePoolSize, 0); // for tracking which player is playing which note

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
  String selectedInstrument = 'piano';

  // base octave
  int baseOctave = 2;
  int minOctave = 2;
  int maxOctave = 6;

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
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: false,
    ));
  }

  // ---------- Config ----------
  Future<void> loadConfig() async {
    try {
      final jsonStr =
          await rootBundle.loadString('assets/config/scale_config.json');
      final data = jsonDecode(jsonStr);

      final loadedScale = List<String>.from(data['scale']);
      final loadedAsc = List<int>.from(data['ascending']);
      final loadedDesc = List<int>.from(data['descending']);
      final loadedBaseOctave =
          (data['baseoctave'] is int) ? data['baseoctave'] as int : 2;

      // safer: if steps missing or <=0, fall back to pattern length
      final rawStepsUp = data['stepsUp'];
      final rawStepsDown = data['stepsDown'];

      final loadedStepsUp =
          (rawStepsUp is int && rawStepsUp > 0) ? rawStepsUp : loadedAsc.length;
      final loadedStepsDown = (rawStepsDown is int && rawStepsDown > 0)
          ? rawStepsDown
          : loadedDesc.length;

      final loadedUseDescending = (data['useDescending'] ?? true) as bool;
      final loadedTimeSignature =
          _parseTimeSignature(data['timeSignature'], fallbackBeats: 4, fallbackNote: 4);
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
        timeSignatureBeats = loadedTimeSignature.$1;
        timeSignatureNote = loadedTimeSignature.$2;
        beatUnit = loadedBeatUnit;
        clickStrongAsset = loadedClickAssets.$1;
        clickWeakAsset = loadedClickAssets.$2;
        uiUpdateEvery = 1;

        configLoaded = true;
        buildPlayPattern();

        // Set initial sound based on first pattern index
        if (scale.isNotEmpty && playPattern.isNotEmpty) {
          final firstToken = scale[playPattern[0]];
          final parsed = _parseNoteWithOctave(firstToken);
          currentSound = parsed != null ? firstToken : '$firstToken$baseOctave';
        } else {
          currentSound = '';
        }
      });

      // Keep the UI notifier in sync immediately
      currentSoundVN.value = currentSound;
      await preloadClick();

      // Warm up first note to reduce first-hit latency
      if (configLoaded && playPattern.isNotEmpty) {
        final idx = playPattern[0];
        if (idx >= 0 && idx < scale.length) {
          final token = scale[idx];
          final parsed = _parseNoteWithOctave(token);
          final warmName = parsed != null ? token : '$token$baseOctave';

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
          'Loaded config: scale=$scale ascending=$ascending descending=$descending stepsUp=$stepsUp stepsDown=$stepsDown useDescending=$useDescending baseOctave=$baseOctave timeSignature=$timeSignatureBeats/$timeSignatureNote beatUnit=${_beatUnitToConfigValue(beatUnit)} clickAssets=[$clickStrongAsset,$clickWeakAsset]');
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
        strong is String && strong.isNotEmpty ? strong : _defaultStrongClickAsset,
        weak is String && weak.isNotEmpty ? weak : _defaultWeakClickAsset,
      );
    }
    return (
      _defaultStrongClickAsset,
      _defaultWeakClickAsset,
    );
  }

  BeatUnit _parseBeatUnit(
    dynamic raw, {
    required int fallbackBeats,
    required int fallbackNote,
  }) {
    final rawText = (raw is String) ? raw.trim().toLowerCase() : '';
    switch (rawText) {
      case 'quarter':
      case '1/4':
        return BeatUnit.quarter;
      case 'eighth':
      case '1/8':
        return BeatUnit.eighth;
      case 'dotted_quarter':
      case 'dotted-quarter':
      case 'dotted quarter':
      case '3/8':
        return BeatUnit.dottedQuarter;
      default:
        return _defaultBeatUnitForSignature(fallbackBeats, fallbackNote);
    }
  }

  BeatUnit _defaultBeatUnitForSignature(int beats, int note) {
    if (beats == 6 && note == 8) {
      return BeatUnit.dottedQuarter;
    }
    return BeatUnit.quarter;
  }

  String _beatUnitLabel(BeatUnit unit) {
    switch (unit) {
      case BeatUnit.quarter:
        return 'Quarter';
      case BeatUnit.eighth:
        return 'Eighth';
      case BeatUnit.dottedQuarter:
        return 'Dotted Quarter';
    }
  }

  String _beatUnitToConfigValue(BeatUnit unit) {
    switch (unit) {
      case BeatUnit.quarter:
        return 'quarter';
      case BeatUnit.eighth:
        return 'eighth';
      case BeatUnit.dottedQuarter:
        return 'dotted_quarter';
    }
  }

  double _beatUnitWholeNoteLength(BeatUnit unit) {
    switch (unit) {
      case BeatUnit.quarter:
        return 1.0 / 4.0;
      case BeatUnit.eighth:
        return 1.0 / 8.0;
      case BeatUnit.dottedQuarter:
        return 3.0 / 8.0;
    }
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

  Future<void> _loadClickWithFallback(AudioPlayer player, String preferredAsset) async {
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
    final signature = '$timeSignatureBeats/$timeSignatureNote';
    switch (signature) {
      case '2/4':
        return beatInBar == 1 ? ClickAccent.strong : ClickAccent.weak;
      case '3/4':
        return beatInBar == 1 ? ClickAccent.strong : ClickAccent.weak;
      case '4/4':
        if (beatInBar == 1) return ClickAccent.strong;
        if (beatInBar == 3) return ClickAccent.secondary;
        return ClickAccent.weak;
      case '6/8':
        if (beatInBar == 1) return ClickAccent.strong;
        if (beatInBar == 4) return ClickAccent.secondary;
        return ClickAccent.weak;
      default:
        return beatInBar == 1 ? ClickAccent.strong : ClickAccent.weak;
    }
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

  Future<void> _fadeOutAndPause(AudioPlayer player, {int releaseMs = 40}) async {
    try {
      const int steps = 5;
      final double startVol = player.volume;
      for (int i = 1; i <= steps; i++) {
        await Future.delayed(Duration(milliseconds: (releaseMs / steps).round()));
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
  String _resolveFullNoteName(String token, int octaveFallback) {
    final parsed = _parseNoteWithOctave(token);
    if (parsed != null) return token;
    return '$token$octaveFallback';
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
    for (final idx in playPattern) {
      if (idx < 0 || idx >= scale.length) continue;
      final token = scale[idx];
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

  // Precache AudioSources for all unique notes in the pattern (for non-per-note player mode).
  Future<void> _precacheSourcesForPattern() async {
    if (!configLoaded || playPattern.isEmpty || scale.isEmpty) return;

    final uniquePaths = <String>{};
    for (final idx in playPattern) {
      if (idx < 0 || idx >= scale.length) continue;
      final token = scale[idx];
      final full = _resolveFullNoteName(token, baseOctave);
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
        final int gateMs = math.max(80, math.min(220, (beatMs * noteGate).round()));

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

    final int playerIndex  = notePoolIndex;
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
      final int gateMs = math.max(80, math.min(220, (beatMs * noteGate).round()));

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

    // If the scale item already includes an octave (e.g., "Bb2"),
    // play exactly that note+octave. Otherwise, use the existing octave math.
    final parsed = _parseNoteWithOctave(token);

    final String noteToPlay;
    final int octaveToPlay;

    if (parsed != null) {
      noteToPlay = parsed.note;
      octaveToPlay = parsed.octave;
    } else {
      noteToPlay = token;

      // Existing behavior: raise octave after completing one full scale length.
      final int octaveOffset = stepCounter ~/ scale.length;
      int o = baseOctave + octaveOffset;
      if (o > maxOctave) o = maxOctave;
      if (o < minOctave) o = minOctave;

      octaveToPlay = o;
    }

    beat++;
    playIndex = (playIndex + 1) % playPattern.length;
    final beatInBar = ((beat - 1) % timeSignatureBeats) + 1;

    // Only advance stepCounter when octave is computed.
    // If octave is embedded in the token list, stepCounter is not needed for octave math.
    if (parsed == null) {
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

      // Set initial sound based on first pattern index
      if (scale.isNotEmpty && playPattern.isNotEmpty) {
        final firstToken = scale[playPattern[0]];
        final parsed = _parseNoteWithOctave(firstToken);
        currentSound = parsed != null ? firstToken : '$firstToken$baseOctave';
      } else {
        currentSound = '';
      }
    });

    currentSoundVN.value = currentSound;

    if (currentSound.isNotEmpty && !_usePerNotePlayers) {
      final player = notePlayers[notePoolIndex];
      notePoolIndex = (notePoolIndex + 1) % notePoolSize;
      await _prepareNoteIfNeeded(player, currentSound, preload: true);
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final isRunning = timer != null;
    final int beatsForDisplay = timeSignatureBeats;
    final int beatInBar = (beat == 0) ? 1 : ((beat - 1) % beatsForDisplay) + 1;
    final int beatNumerator = beatInBar;
    final int beatDenominator = timeSignatureNote;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(beatsForDisplay, (i) {
                        final accent = _accentForBeatPosition(i + 1);
                        final isActive = (i + 1) == beatInBar;
                        final Color activeColor = switch (accent) {
                          ClickAccent.strong => Theme.of(context).colorScheme.primary,
                          ClickAccent.secondary => Theme.of(context).colorScheme.secondary,
                          ClickAccent.weak => Theme.of(context).colorScheme.tertiary,
                        };
                        final Color idleColor = switch (accent) {
                          ClickAccent.strong => Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
                          ClickAccent.secondary => Theme.of(context).colorScheme.secondary.withValues(alpha: 0.28),
                          ClickAccent.weak => Theme.of(context).colorScheme.outlineVariant,
                        };
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 140),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: isActive ? 12 : 8,
                          height: isActive ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? activeColor : idleColor,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$bpm',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
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
                        children: const [
                          Text('30'),
                          Text('240'),
                        ],
                      )
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
                      avatar: const Icon(Icons.music_note, size: 18),
                      selected: enableSound,
                      onSelected: (v) async {
                        setState(() => enableSound = v);
                        if (!v) {
                          try {
                          } catch (_) {}
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Time signature selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Time Signature: '),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: '$timeSignatureBeats/$timeSignatureNote',
                      items: const [
                        DropdownMenuItem(value: '2/4', child: Text('2/4')),
                        DropdownMenuItem(value: '3/4', child: Text('3/4')),
                        DropdownMenuItem(value: '4/4', child: Text('4/4')),
                        DropdownMenuItem(value: '6/8', child: Text('6/8')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        final parts = v.split('/');
                        if (parts.length != 2) return;
                        final parsedBeats = int.tryParse(parts[0]);
                        final parsedNote = int.tryParse(parts[1]);
                        if (parsedBeats == null || parsedNote == null) return;
                        setState(() {
                          timeSignatureBeats = parsedBeats;
                          timeSignatureNote = parsedNote;
                          beat = 0;
                        });
                        _restartIfRunning();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Beat unit selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Beat Unit: '),
                    const SizedBox(width: 8),
                    DropdownButton<BeatUnit>(
                      value: beatUnit,
                      items: BeatUnit.values
                          .map(
                            (u) => DropdownMenuItem<BeatUnit>(
                              value: u,
                              child: Text(_beatUnitLabel(u)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          beatUnit = v;
                          beat = 0;
                        });
                        _restartIfRunning();
                      },
                    ),
                  ],
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
                      items: instruments
                          .map((ins) =>
                              DropdownMenuItem(value: ins, child: Text(ins)))
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        _onInstrumentChanged(v);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Controls
                Row(
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
              ],
            ),
          ),
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 220,
      child: AnimatedBuilder(
        animation: anim,
        builder: (context, _) {
          final angle = (amplitudeDeg * math.pi / 180.0) * anim.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 18,
                child: Container(
                  width: 180,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRunning
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    // rod
                    Container(
                      width: 6,
                      height: 150,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    // weight
                    Container(
                      width: 46,
                      height: 34,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primaryContainer,
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
