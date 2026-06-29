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

  Color _seedColorForTheme(AppThemeColor themeColor) {
    switch (themeColor) {
      case AppThemeColor.defaultColor:
        return Colors.blue;
      case AppThemeColor.rose:
        return Colors.pink;
      case AppThemeColor.purple:
        return Colors.deepPurple;
    }
  }

  Color _scaffoldBackgroundForTheme(Color seedColor, Brightness brightness) {
    final baseColor = brightness == Brightness.dark
        ? const Color(0xFF101214)
        : const Color(0xFFFAFBFC);
    final tintOpacity = brightness == Brightness.dark ? 0.20 : 0.11;

    return Color.alphaBlend(
      seedColor.withValues(alpha: tintOpacity),
      baseColor,
    );
  }

  ThemeData _themeDataFor(Color seedColor, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    );
    final scaffoldBackground = _scaffoldBackgroundForTheme(
      seedColor,
      brightness,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamilyFallback: _fontFamilyFallback,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

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
        final seedColor = _seedColorForTheme(appSettingsController.themeColor);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Metrinote',
          themeMode: appSettingsController.themeMode,
          theme: _themeDataFor(seedColor, Brightness.light),
          darkTheme: _themeDataFor(seedColor, Brightness.dark),
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
