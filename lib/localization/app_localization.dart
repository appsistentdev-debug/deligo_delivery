import 'package:deligo_delivery/config/app_config.dart';
import 'package:flutter/material.dart';

class AppLocalization {
  static final AppLocalization _singleton = AppLocalization._internal();
  AppLocalization._internal();
  static AppLocalization get instance => _singleton;

  Locale _locale = const Locale("en");

  Future<AppLocalization> load(Locale lc) async {
    _locale = lc;
    return this;
  }

  String getLocalizationFor(String key) {
    return (AppConfig.languagesSupported[_locale.languageCode]!.values[key] ??
        (AppConfig.languagesSupported[AppConfig.languageDefault]!.values[key] ??
            key));
  }

  static List<Locale> getSupportedLocales() {
    List<Locale> toReturn = [];
    for (String langCode in AppConfig.languagesSupported.keys) {
      toReturn.add(Locale(langCode));
    }
    return toReturn;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppConfig.languagesSupported.keys.contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalization.
    return AppLocalization.instance.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

extension StateExtension on State {
  String getLocalizationFor(String key) {
    return AppLocalization.instance.getLocalizationFor(key);
  }
}

extension ContextExtension on BuildContext {
  String getLocalizationFor(String key) {
    return AppLocalization.instance.getLocalizationFor(key);
  }
}
