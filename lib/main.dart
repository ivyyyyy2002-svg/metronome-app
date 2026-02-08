import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


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
        // Use the seed color to generate a color scheme.
        
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

  // Audio players
  final AudioPlayer clickPlayer = AudioPlayer();
  final AudioPlayer soundPlayer = AudioPlayer();

  bool enableClick = true;// Enable click sound
  bool enableSound = true;// Enable musical sound

  // Musical scale and patterns
  List<String> scale = []; // Example scale
  List<int> ascending = []; // Example pattern
  List<int> descending = []; // Example pattern

  List<int> playPattern = []; // Current pattern to play
  int playIndex = 0; // Index in the current pattern

  int stepsUp = 0; // Steps up in the pattern
  int stepsDown = 0; // Steps down in the pattern
  bool useDescending = false; // Whether to use descending pattern

  int patternIndex = 0;
  String currentSound = '';
  bool configLoaded = false;

  // Build the play pattern based on the current settings
  void buildPlayPattern() {
  playPattern = [];
  if (ascending.isEmpty) return;

  // Up: fill exactly stepsUp (cycle through ascending)
  for (int i = 0; i < stepsUp; i++) {
    playPattern.add(ascending[i % ascending.length]);
  }

  // Down: fill exactly stepsDown (cycle through descending)
  if (useDescending && descending.isNotEmpty) {
    for (int i = 0; i < stepsDown; i++) {
      playPattern.add(descending[i % descending.length]);
    }
  }

  playIndex = 0;
}


  // Load configuration from JSON file
  Future<void> loadConfig() async {
  try {
    final jsonStr = await rootBundle.loadString('assets/config/scale_config.json');
    final data = jsonDecode(jsonStr);

    final loadedScale = List<String>.from(data['scale']);
    final loadedAsc = List<int>.from(data['ascending']);
    final loadedDesc = List<int>.from(data['descending']);
    
    final loadedStepsUp = (data['stepsUp'] ?? loadedAsc.length) as int;
    final loadedStepsDown = (data['stepsDown'] ?? loadedDesc.length) as int;
    final loadedUseDescending = (data['useDescending'] ?? true) as bool;


    setState(() {
      scale = loadedScale;
      ascending = loadedAsc;
      descending = loadedDesc;
      stepsUp = loadedStepsUp;
      stepsDown = loadedStepsDown;
      useDescending = loadedUseDescending;

      patternIndex = 0;
      currentSound = (scale.isNotEmpty && ascending.isNotEmpty) ? scale[ascending[0]] : '';
      configLoaded = true;

      buildPlayPattern();
    });
  } catch (e) {
    // Handle error (e.g., file not found, JSON parsing error)
    debugPrint('Failed to load config: $e');
    setState(() {
      configLoaded = false;
      currentSound = 'Config load failed';
    });
  }
}

  // Initialize the timer in initState
  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  // Change BPM
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
  
  // Play click sound
  Future<void> playClick() async {
    await clickPlayer.stop();
    await clickPlayer.play(AssetSource('sounds/click.wav'));
  }

  // Play musical sound
  Future<void> playSound(String sound) async {
    await soundPlayer.stop();
    await soundPlayer.play(AssetSource('sounds/$sound.wav'));
  }

  // Start the metronome
  void start(){
    if (timer != null) return; // Prevent multiple timers
    if (!configLoaded) return; // Wait for config to load
    if (scale.isEmpty || ascending.isEmpty) return; // Ensure patterns are loaded
    // Calculate interval based on BPM
    timer = Timer.periodic(Duration(milliseconds: (60000 / bpm).round()), (Timer t) {
      final idx = playPattern[playIndex];
      final soundToPlay = scale[idx];

      setState(() {
        beat++;
        // Cycle through sounds
        currentSound = soundToPlay;
        playIndex = (playIndex + 1) % playPattern.length;
      });

      if (enableClick) playClick();// Play click sound
      if (enableSound) playSound(soundToPlay); // Play musical sound

      if (playPattern.isEmpty) return;
    });
  }

  // Stop the metronome
  Future<void> stop() async {
    timer?.cancel();
    timer = null;

    await clickPlayer.stop();// Stop click sound
    await soundPlayer.stop();// Stop musical sound
  }

  // Reset the metronome
  Future<void> reset() async {
    await stop();
    setState(() {
      beat = 0;
      patternIndex = 0;
      currentSound = (scale.isNotEmpty && ascending.isNotEmpty) ? scale[ascending[0]] : '';
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(// Display the current beat
              'Beat: $beat',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            Text(// Display the current BPM
              'BPM: $bpm',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            Text(// Display the current sound
              'Sound: $currentSound',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            SwitchListTile(// Toggle for click sound
              title: const Text('Enable Click Sound'),
              value: enableClick,
              onChanged: (bool value) async{
                setState(() => enableClick = value);
                if (!value) {
                  await clickPlayer.stop();
                }
              },
            ),
            SwitchListTile(// Toggle for musical sound
              title: const Text('Enable Musical Sound'),
              value: enableSound,
              onChanged: (bool value) async{
                setState(() => enableSound = value);
                if (!value) {
                  await soundPlayer.stop();
                }
              },
            ),
            const SizedBox(height: 20),
            
            Column(
              children: [
                // First row: ±1 BPM
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

                // Second row: ±10 BPM
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

      // Floating action buttons to control the metronome
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(// Start button
            onPressed: start,
            tooltip: 'Start',
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(// Stop button
            onPressed: () => stop(),
            tooltip: 'Stop',
            child: const Icon(Icons.stop),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(// Reset button
            onPressed: () => reset(),
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  // Clean up the timer when the widget is disposed
  @override
  void dispose() {
    timer?.cancel();
    clickPlayer.dispose();
    soundPlayer.dispose();
    super.dispose();
  }
}