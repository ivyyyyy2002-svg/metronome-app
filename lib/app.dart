import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'pages/metronome/note_sequence_controller.dart';
import 'pages/main_home_page.dart';
import 'pages/metronome/metronome_music.dart';
import 'pages/metronome/metronome_demo_page.dart';

// Main app widget, setting up the theme and routes for the metronome application.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NoteSequenceController noteSequenceController =
      NoteSequenceController();

  @override
  void initState() {
    super.initState();
    _loadSavedNoteSequence();
  }

  Future<void> _loadSavedNoteSequence() async {
    final text = await rootBundle.loadString('assets/config/noteSequence.txt');
    final defaultSequence = parseNoteSequenceText(text);

    await noteSequenceController.load(fallbackSequence: defaultSequence);
  }

  // Builds the MaterialApp with theme and routes for the main home page and metronome demo page.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Metronome Studio',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 146, 215, 222),
          brightness: Brightness.light,
        ),
      ),
     // Sets the main home page as the initial route, 
     // passing the note sequence controller.
     home: MainHomePage(noteSequenceController: noteSequenceController),
      routes: {
        '/metronome': (context) =>
            MetronomeDemo(noteSequenceController: noteSequenceController),
      },
    );
  }

  @override
  void dispose() {
    noteSequenceController.dispose();
    super.dispose();
  }
}
