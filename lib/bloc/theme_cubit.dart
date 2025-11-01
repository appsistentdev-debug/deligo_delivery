import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/config/styles.dart';
import 'package:deligo_delivery/utility/constants.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  bool _isDark = AppConfig.themeDefault == Constants.themeDark;

  ThemeCubit()
      : super(AppConfig.themeDefault == Constants.themeDark
            ? AppTheme.darkTheme
            : AppTheme.appTheme);

  bool get isDark => _isDark;

  Future<void> getCurrentTheme() async {
    String? currTheme = await LocalDataLayer().getCurrentTheme();
    currTheme ??= AppConfig.themeDefault;
    setTheme(currTheme == Constants.themeDark);
  }

  Future<void> setTheme(bool isDark) async {
    if (isDark) {
      await LocalDataLayer().setCurrentThemeDark();
    } else {
      await LocalDataLayer().setCurrentThemeLight();
    }
    _isDark = isDark;
    emit(isDark ? AppTheme.darkTheme : AppTheme.appTheme);
  }
}
