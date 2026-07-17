import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:metronome_app/l10n/generated/app_localizations.dart';

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
    'Noto Sans Devanagari',
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

  Locale? _localeForLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.system:
        return null;
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.chinese:
        return const Locale('zh');
      case AppLanguage.french:
        return const Locale('fr');
      case AppLanguage.hindi:
        return const Locale('hi');
      case AppLanguage.spanish:
        return const Locale('es');
    }
  }

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

    final isDark = brightness == Brightness.dark;

    final baseTheme = ThemeData(
      useMaterial3: true,
      fontFamilyFallback: _fontFamilyFallback,
      colorScheme: colorScheme,
    );

    // Refined typography: heavier display weights with tighter tracking
    // for a more contemporary, editorial feel.
    final textTheme = baseTheme.textTheme.copyWith(
      displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -2.0,
      ),
      displayMedium: baseTheme.textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
      ),
      headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    );

    // Translucent, rounded input fields that sit well on glass panels.
    final inputBorderSide = BorderSide(
      color: isDark
          ? Colors.white.withValues(alpha: 0.22)
          : colorScheme.outline.withValues(alpha: 0.55),
    );
    OutlineInputBorder inputBorder(BorderSide side) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: side,
    );

    return baseTheme.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark
            ? Color.alphaBlend(
                Colors.white.withValues(alpha: 0.05),
                scaffoldBackground,
              )
            : colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // White fill = editable. A grey fill reads as a disabled field.
        fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        border: inputBorder(inputBorderSide),
        enabledBorder: inputBorder(inputBorderSide),
        focusedBorder: inputBorder(
          BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        errorBorder: inputBorder(BorderSide(color: colorScheme.error)),
        focusedErrorBorder: inputBorder(
          BorderSide(color: colorScheme.error, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.35)
                : colorScheme.outline,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.18)
              : colorScheme.outline.withValues(alpha: 0.5),
        ),
        // Plain white fills: chips sit inside grey-tinted glass tiles, where
        // seed-tinted fills clashed. White + border keeps them tappable.
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.09)
            : Colors.white,
      ),
      sliderTheme: baseTheme.sliderTheme.copyWith(
        trackHeight: 6,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: baseTheme.dialogTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
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
          onGenerateTitle: (context) => AppLocalizations.of(context).appName,
          locale: _localeForLanguage(appSettingsController.language),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
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
            '/metronome': (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              final showTutorial = args is Map && args['showTutorial'] == true;

              return MetronomeDemo(
                noteSequenceController: noteSequenceController,
                appSettingsController: appSettingsController,
                practiceHistoryController: practiceHistoryController,
                showTutorialOnOpen: showTutorial,
              );
            },
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
