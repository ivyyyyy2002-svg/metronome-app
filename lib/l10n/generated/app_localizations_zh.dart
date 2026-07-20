// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settings => '设置';

  @override
  String get appearance => '外观';

  @override
  String get system => '跟随系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get themeColor => '主题颜色';

  @override
  String get defaultThemeColor => '默认';

  @override
  String get roseThemeColor => '玫瑰色';

  @override
  String get purpleThemeColor => '紫色';

  @override
  String get warmThemeColor => '黄色';

  @override
  String get tealThemeColor => '青绿色';

  @override
  String get language => '语言';

  @override
  String get english => '英文';

  @override
  String get chinese => '中文';

  @override
  String get french => '法语';

  @override
  String get hindi => '印地语';

  @override
  String get spanish => '西班牙语';

  @override
  String get homeTitle => '主页';

  @override
  String get appName => 'Metrinote';

  @override
  String get practiceTab => '练习';

  @override
  String get sequencesTab => '音符模式';

  @override
  String get toolsTab => '工具';

  @override
  String get basicsTab => '基础';

  @override
  String get readyTitle => '你好，\n准备开始练习了吗？';

  @override
  String get readyDescription => '点击下面的按钮，使用你上次的设置开始新的节拍器练习。';

  @override
  String get startMetronome => '开始节拍器';

  @override
  String get musicBasics => '音乐基础';

  @override
  String get practiceHistory => '练习记录';

  @override
  String get todayPractice => '今天';

  @override
  String get last7Days => '最近 7 天';

  @override
  String get lastSession => '上次练习';

  @override
  String get mostUsedBpm => '常用 BPM';

  @override
  String get favoriteInstrument => '最爱乐器';

  @override
  String get noPracticeYet => '还没有练习记录';

  @override
  String get basicsIntro => '节奏、拍号和记谱的简短参考。';

  @override
  String get bpmBasicsTitle => 'BPM';

  @override
  String get bpmBasicsBody => 'BPM 表示每分钟多少拍。练新节奏时可以先用慢速，稳定后再一点点加快。';

  @override
  String get timeSignatureBasicsTitle => '拍号';

  @override
  String get timeSignatureBasicsBody =>
      '上面的数字表示每小节有几拍。4/4 很常见，适合多数练习；3/4 通常会有圆舞曲一样的律动。';

  @override
  String get subdivisionBasicsTitle => '细分';

  @override
  String get subdivisionBasicsBody => '细分控制一拍如何被拆开。四分更简单稳定；八分、十六分会让节拍提示更密。';

  @override
  String get downbeatBasicsTitle => '强拍';

  @override
  String get downbeatBasicsBody => '强拍通常是一小节的第一拍。更明显的第一拍可以帮助你听出小节结构，而不是每一拍都一样。';

  @override
  String get jianpuBasicsTitle => '简谱';

  @override
  String get jianpuBasicsBody =>
      '简谱用数字表示音级，例如 1 2 3 5 6。它在中国乐器学习中很常见，选择调后可以对应到音名。';

  @override
  String get westernNotationBasicsTitle => '西方音名';

  @override
  String get westernNotationBasicsBody =>
      '西方音名使用 A-G。升号 (#) 表示升高半音，降号 (b) 表示降低半音。';

  @override
  String get easternNotationBasicsTitle => '东方音名';

  @override
  String get easternNotationBasicsBody =>
      '东方记谱使用 Sa Re Ga Ma Pa Dha Ni，也可以写成 S R G M P D N。在本应用中对应 C D E F G A B。';

  @override
  String get octaveNotationBasicsTitle => '八度';

  @override
  String get octaveNotationBasicsBody =>
      '使用 \' 表示高八度，使用逗号表示低八度。例如 C\' 比 C 高，C, 比 C 低。';

  @override
  String get groupedNotesBasicsTitle => '同拍音';

  @override
  String get groupedNotesBasicsBody =>
      '空格表示进入下一拍。没有空格的多个音会在同一拍内播放，例如 C D E FG 表示 F 和 G 都在第 4 拍。';

  @override
  String get heldNotesBasicsTitle => '延长音';

  @override
  String get heldNotesBasicsBody =>
      '短横线 (-) 表示把前一个音延长到下一拍。例如 C - D E 表示 C 会持续到第 2 拍。';

  @override
  String get scalePatternGenerator => '音阶模式生成器';

  @override
  String get scalePatternDescription => '快速生成音阶练习，并放入当前音符模式。';

  @override
  String get notation => '记谱';

  @override
  String get westernNotation => '西方';

  @override
  String get easternNotation => '东方';

  @override
  String get rootKey => '主音';

  @override
  String get scale => '音阶';

  @override
  String get direction => '方向';

  @override
  String get ascending => '上行';

  @override
  String get descending => '下行';

  @override
  String get upAndDown => '上下行';

  @override
  String get majorPentatonic => '大调五声音阶';

  @override
  String get minorPentatonic => '小调五声音阶';

  @override
  String get majorScale => '大调音阶';

  @override
  String get minorScale => '小调音阶';

  @override
  String get generatedPattern => '生成的音符模式';

  @override
  String get useAsSequence => '作为音符模式使用';

  @override
  String get patternAppliedNotice => '已放入音符模式编辑区。';

  @override
  String get jianpuConverter => '简谱转换器';

  @override
  String get jianpuConverterDescription => '选择调号后，把数字简谱转换成可以播放的音符模式。';

  @override
  String get jianpuInput => '简谱输入';

  @override
  String get convertedSequence => '转换结果';

  @override
  String get practiceNotePattern => '练习音符模式';

  @override
  String get notePatternDescription => '选择节拍器按顺序播放的音符';

  @override
  String get notesToPlay => '要播放的音符';

  @override
  String get noteInputHelper =>
      '可用 A-G 或 S R G M P D N。可用 \'、逗号、/ 和 - 表示八度、同拍音和延长音。';

  @override
  String get applySequence => '应用音符模式';

  @override
  String get deleteNote => '删除';

  @override
  String get clearNotes => '清空';

  @override
  String get sequenceSavedNotice => '音符模式已保存。';

  @override
  String get sequenceExample => '示例：ABCDEFG, C#D#EF#G#';

  @override
  String get sequenceError => '请输入至少一个有效的西方或东方音符。';

  @override
  String get metronomeTitle => '节拍器';

  @override
  String get advanced => '高级设置';

  @override
  String get advancedSettings => '高级设置';

  @override
  String get bpm => 'BPM';

  @override
  String get start => '开始';

  @override
  String get stop => '停止';

  @override
  String get reset => '重置';

  @override
  String get click => '节拍声';

  @override
  String get clickSound => '节拍音色';

  @override
  String get volumeBalance => '音量平衡';

  @override
  String get clickVolume => '节拍声音量';

  @override
  String get instrumentVolume => '乐器音量';

  @override
  String get sound => '音符声';

  @override
  String get preview => '试听';

  @override
  String get instrument => '乐器';

  @override
  String get tutorialNext => '下一步';

  @override
  String get tutorialSkip => '跳过全部';

  @override
  String get tutorialDone => '完成';

  @override
  String get tutorialReplay => '重看新手教程';

  @override
  String get tutorialTryIt => '试一试：';

  @override
  String get tutorialWellDone => '很好！';

  @override
  String get tutorialTempoTitle => '速度、拍子和摆锤';

  @override
  String get tutorialTempoBody =>
      '摆锤每摆一次是一拍。中间的大数字是速度，单位 BPM，也就是每分钟多少拍。上方的圆点表示你在小节中的位置，最亮的那个是重拍。';

  @override
  String get tutorialTempoExample => '60 BPM = 每秒 1 拍\n120 BPM = 每秒 2 拍（快一倍）';

  @override
  String get tutorialBpmDragTitle => '调整速度';

  @override
  String get tutorialBpmDragBody => '先选一个每个音都能弹准的速度，弹熟之后再往上加。滑块范围是 30 到 240。';

  @override
  String get tutorialBpmDragAction => '拖动速度滑块，调到任意数值。';

  @override
  String get tutorialSequenceTitle => '你的音符模式';

  @override
  String get tutorialSequenceBody =>
      '这个节拍器不只有滴答声，它可以按你的音符模式演奏旋律，每拍一个音，循环播放。这个面板显示当前加载的模式，点击即可修改音符。';

  @override
  String get tutorialToggleTitle => '节拍声和音符声';

  @override
  String get tutorialToggleBody =>
      '「节拍声」是经典的滴答声，用来稳住时间。「音符声」用所选乐器演奏你的音符模式。两个都开可以同时听到拍子和旋律，关掉一个可以单独练。';

  @override
  String get tutorialToggleAction => '关掉其中一个开关，再打开。';

  @override
  String get tutorialMeterTitle => '拍号和细分';

  @override
  String get tutorialMeterBody =>
      '拍号把拍子分成小节。4/4 就是数 1-2-3-4 再循环，第 1 拍是重拍。细分把每一拍再切成更小的滴答，音符比拍子快的时候用得上。';

  @override
  String get tutorialMeterExample =>
      '4/4 = 每小节 4 拍，最常见\n3/4 = 三拍一循环，圆舞曲节奏\n八分细分 = 每拍响 2 下';

  @override
  String get tutorialTransportTitle => '听一听';

  @override
  String get tutorialTransportBody =>
      '设置好了，点「开始」试试。先响的是重拍，然后音符落在每一拍上。「停止」暂停练习，「重置」回到模式开头。';

  @override
  String get tutorialTransportAction => '点击「开始」，听一两个小节。';

  @override
  String get tutorialAdvancedTitle => '高级设置';

  @override
  String get tutorialAdvancedBody =>
      '默认设置不够用时，在这里可以更换节拍音色、选择演奏音符的乐器、调整重音，或者整体升降八度。';

  @override
  String get tutorialHomePracticeTitle => '欢迎，练习从这里开始';

  @override
  String get tutorialHomePracticeBody =>
      'Metrinote 是一个能演奏音符的节拍器，拍子和旋律可以同时听到。点这个按钮进入练习页面，当前的音符模式会一起带过去。';

  @override
  String get tutorialHomeHistoryTitle => '练习记录';

  @override
  String get tutorialHomeHistoryBody =>
      '每次练习都会记录在这里：最近 7 天的练习时长、常用速度、常用乐器。设定每日目标后，进度环会显示完成情况。';

  @override
  String get tutorialHomeTabsTitle => '四个页面';

  @override
  String get tutorialHomeTabsBody =>
      '「练习」是主页面。「音符模式」用来创建和保存模式。「工具」可以自动生成模式。「基础」解释应用里用到的音乐名词。下面按顺序看一遍。';

  @override
  String get tutorialHomeExamplesTitle => '从示例开始';

  @override
  String get tutorialHomeExamplesBody =>
      '不知道练什么？这里有现成的模式，点一下就能加载，包括西方大调音阶和东方拉格循环。先加载一个，再改成自己的。';

  @override
  String get tutorialHomeSequencesTitle => '写自己的模式';

  @override
  String get tutorialHomeSequencesBody =>
      '在输入框里用空格分隔音名，或者直接点下方的音符按钮。西方音名（A B C…）和东方唱名（S R G M…）都支持。起个名字保存，之后随时可以加载。';

  @override
  String get tutorialHomeSequencesExample =>
      'C D E F → 四个音，每拍一个\nG - → 「-」把 G 延长一拍\nE/F → 「/」把两个音放进一拍\nC\' 高八度 · C, 低八度';

  @override
  String get tutorialHomeToolsTitle => '用工具自动生成';

  @override
  String get tutorialHomeToolsBody =>
      '「工具」页有两个生成器：音阶生成器和简谱转换器，都能直接写好模式。下面各看一下。';

  @override
  String get tutorialHomeScaleGenTitle => '音阶模式生成器';

  @override
  String get tutorialHomeScaleGenBody =>
      '选好主音、音阶类型、八度范围和方向，它会写出完整的模式。点「作为音符模式使用」就能放进模式编辑器。';

  @override
  String get tutorialHomeJianpuTitle => '简谱转换器';

  @override
  String get tutorialHomeJianpuBody =>
      '习惯看简谱（1 2 3 = do re mi）的话，把谱子粘贴进来就能变成可播放的模式。八度点和延音线「-」也能识别。';

  @override
  String get tutorialHomeBasicsTitle => '名词解释';

  @override
  String get tutorialHomeBasicsBody =>
      '最后一站。「基础」是一本小词典，用日常语言解释应用里的每个音乐名词。下面看最重要的四个。';

  @override
  String get tutorialBasicsBpmBody =>
      'BPM 是每分钟拍数，60 BPM 正好每秒一拍。这就是练习页速度滑块上的那个数字。原则是：起步速度比你觉得舒服的再慢一点。';

  @override
  String get tutorialBasicsMeterBody =>
      '拍号上面的数字表示每小节有几拍，第 1 拍永远是重拍。在练习页的拍号按钮里选择，大多数音乐用 4/4 就够了。';

  @override
  String get tutorialBasicsSubdivisionBody =>
      '细分把每一拍切成更小的等份：八分是每拍 2 响，十六分是每拍 4 响。音符比主拍快的时候打开它。';

  @override
  String get tutorialBasicsNotationBody =>
      '同一个音有两套记法，应用都支持：西方字母（C D E F G A B）和东方唱名（S R G M P D N）。旁边的卡片还讲了八度记号、延音和一拍多音。';

  @override
  String get tutorialHomeReturnTitle => '回到主页面';

  @override
  String get tutorialHomeReturnBody => '四个页面看完了。请自己点一下「练习」回到主页面，这样以后就知道怎么回来。';

  @override
  String get tutorialStartSessionTitle => '准备好就开始';

  @override
  String get tutorialStartSessionBody => '请点击「开始节拍器」。进入练习页面后，接着是节拍器的实际操作教程。';

  @override
  String get tutorialHomeSettingsTitle => '设置和重看教程';

  @override
  String get tutorialHomeSettingsBody =>
      '主题、颜色和语言都在这个齿轮里。以后忘了怎么用，打开设置点「重看新手教程」。点「完成」后回到「练习」页面。';

  @override
  String get tutorialScoreTitle => '横屏看谱练习';

  @override
  String get tutorialScoreBody =>
      '在大屏幕上横屏时，可以在这里加载谱子图片或 PDF，一边听节拍器一边看谱练习。支持缩放、翻页和全屏。';

  @override
  String get notesLoaded => '个音符已加载';

  @override
  String get noSequenceLoaded => '未加载音符模式';

  @override
  String get editNoteSequence => '编辑音符模式';

  @override
  String get savedSequences => '已保存的音符模式';

  @override
  String get sequenceName => '音符模式名称';

  @override
  String get searchSequences => '搜索音符模式';

  @override
  String get saveSequence => '保存';

  @override
  String get loadSequence => '加载';

  @override
  String get viewAll => '查看全部';

  @override
  String get quickEdit => '快速修改';

  @override
  String get importSequence => '导入音符模式';

  @override
  String get noSavedSequences => '没有已保存的音符模式';

  @override
  String get sequenceNameError => '保存前请输入名称。';

  @override
  String get alreadySavedNotice => '已经保存。';

  @override
  String get replace => '替换';

  @override
  String get cancel => '取消';

  @override
  String get apply => '应用';

  @override
  String get close => '关闭';

  @override
  String get done => '完成';

  @override
  String get timeSignature => '拍号';

  @override
  String get beatUnit => '细分';

  @override
  String get subdivisionHalf => '二分';

  @override
  String get subdivisionQuarter => '四分';

  @override
  String get subdivisionEighth => '八分';

  @override
  String get subdivisionSixteenth => '十六分';

  @override
  String get subdivisionDottedHalf => '附点二分';

  @override
  String get subdivisionDottedQuarter => '附点四分';

  @override
  String get subdivisionDottedEighth => '附点八分';

  @override
  String get missingInstrument => '缺失';

  @override
  String get scorePreview => '谱子';

  @override
  String get addScore => '添加谱子';

  @override
  String get importScoreFromFiles => '从文件选择';

  @override
  String get importScoreFromPhotos => '从相册选择';

  @override
  String get deleteScore => '删除谱子';

  @override
  String get chooseScore => '选择谱子';

  @override
  String get scorePlaceholderTitle => '还没有添加谱子';

  @override
  String get scorePlaceholderBody => '这里会用于显示 PDF 或谱子图片。';

  @override
  String tutorialStepCount(int current, int total) {
    return '$current / $total';
  }

  @override
  String tutorialTapTabAction(String tabName) {
    return '点击下方导航栏里的「$tabName」。';
  }

  @override
  String noteSequenceTooLong(int maxNotes) {
    return '每个音符模式最多可以输入 $maxNotes 个音符。';
  }

  @override
  String replaceSequenceQuestion(String name) {
    return '名为 \"$name\" 的音符模式已存在。要替换它吗？';
  }

  @override
  String savedSequenceSummary(int visibleCount, int totalCount) {
    return '显示 $totalCount 个中的 $visibleCount 个';
  }

  @override
  String get quickEntry => '快速输入';

  @override
  String get notes => '音符';

  @override
  String get modifiers => '修饰符';

  @override
  String get zoomOut => '缩小';

  @override
  String get zoomIn => '放大';

  @override
  String get previousPage => '上一页';

  @override
  String get nextPage => '下一页';

  @override
  String get fullscreen => '全屏';

  @override
  String get show => '显示';

  @override
  String get hide => '隐藏';

  @override
  String get exampleSequences => '示例音符模式';

  @override
  String noPlayableAssets(String instrument) {
    return '找不到 $instrument 的可播放资源';
  }

  @override
  String get instrumentPiano => '钢琴 A';

  @override
  String get instrumentUprightPiano => '钢琴 B';

  @override
  String get instrumentPipa => '琵琶';

  @override
  String get instrumentRuan => '阮';

  @override
  String get instrumentGuzheng => '古筝';

  @override
  String get instrumentErhu => '二胡';

  @override
  String get instrumentFlute => '竹笛';

  @override
  String get instrumentShamisen => '三味线';

  @override
  String get instrumentHarmonium => '簧风琴';

  @override
  String get instrumentTabla => '塔布拉鼓';

  @override
  String get instrumentOud => '乌德琴';

  @override
  String get instrumentQanun => '卡龙琴';

  @override
  String get instrumentDuduk => '都都克管';

  @override
  String get instrumentNey => '奈伊笛';

  @override
  String get instrumentTanbur => '坦布尔琴';

  @override
  String get instrumentCelesta => '钢片琴';

  @override
  String get instrumentHarp => '竖琴';

  @override
  String get instrumentClarinet => '单簧管';

  @override
  String get instrumentOboe => '双簧管';

  @override
  String get instrumentTrumpet => '小号';

  @override
  String get instrumentFrenchHorn => '圆号';

  @override
  String get instrumentAcousticGuitar => '木吉他';

  @override
  String get instrumentElectricGuitar => '电吉他';

  @override
  String get instrumentAcousticBass => '原声贝斯';

  @override
  String get instrumentBianzhong => '编钟';

  @override
  String get instrumentMarimba => '马林巴';

  @override
  String get regionWestern => '西方';

  @override
  String get regionEastAsian => '东亚';

  @override
  String get regionMiddleEastern => '中东';

  @override
  String get regionSouthAsian => '南亚';

  @override
  String get regionOther => '其他';

  @override
  String get clickSoundClassic => '经典';

  @override
  String get clickSoundQuartz => '石英';

  @override
  String get clickSoundStick => '鼓棒';

  @override
  String get clickSoundPracticePad => '练习垫';

  @override
  String get clickSoundGlass => '玻璃';

  @override
  String get clickSoundMetal => '金属';

  @override
  String get clickSoundSnap => '响指';

  @override
  String get clickSoundClap => '拍手';

  @override
  String get clickSoundTambourine => '铃鼓';

  @override
  String get clickSoundCan => '易拉罐';

  @override
  String get clickSoundClickToy => '响片';

  @override
  String get clickSoundWoodBlock => '木块';

  @override
  String get dailyGoal => '每日目标';

  @override
  String get exampleMajorScaleName => '大调音阶上下行';

  @override
  String get exampleMajorScaleDescription => '一条简单的西方音阶，先上行再下行。';

  @override
  String get exampleChandrakaunName => '钱德拉考恩斯拉格循环';

  @override
  String get exampleChandrakaunDescription => '简短的上下行循环：Sa、降 Ga、Ma、降 Dha、Ni。';
}
