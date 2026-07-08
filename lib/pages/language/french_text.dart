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
  String get themeColor => 'Couleur du thème';

  @override
  String get defaultThemeColor => 'Défaut';

  @override
  String get roseThemeColor => 'Rose';

  @override
  String get purpleThemeColor => 'Violet';

  @override
  String get warmThemeColor => 'Jaune';

  @override
  String get tealThemeColor => 'Sarcelle';

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
  String get homeTitle => 'Accueil';

  @override
  String get appName => 'Metrinote';

  @override
  String get practiceTab => 'Pratique';

  @override
  String get sequencesTab => 'Motifs';

  @override
  String get toolsTab => 'Outils';

  @override
  String get basicsTab => 'Bases';

  @override
  String get readyTitle => 'Bonjour,\nprêt à pratiquer ?';

  @override
  String get readyDescription =>
      'Touchez le bouton ci-dessous pour commencer une nouvelle séance avec vos derniers réglages.';

  @override
  String get startMetronome => 'Démarrer le métronome';

  @override
  String get musicBasics => 'Bases musicales';

  @override
  String get practiceHistory => 'Historique';

  @override
  String get todayPractice => 'Aujourd’hui';

  @override
  String get last7Days => '7 derniers jours';

  @override
  String get lastSession => 'Dernière séance';

  @override
  String get mostUsedBpm => 'BPM fréquent';

  @override
  String get favoriteInstrument => 'Instrument favori';

  @override
  String get noPracticeYet => 'Aucune pratique enregistrée';

  @override
  String get basicsIntro =>
      'Repères rapides pour le rythme, la mesure et la notation.';

  @override
  String get bpmBasicsTitle => 'BPM';

  @override
  String get bpmBasicsBody =>
      'BPM signifie battements par minute. Travaillez lentement au début, puis augmentez le tempo quand le rythme devient stable.';

  @override
  String get timeSignatureBasicsTitle => 'Mesure';

  @override
  String get timeSignatureBasicsBody =>
      'Le nombre du haut indique combien de temps il y a dans chaque mesure. 4/4 est très courant; 3/4 donne souvent une sensation de valse.';

  @override
  String get subdivisionBasicsTitle => 'Subdivision';

  @override
  String get subdivisionBasicsBody =>
      'La subdivision indique comment le temps est divisé. La noire reste simple; les croches et doubles croches donnent un repère plus détaillé.';

  @override
  String get downbeatBasicsTitle => 'Premier temps';

  @override
  String get downbeatBasicsBody =>
      'Le premier temps commence la mesure. Un accent plus fort aide à sentir la forme de la mesure au lieu de compter tous les temps pareil.';

  @override
  String get jianpuBasicsTitle => 'Jianpu';

  @override
  String get jianpuBasicsBody =>
      'Le jianpu utilise des chiffres pour les degrés de la gamme, comme 1 2 3 5 6. Il peut être relié aux noms de notes en choisissant une tonalité.';

  @override
  String get westernNotationBasicsTitle => 'Notes occidentales';

  @override
  String get westernNotationBasicsBody =>
      'Les notes occidentales utilisent A-G. Le dièse (#) monte une note d’un demi-ton, et le bémol (b) la baisse d’un demi-ton.';

  @override
  String get easternNotationBasicsTitle => 'Notes orientales';

  @override
  String get easternNotationBasicsBody =>
      'La notation orientale utilise Sa Re Ga Ma Pa Dha Ni, ou S R G M P D N. Dans cette app, cela correspond à C D E F G A B.';

  @override
  String get octaveNotationBasicsTitle => 'Octaves';

  @override
  String get octaveNotationBasicsBody =>
      "Utilisez ' pour une octave plus haute et une virgule pour une octave plus basse. Par exemple, C' est plus haut que C, et C, est plus bas que C.";

  @override
  String get groupedNotesBasicsTitle => 'Notes groupées';

  @override
  String get groupedNotesBasicsBody =>
      'Un espace passe au temps suivant. Les notes sans espace se jouent dans le même temps, donc C D E FG place F et G ensemble sur le quatrième temps.';

  @override
  String get heldNotesBasicsTitle => 'Notes tenues';

  @override
  String get heldNotesBasicsBody =>
      'Un tiret (-) prolonge la note précédente pendant un autre temps. Par exemple, C - D E garde C pendant le deuxième temps.';

  @override
  String get scalePatternGenerator => 'Générateur de gammes';

  @override
  String get scalePatternDescription =>
      'Créez un motif de gamme et envoyez-le aux notes à jouer.';

  @override
  String get notation => 'Notation';

  @override
  String get westernNotation => 'Occidentale';

  @override
  String get easternNotation => 'Orientale';

  @override
  String get rootKey => 'Tonalité';

  @override
  String get scale => 'Gamme';

  @override
  String get direction => 'Direction';

  @override
  String get ascending => 'Montant';

  @override
  String get descending => 'Descendant';

  @override
  String get upAndDown => 'Aller-retour';

  @override
  String get majorPentatonic => 'Pentatonique majeure';

  @override
  String get minorPentatonic => 'Pentatonique mineure';

  @override
  String get majorScale => 'Gamme majeure';

  @override
  String get minorScale => 'Gamme mineure';

  @override
  String get generatedPattern => 'Motif généré';

  @override
  String get useAsSequence => 'Utiliser comme motif';

  @override
  String get patternAppliedNotice => 'Motif ajouté à l’éditeur.';

  @override
  String get jianpuConverter => 'Convertisseur Jianpu';

  @override
  String get jianpuConverterDescription =>
      'Convertissez la notation chiffrée en notes jouables en choisissant une tonalité.';

  @override
  String get jianpuInput => 'Entrée jianpu';

  @override
  String get convertedSequence => 'Séquence convertie';

  @override
  String get practiceNotePattern => 'Motif de notes';

  @override
  String get notePatternDescription =>
      'Choisissez l’ordre des notes que le métronome jouera.';

  @override
  String get notesToPlay => 'Notes à jouer';

  @override
  String get noteInputHelper =>
      "Utilisez A-G ou S R G M P D N. Utilisez ', virgule, / et - pour les octaves, notes groupées et tenues.";

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
      'Entrez au moins une note occidentale ou orientale valide.';

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
  String get viewAll => 'Tout afficher';

  @override
  String get quickEdit => 'Modification rapide';

  @override
  String get importSequence => 'Importer';

  @override
  String get noSavedSequences => 'Aucun motif enregistré';

  @override
  String get sequenceNameError => 'Entrez un nom avant d’enregistrer.';

  @override
  String get alreadySavedNotice => 'Déjà enregistré.';

  @override
  String get replace => 'Remplacer';

  @override
  String noteSequenceTooLong(int maxNotes) =>
      'Utilisez $maxNotes notes ou moins pour un motif.';

  @override
  String replaceSequenceQuestion(String name) =>
      'Un motif nommé "$name" existe déjà. Le remplacer ?';

  @override
  String savedSequenceSummary(int visibleCount, int totalCount) =>
      '$visibleCount sur $totalCount affichés';

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
  String get beatUnit => 'Subdivision';

  @override
  String get subdivisionHalf => 'Blanche';

  @override
  String get subdivisionQuarter => 'Noire';

  @override
  String get subdivisionEighth => 'Croche';

  @override
  String get subdivisionSixteenth => 'Double croche';

  @override
  String get subdivisionDottedHalf => 'Blanche pointée';

  @override
  String get subdivisionDottedQuarter => 'Noire pointée';

  @override
  String get subdivisionDottedEighth => 'Croche pointée';

  @override
  String get missingInstrument => 'manquant';

  @override
  String noPlayableAssets(String instrument) =>
      'Aucune ressource jouable trouvée pour $instrument';

  @override
  String get scorePreview => 'Partition';

  @override
  String get addScore => 'Ajouter';

  @override
  String get scorePlaceholderTitle => 'Aucune partition';

  @override
  String get scorePlaceholderBody =>
      'Cet espace affichera un PDF ou une image de partition.';
}
