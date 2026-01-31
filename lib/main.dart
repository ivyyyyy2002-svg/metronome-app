import 'package:flutter/material.dart';
import 'dart:async';

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
  int bpm = 90; // Beats per minute
  Timer? timer;

  // Musical scale sounds
  final List<String> scale = ['Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Ti']; // Example scale
  final List<int> pattern = [0, 1, 2, 3, 2, 1, 0]; // Example pattern
  int scaleIndex = 0;
  int patternIndex = 0;
  String currentSound = 'Do';

  // Initialize the timer in initState
  @override
  void initState() {
    super.initState();
  }

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

  // Start the metronome
  void start(){
    if (timer != null) return; // Prevent multiple timers

    timer = Timer.periodic(Duration(milliseconds: (60000 / bpm).round()), (Timer t) {
      setState(() {
        beat++;
        // Cycle through sounds
        currentSound = scale[pattern[patternIndex]];
        patternIndex = (patternIndex + 1) % pattern.length;
      });
    });
  }

  // Stop the metronome
  void stop(){
    timer?.cancel();
    timer = null;
  }

  // Reset the metronome
  void reset(){
    stop();
    setState(() {
      beat = 0;
      patternIndex = 0;
      currentSound = scale[pattern[0]];
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => changeBPM(-5),
                  child: const Text('-5 BPM'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => changeBPM(5),
                  child: const Text('+5 BPM'),
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
            onPressed: stop,
            tooltip: 'Stop',
            child: const Icon(Icons.stop),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(// Reset button
            onPressed: reset,
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
    super.dispose();
  }
}