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
  String get sound => 'Sound';

  @override
  String get instrument => 'Instrument';

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
  String get scorePlaceholderTitle => 'No score added';

  @override
  String get scorePlaceholderBody =>
      'This space is reserved for a PDF or score image.';
}
