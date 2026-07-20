import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('zh'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get themeColor;

  /// No description provided for @defaultThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultThemeColor;

  /// No description provided for @roseThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get roseThemeColor;

  /// No description provided for @purpleThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purpleThemeColor;

  /// No description provided for @warmThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get warmThemeColor;

  /// No description provided for @tealThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get tealThemeColor;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Metrinote'**
  String get appName;

  /// No description provided for @practiceTab.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practiceTab;

  /// No description provided for @sequencesTab.
  ///
  /// In en, this message translates to:
  /// **'Sequences'**
  String get sequencesTab;

  /// No description provided for @toolsTab.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsTab;

  /// No description provided for @basicsTab.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get basicsTab;

  /// No description provided for @readyTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello, \nReady to Practice?'**
  String get readyTitle;

  /// No description provided for @readyDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to start a new metronome session with your last used settings.'**
  String get readyDescription;

  /// No description provided for @startMetronome.
  ///
  /// In en, this message translates to:
  /// **'Start Metronome'**
  String get startMetronome;

  /// No description provided for @musicBasics.
  ///
  /// In en, this message translates to:
  /// **'Music Basics'**
  String get musicBasics;

  /// No description provided for @practiceHistory.
  ///
  /// In en, this message translates to:
  /// **'Practice History'**
  String get practiceHistory;

  /// No description provided for @todayPractice.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayPractice;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @lastSession.
  ///
  /// In en, this message translates to:
  /// **'Last session'**
  String get lastSession;

  /// No description provided for @mostUsedBpm.
  ///
  /// In en, this message translates to:
  /// **'Most used BPM'**
  String get mostUsedBpm;

  /// No description provided for @favoriteInstrument.
  ///
  /// In en, this message translates to:
  /// **'Favorite instrument'**
  String get favoriteInstrument;

  /// No description provided for @noPracticeYet.
  ///
  /// In en, this message translates to:
  /// **'No practice recorded yet'**
  String get noPracticeYet;

  /// No description provided for @basicsIntro.
  ///
  /// In en, this message translates to:
  /// **'Quick references for rhythm, meter, and notation.'**
  String get basicsIntro;

  /// No description provided for @bpmBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'BPM'**
  String get bpmBasicsTitle;

  /// No description provided for @bpmBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'BPM means beats per minute. Use a slower BPM when learning a new pattern, then raise it gradually when your timing feels steady.'**
  String get bpmBasicsBody;

  /// No description provided for @timeSignatureBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Signature'**
  String get timeSignatureBasicsTitle;

  /// No description provided for @timeSignatureBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'The top number tells how many beats are in each bar. 4/4 is common for pop and practice exercises, while 3/4 often feels like a waltz.'**
  String get timeSignatureBasicsBody;

  /// No description provided for @subdivisionBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Subdivision'**
  String get subdivisionBasicsTitle;

  /// No description provided for @subdivisionBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'Subdivision controls how the beat is split. Quarter is simple and steady; eighth and sixteenth make the click feel more detailed.'**
  String get subdivisionBasicsBody;

  /// No description provided for @downbeatBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Downbeat'**
  String get downbeatBasicsTitle;

  /// No description provided for @downbeatBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'The downbeat is the first beat of a bar. A stronger first click helps you hear the shape of the measure instead of counting every beat equally.'**
  String get downbeatBasicsBody;

  /// No description provided for @jianpuBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Jianpu'**
  String get jianpuBasicsTitle;

  /// No description provided for @jianpuBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'Jianpu uses numbers for scale degrees, such as 1 2 3 5 6. It is common in Chinese instrument learning and can be mapped to note names by choosing a key.'**
  String get jianpuBasicsBody;

  /// No description provided for @westernNotationBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Western Notes'**
  String get westernNotationBasicsTitle;

  /// No description provided for @westernNotationBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'Western note names use A-G. Sharps (#) raise a note by one semitone, and flats (b) lower a note by one semitone.'**
  String get westernNotationBasicsBody;

  /// No description provided for @easternNotationBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Eastern Notes'**
  String get easternNotationBasicsTitle;

  /// No description provided for @easternNotationBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'Eastern notation uses Sa Re Ga Ma Pa Dha Ni, or S R G M P D N. In this app they map to C D E F G A B.'**
  String get easternNotationBasicsBody;

  /// No description provided for @octaveNotationBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Octaves'**
  String get octaveNotationBasicsTitle;

  /// No description provided for @octaveNotationBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'Use \' for a higher octave and comma for a lower octave. For example, C\' is higher than C, and C, is lower than C.'**
  String get octaveNotationBasicsBody;

  /// No description provided for @groupedNotesBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Grouped Notes'**
  String get groupedNotesBasicsTitle;

  /// No description provided for @groupedNotesBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'A space moves to the next beat. Notes without a space are played inside the same beat, so C D E FG puts F and G together on beat four.'**
  String get groupedNotesBasicsBody;

  /// No description provided for @heldNotesBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Held Notes'**
  String get heldNotesBasicsTitle;

  /// No description provided for @heldNotesBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'A dash (-) holds the previous note for another beat. For example, C - D E keeps C sounding through the second beat.'**
  String get heldNotesBasicsBody;

  /// No description provided for @scalePatternGenerator.
  ///
  /// In en, this message translates to:
  /// **'Scale Pattern Generator'**
  String get scalePatternGenerator;

  /// No description provided for @scalePatternDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a clean scale pattern and send it to your note sequence.'**
  String get scalePatternDescription;

  /// No description provided for @notation.
  ///
  /// In en, this message translates to:
  /// **'Notation'**
  String get notation;

  /// No description provided for @westernNotation.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get westernNotation;

  /// No description provided for @easternNotation.
  ///
  /// In en, this message translates to:
  /// **'Eastern'**
  String get easternNotation;

  /// No description provided for @rootKey.
  ///
  /// In en, this message translates to:
  /// **'Root key'**
  String get rootKey;

  /// No description provided for @scale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get scale;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @upAndDown.
  ///
  /// In en, this message translates to:
  /// **'Up and down'**
  String get upAndDown;

  /// No description provided for @majorPentatonic.
  ///
  /// In en, this message translates to:
  /// **'Major pentatonic'**
  String get majorPentatonic;

  /// No description provided for @minorPentatonic.
  ///
  /// In en, this message translates to:
  /// **'Minor pentatonic'**
  String get minorPentatonic;

  /// No description provided for @majorScale.
  ///
  /// In en, this message translates to:
  /// **'Major scale'**
  String get majorScale;

  /// No description provided for @minorScale.
  ///
  /// In en, this message translates to:
  /// **'Minor scale'**
  String get minorScale;

  /// No description provided for @generatedPattern.
  ///
  /// In en, this message translates to:
  /// **'Generated pattern'**
  String get generatedPattern;

  /// No description provided for @useAsSequence.
  ///
  /// In en, this message translates to:
  /// **'Use as Sequence'**
  String get useAsSequence;

  /// No description provided for @patternAppliedNotice.
  ///
  /// In en, this message translates to:
  /// **'Pattern added to the sequence editor.'**
  String get patternAppliedNotice;

  /// No description provided for @jianpuConverter.
  ///
  /// In en, this message translates to:
  /// **'Jianpu Converter'**
  String get jianpuConverter;

  /// No description provided for @jianpuConverterDescription.
  ///
  /// In en, this message translates to:
  /// **'Convert numbered notation into playable note names by choosing a key.'**
  String get jianpuConverterDescription;

  /// No description provided for @jianpuInput.
  ///
  /// In en, this message translates to:
  /// **'Jianpu input'**
  String get jianpuInput;

  /// No description provided for @convertedSequence.
  ///
  /// In en, this message translates to:
  /// **'Converted sequence'**
  String get convertedSequence;

  /// No description provided for @practiceNotePattern.
  ///
  /// In en, this message translates to:
  /// **'Practice Note Pattern'**
  String get practiceNotePattern;

  /// No description provided for @notePatternDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the order of notes the metronome will play.'**
  String get notePatternDescription;

  /// No description provided for @notesToPlay.
  ///
  /// In en, this message translates to:
  /// **'Notes to play'**
  String get notesToPlay;

  /// No description provided for @noteInputHelper.
  ///
  /// In en, this message translates to:
  /// **'Use A-G or S R G M P D N. Use \', comma, /, and - for octave, grouped notes, and holds.'**
  String get noteInputHelper;

  /// No description provided for @applySequence.
  ///
  /// In en, this message translates to:
  /// **'Apply Sequence'**
  String get applySequence;

  /// No description provided for @deleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteNote;

  /// No description provided for @clearNotes.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearNotes;

  /// No description provided for @sequenceSavedNotice.
  ///
  /// In en, this message translates to:
  /// **'Note pattern saved.'**
  String get sequenceSavedNotice;

  /// No description provided for @sequenceExample.
  ///
  /// In en, this message translates to:
  /// **'Examples: ABCDEFG, C#D#EF#G#, etc.'**
  String get sequenceExample;

  /// No description provided for @sequenceError.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one valid western or eastern note.'**
  String get sequenceError;

  /// No description provided for @metronomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Metronome'**
  String get metronomeTitle;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @bpm.
  ///
  /// In en, this message translates to:
  /// **'BPM'**
  String get bpm;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @click.
  ///
  /// In en, this message translates to:
  /// **'Click'**
  String get click;

  /// No description provided for @clickSound.
  ///
  /// In en, this message translates to:
  /// **'Click sound'**
  String get clickSound;

  /// No description provided for @volumeBalance.
  ///
  /// In en, this message translates to:
  /// **'Volume balance'**
  String get volumeBalance;

  /// No description provided for @clickVolume.
  ///
  /// In en, this message translates to:
  /// **'Click volume'**
  String get clickVolume;

  /// No description provided for @instrumentVolume.
  ///
  /// In en, this message translates to:
  /// **'Instrument volume'**
  String get instrumentVolume;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @instrument.
  ///
  /// In en, this message translates to:
  /// **'Instrument'**
  String get instrument;

  /// No description provided for @tutorialNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorialNext;

  /// No description provided for @tutorialSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip all'**
  String get tutorialSkip;

  /// No description provided for @tutorialDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tutorialDone;

  /// No description provided for @tutorialReplay.
  ///
  /// In en, this message translates to:
  /// **'Replay tutorial'**
  String get tutorialReplay;

  /// No description provided for @tutorialTryIt.
  ///
  /// In en, this message translates to:
  /// **'Try it:'**
  String get tutorialTryIt;

  /// No description provided for @tutorialWellDone.
  ///
  /// In en, this message translates to:
  /// **'Nice!'**
  String get tutorialWellDone;

  /// No description provided for @tutorialTempoTitle.
  ///
  /// In en, this message translates to:
  /// **'Tempo, beats, and the pendulum'**
  String get tutorialTempoTitle;

  /// No description provided for @tutorialTempoBody.
  ///
  /// In en, this message translates to:
  /// **'The pendulum swings once per beat. The big number is the tempo in BPM, or beats per minute. The row of dots shows where you are in the bar, and the brightest dot is the accented downbeat.'**
  String get tutorialTempoBody;

  /// No description provided for @tutorialTempoExample.
  ///
  /// In en, this message translates to:
  /// **'60 BPM = 1 beat per second\n120 BPM = 2 beats per second (twice as fast)'**
  String get tutorialTempoExample;

  /// No description provided for @tutorialBpmDragTitle.
  ///
  /// In en, this message translates to:
  /// **'Set the tempo'**
  String get tutorialBpmDragTitle;

  /// No description provided for @tutorialBpmDragBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a tempo where you can play every note correctly, then raise it once that feels easy. The slider runs from 30 to 240.'**
  String get tutorialBpmDragBody;

  /// No description provided for @tutorialBpmDragAction.
  ///
  /// In en, this message translates to:
  /// **'drag the tempo slider to any value.'**
  String get tutorialBpmDragAction;

  /// No description provided for @tutorialSequenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your note pattern'**
  String get tutorialSequenceTitle;

  /// No description provided for @tutorialSequenceBody.
  ///
  /// In en, this message translates to:
  /// **'This metronome does more than click. It plays your note pattern as a melody, one note per beat, looping while you play along. This panel shows the pattern loaded right now. Tap it to edit the notes.'**
  String get tutorialSequenceBody;

  /// No description provided for @tutorialToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Click and Sound'**
  String get tutorialToggleTitle;

  /// No description provided for @tutorialToggleBody.
  ///
  /// In en, this message translates to:
  /// **'\"Click\" is the classic tick that keeps time. \"Sound\" plays your note pattern on the selected instrument. Keep both on to hear the melody over the beat, or turn one off to focus on the other.'**
  String get tutorialToggleBody;

  /// No description provided for @tutorialToggleAction.
  ///
  /// In en, this message translates to:
  /// **'turn one switch off, then on again.'**
  String get tutorialToggleAction;

  /// No description provided for @tutorialMeterTitle.
  ///
  /// In en, this message translates to:
  /// **'Meter and subdivision'**
  String get tutorialMeterTitle;

  /// No description provided for @tutorialMeterBody.
  ///
  /// In en, this message translates to:
  /// **'The time signature groups beats into bars. In 4/4 you count 1-2-3-4 and start over, and beat 1 gets the accent. Subdivision splits each beat into smaller clicks, which helps when your notes move faster than the beat.'**
  String get tutorialMeterBody;

  /// No description provided for @tutorialMeterExample.
  ///
  /// In en, this message translates to:
  /// **'4/4 = 4 beats per bar, the most common\n3/4 = counts in 3, like a waltz\nEighth subdivision = 2 clicks per beat'**
  String get tutorialMeterExample;

  /// No description provided for @tutorialTransportTitle.
  ///
  /// In en, this message translates to:
  /// **'Hear it'**
  String get tutorialTransportTitle;

  /// No description provided for @tutorialTransportBody.
  ///
  /// In en, this message translates to:
  /// **'Everything is set. Press Start and listen: the accented first beat, then your notes landing on each beat. Stop pauses the session, and Reset returns to the beginning of your pattern.'**
  String get tutorialTransportBody;

  /// No description provided for @tutorialTransportAction.
  ///
  /// In en, this message translates to:
  /// **'press Start and listen for a bar or two.'**
  String get tutorialTransportAction;

  /// No description provided for @tutorialAdvancedTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get tutorialAdvancedTitle;

  /// No description provided for @tutorialAdvancedBody.
  ///
  /// In en, this message translates to:
  /// **'When the defaults feel limiting, open this panel to change the click sound, choose the instrument that plays your notes, adjust accents, or shift the base octave.'**
  String get tutorialAdvancedBody;

  /// No description provided for @tutorialHomePracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome. Practice starts here'**
  String get tutorialHomePracticeTitle;

  /// No description provided for @tutorialHomePracticeBody.
  ///
  /// In en, this message translates to:
  /// **'Metrinote is a metronome that also plays the notes you want to practice, so you hear the beat and the melody together. This button opens the practice page with your current note pattern loaded.'**
  String get tutorialHomePracticeBody;

  /// No description provided for @tutorialHomeHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice history'**
  String get tutorialHomeHistoryTitle;

  /// No description provided for @tutorialHomeHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'Every session is recorded here: minutes practiced over the last 7 days, your most used tempo, and your most used instrument. Set a daily goal and the progress ring shows how far along you are.'**
  String get tutorialHomeHistoryBody;

  /// No description provided for @tutorialHomeTabsTitle.
  ///
  /// In en, this message translates to:
  /// **'Four tabs'**
  String get tutorialHomeTabsTitle;

  /// No description provided for @tutorialHomeTabsBody.
  ///
  /// In en, this message translates to:
  /// **'Practice is the main page. Sequences is where you create and save note patterns. Tools generates patterns for you. Basics explains the music terms this app uses. Let\'s go through them in order.'**
  String get tutorialHomeTabsBody;

  /// No description provided for @tutorialHomeExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Start from an example'**
  String get tutorialHomeExamplesTitle;

  /// No description provided for @tutorialHomeExamplesBody.
  ///
  /// In en, this message translates to:
  /// **'Not sure what to practice? These ready-made patterns load with one tap, including a Western major scale and an Eastern raga cycle. Load one, then change it into your own.'**
  String get tutorialHomeExamplesBody;

  /// No description provided for @tutorialHomeSequencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Write your own pattern'**
  String get tutorialHomeSequencesTitle;

  /// No description provided for @tutorialHomeSequencesBody.
  ///
  /// In en, this message translates to:
  /// **'Type note names separated by spaces, or tap the note buttons below the field. Western letters (A B C…) and Eastern sargam (S R G M…) both work. Give the pattern a name and save it to load again later.'**
  String get tutorialHomeSequencesBody;

  /// No description provided for @tutorialHomeSequencesExample.
  ///
  /// In en, this message translates to:
  /// **'C D E F → four notes, one per beat\nG - → \'-\' holds G for an extra beat\nE/F → \'/\' fits two notes into one beat\nC\' high octave · C, low octave'**
  String get tutorialHomeSequencesExample;

  /// No description provided for @tutorialHomeToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Let Tools generate patterns'**
  String get tutorialHomeToolsTitle;

  /// No description provided for @tutorialHomeToolsBody.
  ///
  /// In en, this message translates to:
  /// **'The Tools tab has two generators: a scale builder and a jianpu converter. Both write patterns for you. Let\'s look at each.'**
  String get tutorialHomeToolsBody;

  /// No description provided for @tutorialHomeScaleGenTitle.
  ///
  /// In en, this message translates to:
  /// **'Scale pattern generator'**
  String get tutorialHomeScaleGenTitle;

  /// No description provided for @tutorialHomeScaleGenBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a root key, scale type, octave range, and direction, and it writes the full pattern. \"Use as Sequence\" drops the result into your sequence editor.'**
  String get tutorialHomeScaleGenBody;

  /// No description provided for @tutorialHomeJianpuTitle.
  ///
  /// In en, this message translates to:
  /// **'Jianpu converter'**
  String get tutorialHomeJianpuTitle;

  /// No description provided for @tutorialHomeJianpuBody.
  ///
  /// In en, this message translates to:
  /// **'If you read numbered notation (1 2 3 = do re mi), paste it here and it becomes a playable pattern. Octave dots and dashes for held notes are recognized too.'**
  String get tutorialHomeJianpuBody;

  /// No description provided for @tutorialHomeBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn the terms'**
  String get tutorialHomeBasicsTitle;

  /// No description provided for @tutorialHomeBasicsBody.
  ///
  /// In en, this message translates to:
  /// **'One more stop. Basics is a plain-language glossary of every music term this app uses. Let\'s read the four most important ones.'**
  String get tutorialHomeBasicsBody;

  /// No description provided for @tutorialBasicsBpmBody.
  ///
  /// In en, this message translates to:
  /// **'BPM means beats per minute, so 60 BPM is exactly one beat every second. This is the number you set with the tempo slider on the practice page. The rule of thumb is to start slower than feels comfortable.'**
  String get tutorialBasicsBpmBody;

  /// No description provided for @tutorialBasicsMeterBody.
  ///
  /// In en, this message translates to:
  /// **'The top number says how many beats each bar contains, and beat 1 always gets the accent. You choose it with the meter button on the practice page. For most music 4/4 is a safe default.'**
  String get tutorialBasicsMeterBody;

  /// No description provided for @tutorialBasicsSubdivisionBody.
  ///
  /// In en, this message translates to:
  /// **'Subdivision splits each beat into smaller equal clicks: eighths give 2 clicks per beat, sixteenths give 4. Turn it on when your notes move faster than the main beat.'**
  String get tutorialBasicsSubdivisionBody;

  /// No description provided for @tutorialBasicsNotationBody.
  ///
  /// In en, this message translates to:
  /// **'The same notes have two naming systems, and this app accepts both: Western letters (C D E F G A B) and Eastern sargam (S R G M P D N). The nearby cards also cover octave marks, held notes, and grouping.'**
  String get tutorialBasicsNotationBody;

  /// No description provided for @tutorialHomeReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Back to the main page'**
  String get tutorialHomeReturnTitle;

  /// No description provided for @tutorialHomeReturnBody.
  ///
  /// In en, this message translates to:
  /// **'That\'s all four tabs. Tap Practice yourself to return to the main page, so you always know how to get back.'**
  String get tutorialHomeReturnBody;

  /// No description provided for @tutorialStartSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Start when you\'re ready'**
  String get tutorialStartSessionTitle;

  /// No description provided for @tutorialStartSessionBody.
  ///
  /// In en, this message translates to:
  /// **'Now press Start Metronome. That opens the practice page, where the hands-on metronome tutorial continues.'**
  String get tutorialStartSessionBody;

  /// No description provided for @tutorialHomeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings and replay'**
  String get tutorialHomeSettingsTitle;

  /// No description provided for @tutorialHomeSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Theme, colors, and language live behind this gear. If you ever forget how something works, open Settings and tap \"Replay tutorial\". Press Done and we\'ll return to Practice.'**
  String get tutorialHomeSettingsBody;

  /// No description provided for @tutorialScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Sheet music in landscape'**
  String get tutorialScoreTitle;

  /// No description provided for @tutorialScoreBody.
  ///
  /// In en, this message translates to:
  /// **'On larger screens in landscape, load a sheet-music image or PDF here and practice with the metronome beside it. You can zoom, flip pages, and go fullscreen.'**
  String get tutorialScoreBody;

  /// No description provided for @notesLoaded.
  ///
  /// In en, this message translates to:
  /// **'notes loaded'**
  String get notesLoaded;

  /// No description provided for @noSequenceLoaded.
  ///
  /// In en, this message translates to:
  /// **'No sequence loaded'**
  String get noSequenceLoaded;

  /// No description provided for @editNoteSequence.
  ///
  /// In en, this message translates to:
  /// **'Edit note sequence'**
  String get editNoteSequence;

  /// No description provided for @savedSequences.
  ///
  /// In en, this message translates to:
  /// **'Saved sequences'**
  String get savedSequences;

  /// No description provided for @sequenceName.
  ///
  /// In en, this message translates to:
  /// **'Sequence name'**
  String get sequenceName;

  /// No description provided for @searchSequences.
  ///
  /// In en, this message translates to:
  /// **'Search sequences'**
  String get searchSequences;

  /// No description provided for @saveSequence.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveSequence;

  /// No description provided for @loadSequence.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get loadSequence;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @quickEdit.
  ///
  /// In en, this message translates to:
  /// **'Quick Edit'**
  String get quickEdit;

  /// No description provided for @importSequence.
  ///
  /// In en, this message translates to:
  /// **'Import Sequence'**
  String get importSequence;

  /// No description provided for @noSavedSequences.
  ///
  /// In en, this message translates to:
  /// **'No saved sequences'**
  String get noSavedSequences;

  /// No description provided for @sequenceNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a name before saving.'**
  String get sequenceNameError;

  /// No description provided for @alreadySavedNotice.
  ///
  /// In en, this message translates to:
  /// **'Already saved.'**
  String get alreadySavedNotice;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @timeSignature.
  ///
  /// In en, this message translates to:
  /// **'Time Signature'**
  String get timeSignature;

  /// No description provided for @beatUnit.
  ///
  /// In en, this message translates to:
  /// **'Subdivision'**
  String get beatUnit;

  /// No description provided for @subdivisionHalf.
  ///
  /// In en, this message translates to:
  /// **'Half'**
  String get subdivisionHalf;

  /// No description provided for @subdivisionQuarter.
  ///
  /// In en, this message translates to:
  /// **'Quarter'**
  String get subdivisionQuarter;

  /// No description provided for @subdivisionEighth.
  ///
  /// In en, this message translates to:
  /// **'Eighth'**
  String get subdivisionEighth;

  /// No description provided for @subdivisionSixteenth.
  ///
  /// In en, this message translates to:
  /// **'Sixteenth'**
  String get subdivisionSixteenth;

  /// No description provided for @subdivisionDottedHalf.
  ///
  /// In en, this message translates to:
  /// **'Dotted Half'**
  String get subdivisionDottedHalf;

  /// No description provided for @subdivisionDottedQuarter.
  ///
  /// In en, this message translates to:
  /// **'Dotted Quarter'**
  String get subdivisionDottedQuarter;

  /// No description provided for @subdivisionDottedEighth.
  ///
  /// In en, this message translates to:
  /// **'Dotted Eighth'**
  String get subdivisionDottedEighth;

  /// No description provided for @missingInstrument.
  ///
  /// In en, this message translates to:
  /// **'missing'**
  String get missingInstrument;

  /// No description provided for @scorePreview.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scorePreview;

  /// No description provided for @addScore.
  ///
  /// In en, this message translates to:
  /// **'Add score'**
  String get addScore;

  /// No description provided for @importScoreFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose from Files'**
  String get importScoreFromFiles;

  /// No description provided for @importScoreFromPhotos.
  ///
  /// In en, this message translates to:
  /// **'Choose from Photos'**
  String get importScoreFromPhotos;

  /// No description provided for @deleteScore.
  ///
  /// In en, this message translates to:
  /// **'Delete score'**
  String get deleteScore;

  /// No description provided for @chooseScore.
  ///
  /// In en, this message translates to:
  /// **'Choose score'**
  String get chooseScore;

  /// No description provided for @scorePlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'No score added'**
  String get scorePlaceholderTitle;

  /// No description provided for @scorePlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'This space is reserved for a PDF or score image.'**
  String get scorePlaceholderBody;

  /// No description provided for @tutorialStepCount.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String tutorialStepCount(int current, int total);

  /// No description provided for @tutorialTapTabAction.
  ///
  /// In en, this message translates to:
  /// **'tap \"{tabName}\" in the bar below.'**
  String tutorialTapTabAction(String tabName);

  /// No description provided for @noteSequenceTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use {maxNotes} notes or fewer for one sequence.'**
  String noteSequenceTooLong(int maxNotes);

  /// No description provided for @replaceSequenceQuestion.
  ///
  /// In en, this message translates to:
  /// **'A sequence named \"{name}\" already exists. Replace it?'**
  String replaceSequenceQuestion(String name);

  /// No description provided for @savedSequenceSummary.
  ///
  /// In en, this message translates to:
  /// **'Showing {visibleCount} of {totalCount}'**
  String savedSequenceSummary(int visibleCount, int totalCount);

  /// No description provided for @quickEntry.
  ///
  /// In en, this message translates to:
  /// **'Quick entry'**
  String get quickEntry;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @modifiers.
  ///
  /// In en, this message translates to:
  /// **'Modifiers'**
  String get modifiers;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOut;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @fullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get fullscreen;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @exampleSequences.
  ///
  /// In en, this message translates to:
  /// **'Example Sequences'**
  String get exampleSequences;

  /// No description provided for @noPlayableAssets.
  ///
  /// In en, this message translates to:
  /// **'No playable assets found for {instrument}'**
  String noPlayableAssets(String instrument);

  /// No description provided for @instrumentPiano.
  ///
  /// In en, this message translates to:
  /// **'Piano A'**
  String get instrumentPiano;

  /// No description provided for @instrumentUprightPiano.
  ///
  /// In en, this message translates to:
  /// **'Piano B'**
  String get instrumentUprightPiano;

  /// No description provided for @instrumentPipa.
  ///
  /// In en, this message translates to:
  /// **'Pipa'**
  String get instrumentPipa;

  /// No description provided for @instrumentRuan.
  ///
  /// In en, this message translates to:
  /// **'Ruan'**
  String get instrumentRuan;

  /// No description provided for @instrumentGuzheng.
  ///
  /// In en, this message translates to:
  /// **'Guzheng'**
  String get instrumentGuzheng;

  /// No description provided for @instrumentErhu.
  ///
  /// In en, this message translates to:
  /// **'Erhu'**
  String get instrumentErhu;

  /// No description provided for @instrumentFlute.
  ///
  /// In en, this message translates to:
  /// **'Bamboo Flute'**
  String get instrumentFlute;

  /// No description provided for @instrumentShamisen.
  ///
  /// In en, this message translates to:
  /// **'Shamisen'**
  String get instrumentShamisen;

  /// No description provided for @instrumentHarmonium.
  ///
  /// In en, this message translates to:
  /// **'Harmonium'**
  String get instrumentHarmonium;

  /// No description provided for @instrumentTabla.
  ///
  /// In en, this message translates to:
  /// **'Tabla'**
  String get instrumentTabla;

  /// No description provided for @instrumentOud.
  ///
  /// In en, this message translates to:
  /// **'Oud'**
  String get instrumentOud;

  /// No description provided for @instrumentQanun.
  ///
  /// In en, this message translates to:
  /// **'Qanun'**
  String get instrumentQanun;

  /// No description provided for @instrumentDuduk.
  ///
  /// In en, this message translates to:
  /// **'Duduk'**
  String get instrumentDuduk;

  /// No description provided for @instrumentNey.
  ///
  /// In en, this message translates to:
  /// **'Ney'**
  String get instrumentNey;

  /// No description provided for @instrumentTanbur.
  ///
  /// In en, this message translates to:
  /// **'Tanbur'**
  String get instrumentTanbur;

  /// No description provided for @instrumentCelesta.
  ///
  /// In en, this message translates to:
  /// **'Celesta'**
  String get instrumentCelesta;

  /// No description provided for @instrumentHarp.
  ///
  /// In en, this message translates to:
  /// **'Harp'**
  String get instrumentHarp;

  /// No description provided for @instrumentClarinet.
  ///
  /// In en, this message translates to:
  /// **'Clarinet'**
  String get instrumentClarinet;

  /// No description provided for @instrumentOboe.
  ///
  /// In en, this message translates to:
  /// **'Oboe'**
  String get instrumentOboe;

  /// No description provided for @instrumentTrumpet.
  ///
  /// In en, this message translates to:
  /// **'Trumpet'**
  String get instrumentTrumpet;

  /// No description provided for @instrumentFrenchHorn.
  ///
  /// In en, this message translates to:
  /// **'French Horn'**
  String get instrumentFrenchHorn;

  /// No description provided for @instrumentAcousticGuitar.
  ///
  /// In en, this message translates to:
  /// **'Acoustic Guitar'**
  String get instrumentAcousticGuitar;

  /// No description provided for @instrumentElectricGuitar.
  ///
  /// In en, this message translates to:
  /// **'Electric Guitar'**
  String get instrumentElectricGuitar;

  /// No description provided for @instrumentAcousticBass.
  ///
  /// In en, this message translates to:
  /// **'Acoustic Bass'**
  String get instrumentAcousticBass;

  /// No description provided for @instrumentBianzhong.
  ///
  /// In en, this message translates to:
  /// **'Bianzhong'**
  String get instrumentBianzhong;

  /// No description provided for @instrumentMarimba.
  ///
  /// In en, this message translates to:
  /// **'Marimba'**
  String get instrumentMarimba;

  /// No description provided for @regionWestern.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get regionWestern;

  /// No description provided for @regionEastAsian.
  ///
  /// In en, this message translates to:
  /// **'East Asian'**
  String get regionEastAsian;

  /// No description provided for @regionMiddleEastern.
  ///
  /// In en, this message translates to:
  /// **'Middle Eastern'**
  String get regionMiddleEastern;

  /// No description provided for @regionSouthAsian.
  ///
  /// In en, this message translates to:
  /// **'South Asian'**
  String get regionSouthAsian;

  /// No description provided for @regionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get regionOther;

  /// No description provided for @clickSoundClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get clickSoundClassic;

  /// No description provided for @clickSoundQuartz.
  ///
  /// In en, this message translates to:
  /// **'Quartz'**
  String get clickSoundQuartz;

  /// No description provided for @clickSoundStick.
  ///
  /// In en, this message translates to:
  /// **'Stick'**
  String get clickSoundStick;

  /// No description provided for @clickSoundPracticePad.
  ///
  /// In en, this message translates to:
  /// **'Practice Pad'**
  String get clickSoundPracticePad;

  /// No description provided for @clickSoundGlass.
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get clickSoundGlass;

  /// No description provided for @clickSoundMetal.
  ///
  /// In en, this message translates to:
  /// **'Metal'**
  String get clickSoundMetal;

  /// No description provided for @clickSoundSnap.
  ///
  /// In en, this message translates to:
  /// **'Snap'**
  String get clickSoundSnap;

  /// No description provided for @clickSoundClap.
  ///
  /// In en, this message translates to:
  /// **'Clap'**
  String get clickSoundClap;

  /// No description provided for @clickSoundTambourine.
  ///
  /// In en, this message translates to:
  /// **'Tambourine'**
  String get clickSoundTambourine;

  /// No description provided for @clickSoundCan.
  ///
  /// In en, this message translates to:
  /// **'Can'**
  String get clickSoundCan;

  /// No description provided for @clickSoundClickToy.
  ///
  /// In en, this message translates to:
  /// **'Click Toy'**
  String get clickSoundClickToy;

  /// No description provided for @clickSoundWoodBlock.
  ///
  /// In en, this message translates to:
  /// **'Wood Block'**
  String get clickSoundWoodBlock;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @exampleMajorScaleName.
  ///
  /// In en, this message translates to:
  /// **'Major Scale Up and Down'**
  String get exampleMajorScaleName;

  /// No description provided for @exampleMajorScaleDescription.
  ///
  /// In en, this message translates to:
  /// **'A simple ascending and descending Western scale.'**
  String get exampleMajorScaleDescription;

  /// No description provided for @exampleChandrakaunName.
  ///
  /// In en, this message translates to:
  /// **'Chandrakaun Raga Cycle'**
  String get exampleChandrakaunName;

  /// No description provided for @exampleChandrakaunDescription.
  ///
  /// In en, this message translates to:
  /// **'A compact aroha-avaroha loop: Sa, komal Ga, Ma, komal Dha, Ni.'**
  String get exampleChandrakaunDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'hi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
