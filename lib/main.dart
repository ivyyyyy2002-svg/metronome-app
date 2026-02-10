import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:math' as math;

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
  // Animation for pendulum swing
  late final AnimationController swingController;
  late Animation<double> swingAnim;

  // Metronome state
  int beat = 0;
  int bpm = 60; // Beats per minute
  Timer? timer;

  // just_audio players
  final AudioPlayer clickPlayer = AudioPlayer();

  // Note player pool to allow overlapping notes without cutting off
  static const int notePoolSize = 4;
  late final List<AudioPlayer> notePlayers;
  int notePoolIndex = 0;
  double noteGate = 0.7; // how long the note plays before cutting off
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

  // Available instruments
  final List<String> instruments = ['piano', 'flute', 'sine'];
  String selectedInstrument = 'piano';

  // base octave
  int baseOctave = 4;
  int minOctave = 3;
  int maxOctave = 5;

  // --- cache to avoid rebuilding/setting source every beat ---
  String? _lastNotePath;
  final Map<String, AudioSource> _noteSourceCache = {};
  bool _noteReady = false;

  // --- timing state for stable ticks (avoid Timer.periodic jitter) ---
  int _tickGen = 0;
  int _intervalMs = 1000;

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

    _initAudio(); // session + preload
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

    await preloadClick();
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
          (data['baseoctave'] is int) ? data['baseoctave'] as int : 4;

      // safer: if steps missing or <=0, fall back to pattern length
      final rawStepsUp = data['stepsUp'];
      final rawStepsDown = data['stepsDown'];

      final loadedStepsUp =
          (rawStepsUp is int && rawStepsUp > 0) ? rawStepsUp : loadedAsc.length;
      final loadedStepsDown = (rawStepsDown is int && rawStepsDown > 0)
          ? rawStepsDown
          : loadedDesc.length;

      final loadedUseDescending = (data['useDescending'] ?? true) as bool;

      // Debug print loaded values before applying
      setState(() {
        scale = loadedScale;
        ascending = loadedAsc;
        descending = loadedDesc;

        stepsUp = loadedStepsUp;
        stepsDown = loadedStepsDown;
        useDescending = loadedUseDescending;
        baseOctave = loadedBaseOctave;

        configLoaded = true;
        buildPlayPattern();

        currentSound = (scale.isNotEmpty && playPattern.isNotEmpty)
            ? '${scale[playPattern[0]]}$baseOctave'
            : '';
      });

      // Warm up first note to reduce first-hit latency
      if (configLoaded && playPattern.isNotEmpty) {
        final idx = playPattern[0];
        if (idx >= 0 && idx < scale.length) {
          final player = notePlayers[notePoolIndex];
          notePoolIndex = (notePoolIndex + 1) % notePoolSize;
          await _prepareNoteIfNeeded(player, '${scale[idx]}$baseOctave');
        }
      }

      // Debug once (helps verify pattern is not stuck)
      debugPrint(
          'Loaded config: scale=$scale ascending=$ascending descending=$descending stepsUp=$stepsUp stepsDown=$stepsDown useDescending=$useDescending baseOctave=$baseOctave');
      debugPrint('playPattern=$playPattern');
    } catch (e, st) {
      debugPrint('Failed to load config: $e');
      debugPrintStack(stackTrace: st);
      setState(() {
        configLoaded = false;
        currentSound = 'Config load failed';
      });
    }
  }

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

  // ---------- Audio (just_audio) ----------
  Future<void> preloadClick() async {
    try {
      await clickPlayer.setAsset('assets/sounds/click.wav');
      clickReady = true;
      if (mounted) setState(() {});
    } catch (e, st) {
      debugPrint('Click preload failed: $e');
      debugPrintStack(stackTrace: st);
      clickReady = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> playClick() async {
    if (!clickReady) {
      await preloadClick();
      if (!clickReady) return;
    }
    try {
      // more reliable for short sounds than just seek+play
      await clickPlayer.stop();
      await clickPlayer.seek(Duration.zero);
      await clickPlayer.play();
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

  Future<void> _fadeOutAndPause(AudioPlayer player, {int releaseMs = 25}) async {
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

  // Play note by name and octave
  Future<void> playNoteByName(String note, int octave) async {
    final int playerIndex  = notePoolIndex;
    notePoolIndex = (notePoolIndex + 1) % notePoolSize;
    final AudioPlayer player = notePlayers[playerIndex];

    // Increment token for this player
    final int token = ++playerTokens[playerIndex];

    try {
      // No stop: allows overlapping notes
      await _prepareNoteIfNeeded(player, '$note$octave', preload: true);
      if (!_noteReady) return;

      await player.seek(Duration.zero);
      await player.play();

      // Schedule stop after gate duration
      final int beatMs = (60000 / bpm).round();
      final int gateMs = math.max(30, (beatMs * noteGate).round());

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

  Future<void> _onInstrumentChanged(String newInstrument) async {
    setState(() => selectedInstrument = newInstrument);

    _lastNotePath = null;
    _noteReady = false;
    _noteSourceCache.clear();

    // Warm up current sound again
    if (currentSound.isNotEmpty) {
      final player = notePlayers[notePoolIndex];
      notePoolIndex = (notePoolIndex + 1) % notePoolSize;
      await _prepareNoteIfNeeded(player, currentSound, preload: false);
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

    if (timer != null) {
      stop();
      start();
    }
  }

  // Apply new BPM value, update animation and timer if running
  void _applyBpm(int newBpm) {
    setState(() {
      bpm = newBpm.clamp(30, 240);
    });

    // Update swing animation duration
    swingController.duration = Duration(milliseconds: (60000 / bpm).round());

    // If timer is running, restart it with new BPM
    if (timer != null) {
      stop();
      start();
    }
  }

  void _onTick() {
    if (playPattern.isEmpty) return;

    final idx = playPattern[playIndex];
    final soundToPlay = scale[idx];

    // Calculate octave based on how many times we've looped through the pattern
    final int octaveOffset = stepCounter ~/ scale.length; // 0,1,2...
    int octaveToPlay = baseOctave + octaveOffset;

    if (octaveToPlay > maxOctave) {
      octaveToPlay = maxOctave;
    } else if (octaveToPlay < minOctave) {
      octaveToPlay = minOctave;
    }

    setState(() {
      beat++;
      currentSound = '$soundToPlay$octaveToPlay';
      playIndex = (playIndex + 1) % playPattern.length;
      stepCounter++;
    });

    if (enableClick) {
      playClick();
    }
    if (enableSound) {
      playNoteByName(soundToPlay, octaveToPlay);
    }
  }

  // Start the metronome
  void start() {
    if (timer != null) return;
    if (!configLoaded) return;
    if (scale.isEmpty || playPattern.isEmpty) return;

    _intervalMs = (60000 / bpm).round();
    final int gen = ++_tickGen;

    // Start the swing animation
    swingController.duration = Duration(milliseconds: _intervalMs);
    swingController.repeat(reverse: true);

    // Stable tick scheduling (avoids Timer.periodic drift/jitter)
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

    try {
      await clickPlayer.pause();
    } catch (_) {}

    // Invalidate scheduled gate timers and stop notes
    for (int i = 0; i < notePlayers.length; i++) {
      playerTokens[i]++;
      try {
        await notePlayers[i].pause();
        await notePlayers[i].seek(Duration.zero);
        notePlayers[i].setVolume(1.0);
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
      currentSound = (scale.isNotEmpty && playPattern.isNotEmpty)
          ? '${scale[playPattern[0]]}$baseOctave'
          : '';
    });

    if (currentSound.isNotEmpty) {
      final player = notePlayers[notePoolIndex];
      notePoolIndex = (notePoolIndex + 1) % notePoolSize;
      await _prepareNoteIfNeeded(player, currentSound, preload: false);
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final isRunning = timer != null;

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

                // BPM big number
                Text(
                  '$bpm',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  'BPM',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 12),

                // Current sound display
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.music_note),
                      const SizedBox(width: 8),
                      Text(
                        currentSound.isEmpty ? '-' : currentSound,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

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

                // Toggles
                SwitchListTile(
                  title: const Text('Click'),
                  value: enableClick,
                  onChanged: (v) async {
                    setState(() => enableClick = v);
                    if (!v) {
                      try {
                        await clickPlayer.pause();
                      } catch (_) {}
                    }
                  },
                ),
                SwitchListTile(
                  title: const Text('Sound'),
                  value: enableSound,
                  onChanged: (v) async {
                    setState(() => enableSound = v);
                    if (!v) {
                      try {
                      } catch (_) {}
                    }
                  },
                ),

                const SizedBox(height: 6),

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

                const SizedBox(height: 12),

                // Octave range display (optional)
                Text(
                  'Octave range: C$minOctave ~ C$maxOctave (base: $baseOctave)',
                  style: Theme.of(context).textTheme.bodySmall,
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
    clickPlayer.dispose();
    for (final p in notePlayers) {
      p.dispose();
    }
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
