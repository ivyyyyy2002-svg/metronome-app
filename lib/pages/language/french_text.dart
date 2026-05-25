import 'app_language_text.dart';

// French language text implementation for the app
class FrenchText implements AppLanguageText {
  const FrenchText();

  @override
  String get settings => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get french => 'Français';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get homeTitle => 'Pratique';

  @override
  String get appName => 'Metronome Studio';

  @override
  String get readyTitle => 'Bonjour,\nprêt à pratiquer ?';

  @override
  String get readyDescription =>
      'Touchez le bouton ci-dessous pour commencer une nouvelle séance avec vos derniers réglages.';

  @override
  String get startMetronome => 'Démarrer le métronome';

  @override
  String get practiceNotePattern => 'Motif de notes';

  @override
  String get notePatternDescription =>
      'Choisissez l’ordre des notes que le métronome jouera.';

  @override
  String get notesToPlay => 'Notes à jouer';

  @override
  String get noteInputHelper =>
      'Utilisez A-G, ou ajoutez des dièses/bémols comme C# et Bb.';

  @override
  String get applySequence => 'Appliquer le motif';

  @override
  String get sequenceSavedNotice => 'Motif de notes enregistré.';

  @override
  String get sequenceExample => 'Exemples : ABCDEFG, C#D#EF#G#';

  @override
  String get sequenceError =>
      'Entrez au moins une note de A à G. Vous pouvez aussi utiliser les dièses (#) et les bémols (b).';

  @override
  String get languageSavedNotice => 'La langue a été enregistrée.';
}
