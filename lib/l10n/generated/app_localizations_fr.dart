// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

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
  String get spanish => 'Espagnol';

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
      'Utilisez \' pour une octave plus haute et une virgule pour une octave plus basse. Par exemple, C\' est plus haut que C, et C, est plus bas que C.';

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
      'Utilisez A-G ou S R G M P D N. Utilisez \', virgule, / et - pour les octaves, notes groupées et tenues.';

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
  String get start => 'Démarrer';

  @override
  String get stop => 'Arrêter';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get click => 'Clic';

  @override
  String get clickSound => 'Son du clic';

  @override
  String get volumeBalance => 'Balance du volume';

  @override
  String get clickVolume => 'Volume du clic';

  @override
  String get instrumentVolume => 'Volume de l’instrument';

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
  String get tutorialTryIt => 'Essayez :';

  @override
  String get tutorialWellDone => 'Bien !';

  @override
  String get tutorialTempoTitle => 'Tempo, temps et balancier';

  @override
  String get tutorialTempoBody =>
      'Le balancier oscille une fois par temps. Le grand nombre est le tempo en BPM, c\'est-à-dire le nombre de temps par minute. La rangée de points indique où vous en êtes dans la mesure, et le point le plus lumineux est le temps fort.';

  @override
  String get tutorialTempoExample =>
      '60 BPM = 1 temps par seconde\n120 BPM = 2 temps par seconde (deux fois plus vite)';

  @override
  String get tutorialBpmDragTitle => 'Réglez le tempo';

  @override
  String get tutorialBpmDragBody =>
      'Choisissez un tempo où vous jouez chaque note correctement, puis augmentez-le une fois que c\'est facile. Le curseur va de 30 à 240.';

  @override
  String get tutorialBpmDragAction =>
      'faites glisser le curseur de tempo sur n\'importe quelle valeur.';

  @override
  String get tutorialSequenceTitle => 'Votre motif de notes';

  @override
  String get tutorialSequenceBody =>
      'Ce métronome ne fait pas que cliquer. Il joue votre motif de notes comme une mélodie, une note par temps, en boucle pendant que vous jouez. Ce panneau affiche le motif chargé actuellement. Touchez-le pour modifier les notes.';

  @override
  String get tutorialToggleTitle => 'Clic et Son';

  @override
  String get tutorialToggleBody =>
      '« Clic » est le tic classique qui donne le tempo. « Son » joue votre motif de notes avec l\'instrument choisi. Laissez les deux activés pour entendre la mélodie par-dessus le temps, ou désactivez-en un pour vous concentrer sur l\'autre.';

  @override
  String get tutorialToggleAction =>
      'désactivez un interrupteur, puis réactivez-le.';

  @override
  String get tutorialMeterTitle => 'Mesure et subdivision';

  @override
  String get tutorialMeterBody =>
      'La mesure regroupe les temps. En 4/4, vous comptez 1-2-3-4 puis recommencez, et le temps 1 est accentué. La subdivision découpe chaque temps en clics plus petits, utile quand vos notes vont plus vite que le temps.';

  @override
  String get tutorialMeterExample =>
      '4/4 = 4 temps par mesure, la plus courante\n3/4 = compte à 3, comme une valse\nSubdivision en croches = 2 clics par temps';

  @override
  String get tutorialTransportTitle => 'Écoutez';

  @override
  String get tutorialTransportBody =>
      'Tout est prêt. Appuyez sur Démarrer et écoutez : le premier temps accentué, puis vos notes sur chaque temps. Arrêter met la séance en pause et Réinitialiser revient au début du motif.';

  @override
  String get tutorialTransportAction =>
      'appuyez sur Démarrer et écoutez une ou deux mesures.';

  @override
  String get tutorialAdvancedTitle => 'Réglages avancés';

  @override
  String get tutorialAdvancedBody =>
      'Quand les réglages par défaut ne suffisent plus, ouvrez ce panneau pour changer le son du clic, choisir l\'instrument qui joue vos notes, ajuster les accents ou décaler l\'octave de base.';

  @override
  String get tutorialHomePracticeTitle => 'Bienvenue. La pratique commence ici';

  @override
  String get tutorialHomePracticeBody =>
      'Metrinote est un métronome qui joue aussi les notes que vous voulez travailler, pour entendre le temps et la mélodie ensemble. Ce bouton ouvre la page de pratique avec votre motif de notes déjà chargé.';

  @override
  String get tutorialHomeHistoryTitle => 'Historique de pratique';

  @override
  String get tutorialHomeHistoryBody =>
      'Chaque séance est enregistrée ici : minutes travaillées sur les 7 derniers jours, votre tempo le plus utilisé et votre instrument le plus utilisé. Fixez un objectif quotidien et l\'anneau de progression montre où vous en êtes.';

  @override
  String get tutorialHomeTabsTitle => 'Quatre onglets';

  @override
  String get tutorialHomeTabsBody =>
      '« Pratique » est la page principale. « Motifs » sert à créer et enregistrer des motifs de notes. « Outils » les génère pour vous. « Bases » explique les termes musicaux utilisés par l\'application. Parcourons-les dans l\'ordre.';

  @override
  String get tutorialHomeExamplesTitle => 'Commencez par un exemple';

  @override
  String get tutorialHomeExamplesBody =>
      'Vous ne savez pas quoi travailler ? Ces motifs prêts à l\'emploi se chargent en un geste, dont une gamme majeure occidentale et un cycle de raga oriental. Chargez-en un, puis adaptez-le.';

  @override
  String get tutorialHomeSequencesTitle => 'Écrivez votre propre motif';

  @override
  String get tutorialHomeSequencesBody =>
      'Saisissez les noms de notes séparés par des espaces, ou touchez les boutons de note sous le champ. Les lettres occidentales (A B C…) et le sargam oriental (S R G M…) fonctionnent. Donnez un nom au motif et enregistrez-le pour le recharger plus tard.';

  @override
  String get tutorialHomeSequencesExample =>
      'C D E F → quatre notes, une par temps\nG - → « - » tient G un temps de plus\nE/F → « / » place deux notes sur un temps\nC\' octave haute · C, octave basse';

  @override
  String get tutorialHomeToolsTitle => 'Laissez Outils générer les motifs';

  @override
  String get tutorialHomeToolsBody =>
      'L\'onglet « Outils » contient deux générateurs : un constructeur de gammes et un convertisseur jianpu. Les deux écrivent des motifs pour vous. Regardons chacun.';

  @override
  String get tutorialHomeScaleGenTitle => 'Générateur de motifs de gamme';

  @override
  String get tutorialHomeScaleGenBody =>
      'Choisissez la tonique, le type de gamme, l\'étendue d\'octaves et la direction : il écrit le motif complet. « Utiliser comme motif » l\'envoie directement dans votre éditeur.';

  @override
  String get tutorialHomeJianpuTitle => 'Convertisseur jianpu';

  @override
  String get tutorialHomeJianpuBody =>
      'Si vous lisez la notation chiffrée (1 2 3 = do ré mi), collez-la ici et elle devient un motif jouable. Les points d\'octave et les tirets de notes tenues sont aussi reconnus.';

  @override
  String get tutorialHomeBasicsTitle => 'Apprenez les termes';

  @override
  String get tutorialHomeBasicsBody =>
      'Encore une étape. « Bases » est un glossaire en langage simple de chaque terme musical utilisé par l\'application. Lisons les quatre plus importants.';

  @override
  String get tutorialBasicsBpmBody =>
      'BPM signifie battements par minute : 60 BPM, c\'est exactement un temps par seconde. C\'est le nombre que vous réglez avec le curseur de tempo sur la page de pratique. La règle générale : commencez plus lentement que ce qui paraît confortable.';

  @override
  String get tutorialBasicsMeterBody =>
      'Le chiffre du haut indique combien de temps contient chaque mesure, et le temps 1 est toujours accentué. Vous le choisissez avec le bouton de mesure sur la page de pratique. Pour la plupart des musiques, 4/4 est la valeur sûre.';

  @override
  String get tutorialBasicsSubdivisionBody =>
      'La subdivision découpe chaque temps en clics égaux plus petits : les croches donnent 2 clics par temps, les doubles croches 4. Activez-la quand vos notes vont plus vite que le temps principal.';

  @override
  String get tutorialBasicsNotationBody =>
      'Les mêmes notes ont deux systèmes de noms, et l\'application accepte les deux : lettres occidentales (C D E F G A B) et sargam oriental (S R G M P D N). Les cartes voisines expliquent aussi les marques d\'octave, les notes tenues et les groupements.';

  @override
  String get tutorialHomeReturnTitle => 'Retour à la page principale';

  @override
  String get tutorialHomeReturnBody =>
      'Voilà les quatre onglets. Touchez « Pratique » vous-même pour revenir à la page principale, afin de toujours savoir comment y retourner.';

  @override
  String get tutorialStartSessionTitle => 'Commencez quand vous voulez';

  @override
  String get tutorialStartSessionBody =>
      'Appuyez maintenant sur « Démarrer le métronome ». Cela ouvre la page de pratique, où le tutoriel pratique du métronome continue.';

  @override
  String get tutorialHomeSettingsTitle => 'Réglages et relecture';

  @override
  String get tutorialHomeSettingsBody =>
      'Le thème, les couleurs et la langue se trouvent derrière cet engrenage. Si vous oubliez comment quelque chose fonctionne, ouvrez les Paramètres et touchez « Revoir le tutoriel ». Appuyez sur Terminé et nous reviendrons à « Pratique ».';

  @override
  String get tutorialScoreTitle => 'Partitions en mode paysage';

  @override
  String get tutorialScoreBody =>
      'Sur les grands écrans en mode paysage, chargez ici une image ou un PDF de partition et travaillez avec le métronome à côté. Vous pouvez zoomer, tourner les pages et passer en plein écran.';

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

  @override
  String tutorialStepCount(int current, int total) {
    return '$current sur $total';
  }

  @override
  String tutorialTapTabAction(String tabName) {
    return 'touchez « $tabName » dans la barre du bas.';
  }

  @override
  String noteSequenceTooLong(int maxNotes) {
    return 'Utilisez $maxNotes notes ou moins pour un motif.';
  }

  @override
  String replaceSequenceQuestion(String name) {
    return 'Un motif nommé \"$name\" existe déjà. Le remplacer ?';
  }

  @override
  String savedSequenceSummary(int visibleCount, int totalCount) {
    return '$visibleCount sur $totalCount affichés';
  }

  @override
  String get quickEntry => 'Saisie rapide';

  @override
  String get notes => 'Notes';

  @override
  String get modifiers => 'Modificateurs';

  @override
  String get zoomOut => 'Réduire';

  @override
  String get zoomIn => 'Agrandir';

  @override
  String get previousPage => 'Page précédente';

  @override
  String get nextPage => 'Page suivante';

  @override
  String get fullscreen => 'Plein écran';

  @override
  String get show => 'Afficher';

  @override
  String get hide => 'Masquer';

  @override
  String get exampleSequences => 'Motifs d’exemple';

  @override
  String noPlayableAssets(String instrument) {
    return 'Aucune ressource jouable trouvée pour $instrument';
  }

  @override
  String get instrumentPiano => 'Piano A';

  @override
  String get instrumentUprightPiano => 'Piano B';

  @override
  String get instrumentPipa => 'Pipa';

  @override
  String get instrumentRuan => 'Ruan';

  @override
  String get instrumentGuzheng => 'Guzheng';

  @override
  String get instrumentErhu => 'Erhu';

  @override
  String get instrumentFlute => 'Flûte de bambou';

  @override
  String get instrumentShamisen => 'Shamisen';

  @override
  String get instrumentHarmonium => 'Harmonium';

  @override
  String get instrumentTabla => 'Tabla';

  @override
  String get instrumentOud => 'Oud';

  @override
  String get instrumentQanun => 'Qanûn';

  @override
  String get instrumentDuduk => 'Doudouk';

  @override
  String get instrumentNey => 'Ney';

  @override
  String get instrumentTanbur => 'Tanbur';

  @override
  String get instrumentCelesta => 'Célesta';

  @override
  String get instrumentHarp => 'Harpe';

  @override
  String get instrumentClarinet => 'Clarinette';

  @override
  String get instrumentOboe => 'Hautbois';

  @override
  String get instrumentTrumpet => 'Trompette';

  @override
  String get instrumentFrenchHorn => 'Cor d\'harmonie';

  @override
  String get instrumentAcousticGuitar => 'Guitare acoustique';

  @override
  String get instrumentElectricGuitar => 'Guitare électrique';

  @override
  String get instrumentAcousticBass => 'Basse acoustique';

  @override
  String get instrumentBianzhong => 'Bianzhong';

  @override
  String get instrumentMarimba => 'Marimba';

  @override
  String get regionWestern => 'Occidental';

  @override
  String get regionEastAsian => 'Asie de l\'Est';

  @override
  String get regionMiddleEastern => 'Moyen-Orient';

  @override
  String get regionSouthAsian => 'Asie du Sud';

  @override
  String get regionOther => 'Autres';

  @override
  String get clickSoundClassic => 'Classique';

  @override
  String get clickSoundQuartz => 'Quartz';

  @override
  String get clickSoundStick => 'Baguette';

  @override
  String get clickSoundPracticePad => 'Pad d\'entraînement';

  @override
  String get clickSoundGlass => 'Verre';

  @override
  String get clickSoundMetal => 'Métal';

  @override
  String get clickSoundSnap => 'Claquement de doigts';

  @override
  String get clickSoundClap => 'Claquement de mains';

  @override
  String get clickSoundTambourine => 'Tambourin';

  @override
  String get clickSoundCan => 'Canette';

  @override
  String get clickSoundClickToy => 'Clicker';

  @override
  String get clickSoundWoodBlock => 'Bloc de bois';

  @override
  String get dailyGoal => 'Objectif quotidien';

  @override
  String get exampleMajorScaleName => 'Gamme majeure montante et descendante';

  @override
  String get exampleMajorScaleDescription =>
      'Une gamme occidentale simple, montante puis descendante.';

  @override
  String get exampleChandrakaunName => 'Cycle du raga Chandrakaun';

  @override
  String get exampleChandrakaunDescription =>
      'Un cycle aroha-avaroha compact : Sa, Ga bémol, Ma, Dha bémol, Ni.';
}
