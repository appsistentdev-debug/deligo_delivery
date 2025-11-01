import 'dart:convert';

import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/models/auth_response.dart';
import 'package:deligo_delivery/models/chat.dart';
import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/models/my_location.dart';
import 'package:deligo_delivery/models/profile_mode.dart';
import 'package:deligo_delivery/models/setting.dart';
import 'package:deligo_delivery/models/user_data.dart';
import 'package:deligo_delivery/utility/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';

class LocalDataLayer {
  LocalDataLayer._privateConstructor() {
    _initPref();
  }

  static final LocalDataLayer _instance = LocalDataLayer._privateConstructor();

  factory LocalDataLayer() {
    return _instance;
  }

  static const String tokenKey = "key_token";
  static const String userKey = "key_user";
  static const String settingsKey = "key_settings";
  static const String currentLanguageKey = "key_cur_lang";
  static const String currentThemeKey = "key_cur_theme";
  static const String lastLocationKey = "key_last_location";
  static const String lastAddressKey = "key_last_address";
  static const String demoLangPromtedKey = "key_demo_lang_promted";
  static const String driverProfileKey = "key_driver_profile";
  static const String providerRatingKey = "key_provider_rating";
  static const String bannersKey = "key_banners";
  static const String chatsLocalKey = "key_chats_local";
  static const String showBuyThisAppKey = "key_buy_this_app_shown";
  static const String profileModeKey = "key_profile_mode";
  static const String introShownKey = "key_is_intro_shown";

  SharedPreferences? _sharedPreferences;

  //holding frequently accessed sharedPreferences in memory.
  List<Setting>? _settingsAll;
  String? _authToken;
  UserData? _userMe;

  Future<void> _initPref() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<bool> initAppSettings() async {
    await _initPref();
    await getAuthenticationToken();
    await getUserMe();
    List<Setting> settingsAll = await getSettings();
    return AppSettings.setupWith(settingsAll);
  }

  Future<bool> clearPrefs() async {
    await _initPref();
    //_settingsAll = null;
    _authToken = null;
    _userMe = null;
    bool cleared = await _sharedPreferences!.clear(); //clearing everything
    saveSettings(_settingsAll); //except setting values
    return cleared;
  }

  Future<bool> clearPrefsUser() async {
    await _initPref();
    _authToken = null;
    _userMe = null;
    bool cleared = await _sharedPreferences!.remove(tokenKey);
    cleared = await _sharedPreferences!.remove(userKey);
    return cleared;
  }

  Future<bool> clearPrefKey(String key) async {
    await _initPref();
    return _sharedPreferences!.remove(key);
  }

  Future<void> saveAuthResponse(AuthResponse authResponse) async {
    await _initPref();
    _authToken = "Bearer ${authResponse.token}";
    _sharedPreferences!.setString(tokenKey, authResponse.token);
    setUserMe(authResponse.user);
  }

  Future<String?> getCurrentTheme() async {
    await _initPref();
    return _sharedPreferences!.getString(currentThemeKey);
  }

  Future<bool> setCurrentThemeDark() async {
    await _initPref();
    return _sharedPreferences!.setString(currentThemeKey, Constants.themeDark);
  }

  Future<bool> setCurrentThemeLight() async {
    await _initPref();
    return _sharedPreferences!.setString(currentThemeKey, Constants.themeLight);
  }

  Future<String> getCurrentLanguage() async {
    await _initPref();
    return _sharedPreferences!.containsKey(currentLanguageKey)
        ? _sharedPreferences!.getString(currentLanguageKey)!
        : AppConfig.languageDefault;
  }

  Future<bool> setCurrentLanguage(String langCode) async {
    await _initPref();
    return _sharedPreferences!.setString(currentLanguageKey, langCode);
  }

  Future<UserData?> getUserMe() async {
    if (_userMe == null) {
      await _initPref();
      _userMe = _sharedPreferences!.containsKey(userKey)
          ? UserData.fromJson(
              jsonDecode(_sharedPreferences!.getString(userKey)!))
          : null;
    }
    if (_userMe != null) _userMe!.setup();
    return _userMe;
  }

  Future<void> setUserMe(UserData userMe) async {
    _userMe = userMe;
    await _initPref();
    _sharedPreferences!.setString(userKey, jsonEncode(_userMe!.toJson()));
  }

  Future<DriverProfile?> getSavedDriverProfile() async {
    await _initPref();
    Map? savedMediaMap = _sharedPreferences!.containsKey(driverProfileKey)
        ? (json.decode(_sharedPreferences!.getString(driverProfileKey)!))
        : null;
    DriverProfile? toReturn = savedMediaMap != null
        ? DriverProfile.fromJson(savedMediaMap as Map<String, dynamic>)
        : null;
    if (toReturn != null) toReturn.setup();
    return toReturn;
  }

  Future<void> setSavedDriverProfile(DriverProfile driverProfile) async {
    await _initPref();
    _sharedPreferences!.setString(driverProfileKey, json.encode(driverProfile));
  }

  Future<MyLocation?> getSavedLocation() async {
    await _initPref();
    String? savedLocationString =
        _sharedPreferences!.getString(lastLocationKey);
    return savedLocationString != null
        ? MyLocation.fromJson(jsonDecode(savedLocationString))
        : null;
  }

  Future<void> setSavedLocation(MyLocation myLocation) async {
    await _initPref();
    _sharedPreferences!
        .setString(lastLocationKey, json.encode(myLocation.toJson()));
  }

  Future<ProfileMode?> getProfileMode() async {
    await _initPref();
    String? savedProfileModeString =
        _sharedPreferences!.getString(profileModeKey);
    return savedProfileModeString != null
        ? ProfileMode.fromJson(jsonDecode(savedProfileModeString))
        : null;
  }

  Future<void> setProfileMode(ProfileMode myLocation) async {
    await _initPref();
    _sharedPreferences!
        .setString(profileModeKey, json.encode(myLocation.toJson()));
  }

  Future<bool> saveSettings(List<Setting>? settings) async {
    if (settings != null) {
      _settingsAll = settings;
      await _initPref();
      _sharedPreferences!.setString(settingsKey, jsonEncode(settings));
      return AppSettings.setupWith(settings);
    } else {
      return false;
    }
  }

  Future<List<Setting>> getSettings() async {
    await _initPref();
    String? settingVal = _sharedPreferences!.getString(settingsKey);
    if (settingVal != null && settingVal.isNotEmpty) {
      try {
        return (jsonDecode(settingVal) as List)
            .map((e) => Setting.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print("getSettings(): $e");
        }
        return [];
      }
    } else {
      return [];
    }
  }

  Future<bool> getHasLanguageSelectionPromted() async {
    await _initPref();
    return !_sharedPreferences!.containsKey(demoLangPromtedKey);
  }

  Future<bool> setHasLanguageSelectionPromted() async {
    await _initPref();
    return _sharedPreferences!.setBool(demoLangPromtedKey, true);
  }

  String? getSettingValue(String forKey) {
    String? toReturn = "";
    if (_settingsAll != null) {
      for (Setting setting in _settingsAll!) {
        if (setting.key == forKey) {
          toReturn = setting.value;
          break;
        }
      }
    }
    if (toReturn!.isEmpty) {
      if (kDebugMode) {
        print(
            "getSettingValue returned empty value for: $forKey, when settings were: $_settingsAll");
      }
    }
    return toReturn;
  }

  Future<String?> getAuthenticationToken() async {
    await _initPref();
    if (_authToken == null && _sharedPreferences!.containsKey(tokenKey)) {
      _authToken = "Bearer ${_sharedPreferences!.getString(tokenKey)}";
    }
    return _authToken;
  }

  static void printConsoleWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    // ignore: avoid_print
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<bool> addIfChatUnread(Chat chat) async {
    await _initPref();
    List<Chat> chats = await getChatsLocal();
    int existingIndex = chats.indexOf(chat);
    if (existingIndex == -1) {
      chats.add(chat);
      await setChatsLocal(chats);
      return false;
    } else {
      if (chats[existingIndex].lastMessage != chat.lastMessage) {
        chats[existingIndex] = chat;
        await setChatsLocal(chats);
        return false;
      } else {
        return chats[existingIndex].isRead ?? false;
      }
    }
  }

  Future<void> setChatRead(Chat chat) async {
    await _initPref();
    List<Chat> chats = await getChatsLocal();
    int existingIndex = chats.indexOf(chat);
    chat.isRead = true;
    if (existingIndex != -1) {
      chats[existingIndex] = chat;
    } else {
      chats.add(chat);
    }
    await setChatsLocal(chats);
  }

  Future<int> getChatsUnreadCount() async {
    await _initPref();
    List<Chat> chats = await getChatsLocal();
    chats.removeWhere((element) => (element.isRead ?? false));
    return chats.length;
  }

  Future<List<Chat>> getChatsLocal() async {
    String? settingVal = _sharedPreferences!.getString(chatsLocalKey);
    if (settingVal != null && settingVal.isNotEmpty) {
      try {
        return (jsonDecode(settingVal) as List)
            .map((e) => Chat.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print("getChatsLocal(): $e");
        }
        return [];
      }
    } else {
      return [];
    }
  }

  Future<bool> setChatsLocal(List<Chat> chats) async {
    await _initPref();
    return _sharedPreferences!.setString(chatsLocalKey, jsonEncode(chats));
  }

  Future<bool> isBuyThisAppPrompted() async {
    await _initPref();
    return _sharedPreferences?.containsKey(showBuyThisAppKey) ?? false;
  }

  Future<bool?> setBuyThisAppPrompted() async {
    await _initPref();
    return _sharedPreferences?.setBool(showBuyThisAppKey, true);
  }

  Future<bool> getIsIntroShown() async {
    await _initPref();
    return _sharedPreferences!.containsKey(introShownKey);
  }

  Future<bool> setIsIntroShown() async {
    await _initPref();
    return _sharedPreferences!.setBool(introShownKey, true);
  }
}
