import 'app_language_text.dart';

// Hindi language text implementation for the app
class HindiText implements AppLanguageText {
  const HindiText();

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get appearance => 'दिखावट';

  @override
  String get system => 'सिस्टम';

  @override
  String get light => 'लाइट';

  @override
  String get dark => 'डार्क';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get french => 'Français';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get homeTitle => 'अभ्यास';

  @override
  String get appName => 'Metronome Studio';

  @override
  String get readyTitle => 'नमस्ते,\nअभ्यास के लिए तैयार हैं?';

  @override
  String get readyDescription =>
      'अपनी पिछली सेटिंग्स के साथ नया मेट्रोनोम सेशन शुरू करने के लिए नीचे बटन दबाएँ।';

  @override
  String get startMetronome => 'मेट्रोनोम शुरू करें';

  @override
  String get practiceNotePattern => 'नोट पैटर्न';

  @override
  String get notePatternDescription =>
      'मेट्रोनोम जिन नोट्स को क्रम से बजाएगा, उनका क्रम चुनें।';

  @override
  String get notesToPlay => 'बजाने वाले नोट्स';

  @override
  String get noteInputHelper => 'A-G, # और b इस्तेमाल करें, जैसे C# और Bb।';

  @override
  String get applySequence => 'पैटर्न लागू करें';

  @override
  String get deleteNote => 'हटाएँ';

  @override
  String get clearNotes => 'साफ करें';

  @override
  String get sequenceSavedNotice => 'नोट पैटर्न सेव हो गया है।';

  @override
  String get sequenceExample => 'उदाहरण: ABCDEFG, C#D#EF#G#';

  @override
  String get sequenceError =>
      'A-G में से कम से कम एक नोट डालें। आप sharps (#) और flats (b) भी इस्तेमाल कर सकते हैं।';

  @override
  String get languageSavedNotice => 'भाषा सेटिंग सेव हो गई है।';

  @override
  String get metronomeTitle => 'मेट्रोनोम';

  @override
  String get advanced => 'एडवांस्ड';

  @override
  String get advancedSettings => 'एडवांस्ड सेटिंग्स';

  @override
  String get bpm => 'BPM';

  @override
  String get start => 'शुरू';

  @override
  String get stop => 'रोकें';

  @override
  String get reset => 'रीसेट';

  @override
  String get click => 'क्लिक';

  @override
  String get sound => 'साउंड';

  @override
  String get instrument => 'वाद्य';

  @override
  String get notesLoaded => 'नोट्स लोड हुए';

  @override
  String get noSequenceLoaded => 'कोई पैटर्न लोड नहीं हुआ';

  @override
  String get editNoteSequence => 'नोट पैटर्न संपादित करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get apply => 'लागू करें';

  @override
  String get close => 'बंद करें';

  @override
  String get done => 'हो गया';

  @override
  String get timeSignature => 'टाइम सिग्नेचर';

  @override
  String get beatUnit => 'बीट यूनिट';

  @override
  String get missingInstrument => 'नहीं मिला';

  @override
  String noPlayableAssets(String instrument) =>
      '$instrument के लिए कोई playable asset नहीं मिला';
}
