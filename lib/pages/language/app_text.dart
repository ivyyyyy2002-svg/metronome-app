import 'package:flutter/widgets.dart';
import 'package:metronome_app/l10n/generated/app_localizations.dart';
import 'package:metronome_app/l10n/generated/app_localizations_en.dart';
import 'package:metronome_app/l10n/generated/app_localizations_es.dart';
import 'package:metronome_app/l10n/generated/app_localizations_fr.dart';
import 'package:metronome_app/l10n/generated/app_localizations_hi.dart';
import 'package:metronome_app/l10n/generated/app_localizations_zh.dart';

import '../app_settings_controller.dart';

// Factory function to get the appropriate language text based
// on the current app language setting
AppLocalizations appTextFor(AppLanguage language) {
  if (language == AppLanguage.chinese) {
    return AppLocalizationsZh();
  }

  if (language == AppLanguage.english) {
    return AppLocalizationsEn();
  }

  if (language == AppLanguage.french) {
    return AppLocalizationsFr();
  }

  if (language == AppLanguage.hindi) {
    return AppLocalizationsHi();
  }

  if (language == AppLanguage.spanish) {
    return AppLocalizationsEs();
  }

  final systemLanguage =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  if (systemLanguage == 'zh') return AppLocalizationsZh();
  if (systemLanguage == 'fr') return AppLocalizationsFr();
  if (systemLanguage == 'hi') return AppLocalizationsHi();
  if (systemLanguage == 'es') return AppLocalizationsEs();
  return AppLocalizationsEn();
}
