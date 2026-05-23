import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'pages/app_settings_controller.dart';
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
  final AppSettingsController appSettingsController = AppSettingsController();

  @override
  void initState() {
    super.initState();
    _loadSavedNoteSequence();
    appSettingsController.load();
  }

  Future<void> _loadSavedNoteSequence() async {
    final text = await rootBundle.loadString('assets/config/noteSequence.txt');
    final defaultSequence = parseNoteSequenceText(text);

    await noteSequenceController.load(fallbackSequence: defaultSequence);
  }

  // Builds the MaterialApp with theme and routes, using the app
  // settings controller to determine the theme mode and providing
  // the note sequence controller to the home page and metronome demo
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettingsController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Metronome Studio',
          themeMode: appSettingsController.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 146, 215, 222),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 146, 215, 222),
              brightness: Brightness.dark,
            ),
          ),
          home: MainHomePage(
            noteSequenceController: noteSequenceController,
            appSettingsController: appSettingsController,
          ),
          routes: {
            '/metronome': (context) =>
                MetronomeDemo(noteSequenceController: noteSequenceController),
          },
        );
      },
    );
  }

  @override
  void dispose() {
    noteSequenceController.dispose();
    appSettingsController.dispose();
    super.dispose();
  }
}
