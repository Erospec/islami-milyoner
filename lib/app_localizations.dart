import 'package:flutter/widgets.dart';

/// Language catalogue for İslamiyet Milyoneri.
/// Keep this separate from the question bank so new languages do not
/// require changes to the quiz engine.
class GameLanguage {
  final String code;
  final String nativeName;
  final bool isRtl;

  const GameLanguage(this.code, this.nativeName, {this.isRtl = false});
}

const supportedLanguages = <GameLanguage>[
  GameLanguage('tr', 'Türkçe'),
  GameLanguage('en', 'English'),
  GameLanguage('ar', 'العربية', isRtl: true),
  GameLanguage('fr', 'Français'),
  GameLanguage('de', 'Deutsch'),
  GameLanguage('es', 'Español'),
  GameLanguage('pt', 'Português'),
  GameLanguage('id', 'Bahasa Indonesia'),
  GameLanguage('ms', 'Bahasa Melayu'),
  GameLanguage('ur', 'اردو', isRtl: true),
  GameLanguage('fa', 'فارسی', isRtl: true),
  GameLanguage('bn', 'বাংলা'),
  GameLanguage('hi', 'हिन्दी'),
  GameLanguage('ru', 'Русский'),
  GameLanguage('zh', '简体中文'),
  GameLanguage('zh_TW', '繁體中文'),
  GameLanguage('ja', '日本語'),
  GameLanguage('ko', '한국어'),
  GameLanguage('nl', 'Nederlands'),
  GameLanguage('it', 'Italiano'),
  GameLanguage('sw', 'Kiswahili'),
  GameLanguage('ha', 'Hausa'),
];

const Map<String, Map<String, String>> _strings = {
  'tr': {
    'fifty_used': 'İki yanlış seçenek kaldırıldı.',
    'audience_result': 'Seyirci tahmini:',
    'hint': 'İpucu',
    'removed_option': '50:50 ile elendi',
    'time_up': 'Süre doldu! Cevap veremedin.',
    'excellent': 'TEBRİKLER!',
    'game_over': 'OYUN BİTTİ',
    'guaranteed_level': 'Garanti kazanç',
    'top_prize': 'Tebrikler! Büyük ödüle ulaştın.',
    'title': 'İSLAMİYET MİLYONERİ',
    'question': 'SORU',
    'lifelines': 'JOKERLER',
    'ladder': 'ÖDÜL MERDİVENİ',
    'fifty': '50:50',
    'audience': 'Seyirci',
    'expert': 'Bilge',
    'play_again': 'YENİDEN OYNA',
    'correct': 'Doğru cevap!',
    'wrong': 'Yanlış cevap.',
    'language': 'Dil',
    'settings': 'Ayarlar',
    'disclaimer': 'Bilgi yarışmasıdır; gerçek para ödülü verilmez.',
  },
  'en': {
    'fifty_used': 'Two incorrect options have been removed.',
    'audience_result': 'Audience estimate:',
    'hint': 'Hint',
    'removed_option': 'Removed by 50:50',
    'time_up': 'Time is up! You did not answer in time.',
    'excellent': 'CONGRATULATIONS!',
    'game_over': 'GAME OVER',
    'guaranteed_level': 'Guaranteed prize',
    'top_prize': 'Congratulations! You reached the top prize.',
    'title': 'ISLAMIC MILLIONAIRE',
    'question': 'QUESTION',
    'lifelines': 'LIFELINES',
    'ladder': 'PRIZE LADDER',
    'fifty': '50:50',
    'audience': 'Audience',
    'expert': 'Scholar',
    'play_again': 'PLAY AGAIN',
    'correct': 'Correct answer!',
    'wrong': 'Incorrect answer.',
    'language': 'Language',
    'settings': 'Settings',
    'disclaimer': 'Quiz game only; no real cash prizes are awarded.',
  },
  'ar': {
    'fifty_used': 'تم حذف إجابتين خاطئتين.',
    'audience_result': 'تقدير الجمهور:',
    'hint': 'تلميح',
    'removed_option': 'حُذف باستخدام ٥٠:٥٠',
    'time_up': 'انتهى الوقت! لم تجب في الوقت المحدد.',
    'excellent': 'تهانينا!',
    'game_over': 'انتهت اللعبة',
    'guaranteed_level': 'الجائزة المضمونة',
    'top_prize': 'تهانينا! لقد وصلت إلى الجائزة الكبرى.',
    'title': 'مليونير الإسلام',
    'question': 'السؤال',
    'lifelines': 'وسائل المساعدة',
    'ladder': 'سُلّم الجوائز',
    'fifty': '٥٠:٥٠',
    'audience': 'الجمهور',
    'expert': 'العالِم',
    'play_again': 'العب مجدداً',
    'correct': 'إجابة صحيحة!',
    'wrong': 'إجابة غير صحيحة.',
    'language': 'اللغة',
    'settings': 'الإعدادات',
    'disclaimer': 'لعبة معلومات فقط؛ لا تُمنح جوائز نقدية حقيقية.',
  },
  'fr': {
    'fifty_used': 'Deux mauvaises réponses ont été supprimées.',
    'audience_result': 'Estimation du public :',
    'hint': 'Indice',
    'removed_option': 'Éliminée par le 50:50',
    'time_up': 'Temps écoulé ! Vous n’avez pas répondu à temps.',
    'excellent': 'FÉLICITATIONS !',
    'game_over': 'FIN DE LA PARTIE',
    'guaranteed_level': 'Gain garanti',
    'top_prize': 'Félicitations ! Vous avez atteint le premier prix.',
    'title': 'ISLAM MILLIONNAIRE',
    'question': 'QUESTION',
    'lifelines': 'JOKERS',
    'ladder': 'ÉCHELLE DES PRIX',
    'fifty': '50:50',
    'audience': 'Public',
    'expert': 'Érudit',
    'play_again': 'REJOUER',
    'correct': 'Bonne réponse !',
    'wrong': 'Mauvaise réponse.',
    'language': 'Langue',
    'settings': 'Paramètres',
    'disclaimer': 'Jeu-questionnaire ; aucun prix en argent réel.',
  },
  'de': {
    'fifty_used': 'Zwei falsche Antworten wurden entfernt.',
    'audience_result': 'Publikumsschätzung:',
    'hint': 'Hinweis',
    'removed_option': 'Durch 50:50 entfernt',
    'time_up': 'Die Zeit ist abgelaufen! Du hast nicht rechtzeitig geantwortet.',
    'excellent': 'GLÜCKWUNSCH!',
    'game_over': 'SPIEL BEENDET',
    'guaranteed_level': 'Garantierter Gewinn',
    'top_prize': 'Glückwunsch! Du hast den Hauptgewinn erreicht.',
    'title': 'ISLAM-MILLIONÄR',
    'question': 'FRAGE',
    'lifelines': 'JOKER',
    'ladder': 'GEWINNLEITER',
    'fifty': '50:50',
    'audience': 'Publikum',
    'expert': 'Gelehrter',
    'play_again': 'NOCHMAL SPIELEN',
    'correct': 'Richtige Antwort!',
    'wrong': 'Falsche Antwort.',
    'language': 'Sprache',
    'settings': 'Einstellungen',
    'disclaimer': 'Quizspiel; es werden keine echten Geldpreise vergeben.',
  },
};

bool isRtlLanguage(String code) =>
    supportedLanguages.any((language) => language.code == code && language.isRtl);

/// Unreviewed language packs fall back to English until their translations
/// have been checked and included.
String gameText(String languageCode, String key) =>
    _strings[languageCode]?[key] ?? _strings['en']?[key] ?? key;

/// Detect the game language from the device locale.
String languageFromLocale(Locale locale) {
  if (locale.languageCode == 'zh' && locale.countryCode == 'TW') {
    return 'zh_TW';
  }
  final code = locale.languageCode;
  return supportedLanguages.any((language) => language.code == code)
      ? code
      : 'en';
}
