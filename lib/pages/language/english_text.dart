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
  String get homeTitle => 'Practice';

  @override
  String get appName => 'Metronome Studio';

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
  String get practiceNotePattern => 'Practice Note Pattern';

  @override
  String get notePatternDescription =>
      'Choose the order of notes the metronome will play.';

  @override
  String get notesToPlay => 'Notes to play';

  @override
  String get noteInputHelper => 'Use A-G, # and b. Example: A B C# Bb.';

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
      'Enter at least one note from A-G. You can also use sharps (#) and flats (b).';

  @override
  String get languageSavedNotice => 'Language selection is saved now';

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
}
