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
  String get homeTitle => 'होम';

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
  String get readyTitle => 'नमस्ते,\nअभ्यास के लिए तैयार हैं?';

  @override
  String get readyDescription =>
      'अपनी पिछली सेटिंग्स के साथ नया मेट्रोनोम सेशन शुरू करने के लिए नीचे बटन दबाएँ।';

  @override
  String get startMetronome => 'मेट्रोनोम शुरू करें';

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
  String get favoriteInstrument => 'पसंदीदा instrument';

  @override
  String get noPracticeYet => 'अभी कोई practice record नहीं है';

  @override
  String get basicsIntro =>
      'Rhythm, meter और notation के छोटे reference cards.';

  @override
  String get bpmBasicsTitle => 'BPM';

  @override
  String get bpmBasicsBody =>
      'BPM का मतलब beats per minute है। नया pattern सीखते समय slow BPM रखें, फिर timing steady होने पर धीरे-धीरे बढ़ाएँ।';

  @override
  String get timeSignatureBasicsTitle => 'Time Signature';

  @override
  String get timeSignatureBasicsBody =>
      'ऊपर वाला नंबर बताता है कि हर bar में कितने beats हैं। 4/4 बहुत common है, और 3/4 में अक्सर waltz जैसा feel आता है।';

  @override
  String get subdivisionBasicsTitle => 'Subdivision';

  @override
  String get subdivisionBasicsBody =>
      'Subdivision बताता है कि beat कैसे split होता है। Quarter simple रहता है; eighth और sixteenth click को ज्यादा detailed बनाते हैं।';

  @override
  String get downbeatBasicsTitle => 'Downbeat';

  @override
  String get downbeatBasicsBody =>
      'Downbeat bar का पहला beat होता है। Strong first click से measure की shape साफ सुनाई देती है।';

  @override
  String get jianpuBasicsTitle => 'Jianpu';

  @override
  String get jianpuBasicsBody =>
      'Jianpu scale degrees के लिए numbers इस्तेमाल करता है, जैसे 1 2 3 5 6। Key चुनकर इसे note names से जोड़ा जा सकता है।';

  @override
  String get westernNotationBasicsTitle => 'Western Notes';

  @override
  String get westernNotationBasicsBody =>
      'Western note names A-G इस्तेमाल करते हैं। Sharp (#) note को एक semitone ऊपर करता है, और flat (b) note को एक semitone नीचे करता है।';

  @override
  String get easternNotationBasicsTitle => 'Eastern Notes';

  @override
  String get easternNotationBasicsBody =>
      'Eastern notation Sa Re Ga Ma Pa Dha Ni इस्तेमाल करता है, या S R G M P D N. इस app में ये C D E F G A B से map होते हैं।';

  @override
  String get octaveNotationBasicsTitle => 'Octaves';

  @override
  String get octaveNotationBasicsBody =>
      "Higher octave के लिए ' और lower octave के लिए comma इस्तेमाल करें। जैसे C' C से ऊँचा है, और C, C से नीचे है।";

  @override
  String get groupedNotesBasicsTitle => 'Grouped Notes';

  @override
  String get groupedNotesBasicsBody =>
      'Space अगले beat पर ले जाता है। बिना space वाले notes एक ही beat में बजते हैं, इसलिए C D E FG में F और G चौथे beat में साथ आते हैं।';

  @override
  String get heldNotesBasicsTitle => 'Held Notes';

  @override
  String get heldNotesBasicsBody =>
      'Dash (-) previous note को अगले beat तक hold करता है। जैसे C - D E में C second beat तक चलता है।';

  @override
  String get scalePatternGenerator => 'Scale Pattern Generator';

  @override
  String get scalePatternDescription =>
      'Scale practice pattern बनाएँ और note sequence में भेजें।';

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
  String get patternAppliedNotice =>
      'Pattern sequence editor में जोड़ दिया गया है।';

  @override
  String get jianpuConverter => 'Jianpu Converter';

  @override
  String get jianpuConverterDescription =>
      'Key चुनकर numbered notation को playable note names में बदलें।';

  @override
  String get jianpuInput => 'Jianpu input';

  @override
  String get convertedSequence => 'Converted sequence';

  @override
  String get practiceNotePattern => 'नोट पैटर्न';

  @override
  String get notePatternDescription =>
      'मेट्रोनोम जिन नोट्स को क्रम से बजाएगा, उनका क्रम चुनें।';

  @override
  String get notesToPlay => 'बजाने वाले नोट्स';

  @override
  String get noteInputHelper =>
      "A-G या S R G M P D N इस्तेमाल करें। ', comma, / और - octave, grouped notes और holds के लिए हैं।";

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
      'कम से कम एक valid western या eastern note डालें।';

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
  String get clickSound => 'क्लिक साउंड';

  @override
  String get sound => 'साउंड';

  @override
  String get preview => 'प्रिव्यू';

  @override
  String get instrument => 'वाद्य';

  @override
  String get tutorialNext => 'आगे';

  @override
  String get tutorialSkip => 'सब skip करें';

  @override
  String get tutorialDone => 'पूरा';

  @override
  String get tutorialReplay => 'Tutorial फिर से देखें';

  @override
  String tutorialStepCount(int current, int total) => '$current / $total';

  @override
  String get tutorialTryIt => 'Try करें:';

  @override
  String get tutorialWellDone => 'बहुत बढ़िया!';

  @override
  String tutorialTapTabAction(String tabName) =>
      'नीचे की bar में "$tabName" पर tap करें।';

  @override
  String get tutorialTempoTitle => 'Tempo, beat और pendulum';

  @override
  String get tutorialTempoBody =>
      'Pendulum हर beat पर एक बार झूलता है, और बड़ा नंबर tempo है — BPM (beats per minute), यानी एक minute में कितने beats। ऊपर के dots बताते हैं कि आप bar में कहां हैं: सबसे चमकीला पहला dot accented downbeat है।';

  @override
  String get tutorialTempoExample =>
      '60 BPM = हर second 1 beat\n120 BPM = हर second 2 beats (दुगना तेज़)';

  @override
  String get tutorialBpmDragTitle => 'अपना tempo set करें';

  @override
  String get tutorialBpmDragBody =>
      'धीमी practice ही साफ बजाने का राज़ है: ऐसा tempo चुनें जहां हर note सही बजे, आसान लगने पर ही धीरे-धीरे बढ़ाएं। Slider 30 (बहुत धीमा) से 240 (बहुत तेज़) तक जाता है।';

  @override
  String get tutorialBpmDragAction =>
      'tempo slider को खींचकर कोई भी value set करें।';

  @override
  String get tutorialSequenceTitle => 'आपका note pattern';

  @override
  String get tutorialSequenceBody =>
      'यह metronome सिर्फ click नहीं करता — यह melody भी बजा सकता है: हर beat पर एक note, आपका pattern loop में। यह panel अभी loaded pattern दिखाता है; notes बदलने के लिए कभी भी इस पर tap करें।';

  @override
  String get tutorialToggleTitle => 'Click, notes, या दोनों';

  @override
  String get tutorialToggleBody =>
      '"Click" classic टिक-टिक है जो time पकड़कर रखती है। "Sound" चुने हुए instrument पर आपका note pattern बजाता है। दोनों on रखें तो melody beat के ऊपर सुनाई देती है; focus करना हो तो एक बंद कर दें।';

  @override
  String get tutorialToggleAction => 'कोई एक switch off करके फिर on करें।';

  @override
  String get tutorialMeterTitle => 'Meter और subdivision';

  @override
  String get tutorialMeterBody =>
      'Time signature beats को bars में बांटता है: 4/4 में आप 1-2-3-4 गिनकर फिर शुरू करते हैं, और beat 1 पर accent आता है। Beat unit हर beat को छोटे clicks में बांटता है — जब notes beat से तेज़ चलें तब काम आता है।';

  @override
  String get tutorialMeterExample =>
      '4/4 = हर bar में 4 beats (सबसे common)\n3/4 = 3 की गिनती, waltz जैसा\nEighth beat unit = हर beat पर 2 clicks';

  @override
  String get tutorialTransportTitle => 'Live सुनें';

  @override
  String get tutorialTransportBody =>
      'सब set है — Start दबाकर सुनें: accented पहला beat, फिर हर beat पर आपके notes। Stop session रोकता है; Reset pattern की शुरुआत पर वापस ले जाता है।';

  @override
  String get tutorialTransportAction => 'Start दबाएं और एक-दो bar सुनें।';

  @override
  String get tutorialAdvancedTitle => 'Advanced settings';

  @override
  String get tutorialAdvancedBody =>
      'Defaults कम पड़ने लगें तो यह panel खोलें: click sound बदलें, notes बजाने वाला instrument चुनें, accents adjust करें, या base octave ऊपर-नीचे करें।';

  @override
  String get tutorialHomePracticeTitle => 'Welcome! Practice यहां शुरू होती है';

  @override
  String get tutorialHomePracticeBody =>
      'Metrinote एक ऐसा metronome है जो आपके practice वाले notes भी बजा सकता है — beat और melody एक साथ सुनाई देती है। यह button practice page खोलता है, आपका current note pattern पहले से loaded होगा।';

  @override
  String get tutorialHomeHistoryTitle => 'आपकी practice history';

  @override
  String get tutorialHomeHistoryBody =>
      'हर session यहां track होता है: पिछले 7 दिनों के practice minutes, सबसे ज्यादा use हुआ tempo, और favorite instrument। Daily goal set करें — progress ring आपको ईमानदार रखेगी।';

  @override
  String get tutorialHomeTabsTitle => 'चार tabs, एक workflow';

  @override
  String get tutorialHomeTabsBody =>
      'Practice home base है। Sequences में note patterns बनते और save होते हैं। Tools आपके लिए patterns generate करता है। Basics app के music terms समझाता है। चलिए order में देखते हैं।';

  @override
  String get tutorialHomeExamplesTitle => 'Example से शुरू करें';

  @override
  String get tutorialHomeExamplesBody =>
      'समझ नहीं आ रहा क्या practice करें? ये ready-made patterns एक tap में load होते हैं — Western major scale या Eastern raga cycle। एक load करें, फिर अपने हिसाब से बदलें।';

  @override
  String get tutorialHomeSequencesTitle => 'अपना pattern लिखें';

  @override
  String get tutorialHomeSequencesBody =>
      'Note names spaces से अलग करके type करें, या field के नीचे chips पर tap करें। Western letters (A B C…) और Eastern sargam (S R G M…) दोनों चलते हैं। नाम देकर save करें, कभी भी reuse करें।';

  @override
  String get tutorialHomeSequencesExample =>
      "C D E F → चार notes, हर beat पर एक\nG - → '-' G को एक beat और रोकता है\nE/F → '/' दो notes एक beat में\nC' ऊंचा octave · C, नीचा octave";

  @override
  String get tutorialHomeToolsTitle => 'Typing का काम Tools को दें';

  @override
  String get tutorialHomeToolsBody =>
      'Tools में दो generators हैं जो आपके लिए patterns लिखते हैं: scale builder और jianpu (numbered notation) converter। दोनों पर एक नज़र डालते हैं।';

  @override
  String get tutorialHomeScaleGenTitle => 'Scale pattern generator';

  @override
  String get tutorialHomeScaleGenBody =>
      'Root key, scale type, octave range और direction चुनें — पूरा pattern अपने आप लिख जाता है। "Use pattern" result को सीधे आपके sequence editor में डाल देता है।';

  @override
  String get tutorialHomeJianpuTitle => 'Jianpu converter';

  @override
  String get tutorialHomeJianpuBody =>
      'अगर आप numbered notation पढ़ते हैं (1 2 3 = do re mi), तो उसे यहां paste करें — playable pattern बन जाएगा। Octave dots और held notes के dashes भी समझ में आते हैं।';

  @override
  String get tutorialHomeBasicsTitle => 'Terms सीखें';

  @override
  String get tutorialHomeBasicsBody =>
      'एक आखिरी पड़ाव: Basics एक आसान glossary है जो app के हर term को समझाती है। चलिए चार सबसे ज़रूरी terms साथ में पढ़ते हैं।';

  @override
  String get tutorialBasicsBpmBody =>
      'BPM मतलब beats per minute: 60 BPM यानी हर second ठीक एक beat। यही नंबर practice page के tempo slider से set होता है। Golden rule: जितना comfortable लगे उससे धीमा शुरू करें।';

  @override
  String get tutorialBasicsMeterBody =>
      'ऊपर वाला नंबर बताता है हर bar में कितने beats हैं, और beat 1 पर हमेशा accent आता है। Practice page की meter chip से यह चुना जाता है — ज़्यादातर music के लिए 4/4 safe रहता है।';

  @override
  String get tutorialBasicsSubdivisionBody =>
      'Subdivision हर beat को छोटे बराबर clicks में बांटता है: eighths से हर beat पर 2 clicks, sixteenths से 4। जब notes main beat से तेज़ चलें तब इसे use करें।';

  @override
  String get tutorialBasicsNotationBody =>
      'App एक ही notes के दो naming systems समझता है: Western letters (C D E F G A B) और Eastern sargam (S R G M P D N)। आस-पास के cards octave marks, held notes और grouping समझाते हैं।';

  @override
  String get tutorialHomeReturnTitle => 'वापस home base पर';

  @override
  String get tutorialHomeReturnBody =>
      'Tabs का tour पूरा हुआ। Practice पर वापस चलें — metronome खोलकर hands-on try करने से पहले एक आखिरी चीज़ देखनी है।';

  @override
  String get tutorialHomeSettingsTitle => 'Settings और tutorial';

  @override
  String get tutorialHomeSettingsBody =>
      'Theme, colors और language इस gear के पीछे हैं। कभी कुछ भूल जाएं तो Settings खोलकर "Tutorial फिर से देखें" tap करें। अब "पूरा" दबाएं — metronome page पर असली try करते हैं।';

  @override
  String get tutorialScoreTitle => 'iPad score practice';

  @override
  String get tutorialScoreBody =>
      'बड़ी screen पर landscape में यहां sheet-music image या PDF load करें — metronome बगल में दिखता रहेगा। Zoom, page बदलना और fullscreen सब available है।';

  @override
  String get notesLoaded => 'नोट्स लोड हुए';

  @override
  String get noSequenceLoaded => 'कोई पैटर्न लोड नहीं हुआ';

  @override
  String get editNoteSequence => 'नोट पैटर्न संपादित करें';

  @override
  String get savedSequences => 'सेव किए गए पैटर्न';

  @override
  String get sequenceName => 'पैटर्न का नाम';

  @override
  String get searchSequences => 'पैटर्न खोजें';

  @override
  String get saveSequence => 'पैटर्न सेव करें';

  @override
  String get loadSequence => 'लोड करें';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get quickEdit => 'जल्दी संपादित करें';

  @override
  String get importSequence => 'पैटर्न इम्पोर्ट करें';

  @override
  String get noSavedSequences => 'कोई सेव किया गया पैटर्न नहीं';

  @override
  String get sequenceNameError => 'सेव करने से पहले नाम डालें।';

  @override
  String get alreadySavedNotice => 'पहले से सेव है।';

  @override
  String get replace => 'बदलें';

  @override
  String noteSequenceTooLong(int maxNotes) =>
      'एक पैटर्न में $maxNotes या उससे कम नोट्स इस्तेमाल करें।';

  @override
  String replaceSequenceQuestion(String name) =>
      '"$name" नाम का पैटर्न पहले से है। क्या इसे बदलना है?';

  @override
  String savedSequenceSummary(int visibleCount, int totalCount) =>
      '$totalCount में से $visibleCount दिख रहे हैं';

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
  String get beatUnit => 'सबडिवीजन';

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
  String get missingInstrument => 'नहीं मिला';

  @override
  String noPlayableAssets(String instrument) =>
      '$instrument के लिए कोई playable asset नहीं मिला';

  @override
  String get scorePreview => 'Score';

  @override
  String get addScore => 'Score जोड़ें';

  @override
  String get scorePlaceholderTitle => 'कोई score नहीं जोड़ा गया';

  @override
  String get scorePlaceholderBody =>
      'यह जगह PDF या score image दिखाने के लिए है।';
}
