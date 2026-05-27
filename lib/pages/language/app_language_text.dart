// language text for app

abstract class AppLanguageText {
  String get settings;
  String get appearance;
  String get system;
  String get light;
  String get dark;
  String get language;
  String get english;
  String get chinese;
  String get french;
  String get hindi;

  String get homeTitle;
  String get appName;

  String get readyTitle;
  String get readyDescription;
  String get startMetronome;

  String get practiceNotePattern;
  String get notePatternDescription;
  String get notesToPlay;
  String get noteInputHelper;
  String get applySequence;
  String get deleteNote;
  String get clearNotes;
  String get sequenceSavedNotice;
  String get sequenceExample;
  String get sequenceError;

  String get languageSavedNotice;

  String get metronomeTitle;
  String get advanced;
  String get advancedSettings;
  String get bpm;
  String get start;
  String get stop;
  String get reset;
  String get click;
  String get sound;
  String get instrument;
  String get notesLoaded;
  String get noSequenceLoaded;
  String get editNoteSequence;
  String get savedSequences;
  String get sequenceName;
  String get searchSequences;
  String get saveSequence;
  String get loadSequence;
  String get viewAll;
  String get quickEdit;
  String get importSequence;
  String get noSavedSequences;
  String get sequenceNameError;
  String get alreadySavedNotice;
  String get replace;
  String noteSequenceTooLong(int maxNotes);
  String replaceSequenceQuestion(String name);
  String savedSequenceSummary(int visibleCount, int totalCount);
  String get cancel;
  String get apply;
  String get close;
  String get done;
  String get timeSignature;
  String get beatUnit;
  String get missingInstrument;
  String noPlayableAssets(String instrument);
}
