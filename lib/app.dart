// ignore_for_file: type_literal_in_constant_pattern

import 'package:buy_this_app/buy_this_app.dart';
import 'package:deligo_delivery/config/styles.dart';
import 'package:deligo_delivery/config/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/app_cubit.dart';
import 'bloc/connectivity_cubit.dart';
import 'bloc/language_cubit.dart';
import 'bloc/theme_cubit.dart';
import 'config/page_routes.dart';
import 'localization/app_localization.dart';
import 'pages/auth_sign_in_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/secondary_splash_page.dart';
import 'pages/select_language_page.dart';
import 'widgets/error_final_widget.dart';
import 'widgets/toaster.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    _initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) => MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            BuyThisApp.delegate,
          ],
          supportedLocales: AppLocalization.getSupportedLocales(),
          locale: locale,
          theme: AppTheme.appTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routes: PageRoutes().routes(),
          home: BlocConsumer<AppCubit, AppState>(
            listener: (context, appState) {
              if (appState is Unauthenticated &&
                  appState.wasLoggedOut == true) {
                Toaster.showToastCenter(
                    AppLocalization.instance.getLocalizationFor("loggedout"));
              }
              if (appState is Unauthenticated &&
                  appState.wasLoggedOut == null) {
                Toaster.showToastCenter(AppLocalization.instance
                    .getLocalizationFor("something_wrong"));
              }
              if (appState is Authenticated && appState.profileSet == false) {
                Toaster.showToastCenter(AppLocalization.instance
                    .getLocalizationFor("setup_profile"));
              }
            },
            builder: (context, appState) {
              switch (appState.runtimeType) {
                case Authenticated:
                  return (appState as Authenticated).isDemoShowLangs
                      ? const SelectLanguagePage(fromRoot: true)
                      : (appState.profileSet
                          ? const HomePage()
                          : const ProfilePage(fromRoot: true));
                case Unauthenticated:
                  return (appState as Unauthenticated).isDemoShowLangs
                      ? const SelectLanguagePage(fromRoot: true)
                      : const AuthSignInPage();
                case FailureState:
                  return BlocListener<ConnectivityCubit, ConnectivityState>(
                    listener: (context, state) {
                      if (state.isConnected) {
                        _initializeApp();
                      }
                    },
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: ErrorFinalWidget.errorWithRetry(
                        context: context,
                        message: AppLocalization.instance
                            .getLocalizationFor("network_issue"),
                        imageAsset: Assets.emptyOrders,
                        actionText:
                            AppLocalization.instance.getLocalizationFor("okay"),
                        action: () => SystemNavigator.pop(),
                      ),
                    ),
                  );
                default:
                  return const SecondarySplashPage();
              }
            },
          ),
        ),
      );

  void _initializeApp() async {
    ConnectivityCubit cc = BlocProvider.of<ConnectivityCubit>(context);
    cc.monitorInternet();
    bool ic = await cc.checkConnectivity();
    if (mounted) {
      if (ic) {
        BlocProvider.of<AppCubit>(context).initApp();
        BlocProvider.of<ThemeCubit>(context).getCurrentTheme();
        BlocProvider.of<LanguageCubit>(context).getCurrentLanguage();
      } else {
        BlocProvider.of<AppCubit>(context).failed();
      }
    }
  }
}
