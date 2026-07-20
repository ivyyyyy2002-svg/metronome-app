// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

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
  String get themeColor => 'थीम रंग';

  @override
  String get defaultThemeColor => 'डिफ़ॉल्ट';

  @override
  String get roseThemeColor => 'गुलाबी';

  @override
  String get purpleThemeColor => 'बैंगनी';

  @override
  String get warmThemeColor => 'पीला';

  @override
  String get tealThemeColor => 'टील';

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
  String get spanish => 'स्पेनिश';

  @override
  String get homeTitle => 'होम';

  @override
  String get appName => 'Metrinote';

  @override
  String get practiceTab => 'अभ्यास';

  @override
  String get sequencesTab => 'सीक्वेंस';

  @override
  String get toolsTab => 'टूल्स';

  @override
  String get basicsTab => 'मूल बातें';

  @override
  String get readyTitle => 'नमस्ते,\nअभ्यास के लिए तैयार हैं?';

  @override
  String get readyDescription =>
      'अपनी पिछली सेटिंग्स के साथ नया मेट्रोनोम सेशन शुरू करने के लिए नीचे बटन दबाएँ।';

  @override
  String get startMetronome => 'मेट्रोनोम शुरू करें';

  @override
  String get musicBasics => 'संगीत की मूल बातें';

  @override
  String get practiceHistory => 'अभ्यास इतिहास';

  @override
  String get todayPractice => 'आज';

  @override
  String get last7Days => 'पिछले 7 दिन';

  @override
  String get lastSession => 'पिछला सत्र';

  @override
  String get mostUsedBpm => 'सर्वाधिक प्रयुक्त BPM';

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
  String get timeSignatureBasicsTitle => 'ताल चिह्न';

  @override
  String get timeSignatureBasicsBody =>
      'ऊपर वाला नंबर बताता है कि हर bar में कितने beats हैं। 4/4 बहुत common है, और 3/4 में अक्सर waltz जैसा feel आता है।';

  @override
  String get subdivisionBasicsTitle => 'उपविभाजन';

  @override
  String get subdivisionBasicsBody =>
      'Subdivision बताता है कि beat कैसे split होता है। Quarter simple रहता है; eighth और sixteenth click को ज्यादा detailed बनाते हैं।';

  @override
  String get downbeatBasicsTitle => 'पहली मात्रा';

  @override
  String get downbeatBasicsBody =>
      'Downbeat bar का पहला beat होता है। Strong first click से measure की shape साफ सुनाई देती है।';

  @override
  String get jianpuBasicsTitle => 'जियानपु';

  @override
  String get jianpuBasicsBody =>
      'Jianpu scale degrees के लिए numbers इस्तेमाल करता है, जैसे 1 2 3 5 6। Key चुनकर इसे note names से जोड़ा जा सकता है।';

  @override
  String get westernNotationBasicsTitle => 'पश्चिमी स्वर';

  @override
  String get westernNotationBasicsBody =>
      'Western note names A-G इस्तेमाल करते हैं। Sharp (#) note को एक semitone ऊपर करता है, और flat (b) note को एक semitone नीचे करता है।';

  @override
  String get easternNotationBasicsTitle => 'पूर्वी स्वर';

  @override
  String get easternNotationBasicsBody =>
      'Eastern notation Sa Re Ga Ma Pa Dha Ni इस्तेमाल करता है, या S R G M P D N. इस app में ये C D E F G A B से map होते हैं।';

  @override
  String get octaveNotationBasicsTitle => 'सप्तक';

  @override
  String get octaveNotationBasicsBody =>
      'Higher octave के लिए \' और lower octave के लिए comma इस्तेमाल करें। जैसे C\' C से ऊँचा है, और C, C से नीचे है।';

  @override
  String get groupedNotesBasicsTitle => 'समूहित स्वर';

  @override
  String get groupedNotesBasicsBody =>
      'Space अगले beat पर ले जाता है। बिना space वाले notes एक ही beat में बजते हैं, इसलिए C D E FG में F और G चौथे beat में साथ आते हैं।';

  @override
  String get heldNotesBasicsTitle => 'विस्तारित स्वर';

  @override
  String get heldNotesBasicsBody =>
      'Dash (-) previous note को अगले beat तक hold करता है। जैसे C - D E में C second beat तक चलता है।';

  @override
  String get scalePatternGenerator => 'स्केल पैटर्न जनरेटर';

  @override
  String get scalePatternDescription =>
      'Scale practice pattern बनाएँ और note sequence में भेजें।';

  @override
  String get notation => 'स्वरलिपि';

  @override
  String get westernNotation => 'पश्चिमी';

  @override
  String get easternNotation => 'पूर्वी';

  @override
  String get rootKey => 'मूल स्वर';

  @override
  String get scale => 'स्केल';

  @override
  String get direction => 'दिशा';

  @override
  String get ascending => 'आरोह';

  @override
  String get descending => 'अवरोह';

  @override
  String get upAndDown => 'आरोह-अवरोह';

  @override
  String get majorPentatonic => 'मेजर पेंटाटोनिक';

  @override
  String get minorPentatonic => 'माइनर पेंटाटोनिक';

  @override
  String get majorScale => 'मेजर स्केल';

  @override
  String get minorScale => 'माइनर स्केल';

  @override
  String get generatedPattern => 'उत्पन्न पैटर्न';

  @override
  String get useAsSequence => 'सीक्वेंस के रूप में उपयोग करें';

  @override
  String get patternAppliedNotice =>
      'Pattern sequence editor में जोड़ दिया गया है।';

  @override
  String get jianpuConverter => 'जियानपु कन्वर्टर';

  @override
  String get jianpuConverterDescription =>
      'Key चुनकर numbered notation को playable note names में बदलें।';

  @override
  String get jianpuInput => 'जियानपु इनपुट';

  @override
  String get convertedSequence => 'परिवर्तित सीक्वेंस';

  @override
  String get practiceNotePattern => 'नोट पैटर्न';

  @override
  String get notePatternDescription =>
      'मेट्रोनोम जिन नोट्स को क्रम से बजाएगा, उनका क्रम चुनें।';

  @override
  String get notesToPlay => 'बजाने वाले नोट्स';

  @override
  String get noteInputHelper =>
      'A-G या S R G M P D N इस्तेमाल करें। \', comma, / और - octave, grouped notes और holds के लिए हैं।';

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
  String get volumeBalance => 'वॉल्यूम बैलेंस';

  @override
  String get clickVolume => 'क्लिक वॉल्यूम';

  @override
  String get instrumentVolume => 'वाद्य वॉल्यूम';

  @override
  String get sound => 'साउंड';

  @override
  String get preview => 'प्रिव्यू';

  @override
  String get instrument => 'वाद्य';

  @override
  String get tutorialNext => 'आगे';

  @override
  String get tutorialSkip => 'सब छोड़ें';

  @override
  String get tutorialDone => 'हो गया';

  @override
  String get tutorialReplay => 'ट्यूटोरियल फिर से देखें';

  @override
  String get tutorialTryIt => 'आज़माएँ:';

  @override
  String get tutorialWellDone => 'बढ़िया!';

  @override
  String get tutorialTempoTitle => 'गति, मात्रा और पेंडुलम';

  @override
  String get tutorialTempoBody =>
      'पेंडुलम हर मात्रा पर एक बार झूलता है। बड़ा नंबर BPM में गति है, यानी प्रति मिनट कितनी मात्राएँ। बिंदुओं की पंक्ति बताती है कि आप ताल में कहाँ हैं, और सबसे चमकीला बिंदु सम है।';

  @override
  String get tutorialTempoExample =>
      '60 BPM = 1 मात्रा प्रति सेकंड\n120 BPM = 2 मात्रा प्रति सेकंड (दोगुनी तेज़)';

  @override
  String get tutorialBpmDragTitle => 'गति सेट करें';

  @override
  String get tutorialBpmDragBody =>
      'ऐसी गति चुनें जिस पर हर स्वर सही बजे, और आसान लगने पर ही बढ़ाएँ। स्लाइडर 30 से 240 तक जाता है।';

  @override
  String get tutorialBpmDragAction => 'गति स्लाइडर को किसी भी मान पर खींचें।';

  @override
  String get tutorialSequenceTitle => 'आपका स्वर पैटर्न';

  @override
  String get tutorialSequenceBody =>
      'यह मेट्रोनोम सिर्फ़ क्लिक नहीं करता। यह आपके स्वर पैटर्न को धुन की तरह बजाता है, हर मात्रा पर एक स्वर, और आपके साथ लूप में चलता है। यह पैनल अभी लोड किया गया पैटर्न दिखाता है। स्वर बदलने के लिए इसे टैप करें।';

  @override
  String get tutorialToggleTitle => 'क्लिक और साउंड';

  @override
  String get tutorialToggleBody =>
      '“क्लिक” वही पारंपरिक टिक है जो समय संभालता है। “साउंड” चुने हुए वाद्य पर आपका स्वर पैटर्न बजाता है। दोनों चालू रखें तो मात्रा के ऊपर धुन सुनाई देगी, या एक बंद करके दूसरे पर ध्यान दें।';

  @override
  String get tutorialToggleAction => 'एक स्विच बंद करें, फिर वापस चालू करें।';

  @override
  String get tutorialMeterTitle => 'ताल और उपविभाजन';

  @override
  String get tutorialMeterBody =>
      'ताल चिह्न मात्राओं को ताल में बाँटता है। 4/4 में आप 1-2-3-4 गिनकर फिर से शुरू करते हैं, और पहली मात्रा पर ज़ोर होता है। उपविभाजन हर मात्रा को छोटे क्लिक में बाँटता है, जो तब काम आता है जब स्वर मात्रा से तेज़ चलें।';

  @override
  String get tutorialMeterExample =>
      '4/4 = हर ताल में 4 मात्रा, सबसे आम\n3/4 = 3 की गिनती, वाल्ट्ज़ जैसी\nआठवाँ उपविभाजन = हर मात्रा पर 2 क्लिक';

  @override
  String get tutorialTransportTitle => 'सुनकर देखें';

  @override
  String get tutorialTransportBody =>
      'सब तैयार है। शुरू दबाएँ और सुनें: पहली ज़ोरदार मात्रा, फिर हर मात्रा पर आपके स्वर। रोकें से सत्र रुकता है और रीसेट से पैटर्न शुरुआत पर लौटता है।';

  @override
  String get tutorialTransportAction => 'शुरू दबाएँ और एक-दो ताल सुनें।';

  @override
  String get tutorialAdvancedTitle => 'उन्नत सेटिंग्स';

  @override
  String get tutorialAdvancedBody =>
      'जब डिफ़ॉल्ट सेटिंग्स कम पड़ें, तो इस पैनल से क्लिक की ध्वनि बदलें, स्वर बजाने वाला वाद्य चुनें, ज़ोर समायोजित करें, या मूल सप्तक ऊपर-नीचे करें।';

  @override
  String get tutorialHomePracticeTitle =>
      'स्वागत है। अभ्यास यहीं से शुरू होता है';

  @override
  String get tutorialHomePracticeBody =>
      'Metrinote एक ऐसा मेट्रोनोम है जो आपके अभ्यास के स्वर भी बजाता है, ताकि मात्रा और धुन साथ-साथ सुनाई दें। यह बटन अभ्यास पेज खोलता है, जिसमें आपका मौजूदा स्वर पैटर्न पहले से लोड होता है।';

  @override
  String get tutorialHomeHistoryTitle => 'अभ्यास इतिहास';

  @override
  String get tutorialHomeHistoryBody =>
      'हर सत्र यहाँ दर्ज होता है: पिछले 7 दिनों के अभ्यास के मिनट, सबसे ज़्यादा इस्तेमाल की गई गति और वाद्य। दैनिक लक्ष्य तय करें और प्रगति रिंग दिखाएगी कि आप कहाँ तक पहुँचे।';

  @override
  String get tutorialHomeTabsTitle => 'चार टैब';

  @override
  String get tutorialHomeTabsBody =>
      '“अभ्यास” मुख्य पेज है। “सीक्वेंस” में आप स्वर पैटर्न बनाते और सहेजते हैं। “टूल्स” आपके लिए पैटर्न बनाता है। “मूल बातें” ऐप में इस्तेमाल हुए संगीत शब्द समझाता है। इन्हें क्रम से देखते हैं।';

  @override
  String get tutorialHomeExamplesTitle => 'उदाहरण से शुरू करें';

  @override
  String get tutorialHomeExamplesBody =>
      'समझ नहीं आ रहा क्या अभ्यास करें? ये तैयार पैटर्न एक टैप में लोड होते हैं, जिनमें एक पश्चिमी मेजर स्केल और एक पूर्वी राग चक्र शामिल है। एक लोड करें, फिर अपने हिसाब से बदलें।';

  @override
  String get tutorialHomeSequencesTitle => 'अपना पैटर्न लिखें';

  @override
  String get tutorialHomeSequencesBody =>
      'स्वरों के नाम स्पेस से अलग करके लिखें, या नीचे दिए स्वर बटन दबाएँ। पश्चिमी अक्षर (A B C…) और पूर्वी सरगम (S R G M…) दोनों चलते हैं। पैटर्न को नाम देकर सहेजें ताकि बाद में फिर लोड कर सकें।';

  @override
  String get tutorialHomeSequencesExample =>
      'C D E F → चार स्वर, हर मात्रा पर एक\nG - → “-” G को एक मात्रा और खींचता है\nE/F → “/” दो स्वर एक मात्रा में रखता है\nC\' ऊँचा सप्तक · C, नीचा सप्तक';

  @override
  String get tutorialHomeToolsTitle => 'टूल्स से पैटर्न बनवाएँ';

  @override
  String get tutorialHomeToolsBody =>
      '“टूल्स” टैब में दो जनरेटर हैं: एक स्केल बिल्डर और एक जियानपु कन्वर्टर। दोनों आपके लिए पैटर्न लिखते हैं। दोनों को देखते हैं।';

  @override
  String get tutorialHomeScaleGenTitle => 'स्केल पैटर्न जनरेटर';

  @override
  String get tutorialHomeScaleGenBody =>
      'मूल स्वर, स्केल का प्रकार, सप्तक की सीमा और दिशा चुनें, और यह पूरा पैटर्न लिख देगा। “सीक्वेंस के रूप में उपयोग करें” उसे सीधे आपके एडिटर में डाल देता है।';

  @override
  String get tutorialHomeJianpuTitle => 'जियानपु कन्वर्टर';

  @override
  String get tutorialHomeJianpuBody =>
      'अगर आप अंकीय स्वरलिपि (1 2 3 = सा रे ग) पढ़ते हैं, तो उसे यहाँ चिपकाएँ और वह बजने योग्य पैटर्न बन जाएगी। सप्तक के बिंदु और खींचे गए स्वरों के डैश भी पहचाने जाते हैं।';

  @override
  String get tutorialHomeBasicsTitle => 'शब्द समझें';

  @override
  String get tutorialHomeBasicsBody =>
      'एक आख़िरी पड़ाव। “मूल बातें” ऐप में इस्तेमाल हर संगीत शब्द की सरल भाषा में शब्दावली है। चार सबसे ज़रूरी शब्द पढ़ते हैं।';

  @override
  String get tutorialBasicsBpmBody =>
      'BPM का मतलब है प्रति मिनट मात्राएँ, यानी 60 BPM पर हर सेकंड ठीक एक मात्रा। यही वह संख्या है जो आप अभ्यास पेज के गति स्लाइडर से तय करते हैं। नियम यह है कि आरामदायक लगने वाली गति से भी धीमे शुरू करें।';

  @override
  String get tutorialBasicsMeterBody =>
      'ऊपर का अंक बताता है कि हर ताल में कितनी मात्राएँ हैं, और पहली मात्रा पर हमेशा ज़ोर रहता है। इसे आप अभ्यास पेज के ताल बटन से चुनते हैं। ज़्यादातर संगीत के लिए 4/4 सुरक्षित विकल्प है।';

  @override
  String get tutorialBasicsSubdivisionBody =>
      'उपविभाजन हर मात्रा को छोटे बराबर क्लिक में बाँटता है: आठवाँ हर मात्रा पर 2 क्लिक देता है, सोलहवाँ 4। जब स्वर मुख्य मात्रा से तेज़ चलें तब इसे चालू करें।';

  @override
  String get tutorialBasicsNotationBody =>
      'एक ही स्वर के दो नाम-तंत्र हैं और ऐप दोनों स्वीकार करता है: पश्चिमी अक्षर (C D E F G A B) और पूर्वी सरगम (S R G M P D N)। पास के कार्ड सप्तक चिह्न, खींचे गए स्वर और समूह भी समझाते हैं।';

  @override
  String get tutorialHomeReturnTitle => 'मुख्य पेज पर वापस';

  @override
  String get tutorialHomeReturnBody =>
      'चारों टैब हो गए। अब खुद “अभ्यास” टैप करके मुख्य पेज पर लौटें, ताकि आपको हमेशा वापसी का रास्ता पता रहे।';

  @override
  String get tutorialStartSessionTitle => 'तैयार हों तो शुरू करें';

  @override
  String get tutorialStartSessionBody =>
      'अब “मेट्रोनोम शुरू करें” दबाएँ। इससे अभ्यास पेज खुलेगा, जहाँ मेट्रोनोम का व्यावहारिक ट्यूटोरियल जारी रहेगा।';

  @override
  String get tutorialHomeSettingsTitle => 'सेटिंग्स और दोबारा देखना';

  @override
  String get tutorialHomeSettingsBody =>
      'थीम, रंग और भाषा इस गियर के पीछे हैं। कभी कुछ भूल जाएँ तो सेटिंग्स खोलकर “ट्यूटोरियल फिर से देखें” दबाएँ। “हो गया” दबाएँ और हम “अभ्यास” पर लौटेंगे।';

  @override
  String get tutorialScoreTitle => 'लैंडस्केप में शीट संगीत';

  @override
  String get tutorialScoreBody =>
      'बड़े स्क्रीन पर लैंडस्केप मोड में यहाँ शीट संगीत की तस्वीर या PDF लोड करें और मेट्रोनोम को साथ रखकर अभ्यास करें। ज़ूम, पेज बदलना और फुल स्क्रीन सब कर सकते हैं।';

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
  String get subdivisionHalf => 'आधा';

  @override
  String get subdivisionQuarter => 'चौथाई';

  @override
  String get subdivisionEighth => 'आठवाँ';

  @override
  String get subdivisionSixteenth => 'सोलहवाँ';

  @override
  String get subdivisionDottedHalf => 'बिंदुयुक्त आधा';

  @override
  String get subdivisionDottedQuarter => 'बिंदुयुक्त चौथाई';

  @override
  String get subdivisionDottedEighth => 'बिंदुयुक्त आठवाँ';

  @override
  String get missingInstrument => 'नहीं मिला';

  @override
  String get scorePreview => 'शीट संगीत';

  @override
  String get addScore => 'Score जोड़ें';

  @override
  String get importScoreFromFiles => 'Files से चुनें';

  @override
  String get importScoreFromPhotos => 'Photos से चुनें';

  @override
  String get deleteScore => 'Score हटाएं';

  @override
  String get chooseScore => 'Score चुनें';

  @override
  String get scorePlaceholderTitle => 'कोई score नहीं जोड़ा गया';

  @override
  String get scorePlaceholderBody =>
      'यह जगह PDF या score image दिखाने के लिए है।';

  @override
  String tutorialStepCount(int current, int total) {
    return '$current / $total';
  }

  @override
  String tutorialTapTabAction(String tabName) {
    return 'नीचे की बार में “$tabName” टैप करें।';
  }

  @override
  String noteSequenceTooLong(int maxNotes) {
    return 'एक पैटर्न में $maxNotes या उससे कम नोट्स इस्तेमाल करें।';
  }

  @override
  String replaceSequenceQuestion(String name) {
    return '\"$name\" नाम का पैटर्न पहले से है। क्या इसे बदलना है?';
  }

  @override
  String savedSequenceSummary(int visibleCount, int totalCount) {
    return '$totalCount में से $visibleCount दिख रहे हैं';
  }

  @override
  String get quickEntry => 'त्वरित इनपुट';

  @override
  String get notes => 'नोट्स';

  @override
  String get modifiers => 'संशोधक';

  @override
  String get zoomOut => 'ज़ूम आउट';

  @override
  String get zoomIn => 'ज़ूम इन';

  @override
  String get previousPage => 'पिछला पृष्ठ';

  @override
  String get nextPage => 'अगला पृष्ठ';

  @override
  String get fullscreen => 'पूर्ण स्क्रीन';

  @override
  String get show => 'दिखाएँ';

  @override
  String get hide => 'छिपाएँ';

  @override
  String get exampleSequences => 'उदाहरण पैटर्न';

  @override
  String noPlayableAssets(String instrument) {
    return '$instrument के लिए कोई playable asset नहीं मिला';
  }

  @override
  String get instrumentPiano => 'पियानो A';

  @override
  String get instrumentUprightPiano => 'पियानो B';

  @override
  String get instrumentPipa => 'पीपा';

  @override
  String get instrumentRuan => 'रुआन';

  @override
  String get instrumentGuzheng => 'गुझेंग';

  @override
  String get instrumentErhu => 'एरहू';

  @override
  String get instrumentFlute => 'बाँसुरी';

  @override
  String get instrumentShamisen => 'शामिसेन';

  @override
  String get instrumentHarmonium => 'हारमोनियम';

  @override
  String get instrumentTabla => 'तबला';

  @override
  String get instrumentOud => 'ऊद';

  @override
  String get instrumentQanun => 'क़ानून';

  @override
  String get instrumentDuduk => 'दुदुक';

  @override
  String get instrumentNey => 'ने';

  @override
  String get instrumentTanbur => 'तंबूर';

  @override
  String get instrumentCelesta => 'सेलेस्टा';

  @override
  String get instrumentHarp => 'हार्प';

  @override
  String get instrumentClarinet => 'क्लैरिनेट';

  @override
  String get instrumentOboe => 'ओबो';

  @override
  String get instrumentTrumpet => 'ट्रम्पेट';

  @override
  String get instrumentFrenchHorn => 'फ़्रेंच हॉर्न';

  @override
  String get instrumentAcousticGuitar => 'ऐकोस्टिक गिटार';

  @override
  String get instrumentElectricGuitar => 'इलेक्ट्रिक गिटार';

  @override
  String get instrumentAcousticBass => 'ऐकोस्टिक बास';

  @override
  String get instrumentBianzhong => 'बियानझोंग';

  @override
  String get instrumentMarimba => 'मारिम्बा';

  @override
  String get regionWestern => 'पश्चिमी';

  @override
  String get regionEastAsian => 'पूर्वी एशियाई';

  @override
  String get regionMiddleEastern => 'मध्य पूर्वी';

  @override
  String get regionSouthAsian => 'दक्षिण एशियाई';

  @override
  String get regionOther => 'अन्य';

  @override
  String get clickSoundClassic => 'क्लासिक';

  @override
  String get clickSoundQuartz => 'क्वार्ट्ज़';

  @override
  String get clickSoundStick => 'स्टिक';

  @override
  String get clickSoundPracticePad => 'प्रैक्टिस पैड';

  @override
  String get clickSoundGlass => 'ग्लास';

  @override
  String get clickSoundMetal => 'मेटल';

  @override
  String get clickSoundSnap => 'चुटकी';

  @override
  String get clickSoundClap => 'ताली';

  @override
  String get clickSoundTambourine => 'डफ़';

  @override
  String get clickSoundCan => 'कैन';

  @override
  String get clickSoundClickToy => 'क्लिकर';

  @override
  String get clickSoundWoodBlock => 'वुड ब्लॉक';

  @override
  String get dailyGoal => 'दैनिक लक्ष्य';

  @override
  String get exampleMajorScaleName => 'मेजर स्केल आरोह-अवरोह';

  @override
  String get exampleMajorScaleDescription =>
      'एक सरल पश्चिमी स्केल, ऊपर जाकर नीचे आता है।';

  @override
  String get exampleChandrakaunName => 'चंद्रकौंस राग चक्र';

  @override
  String get exampleChandrakaunDescription =>
      'एक संक्षिप्त आरोह-अवरोह चक्र: सा, कोमल ग, म, कोमल ध, नि।';
}
