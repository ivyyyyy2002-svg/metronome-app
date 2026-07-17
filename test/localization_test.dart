import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metronome_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('Spanish localization loads translated text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).settings),
        ),
      ),
    );

    expect(find.text('Ajustes'), findsOneWidget);
  });
}
