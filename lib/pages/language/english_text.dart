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
  String get practiceNotePattern => 'Practice Note Pattern';

  @override
  String get notePatternDescription =>
      'Choose the order of notes the metronome will play.';

  @override
  String get notesToPlay => 'Notes to play';

  @override
  String get noteInputHelper => 'Use A-G, # and b, e.g. C# and Bb.';

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
  String get beatUnit => 'Beat Unit';

  @override
  String get missingInstrument => 'missing';

  @override
  String noPlayableAssets(String instrument) =>
      'No playable assets found for $instrument';
}
