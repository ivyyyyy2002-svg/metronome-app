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
  String get scorePlaceholderTitle => '还没有添加谱子';

  @override
  String get scorePlaceholderBody => '这里会用于显示 PDF 或谱子图片。';
}
