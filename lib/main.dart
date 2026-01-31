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
  int bpm = 120; // Beats per minute
  Timer? timer;

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
      });
    });
  }

  // Stop the metronome
  void stop(){
    timer?.cancel();
    timer = null;
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
          FloatingActionButton(
            onPressed: start,
            tooltip: 'Start',
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: stop,
            tooltip: 'Stop',
            child: const Icon(Icons.stop),
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