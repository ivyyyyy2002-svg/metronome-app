import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:metronome_app/pages/app_settings_controller.dart';
import 'package:metronome_app/pages/main_home_page.dart';
import 'package:metronome_app/pages/metronome/note_sequence_controller.dart';
import 'package:metronome_app/pages/practice_history_controller.dart';

Future<Widget> _buildHome() async {
  final noteSequenceController = NoteSequenceController();
  await noteSequenceController.load(fallbackSequence: ['C', 'D', 'E', 'F']);
  final appSettingsController = AppSettingsController();
  await appSettingsController.load();
  final practiceHistoryController = PracticeHistoryController();
  await practiceHistoryController.load();

  return MaterialApp(
    home: MainHomePage(
      noteSequenceController: noteSequenceController,
      appSettingsController: appSettingsController,
      practiceHistoryController: practiceHistoryController,
    ),
    routes: {'/metronome': (_) => const Scaffold(body: Text('metronome'))},
  );
}

void _usePhoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532); // iPhone-ish
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

Future<void> _settle(WidgetTester tester, [int frames = 10]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('first run shows the tutorial automatically', (tester) async {
    _usePhoneSize(tester);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(await _buildHome());
    await _settle(tester);

    expect(find.text('Welcome! Practice starts here'), findsOneWidget);

    // Close it so no tickers/timers leak into teardown.
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Welcome! Practice starts here'), findsNothing);
  });

  testWidgets('settings replay starts the tutorial again', (tester) async {
    _usePhoneSize(tester);
    SharedPreferences.setMockInitialValues({'app_tutorial_seen_v2': true});
    await tester.pumpWidget(await _buildHome());
    await _settle(tester);

    // Seen flag set: no tutorial on open.
    expect(find.text('Welcome! Practice starts here'), findsNothing);

    // Open settings sheet.
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await _settle(tester, 8);
    expect(find.text('Watch tutorial again'), findsOneWidget);

    // Tap replay (scroll it into view first in case the sheet scrolls).
    await tester.ensureVisible(find.text('Watch tutorial again'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Watch tutorial again'));
    await _settle(tester, 15);

    expect(find.text('Welcome! Practice starts here'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('header help button starts the tutorial directly', (
    tester,
  ) async {
    _usePhoneSize(tester);
    SharedPreferences.setMockInitialValues({'app_tutorial_seen_v2': true});
    await tester.pumpWidget(await _buildHome());
    await _settle(tester);
    expect(find.text('Welcome! Practice starts here'), findsNothing);

    await tester.tap(find.byIcon(Icons.help_outline_rounded));
    await _settle(tester);

    expect(find.text('Welcome! Practice starts here'), findsOneWidget);

    // Interactive tab step: highlight allows real taps on the tab bar.
    await tester.tap(find.text('Next')); // to history step
    await _settle(tester, 5);
    await tester.tap(find.text('Next')); // to interactive tabs step
    await _settle(tester, 5);
    expect(find.text('Four tabs, one workflow'), findsOneWidget);

    await tester.tap(find.text('Sequences'));
    await _settle(tester, 15); // success + auto-advance

    expect(find.text('Start from an example'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('completed home tour waits for user to start metronome', (
    tester,
  ) async {
    _usePhoneSize(tester);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(await _buildHome());
    await _settle(tester);

    await tester.tap(find.text('Next')); // Practice intro.
    await _settle(tester, 5);
    await tester.tap(find.text('Next')); // History.
    await _settle(tester, 5);
    await tester.tap(find.text('Sequences')); // Interactive navigation.
    await _settle(tester, 12);
    await tester.tap(find.text('Next')); // Examples.
    await _settle(tester, 5);
    await tester.tap(find.text('Next')); // Sequence editor.
    await _settle(tester, 5);
    await tester.tap(find.text('Next')); // Tools.
    await _settle(tester, 5);
    await tester.tap(find.text('Next')); // Basics.
    await _settle(tester, 5);
    await tester.tap(find.text('Done')); // Settings and replay.
    await _settle(tester, 8);

    expect(find.text('Back to home base'), findsOneWidget);
    expect(find.text('metronome'), findsNothing);

    await tester.tap(find.text('Practice'));
    await _settle(tester, 12);
    expect(find.text('Start when you are ready'), findsOneWidget);
    expect(find.text('metronome'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('start-metronome-button')));
    await _settle(tester, 15);

    expect(find.text('metronome'), findsOneWidget);
  });
}
