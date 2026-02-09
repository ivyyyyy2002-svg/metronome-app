import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

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
class _MetronomeDemoState extends State<MetronomeDemo> {
  int beat = 0;
  int bpm = 60; // Beats per minute
  Timer? timer;

  // just_audio players
  final AudioPlayer clickPlayer = AudioPlayer();
  final AudioPlayer notePlayer = AudioPlayer();

  bool enableClick = true; // Enable click sound
  bool enableSound = true; // Enable musical sound

  // Musical scale and patterns
  List<String> scale = [];
  List<int> ascending = [];
  List<int> descending = [];

  List<int> playPattern = [];
  int playIndex = 0;

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

  // --- cache to avoid rebuilding/setting source every beat ---
  String? _lastNotePath;
  final Map<String, AudioSource> _noteSourceCache = {};
  bool _noteReady = false;

  @override
  void initState() {
    super.initState();
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

      // safer: if steps missing or <=0, fall back to pattern length
      final rawStepsUp = data['stepsUp'];
      final rawStepsDown = data['stepsDown'];

      final loadedStepsUp =
          (rawStepsUp is int && rawStepsUp > 0) ? rawStepsUp : loadedAsc.length;
      final loadedStepsDown = (rawStepsDown is int && rawStepsDown > 0)
          ? rawStepsDown
          : loadedDesc.length;

      final loadedUseDescending = (data['useDescending'] ?? true) as bool;

      setState(() {
        scale = loadedScale;
        ascending = loadedAsc;
        descending = loadedDesc;

        stepsUp = loadedStepsUp;
        stepsDown = loadedStepsDown;
        useDescending = loadedUseDescending;

        configLoaded = true;
        buildPlayPattern();

        currentSound = (scale.isNotEmpty && playPattern.isNotEmpty)
            ? scale[playPattern[0]]
            : '';
      });

      // Warm up first note to reduce first-hit latency
      if (configLoaded && playPattern.isNotEmpty) {
        final idx = playPattern[0];
        if (idx >= 0 && idx < scale.length) {
          await _prepareNoteIfNeeded(scale[idx]);
        }
      }

      // Debug once (helps verify pattern is not stuck)
      debugPrint(
          'Loaded config: scale=$scale ascending=$ascending descending=$descending stepsUp=$stepsUp stepsDown=$stepsDown useDescending=$useDescending');
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
  Future<void> _prepareNoteIfNeeded(String note) async {
    // final path = 'assets/notes/$selectedInstrument/$note.mp3';
    final path = 'assets/notes/piano_m4a/$note.m4a';


    // If already prepared for this exact path, do nothing.
    if (_lastNotePath == path && _noteReady) return;

    try {
      final source = _noteSourceCache.putIfAbsent(
        path,
        () => AudioSource.asset(path),
      );

      await notePlayer.setAudioSource(source);
      _lastNotePath = path;
      _noteReady = true;
    } catch (e, st) {
      _noteReady = false;
      debugPrint('Prepare note failed: $note ($path) -> $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> playNoteByName(String note) async {
    try {
      await _prepareNoteIfNeeded(note);
      if (!_noteReady) return;

      // For short samples, stop+seek+play is often most stable.
      await notePlayer.stop();
      await notePlayer.seek(Duration.zero);
      await notePlayer.play();
    } catch (e, st) {
      // final path = 'assets/notes/$selectedInstrument/$note.mp3';
      final path = 'assets/notes/piano_m4a/$note.m4a';
      debugPrint('Failed to play note $note ($path): $e');
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
      await _prepareNoteIfNeeded(currentSound);
    }
  }

  // ---------- Control ----------
  void changeBPM(int delta) {
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

  void start() {
    if (timer != null) return;
    if (!configLoaded) return;
    if (scale.isEmpty || playPattern.isEmpty) return;

    timer = Timer.periodic(
      Duration(milliseconds: (60000 / bpm).round()),
      (Timer t) {
        if (playPattern.isEmpty) return;

        final idx = playPattern[playIndex];
        if (idx < 0 || idx >= scale.length) return;

        final soundToPlay = scale[idx];

        setState(() {
          beat++;
          currentSound = soundToPlay;
          playIndex = (playIndex + 1) % playPattern.length;
        });

        if (enableClick) {
          playClick();
        }
        if (enableSound) {
          playNoteByName(soundToPlay);
        }
      },
    );
  }

  Future<void> stop() async {
    timer?.cancel();
    timer = null;

    try {
      await clickPlayer.pause();
      await notePlayer.pause();
    } catch (_) {}
  }

  Future<void> reset() async {
    await stop();
    setState(() {
      beat = 0;
      playIndex = 0;
      currentSound = (scale.isNotEmpty && playPattern.isNotEmpty)
          ? scale[playPattern[0]]
          : '';
    });

    if (currentSound.isNotEmpty) {
      await _prepareNoteIfNeeded(currentSound);
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final audioStatus = clickReady ? 'Audio: Ready' : 'Audio: Loading/Failed';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(audioStatus),
            const SizedBox(height: 20),
            Text(
              'Beat: $beat',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'BPM: $bpm',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              'Sound: $currentSound',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Enable Click Sound'),
              value: enableClick,
              onChanged: (bool value) async {
                setState(() => enableClick = value);
                if (!value) {
                  try {
                    await clickPlayer.pause();
                  } catch (_) {}
                }
              },
            ),
            SwitchListTile(
              title: const Text('Enable Musical Sound'),
              value: enableSound,
              onChanged: (bool value) async {
                setState(() => enableSound = value);
                if (!value) {
                  try {
                    await notePlayer.pause();
                  } catch (_) {}
                }
              },
            ),
            const SizedBox(height: 20),

            DropdownButton<String>(
              value: selectedInstrument,
              items: instruments
                  .map((ins) => DropdownMenuItem(value: ins, child: Text(ins)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                _onInstrumentChanged(v);
              },
            ),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => changeBPM(-1),
                      child: const Text('-1 BPM'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => changeBPM(1),
                      child: const Text('+1 BPM'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => changeBPM(-10),
                      child: const Text('-10 BPM'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => changeBPM(10),
                      child: const Text('+10 BPM'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: start,
            tooltip: 'Start',
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => stop(),
            tooltip: 'Stop',
            child: const Icon(Icons.stop),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => reset(),
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    clickPlayer.dispose();
    notePlayer.dispose();
    super.dispose();
  }
}
