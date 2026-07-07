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

  static const Color _defaultThemeSeed = Color(0xFFC18A2B);
  static const Color _defaultDarkBackground = Color(0xFF111111);
  static const Color _roseLightBackground = Color(0xFFFFF8FA);
  static const Color _warmLightBackground = Color(0xFFFFFCF5);
  static const Color _tealLightBackground = Color(0xFFF5FFFC);

  Color _seedColorForTheme(AppThemeColor themeColor) {
    switch (themeColor) {
      case AppThemeColor.defaultColor:
        return Colors.blue;
      case AppThemeColor.rose:
        return Colors.pink;
      case AppThemeColor.purple:
        return Colors.deepPurple;
      case AppThemeColor.warm:
        return _defaultThemeSeed;
      case AppThemeColor.teal:
        return Colors.teal;
    }
  }

  Color _scaffoldBackgroundForTheme(
    AppThemeColor themeColor,
    Color seedColor,
    Brightness brightness,
  ) {
    if (brightness == Brightness.light) {
      switch (themeColor) {
        case AppThemeColor.rose:
          return _roseLightBackground;
        case AppThemeColor.warm:
          return _warmLightBackground;
        case AppThemeColor.teal:
          return _tealLightBackground;
        case AppThemeColor.defaultColor:
        case AppThemeColor.purple:
          break;
      }
    }

    if (themeColor == AppThemeColor.warm && brightness == Brightness.dark) {
      return _defaultDarkBackground;
    }

    final baseColor = brightness == Brightness.dark
        ? const Color(0xFF101214)
        : const Color(0xFFFAFBFC);
    final tintOpacity = brightness == Brightness.dark ? 0.20 : 0.11;

    return Color.alphaBlend(
      seedColor.withValues(alpha: tintOpacity),
      baseColor,
    );
  }

  ColorScheme _colorSchemeForTheme(
    AppThemeColor themeColor,
    Color seedColor,
    Brightness brightness,
  ) {
    final generatedScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    );

    if (brightness == Brightness.dark) {
      return generatedScheme;
    }

    switch (themeColor) {
      case AppThemeColor.rose:
        return generatedScheme.copyWith(
          primary: const Color(0xFFF06D9D),
          onPrimary: const Color(0xFF3A1020),
          primaryContainer: const Color(0xFFFFD8E5),
          onPrimaryContainer: const Color(0xFF4A1027),
          secondaryContainer: const Color(0xFFFFE8EF),
          onSecondaryContainer: const Color(0xFF49303A),
          surface: Colors.white,
          surfaceContainerHighest: const Color(0xFFFFEDF3),
        );
      case AppThemeColor.warm:
        return generatedScheme.copyWith(
          primary: const Color(0xFFE0A92F),
          onPrimary: const Color(0xFF2A1B00),
          primaryContainer: const Color(0xFFF6D77A),
          onPrimaryContainer: const Color(0xFF382500),
          secondaryContainer: const Color(0xFFFFEAB4),
          onSecondaryContainer: const Color(0xFF463716),
          surface: Colors.white,
          surfaceContainerHighest: const Color(0xFFFFEFC6),
        );
      case AppThemeColor.teal:
        return generatedScheme.copyWith(
          primary: const Color(0xFF26A69A),
          onPrimary: const Color(0xFF003732),
          primaryContainer: const Color(0xFFB2DFDB),
          onPrimaryContainer: const Color(0xFF003B36),
          secondaryContainer: const Color(0xFFD9F3EF),
          onSecondaryContainer: const Color(0xFF244B46),
          surface: Colors.white,
          surfaceContainerHighest: const Color(0xFFE0F2F1),
        );
      case AppThemeColor.defaultColor:
      case AppThemeColor.purple:
        return generatedScheme;
    }
  }

  ThemeData _themeDataFor(
    AppThemeColor themeColor,
    Color seedColor,
    Brightness brightness,
  ) {
    final colorScheme = _colorSchemeForTheme(themeColor, seedColor, brightness);
    final scaffoldBackground = _scaffoldBackgroundForTheme(
      themeColor,
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
          theme: _themeDataFor(
            appSettingsController.themeColor,
            seedColor,
            Brightness.light,
          ),
          darkTheme: _themeDataFor(
            appSettingsController.themeColor,
            seedColor,
            Brightness.dark,
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
