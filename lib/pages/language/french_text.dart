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
  String get noteInputHelper => 'Utilisez A-G, # et b, ex. C# et Bb.';

  @override
  String get applySequence => 'Appliquer le motif';

  @override
  String get deleteNote => 'Supprimer';

  @override
  String get clearNotes => 'Effacer';

  @override
  String get sequenceSavedNotice => 'Motif de notes enregistré.';

  @override
  String get sequenceExample => 'Exemples : ABCDEFG, C#D#EF#G#';

  @override
  String get sequenceError =>
      'Entrez au moins une note de A à G. Vous pouvez aussi utiliser les dièses (#) et les bémols (b).';

  @override
  String get languageSavedNotice => 'La langue a été enregistrée.';

  @override
  String get metronomeTitle => 'Métronome';

  @override
  String get advanced => 'Avancé';

  @override
  String get advancedSettings => 'Paramètres avancés';

  @override
  String get bpm => 'BPM';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get reset => 'Reset';

  @override
  String get click => 'Clic';

  @override
  String get sound => 'Son';

  @override
  String get instrument => 'Instrument';

  @override
  String get notesLoaded => 'notes chargées';

  @override
  String get noSequenceLoaded => 'Aucun motif chargé';

  @override
  String get editNoteSequence => 'Modifier le motif de notes';

  @override
  String get savedSequences => 'Motifs enregistrés';

  @override
  String get sequenceName => 'Nom du motif';

  @override
  String get searchSequences => 'Rechercher des motifs';

  @override
  String get saveSequence => 'Enregistrer';

  @override
  String get loadSequence => 'Charger';

  @override
  String get quickEdit => 'Modification rapide';

  @override
  String get importSequence => 'Importer';

  @override
  String get noSavedSequences => 'Aucun motif enregistré';

  @override
  String get sequenceNameError => 'Entrez un nom avant d’enregistrer.';

  @override
  String noteSequenceTooLong(int maxNotes) =>
      'Utilisez $maxNotes notes ou moins pour un motif.';

  @override
  String get cancel => 'Annuler';

  @override
  String get apply => 'Appliquer';

  @override
  String get close => 'Fermer';

  @override
  String get done => 'Terminé';

  @override
  String get timeSignature => 'Mesure';

  @override
  String get beatUnit => 'Unité de temps';

  @override
  String get missingInstrument => 'manquant';

  @override
  String noPlayableAssets(String instrument) =>
      'Aucune ressource jouable trouvée pour $instrument';
}
