import 'package:deligo_delivery/flavors.dart';
import 'package:deligo_delivery/localization/languages/english.dart';
import 'package:deligo_delivery/localization/languages/french.dart';
import 'package:deligo_delivery/localization/languages/german.dart';
import 'package:deligo_delivery/localization/languages/indonesian.dart';
import 'package:deligo_delivery/localization/languages/italian.dart';
import 'package:deligo_delivery/localization/languages/portuguese.dart';
import 'package:deligo_delivery/localization/languages/romanian.dart';
import 'package:deligo_delivery/localization/languages/spanish.dart';
import 'package:deligo_delivery/localization/languages/swahili.dart';
import 'package:deligo_delivery/localization/languages/turkish.dart';
import 'package:deligo_delivery/utility/constants.dart';

class AppConfig {
  static String appName = F.title;
  static String baseUrl = F.apiBase;
  static const String googleApiKey = "AIzaSyBNkC40LLMIkOY-myYT2Vmq12Z0lYBU-tw";
  static String onesignalAppId = "YourOnesignalAppId";
  static const String languageDefault = "en";
  static const String themeDefault = Constants.themeDark;
  static String demoNumber = "7676767676";
  static const bool isDemoMode = false;
  static const Map<String, double> mapCenterDefault = {
    "latitude": 28.6440836,
    "longitude": 77.0932313,
  };
  static final Map<String, AppLanguage> languagesSupported = {
    "en": AppLanguage("English", english()),
    //"ar": AppLanguage("عربى", arabic()),
    "de": AppLanguage("Deutsch", german()),
    "pt": AppLanguage("Portugal", portuguese()),
    "fr": AppLanguage("Français", french()),
    "id": AppLanguage("Bahasa Indonesia", indonesian()),
    "es": AppLanguage("Español", spanish()),
    "it": AppLanguage("italiano", italian()),
    "tr": AppLanguage("Türk", turkish()),
    "sw": AppLanguage("Kiswahili", swahili()),
    "ro": AppLanguage("română", romanian()),
  };
  static late FireConfig fireConfig;
}

class FireConfig {
  bool enableSocialAuthApple = false;
  bool enableSocialAuthGoogle = false;
  bool enableSocialAuthFacebook = false;

  bool get isSocialAuthEnabled =>
      enableSocialAuthApple ||
      enableSocialAuthGoogle ||
      enableSocialAuthFacebook;

  @override
  String toString() {
    return '(enableSocialAuthApple: $enableSocialAuthApple, enableSocialAuthGoogle: $enableSocialAuthGoogle, enableSocialAuthFacebook: $enableSocialAuthFacebook)';
  }
}

class AppLanguage {
  final String name;
  final Map<String, String> values;
  AppLanguage(this.name, this.values);
}
