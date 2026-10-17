import 'dart:ui';

enum AppLanguage {
  en(Locale('en'), 'English'),
  ar(Locale('ar'), 'العربية');

  final Locale locale;
  final String displayName;

  const AppLanguage(this.locale, this.displayName);

  static AppLanguage fromLocale(Locale locale) {
    return locale.languageCode == 'ar' ? AppLanguage.ar : AppLanguage.en;
  }

  AppLanguage get nextLanguage =>
      this == AppLanguage.en ? AppLanguage.ar : AppLanguage.en;
}
