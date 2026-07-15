import 'app_language_text.dart';

// English language text implementation for the app
class EnglishText implements AppLanguageText {
  const EnglishText();

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get themeColor => 'Theme color';

  @override
  String get defaultThemeColor => 'Default';

  @override
  String get roseThemeColor => 'Rose';

  @override
  String get purpleThemeColor => 'Purple';

  @override
  String get warmThemeColor => 'Yellow';

  @override
  String get tealThemeColor => 'Teal';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get french => 'Français';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get homeTitle => 'Home';

  @override
  String get appName => 'Metrinote';

  @override
  String get practiceTab => 'Practice';

  @override
  String get sequencesTab => 'Sequences';

  @override
  String get toolsTab => 'Tools';

  @override
  String get basicsTab => 'Basics';

  @override
  String get readyTitle => 'Hello, \nReady to Practice?';

  @override
  String get readyDescription =>
      'Tap the button below to start a new metronome session with your last used settings.';

  @override
  String get startMetronome => 'Start Metronome';

  @override
  String get musicBasics => 'Music Basics';

  @override
  String get practiceHistory => 'Practice History';

  @override
  String get todayPractice => 'Today';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get lastSession => 'Last session';

  @override
  String get mostUsedBpm => 'Most used BPM';

  @override
  String get favoriteInstrument => 'Favorite instrument';

  @override
  String get noPracticeYet => 'No practice recorded yet';

  @override
  String get basicsIntro => 'Quick references for rhythm, meter, and notation.';

  @override
  String get bpmBasicsTitle => 'BPM';

  @override
  String get bpmBasicsBody =>
      'BPM means beats per minute. Use a slower BPM when learning a new pattern, then raise it gradually when your timing feels steady.';

  @override
  String get timeSignatureBasicsTitle => 'Time Signature';

  @override
  String get timeSignatureBasicsBody =>
      'The top number tells how many beats are in each bar. 4/4 is common for pop and practice exercises, while 3/4 often feels like a waltz.';

  @override
  String get subdivisionBasicsTitle => 'Subdivision';

  @override
  String get subdivisionBasicsBody =>
      'Subdivision controls how the beat is split. Quarter is simple and steady; eighth and sixteenth make the click feel more detailed.';

  @override
  String get downbeatBasicsTitle => 'Downbeat';

  @override
  String get downbeatBasicsBody =>
      'The downbeat is the first beat of a bar. A stronger first click helps you hear the shape of the measure instead of counting every beat equally.';

  @override
  String get jianpuBasicsTitle => 'Jianpu';

  @override
  String get jianpuBasicsBody =>
      'Jianpu uses numbers for scale degrees, such as 1 2 3 5 6. It is common in Chinese instrument learning and can be mapped to note names by choosing a key.';

  @override
  String get westernNotationBasicsTitle => 'Western Notes';

  @override
  String get westernNotationBasicsBody =>
      'Western note names use A-G. Sharps (#) raise a note by one semitone, and flats (b) lower a note by one semitone.';

  @override
  String get easternNotationBasicsTitle => 'Eastern Notes';

  @override
  String get easternNotationBasicsBody =>
      'Eastern notation uses Sa Re Ga Ma Pa Dha Ni, or S R G M P D N. In this app they map to C D E F G A B.';

  @override
  String get octaveNotationBasicsTitle => 'Octaves';

  @override
  String get octaveNotationBasicsBody =>
      "Use ' for a higher octave and comma for a lower octave. For example, C' is higher than C, and C, is lower than C.";

  @override
  String get groupedNotesBasicsTitle => 'Grouped Notes';

  @override
  String get groupedNotesBasicsBody =>
      'A space moves to the next beat. Notes without a space are played inside the same beat, so C D E FG puts F and G together on beat four.';

  @override
  String get heldNotesBasicsTitle => 'Held Notes';

  @override
  String get heldNotesBasicsBody =>
      'A dash (-) holds the previous note for another beat. For example, C - D E keeps C sounding through the second beat.';

  @override
  String get scalePatternGenerator => 'Scale Pattern Generator';

  @override
  String get scalePatternDescription =>
      'Create a clean scale pattern and send it to your note sequence.';

  @override
  String get notation => 'Notation';

  @override
  String get westernNotation => 'Western';

  @override
  String get easternNotation => 'Eastern';

  @override
  String get rootKey => 'Root key';

  @override
  String get scale => 'Scale';

  @override
  String get direction => 'Direction';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get upAndDown => 'Up and down';

  @override
  String get majorPentatonic => 'Major pentatonic';

  @override
  String get minorPentatonic => 'Minor pentatonic';

  @override
  String get majorScale => 'Major scale';

  @override
  String get minorScale => 'Minor scale';

  @override
  String get generatedPattern => 'Generated pattern';

  @override
  String get useAsSequence => 'Use as Sequence';

  @override
  String get patternAppliedNotice => 'Pattern added to the sequence editor.';

  @override
  String get jianpuConverter => 'Jianpu Converter';

  @override
  String get jianpuConverterDescription =>
      'Convert numbered notation into playable note names by choosing a key.';

  @override
  String get jianpuInput => 'Jianpu input';

  @override
  String get convertedSequence => 'Converted sequence';

  @override
  String get practiceNotePattern => 'Practice Note Pattern';

  @override
  String get notePatternDescription =>
      'Choose the order of notes the metronome will play.';

  @override
  String get notesToPlay => 'Notes to play';

  @override
  String get noteInputHelper =>
      "Use A-G or S R G M P D N. Use ', comma, /, and - for octave, grouped notes, and holds.";

  @override
  String get applySequence => 'Apply Sequence';

  @override
  String get deleteNote => 'Delete';

  @override
  String get clearNotes => 'Clear';

  @override
  String get sequenceSavedNotice => 'Note pattern saved.';

  @override
  String get sequenceExample => 'Examples: ABCDEFG, C#D#EF#G#, etc.';

  @override
  String get sequenceError =>
      'Enter at least one valid western or eastern note.';

  @override
  String get metronomeTitle => 'Metronome';

  @override
  String get advanced => 'Advanced';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get bpm => 'BPM';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get reset => 'Reset';

  @override
  String get click => 'Click';

  @override
  String get clickSound => 'Click sound';

  @override
  String get volumeBalance => 'Volume balance';

  @override
  String get clickVolume => 'Click volume';

  @override
  String get instrumentVolume => 'Instrument volume';

  @override
  String get sound => 'Sound';

  @override
  String get preview => 'Preview';

  @override
  String get instrument => 'Instrument';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialSkip => 'Skip all';

  @override
  String get tutorialDone => 'Done';

  @override
  String get tutorialReplay => 'Watch tutorial again';

  @override
  String tutorialStepCount(int current, int total) => '$current of $total';

  @override
  String get tutorialTryIt => 'Try it:';

  @override
  String get tutorialWellDone => 'Nice!';

  @override
  String tutorialTapTabAction(String tabName) =>
      'tap "$tabName" in the bar below.';

  @override
  String get tutorialTempoTitle => 'Tempo, beats, and the pendulum';

  @override
  String get tutorialTempoBody =>
      'The pendulum swings once per beat, and the big number is the tempo in BPM (beats per minute) — how many beats fit into one minute. The row of dots shows where you are inside the bar: the brighter first dot is the accented downbeat.';

  @override
  String get tutorialTempoExample =>
      '60 BPM = 1 beat per second\n120 BPM = 2 beats per second (twice as fast)';

  @override
  String get tutorialBpmDragTitle => 'Set your own tempo';

  @override
  String get tutorialBpmDragBody =>
      'Slow practice is the secret to clean playing: pick a tempo where you can play every note correctly, and only raise it once it feels easy. The slider goes from 30 (very slow) to 240 (very fast).';

  @override
  String get tutorialBpmDragAction => 'drag the tempo slider to any value.';

  @override
  String get tutorialSequenceTitle => 'Your note pattern';

  @override
  String get tutorialSequenceBody =>
      'This metronome does more than click — it can play a melody, one note per beat, looping your pattern while you play along. This panel shows the pattern loaded right now. Tap it any time to edit the notes without leaving this page.';

  @override
  String get tutorialToggleTitle => 'Click, notes, or both';

  @override
  String get tutorialToggleBody =>
      '"Click" is the classic tick that keeps time. "Sound" plays your note pattern on the selected instrument. Keep both on to hear the melody riding on top of the beat, or turn one off to focus.';

  @override
  String get tutorialToggleAction =>
      'tap one of the switches off, then on again.';

  @override
  String get tutorialMeterTitle => 'Meter and subdivision';

  @override
  String get tutorialMeterBody =>
      'The time signature groups beats into bars: in 4/4 you count 1-2-3-4 and start over, and beat 1 gets the accent. The beat unit subdivides each beat into smaller clicks, which helps when your notes move faster than the beat.';

  @override
  String get tutorialMeterExample =>
      '4/4 = 4 beats per bar (most common)\n3/4 = counts in 3, like a waltz\nEighth beat unit = 2 clicks per beat';

  @override
  String get tutorialTransportTitle => 'Hear it live';

  @override
  String get tutorialTransportBody =>
      'Everything is set — press Start and listen: the accented first beat, then your notes landing on each beat. Stop pauses the session; Reset jumps back to the beginning of your pattern.';

  @override
  String get tutorialTransportAction =>
      'press Start and listen for a bar or two.';

  @override
  String get tutorialAdvancedTitle => 'Advanced settings';

  @override
  String get tutorialAdvancedBody =>
      'When the defaults feel limiting, open this panel to change the click sound, choose the instrument that plays your notes, adjust accents, or shift the base octave up and down.';

  @override
  String get tutorialHomePracticeTitle => 'Welcome! Practice starts here';

  @override
  String get tutorialHomePracticeBody =>
      'Metrinote is a metronome that can also play the notes you want to practice, so you hear the beat and the melody together. This button opens the practice page with your current note pattern already loaded.';

  @override
  String get tutorialHomeHistoryTitle => 'Your practice history';

  @override
  String get tutorialHomeHistoryBody =>
      'Every session is tracked here: minutes practiced over the last 7 days, your most used tempo, and your favorite instrument. Set a daily goal and the progress ring keeps you honest.';

  @override
  String get tutorialHomeTabsTitle => 'Four tabs, one workflow';

  @override
  String get tutorialHomeTabsBody =>
      'Practice is home base. Sequences is where you build and save note patterns. Tools generates patterns for you. Basics explains the music terms this app uses. Let\'s visit them in order.';

  @override
  String get tutorialHomeExamplesTitle => 'Start from an example';

  @override
  String get tutorialHomeExamplesBody =>
      'Not sure what to practice? These ready-made patterns load with one tap — a Western major scale or an Eastern raga cycle. Load one, then tweak it to make it yours.';

  @override
  String get tutorialHomeSequencesTitle => 'Write your own pattern';

  @override
  String get tutorialHomeSequencesBody =>
      'Type note names separated by spaces, or tap the note chips below the field. Both Western letters (A B C…) and Eastern sargam (S R G M…) work. Give the pattern a name and save it to reuse any time.';

  @override
  String get tutorialHomeSequencesExample =>
      "C D E F → four notes, one per beat\nG - → '-' holds G for an extra beat\nE/F → '/' fits two notes into one beat\nC' high octave · C, low octave";

  @override
  String get tutorialHomeToolsTitle => 'Let Tools do the typing';

  @override
  String get tutorialHomeToolsBody =>
      'Tools has two generators that write patterns for you: a scale builder and a jianpu (numbered notation) converter. Let\'s take a quick look at both.';

  @override
  String get tutorialHomeScaleGenTitle => 'Scale pattern generator';

  @override
  String get tutorialHomeScaleGenBody =>
      'Pick a root key, scale type, octave range, and direction — it writes the full pattern for you. "Use pattern" drops the result straight into your sequence editor.';

  @override
  String get tutorialHomeJianpuTitle => 'Jianpu converter';

  @override
  String get tutorialHomeJianpuBody =>
      'If you read numbered notation (1 2 3 = do re mi), paste it here and it becomes a playable pattern. Octave dots and dashes for held notes are understood too.';

  @override
  String get tutorialHomeBasicsTitle => 'Learn the words';

  @override
  String get tutorialHomeBasicsBody =>
      'One more stop: Basics is a plain-language glossary of every term this app uses. Let\'s read the four most important ones together.';

  @override
  String get tutorialBasicsBpmBody =>
      'BPM means beats per minute: 60 BPM is exactly one beat every second. This is the number you set with the tempo slider on the practice page. Golden rule: start slower than feels comfortable.';

  @override
  String get tutorialBasicsMeterBody =>
      'The top number says how many beats each bar contains, and beat 1 always gets the accent. You choose this in the meter chip on the practice page — 4/4 is the safe default for most music.';

  @override
  String get tutorialBasicsSubdivisionBody =>
      'Subdivision splits each beat into smaller equal clicks: eighths give 2 clicks per beat, sixteenths give 4. Turn it on when your notes move faster than the main beat.';

  @override
  String get tutorialBasicsNotationBody =>
      'This app accepts two naming systems for the same notes: Western letters (C D E F G A B) and Eastern sargam (S R G M P D N). The nearby cards explain octave marks, held notes, and grouping.';

  @override
  String get tutorialHomeReturnTitle => 'Back to home base';

  @override
  String get tutorialHomeReturnBody =>
      'That\'s the tour of the tabs. Select Practice yourself so you always know how to get back to your starting point.';

  @override
  String get tutorialStartSessionTitle => 'Start when you are ready';

  @override
  String get tutorialStartSessionBody =>
      'Now press Start Metronome yourself. That opens the practice workspace, where the hands-on metronome tutorial will continue.';

  @override
  String get tutorialHomeSettingsTitle => 'Settings and replay';

  @override
  String get tutorialHomeSettingsBody =>
      'Theme, colors, and language live behind this gear. If you ever forget how something works, open Settings and tap "Watch tutorial again". Press Done, then we\'ll return to Practice together.';

  @override
  String get tutorialScoreTitle => 'Score practice on iPad';

  @override
  String get tutorialScoreBody =>
      'On larger screens in landscape, load a sheet-music image or PDF here and practice while the metronome stays visible beside it. You can zoom, flip pages, and go fullscreen.';

  @override
  String get notesLoaded => 'notes loaded';

  @override
  String get noSequenceLoaded => 'No sequence loaded';

  @override
  String get editNoteSequence => 'Edit note sequence';

  @override
  String get savedSequences => 'Saved sequences';

  @override
  String get sequenceName => 'Sequence name';

  @override
  String get searchSequences => 'Search sequences';

  @override
  String get saveSequence => 'Save';

  @override
  String get loadSequence => 'Load';

  @override
  String get viewAll => 'View All';

  @override
  String get quickEdit => 'Quick Edit';

  @override
  String get importSequence => 'Import Sequence';

  @override
  String get noSavedSequences => 'No saved sequences';

  @override
  String get sequenceNameError => 'Enter a name before saving.';

  @override
  String get alreadySavedNotice => 'Already saved.';

  @override
  String get replace => 'Replace';

  @override
  String noteSequenceTooLong(int maxNotes) =>
      'Use $maxNotes notes or fewer for one sequence.';

  @override
  String replaceSequenceQuestion(String name) =>
      'A sequence named "$name" already exists. Replace it?';

  @override
  String savedSequenceSummary(int visibleCount, int totalCount) =>
      'Showing $visibleCount of $totalCount';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get timeSignature => 'Time Signature';

  @override
  String get beatUnit => 'Subdivision';

  @override
  String get subdivisionHalf => 'Half';

  @override
  String get subdivisionQuarter => 'Quarter';

  @override
  String get subdivisionEighth => 'Eighth';

  @override
  String get subdivisionSixteenth => 'Sixteenth';

  @override
  String get subdivisionDottedHalf => 'Dotted Half';

  @override
  String get subdivisionDottedQuarter => 'Dotted Quarter';

  @override
  String get subdivisionDottedEighth => 'Dotted Eighth';

  @override
  String get missingInstrument => 'missing';

  @override
  String noPlayableAssets(String instrument) =>
      'No playable assets found for $instrument';

  @override
  String get scorePreview => 'Score';

  @override
  String get addScore => 'Add score';

  @override
  String get importScoreFromFiles => 'Choose from Files';

  @override
  String get importScoreFromPhotos => 'Choose from Photos';

  @override
  String get deleteScore => 'Delete score';

  @override
  String get chooseScore => 'Choose score';

  @override
  String get scorePlaceholderTitle => 'No score added';

  @override
  String get scorePlaceholderBody =>
      'This space is reserved for a PDF or score image.';
}
