import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'pages/app_settings_controller.dart';
import 'pages/metronome/note_sequence_controller.dart';
import 'pages/practice_history_controller.dart';
import 'pages/main_home_page.dart';
import 'pages/music_basics_page.dart';
import 'pages/metronome/metronome_music.dart';
import 'pages/metronome/metronome_demo_page.dart';

// Main app widget, setting up the theme and routes for the metronome application.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// The state of the main app widget, responsible for loading the note sequence
class _MyAppState extends State<MyApp> {
  static const List<String> _fontFamilyFallback = [
    // Common Chinese fonts for better character support
    'PingFang SC',
    'Noto Sans CJK SC',
    'Microsoft YaHei',
    'Arial Unicode MS',
  ];

  final NoteSequenceController noteSequenceController =
      NoteSequenceController();
  final AppSettingsController appSettingsController = AppSettingsController();
  final PracticeHistoryController practiceHistoryController =
      PracticeHistoryController();

  @override
  void initState() {
    super.initState();
    _loadSavedNoteSequence();
    appSettingsController.load();
    practiceHistoryController.load();
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
            fontFamilyFallback: _fontFamilyFallback,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 146, 215, 222),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamilyFallback: _fontFamilyFallback,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 146, 215, 222),
              brightness: Brightness.dark,
            ),
          ),
          home: MainHomePage(
            noteSequenceController: noteSequenceController,
            appSettingsController: appSettingsController,
            practiceHistoryController: practiceHistoryController,
          ),
          routes: {
            '/metronome': (context) => MetronomeDemo(
              noteSequenceController: noteSequenceController,
              appSettingsController: appSettingsController,
              practiceHistoryController: practiceHistoryController,
            ),
            '/music-basics': (context) =>
                MusicBasicsPage(appSettingsController: appSettingsController),
          },
        );
      },
    );
  }

  @override
  void dispose() {
    noteSequenceController.dispose();
    appSettingsController.dispose();
    practiceHistoryController.dispose();
    super.dispose();
  }
}
