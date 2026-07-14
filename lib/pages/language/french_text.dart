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
  String get clickSound => 'Son du clic';

  @override
  String get sound => 'Son';

  @override
  String get preview => 'Aperçu';

  @override
  String get instrument => 'Instrument';

  @override
  String get tutorialNext => 'Suivant';

  @override
  String get tutorialSkip => 'Tout ignorer';

  @override
  String get tutorialDone => 'Terminé';

  @override
  String get tutorialReplay => 'Revoir le tutoriel';

  @override
  String tutorialStepCount(int current, int total) => '$current sur $total';

  @override
  String get tutorialTryIt => 'Essayez :';

  @override
  String get tutorialWellDone => 'Bravo !';

  @override
  String tutorialTapTabAction(String tabName) =>
      'touchez « $tabName » dans la barre du bas.';

  @override
  String get tutorialTempoTitle => 'Tempo, temps et pendule';

  @override
  String get tutorialTempoBody =>
      'Le pendule oscille une fois par temps, et le grand nombre est le tempo en BPM (battements par minute) — le nombre de temps dans une minute. La rangée de points montre votre position dans la mesure : le premier point, plus lumineux, est le temps fort accentué.';

  @override
  String get tutorialTempoExample =>
      '60 BPM = 1 temps par seconde\n120 BPM = 2 temps par seconde (deux fois plus vite)';

  @override
  String get tutorialBpmDragTitle => 'Choisissez votre tempo';

  @override
  String get tutorialBpmDragBody =>
      'Travailler lentement est le secret d\'un jeu propre : choisissez un tempo où chaque note est juste, puis augmentez petit à petit. Le curseur va de 30 (très lent) à 240 (très rapide).';

  @override
  String get tutorialBpmDragAction =>
      'glissez le curseur de tempo vers une autre valeur.';

  @override
  String get tutorialSequenceTitle => 'Votre motif de notes';

  @override
  String get tutorialSequenceBody =>
      'Ce métronome ne fait pas que cliquer — il peut jouer une mélodie, une note par temps, en boucle, pendant que vous jouez avec lui. Ce panneau montre le motif chargé actuellement ; touchez-le à tout moment pour modifier les notes.';

  @override
  String get tutorialToggleTitle => 'Clic, notes, ou les deux';

  @override
  String get tutorialToggleBody =>
      '« Clic » est le tic-tac classique qui tient le tempo. « Notes » joue votre motif avec l\'instrument choisi. Gardez les deux pour entendre la mélodie posée sur la pulsation, ou coupez-en un pour vous concentrer.';

  @override
  String get tutorialToggleAction =>
      'désactivez puis réactivez l\'un des boutons.';

  @override
  String get tutorialMeterTitle => 'Mesure et subdivision';

  @override
  String get tutorialMeterBody =>
      'La signature rythmique groupe les temps en mesures : en 4/4 on compte 1-2-3-4 puis on recommence, et le temps 1 est accentué. L\'unité de temps subdivise chaque temps en clics plus fins, utile quand les notes vont plus vite que la pulsation.';

  @override
  String get tutorialMeterExample =>
      '4/4 = 4 temps par mesure (le plus courant)\n3/4 = on compte à 3, comme une valse\nCroche = 2 clics par temps';

  @override
  String get tutorialTransportTitle => 'Écoutez le résultat';

  @override
  String get tutorialTransportBody =>
      'Tout est prêt — appuyez sur Start et écoutez : le temps fort accentué, puis vos notes sur chaque temps. Stop met en pause ; Reset revient au début du motif.';

  @override
  String get tutorialTransportAction =>
      'appuyez sur Start et écoutez une mesure ou deux.';

  @override
  String get tutorialAdvancedTitle => 'Paramètres avancés';

  @override
  String get tutorialAdvancedBody =>
      'Quand les réglages par défaut ne suffisent plus, ouvrez ce panneau pour changer le son du clic, choisir l\'instrument qui joue vos notes, ajuster les accents ou décaler l\'octave de base.';

  @override
  String get tutorialHomePracticeTitle =>
      'Bienvenue ! La pratique commence ici';

  @override
  String get tutorialHomePracticeBody =>
      'Metrinote est un métronome qui peut aussi jouer les notes que vous voulez travailler : vous entendez la pulsation et la mélodie ensemble. Ce bouton ouvre la page de pratique avec votre motif actuel déjà chargé.';

  @override
  String get tutorialHomeHistoryTitle => 'Votre historique de pratique';

  @override
  String get tutorialHomeHistoryBody =>
      'Chaque session est suivie ici : minutes de pratique sur les 7 derniers jours, tempo le plus utilisé et instrument favori. Fixez un objectif quotidien et l\'anneau de progression vous garde motivé.';

  @override
  String get tutorialHomeTabsTitle => 'Quatre onglets, un seul parcours';

  @override
  String get tutorialHomeTabsBody =>
      'Practice est la base. Sequences sert à créer et sauvegarder vos motifs de notes. Tools génère des motifs pour vous. Basics explique les termes musicaux de l\'app. Visitons-les dans l\'ordre.';

  @override
  String get tutorialHomeExamplesTitle => 'Partir d\'un exemple';

  @override
  String get tutorialHomeExamplesBody =>
      'Vous ne savez pas quoi travailler ? Ces motifs prêts à l\'emploi se chargent en un geste — gamme majeure occidentale ou cycle de raga oriental. Chargez-en un, puis adaptez-le.';

  @override
  String get tutorialHomeSequencesTitle => 'Écrire votre propre motif';

  @override
  String get tutorialHomeSequencesBody =>
      'Saisissez les noms de notes séparés par des espaces, ou touchez les pastilles sous le champ. Les lettres occidentales (A B C…) et le sargam oriental (S R G M…) fonctionnent. Nommez le motif et sauvegardez-le pour le réutiliser.';

  @override
  String get tutorialHomeSequencesExample =>
      "C D E F → quatre notes, une par temps\nG - → « - » tient G un temps de plus\nE/F → « / » place deux notes dans un temps\nC' octave aigu · C, octave grave";

  @override
  String get tutorialHomeToolsTitle => 'Laissez Tools écrire pour vous';

  @override
  String get tutorialHomeToolsBody =>
      'Tools contient deux générateurs : un constructeur de gammes et un convertisseur de jianpu (notation chiffrée). Jetons-y un coup d\'œil.';

  @override
  String get tutorialHomeScaleGenTitle => 'Générateur de gammes';

  @override
  String get tutorialHomeScaleGenBody =>
      'Choisissez la tonique, le type de gamme, les octaves et la direction — il écrit le motif complet. « Use pattern » l\'envoie directement dans votre éditeur.';

  @override
  String get tutorialHomeJianpuTitle => 'Convertisseur de jianpu';

  @override
  String get tutorialHomeJianpuBody =>
      'Si vous lisez la notation chiffrée (1 2 3 = do ré mi), collez-la ici et elle devient un motif jouable. Les points d\'octave et les tirets de tenue sont compris.';

  @override
  String get tutorialHomeBasicsTitle => 'Apprendre le vocabulaire';

  @override
  String get tutorialHomeBasicsBody =>
      'Dernière étape : Basics est un petit glossaire qui explique simplement chaque terme de l\'app. Lisons ensemble les quatre plus importants.';

  @override
  String get tutorialBasicsBpmBody =>
      'BPM signifie battements par minute : 60 BPM, c\'est exactement un temps par seconde. C\'est le nombre que règle le grand curseur de la page de pratique. Règle d\'or : commencez plus lentement que confortable.';

  @override
  String get tutorialBasicsMeterBody =>
      'Le nombre du haut indique combien de temps contient chaque mesure ; le temps 1 est toujours accentué. Vous le choisissez via la pastille de mesure sur la page de pratique — 4/4 est le choix sûr.';

  @override
  String get tutorialBasicsSubdivisionBody =>
      'La subdivision découpe chaque temps en clics égaux plus fins : les croches donnent 2 clics par temps, les doubles croches 4. Activez-la quand vos notes vont plus vite que la pulsation.';

  @override
  String get tutorialBasicsNotationBody =>
      'L\'app accepte deux systèmes pour nommer les mêmes notes : les lettres occidentales (C D E F G A B) et le sargam oriental (S R G M P D N). Les cartes voisines expliquent octaves, tenues et regroupements.';

  @override
  String get tutorialHomeReturnTitle => 'Retour à la base';

  @override
  String get tutorialHomeReturnBody =>
      'Le tour des onglets est terminé. Revenez sur Practice — une dernière chose à voir avant d\'ouvrir le métronome pour l\'essayer en vrai.';

  @override
  String get tutorialHomeSettingsTitle => 'Réglages et tutoriel';

  @override
  String get tutorialHomeSettingsBody =>
      'Thème, couleurs et langue se trouvent derrière cet engrenage. Et si vous oubliez comment quelque chose fonctionne, ouvrez les réglages et touchez « Revoir le tutoriel ». Appuyez sur Terminé pour ouvrir le métronome.';

  @override
  String get tutorialScoreTitle => 'Partition sur iPad';

  @override
  String get tutorialScoreBody =>
      'Sur grand écran en paysage, chargez ici une partition (image ou PDF) et pratiquez avec le métronome visible à côté. Zoom, changement de page et plein écran sont disponibles.';

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
  String get importScoreFromFiles => 'Choisir dans Fichiers';

  @override
  String get importScoreFromPhotos => 'Choisir dans Photos';

  @override
  String get deleteScore => 'Supprimer la partition';

  @override
  String get chooseScore => 'Choisir une partition';

  @override
  String get scorePlaceholderTitle => 'Aucune partition';

  @override
  String get scorePlaceholderBody =>
      'Cet espace affichera un PDF ou une image de partition.';
}
