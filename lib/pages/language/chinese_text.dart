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
  String get homeTitle => '练习';

  @override
  String get appName => 'Metronome Studio';

  @override
  String get readyTitle => '你好，\n准备开始练习了吗？';

  @override
  String get readyDescription => '点击下面的按钮，使用你上次的设置开始新的节拍器练习。';

  @override
  String get startMetronome => '开始节拍器';

  @override
  String get practiceNotePattern => '练习音符模式';

  @override
  String get notePatternDescription => '选择节拍器按顺序播放的音符';

  @override
  String get notesToPlay => '要播放的音符';

  @override
  String get noteInputHelper => '使用 A-G、# 和 b，例如 C# 和 Bb。';

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
  String get sequenceError => '请输入至少一个 A-G 的音符，也可以使用升号 (#) 和降号 (b)。';

  @override
  String get languageSavedNotice => '语言设置已保存';

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
  String get sound => '音符声';

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
  String get beatUnit => '拍值';

  @override
  String get missingInstrument => '缺失';

  @override
  String noPlayableAssets(String instrument) => '找不到 $instrument 的可播放资源';
}
