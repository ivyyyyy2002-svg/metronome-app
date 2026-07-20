import '../language/app_language_text.dart';

/// Localized display names for instrument keys, used by the instrument picker
/// and the practice-history "favorite instrument" stat.
///
/// Keys must match the identifiers used by the SF2 controller and the
/// instrument region lists in the advanced settings drawer.
String instrumentDisplayName(AppLanguageText text, String instrument) {
  switch (instrument) {
    case 'piano':
      return text.instrumentPiano;
    case 'uprightPiano':
      return text.instrumentUprightPiano;
    case 'pipa':
      return text.instrumentPipa;
    case 'ruan':
      return text.instrumentRuan;
    case 'guzheng':
      return text.instrumentGuzheng;
    case 'erhu':
      return text.instrumentErhu;
    case 'flute':
      return text.instrumentFlute;
    case 'shamisen':
      return text.instrumentShamisen;
    case 'harmonium':
      return text.instrumentHarmonium;
    case 'tabla':
      return text.instrumentTabla;
    case 'oud':
      return text.instrumentOud;
    case 'qanun':
      return text.instrumentQanun;
    case 'duduk':
      return text.instrumentDuduk;
    case 'ney':
      return text.instrumentNey;
    case 'tanbur':
      return text.instrumentTanbur;
    case 'celesta':
      return text.instrumentCelesta;
    case 'harp':
      return text.instrumentHarp;
    case 'clarinet':
      return text.instrumentClarinet;
    case 'oboe':
      return text.instrumentOboe;
    case 'trumpet':
      return text.instrumentTrumpet;
    case 'frenchHorn':
      return text.instrumentFrenchHorn;
    case 'acousticGuitar':
      return text.instrumentAcousticGuitar;
    case 'electricGuitar':
      return text.instrumentElectricGuitar;
    case 'acousticBass':
      return text.instrumentAcousticBass;
    case 'bianzhong':
      return text.instrumentBianzhong;
    case 'marimba':
      return text.instrumentMarimba;
  }
  if (instrument.isEmpty) return instrument;
  return '${instrument[0].toUpperCase()}${instrument.substring(1)}';
}
