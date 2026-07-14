import 'app_language_text.dart';

// Chinese language text implementation for the app
class ChineseText implements AppLanguageText {
  const ChineseText();

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
      '东方记谱使用 Sa Re Ga Ma Pa Dha Ni，也可以写成 S R G M P D N。在这个 app 中对应 C D E F G A B。';

  @override
  String get octaveNotationBasicsTitle => '八度';

  @override
  String get octaveNotationBasicsBody =>
      "使用 ' 表示高八度，使用逗号表示低八度。例如 C' 比 C 高，C, 比 C 低。";

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
      "可用 A-G 或 S R G M P D N。可用 '、逗号、/ 和 - 表示八度、同拍音和延长音。";

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
  String get tutorialReplay => '再看一遍新手教程';

  @override
  String tutorialStepCount(int current, int total) => '$current / $total';

  @override
  String get tutorialTryIt => '试一试：';

  @override
  String get tutorialWellDone => '做得好！';

  @override
  String tutorialTapTabAction(String tabName) => '点击下方导航栏里的「$tabName」。';

  @override
  String get tutorialTempoTitle => '速度、拍子和摆锤';

  @override
  String get tutorialTempoBody =>
      '摆锤每摆动一次就是一拍，大数字是速度（BPM，每分钟拍数），表示一分钟里有多少拍。上方一排圆点显示你在小节里的位置：最亮的第一个点就是重拍。';

  @override
  String get tutorialTempoExample => '60 BPM = 每秒 1 拍\n120 BPM = 每秒 2 拍（快一倍）';

  @override
  String get tutorialBpmDragTitle => '设置你自己的速度';

  @override
  String get tutorialBpmDragBody =>
      '慢练是练干净的秘诀：先选一个每个音都能弹对的速度，弹轻松了再一点点加快。滑块范围从 30（很慢）到 240（很快）。';

  @override
  String get tutorialBpmDragAction => '拖动速度滑块，改成任意一个数值。';

  @override
  String get tutorialSequenceTitle => '你的音符模式';

  @override
  String get tutorialSequenceBody =>
      '这个节拍器不只会打拍子——它还能按你的音符模式演奏旋律，每拍一个音、循环播放，让你跟着一起练。这个面板显示当前加载的模式，随时点击就能直接修改音符。';

  @override
  String get tutorialToggleTitle => '节拍声、音符声，或者都要';

  @override
  String get tutorialToggleBody =>
      '「节拍声」是经典的滴答声，负责稳住时间；「音符声」用所选乐器演奏你的音符模式。两个都开，就能听到旋律叠在拍子上；想专注某一个就关掉另一个。';

  @override
  String get tutorialToggleAction => '把其中一个开关关掉，再打开。';

  @override
  String get tutorialMeterTitle => '拍号和细分';

  @override
  String get tutorialMeterBody =>
      '拍号把拍子分组成小节：4/4 就是数 1-2-3-4 再重来，第 1 拍是重拍。细分单位把每一拍再切成更小的滴答，音符比拍子快的时候特别有用。';

  @override
  String get tutorialMeterExample =>
      '4/4 = 每小节 4 拍（最常见）\n3/4 = 三拍一循环，像圆舞曲\n八分音符细分 = 每拍响 2 下';

  @override
  String get tutorialTransportTitle => '实际听一听';

  @override
  String get tutorialTransportBody =>
      '一切就绪——点开始听听看：先是重拍，然后你的音符会落在每一拍上。「停止」暂停练习，「重置」回到模式的开头。';

  @override
  String get tutorialTransportAction => '点击开始，听一两个小节。';

  @override
  String get tutorialAdvancedTitle => '高级设置';

  @override
  String get tutorialAdvancedBody =>
      '觉得默认设置不够用时，从这里可以更换节拍音色、选择演奏音符的乐器、调整重音，还能整体升降八度。';

  @override
  String get tutorialHomePracticeTitle => '欢迎！练习从这里开始';

  @override
  String get tutorialHomePracticeBody =>
      'Metrinote 是一个会「唱谱」的节拍器：除了打拍子，还能演奏你想练的音符，让你同时听到拍子和旋律。点这个按钮进入练习页，你当前的音符模式会自动带过去。';

  @override
  String get tutorialHomeHistoryTitle => '你的练习记录';

  @override
  String get tutorialHomeHistoryBody =>
      '每次练习都会记录在这里：最近 7 天的练习时长、最常用的速度、最喜欢的乐器。设一个每日目标，进度环会帮你坚持下去。';

  @override
  String get tutorialHomeTabsTitle => '四个页面，一条流程';

  @override
  String get tutorialHomeTabsBody =>
      'Practice 是主页；Sequences 用来创建和保存音符模式；Tools 帮你自动生成模式；Basics 解释 app 里用到的音乐名词。我们按顺序逛一遍。';

  @override
  String get tutorialHomeExamplesTitle => '从示例开始';

  @override
  String get tutorialHomeExamplesBody =>
      '不知道练什么？这里有现成的模式，一键加载——西方大调音阶，或东方拉格循环。先加载一个，再改成你自己的。';

  @override
  String get tutorialHomeSequencesTitle => '写你自己的模式';

  @override
  String get tutorialHomeSequencesBody =>
      '在输入框里用空格分隔音名，或直接点下方的音符按钮。西方音名（A B C…）和东方唱名（S R G M…）都支持。起个名字保存，以后随时能用。';

  @override
  String get tutorialHomeSequencesExample =>
      "C D E F → 四个音，每拍一个\nG - → 「-」让 G 多延长一拍\nE/F → 「/」把两个音挤进一拍\nC' 高八度 · C, 低八度";

  @override
  String get tutorialHomeToolsTitle => '让工具替你动手';

  @override
  String get tutorialHomeToolsBody =>
      'Tools 页有两个自动生成器：音阶生成器和简谱转换器，都能直接帮你写好模式。我们去看看。';

  @override
  String get tutorialHomeScaleGenTitle => '音阶模式生成器';

  @override
  String get tutorialHomeScaleGenBody =>
      '选好主音、音阶类型、八度范围和方向，它会自动写出完整模式。点「Use Pattern」就能直接放进你的模式编辑器。';

  @override
  String get tutorialHomeJianpuTitle => '简谱转换器';

  @override
  String get tutorialHomeJianpuBody =>
      '习惯看简谱（1 2 3 = do re mi）的话，把谱子粘贴到这里就能变成可播放的模式。八度点和延音线「-」也都能识别。';

  @override
  String get tutorialHomeBasicsTitle => '认识这些名词';

  @override
  String get tutorialHomeBasicsBody =>
      '最后一站：Basics 是一本小词典，用大白话解释 app 里的每个音乐名词。我们一起读最重要的四个。';

  @override
  String get tutorialBasicsBpmBody =>
      'BPM 就是每分钟拍数：60 BPM 正好每秒一拍。它就是练习页大滑块上调的那个数字。黄金法则：起步速度要比你觉得舒服的再慢一点。';

  @override
  String get tutorialBasicsMeterBody =>
      '拍号上面的数字表示每小节有几拍，每小节第 1 拍永远是重拍。练习页的拍号按钮就是选这个的——大多数音乐用 4/4 就很稳。';

  @override
  String get tutorialBasicsSubdivisionBody =>
      '细分是把每一拍再切成更小的等分：八分音符 = 每拍 2 响，十六分音符 = 每拍 4 响。当音符比拍子跑得快时就用它。';

  @override
  String get tutorialBasicsNotationBody =>
      '同样的音有两套记法，app 都认：西方字母（C D E F G A B）和东方唱名（S R G M P D N）。旁边几张卡片还讲了八度记号、延音和一拍多音。';

  @override
  String get tutorialHomeReturnTitle => '回到主页';

  @override
  String get tutorialHomeReturnBody =>
      '四个页面逛完了。回到 Practice——在打开节拍器实际操作之前，还有最后一样东西要给你看。';

  @override
  String get tutorialHomeSettingsTitle => '设置和重看教程';

  @override
  String get tutorialHomeSettingsBody =>
      '主题、颜色和语言都在这个齿轮里。以后忘了怎么用，打开设置点「再看一遍新手教程」就行。点「完成」，我们去节拍器页面动手试试。';

  @override
  String get tutorialScoreTitle => 'iPad 横屏乐谱练习';

  @override
  String get tutorialScoreBody =>
      '在较大屏幕横屏时，可以在这里加载乐谱图片或 PDF，节拍器就在旁边一边响一边看谱练。支持缩放、翻页和全屏。';

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
  String noteSequenceTooLong(int maxNotes) => '每个音符模式最多可以输入 $maxNotes 个音符。';

  @override
  String replaceSequenceQuestion(String name) => '名为 "$name" 的音符模式已存在。要替换它吗？';

  @override
  String savedSequenceSummary(int visibleCount, int totalCount) =>
      '显示 $totalCount 个中的 $visibleCount 个';

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
  String noPlayableAssets(String instrument) => '找不到 $instrument 的可播放资源';

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
}
