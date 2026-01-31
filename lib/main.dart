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
  Timer? timer;

  // Initialize the timer in initState
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        beat++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome Demo'),
      ),
      body: Center(
        child: Text('Metronome is running... (Beat $beat)'),
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