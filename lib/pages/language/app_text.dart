import 'package:flutter/widgets.dart';

import '../app_settings_controller.dart';
import 'app_language_text.dart';
import 'chinese_text.dart';
import 'english_text.dart';
import 'french_text.dart';
import 'hindi_text.dart';

// Factory function to get the appropriate language text based
// on the current app language setting
AppLanguageText appTextFor(AppLanguage language) {
  if (language == AppLanguage.chinese) {
    return const ChineseText();
  }

  if (language == AppLanguage.english) {
    return const EnglishText();
  }

  if (language == AppLanguage.french) {
    return const FrenchText();
  }

  if (language == AppLanguage.hindi) {
    return const HindiText();
  }

  // Fallback to system locale if no specific language is set
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  if (locale.languageCode == 'zh') {
    return const ChineseText();
  }
  if (locale.languageCode == 'fr') {
    return const FrenchText();
  }
  if (locale.languageCode == 'hi') {
    return const HindiText();
  }

  return const EnglishText();
}
