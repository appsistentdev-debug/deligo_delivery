// ignore: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/models/profile_mode.dart';
import 'package:deligo_delivery/models/setting.dart';
import 'package:deligo_delivery/models/user_data.dart';
import 'package:deligo_delivery/network/remote_repository.dart';
import 'package:deligo_delivery/utility/constants.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  late RemoteRepository _repository;

  AppCubit() : super(Uninitialized());

  void failed() {
    FlutterNativeSplash.remove();
    emit(FailureState("network_issue"));
  }

  Future<void> initApp() async {
    try {
      await Firebase.initializeApp();
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      if (AppConfig.onesignalAppId.isNotEmpty) {
        OneSignal.initialize(AppConfig.onesignalAppId);
        //await OneSignal.shared.promptUserForPushNotificationPermission();
        //_addOnesignalEvents();
      }
      _repository = RemoteRepository();
      bool initialised = await LocalDataLayer().initAppSettings();
      await _setupFireConfig();
      if (initialised) {
        await emitAuthenticationState();
        _setupSettings(initialised);
      } else {
        await _setupSettings(initialised);
      }
    } catch (e) {
      if (kDebugMode) {
        print("AppCubit.initApp: $e");
      }
      emit(FailureState("network_issue"));
    } finally {
      FlutterNativeSplash.remove();
    }
  }

  Future<void> _setupSettings(bool alreadyInitialized) async {
    try {
      List<Setting> settings = await _repository.fetchSettings();
      await LocalDataLayer().saveSettings(settings);
      if (!alreadyInitialized) await emitAuthenticationState();
    } catch (e) {
      if (kDebugMode) {
        print("getSettings: $e");
        print("something went wrong in emitAuthenticationState");
      }
      await LocalDataLayer().clearPrefKey(LocalDataLayer.settingsKey);
      emit(FailureState("network_issue"));
    }
  }

  Future<void> emitAuthenticationState() async {
    emit(Uninitialized());

    UserData? userData;
    try {
      //userData = await _authRepo.getUser();
      userData = await LocalDataLayer().getUserMe();
    } catch (e) {
      if (kDebugMode) {
        print("emitAuthenticationState: $e");
      }
    }

    bool isDemoShowLangs = false;
    if (AppConfig.isDemoMode) {
      isDemoShowLangs = await LocalDataLayer().getHasLanguageSelectionPromted();
      await LocalDataLayer().setHasLanguageSelectionPromted();
    }

    if (userData != null) {
      //await LocalDataLayer().setUserMe(userData);
      bool? profileSet = await _isProfileSetup();
      if (profileSet != null) {
        emit(Authenticated(isDemoShowLangs, profileSet));
        _setupUserLanguageAndOneSignalPlayerId();
      } else {
        await LocalDataLayer().clearPrefsUser();
        emit(Unauthenticated(isDemoShowLangs, true));
      }
    } else {
      await LocalDataLayer().clearPrefsUser();
      emit(Unauthenticated(isDemoShowLangs, false));
    }
  }

  Future<void> initAuthenticated() async {
    emit(Uninitialized());
    bool? profileSet = await _isProfileSetup();
    if (profileSet != null) {
      emit(Authenticated(false, profileSet));
      _setupUserLanguageAndOneSignalPlayerId();
    } else {
      await LocalDataLayer().clearPrefsUser();
      emit(Unauthenticated(false, null));
    }
  }

  Future<void> logOut() async {
    emit(Uninitialized());
    Future.delayed(const Duration(milliseconds: 500), () async {
      await _repository.logout();
      emit(Unauthenticated(false, false));
    });
  }

  Future<void> _setupUserLanguageAndOneSignalPlayerId() async {
    try {
      await OneSignal.Notifications.requestPermission(true);

      String currLang = await LocalDataLayer().getCurrentLanguage();
      UserData? updatedUserData = await _repository.updateUser({
        "notification":
            "{\"${Constants.roleDriver}\":\"${OneSignal.User.pushSubscription.id!}\"}",
        "language": currLang,
      });
      if (updatedUserData != null) {
        await LocalDataLayer().setUserMe(updatedUserData);
        await FirebaseDatabase.instance
            .ref()
            .child(Constants.refUsersFcmIds)
            .child(("${updatedUserData.id}${Constants.roleDriver}"))
            .set(OneSignal.User.pushSubscription.id!);
      }
    } catch (e) {
      if (kDebugMode) {
        print("userLanguageAndPlayerId: $e");
      }
    }
  }

  Future<void> _setupFireConfig() async {
    try {
      AppConfig.fireConfig = FireConfig();
      DatabaseReference configRef =
          FirebaseDatabase.instance.ref().child(Constants.refConfig);
      DatabaseEvent databaseEventFireConfig = await configRef.once();
      if (databaseEventFireConfig.snapshot.value != null &&
          databaseEventFireConfig.snapshot.value is Map) {
        AppConfig.fireConfig.enableSocialAuthGoogle = ((databaseEventFireConfig
                .snapshot.value as Map)["enableSocialAuthGoogle"] as bool?) ??
            false;
        AppConfig.fireConfig.enableSocialAuthApple = ((databaseEventFireConfig
                .snapshot.value as Map)["enableSocialAuthApple"] as bool?) ??
            false;
        AppConfig.fireConfig.enableSocialAuthFacebook =
            ((databaseEventFireConfig.snapshot.value
                    as Map)["enableSocialAuthFacebook"] as bool?) ??
                false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("setupFireConfig: $e");
      }
    }
    if (kDebugMode) {
      print("FireConfig: ${AppConfig.fireConfig}");
    }
  }

  Future<bool?> _isProfileSetup() async {
    try {
      ProfileMode? profileMode = await LocalDataLayer().getProfileMode();
      DriverProfile driverProfile = await _repository.getDriverProfile(null);
      DriverProfile? deliveryProfile;

      deliveryProfile = await _repository.getDeliveryProfile(null);

      profileMode ??= ProfileMode();
      profileMode.delivery_profile_id = deliveryProfile?.id;
      profileMode.driver_profile_id = driverProfile.id;

      await LocalDataLayer().setProfileMode(profileMode);

      return ((profileMode.riding_mode == "delivery" &&
              deliveryProfile?.meta != null) ||
          (profileMode.riding_mode == "riding" && driverProfile.meta != null));
    } catch (e) {
      if (kDebugMode) {
        print("isProfileSetup: $e");
      }
      return null;
    }
  }
}
