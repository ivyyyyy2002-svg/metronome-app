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
  String get noteInputHelper => '使用 A-G，也可以加入升号/降号，例如 C# 和 Bb。';

  @override
  String get applySequence => '应用音符模式';

  @override
  String get sequenceSavedNotice => '音符模式已保存。';

  @override
  String get sequenceExample => '示例：ABCDEFG, C#D#EF#G#';

  @override
  String get sequenceError => '请输入至少一个 A-G 的音符，也可以使用升号 (#) 和降号 (b)。';

  @override
  String get languageSavedNotice => '语言设置已保存';
}
