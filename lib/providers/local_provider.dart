import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('fr', 'FR');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  void toggleLocale() {
    if (_locale.languageCode == 'fr') {
      setLocale(const Locale('en', 'US'));
    } else {
      setLocale(const Locale('fr', 'FR'));
    }
  }

  String get languageCode => _locale.languageCode.toUpperCase();

  bool get isFrench => _locale.languageCode == 'fr';
  bool get isEnglish => _locale.languageCode == 'en';
}