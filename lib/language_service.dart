import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';

/// Loads and stores the player's language choice on the device.
class LanguageService {
  static const _storageKey = 'selected_game_language';

  Future<String> loadLanguage(String deviceLanguageCode) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_storageKey);

    if (saved != null &&
        supportedLanguages.any((language) => language.code == saved)) {
      return saved;
    }

    for (final language in supportedLanguages) {
      if (language.code == deviceLanguageCode) {
        return language.code;
      }
    }
    return 'en';
  }

  Future<void> saveLanguage(String languageCode) async {
    final isSupported = supportedLanguages
        .any((language) => language.code == languageCode);

    if (!isSupported) {
      throw ArgumentError.value(languageCode, 'languageCode', 'Unsupported language');
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, languageCode);
  }
}
