import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metronome_app/pages/widgets/coach_mark_tutorial.dart';

void main() {
  testWidgets('coach mark tutorial shows, advances, and completes', (
    tester,
  ) async {
    final targetKey = GlobalKey();
    final actions = CoachMarkActionNotifier();
    Future<CoachMarkTutorialResult>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: Column(
                  children: [
                    Container(
                      key: targetKey,
                      width: 120,
                      height: 44,
                      color: Colors.red,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        result = showCoachMarkTutorial(
                          context: context,
                          steps: [
                            CoachMarkStep(
                              targetKey: targetKey,
                              title: 'Step One',
                              body: 'Body one',
                              example: 'Example text',
                              icon: Icons.speed_rounded,
                            ),
                            CoachMarkStep(
                              targetKey: targetKey,
                              title: 'Step Two',
                              body: 'Body two',
                              icon: Icons.touch_app_rounded,
                              actionId: 'poke',
                              actionHint: 'poke the box.',
                            ),
                          ],
                          nextLabel: 'Next',
                          doneLabel: 'Done',
                          skipLabel: 'Skip',
                          tryItLabel: 'Try it:',
                          skipStepLabel: 'Skip this step',
                          wellDoneLabel: 'Nice!',
                          stepCountLabel: (c, t) => '$c of $t',
                          actions: actions,
                        );
                      },
                      child: const Text('open tutorial'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open tutorial'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Step One'), findsOneWidget);
    expect(find.text('Example text'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Step Two'), findsOneWidget);

    // Interactive step: report the action, expect success state then
    // auto-advance to completion.
    actions.notify('poke');
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Nice!'), findsWidgets);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 400));

    expect(await result, CoachMarkTutorialResult.completed);
    expect(find.text('Step Two'), findsNothing);
  });

  testWidgets('skip ends the tutorial', (tester) async {
    final targetKey = GlobalKey();
    Future<CoachMarkTutorialResult>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  result = showCoachMarkTutorial(
                    context: context,
                    steps: [
                      CoachMarkStep(
                        targetKey: targetKey, // not attached: fallback rect
                        title: 'Orphan',
                        body: 'No target exists',
                        icon: Icons.help_outline_rounded,
                      ),
                    ],
                    nextLabel: 'Next',
                    doneLabel: 'Done',
                    skipLabel: 'Skip',
                    tryItLabel: 'Try it:',
                    skipStepLabel: 'Skip this step',
                    wellDoneLabel: 'Nice!',
                    stepCountLabel: (c, t) => '$c of $t',
                  );
                },
                child: const Text('open'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Orphan'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump(const Duration(milliseconds: 400));
    expect(await result, CoachMarkTutorialResult.skipped);
  });
}
