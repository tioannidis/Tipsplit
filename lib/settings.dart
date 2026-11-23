import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { system, english, german }

class Settings extends ChangeNotifier {
  AppLanguage _language = AppLanguage.system;
  double _defaultTipPercent = 15.0;

  static const _languageKey = 'language';
  static const _defaultTipKey = 'default_tip_percent';

  AppLanguage get language => _language;

  double get defaultTipPercent => _defaultTipPercent;

  Locale? get resolvedLocale {
    switch (_language) {
      case AppLanguage.system:
        return null;
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.german:
        return const Locale('de');
    }
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString(_languageKey);
      for (final value in AppLanguage.values) {
        if (value.name == lang) {
          _language = value;
        }
      }
      _defaultTipPercent =
          prefs.getDouble(_defaultTipKey) ?? _defaultTipPercent;
      notifyListeners();
    } catch (_) {
      // Fall back to in-memory defaults when preferences are unavailable.
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.name);
  }

  Future<void> setDefaultTipPercent(double percent) async {
    _defaultTipPercent = percent;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_defaultTipKey, percent);
  }
}
