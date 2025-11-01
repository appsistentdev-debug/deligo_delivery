// ignore_for_file: use_build_context_synchronously

import 'package:buy_this_app/buy_this_app.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:deligo_delivery/bloc/app_cubit.dart';
import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/config/assets.dart';
import 'package:deligo_delivery/config/page_routes.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/models/wallet.dart';
import 'package:deligo_delivery/network/remote_repository.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';

import 'cached_image.dart';
import 'confirm_dialog.dart';

class DrawerWidget extends StatelessWidget {
  final bool fromHome;

  const DrawerWidget({super.key, this.fromHome = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (AppConfig.isDemoMode)
                      BuyThisApp.button(
                        AppConfig.appName,
                        'https://dashboard.vtlabs.dev/projects/envato-referral-buy-link?project_slug=cab_book_flutter',
                        target: Target.WhatsApp,
                        color: const Color(0xffF80048),
                        height: 40,
                      ),
                    if (AppConfig.isDemoMode) const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10),
                const UserMeGlance(),
                const SizedBox(height: 20),
                const WalletMeGlance(),
                Divider(
                  height: 6,
                  thickness: 6,
                  color: theme.colorScheme.surface,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildAccountOption(
                        theme,
                        Icons.home,
                        AppLocalization.instance.getLocalizationFor("home"),
                        onTap: () {
                          if (fromHome) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, PageRoutes.homePage);
                          }
                        },
                      ),
                      buildAccountOption(
                        theme,
                        Icons.insert_chart,
                        AppLocalization.instance.getLocalizationFor("insights"),
                        onTap: () {
                          Navigator.pop(context);
                          navigate(context, PageRoutes.insightPage);
                        },
                      ),
                      buildAccountOption(
                        theme,
                        Icons.assignment,
                        AppLocalization.instance.getLocalizationFor("tnc"),
                        onTap: () {
                          Navigator.pop(context);
                          navigate(context, PageRoutes.tncPage);
                        },
                      ),
                      buildAccountOption(
                        theme,
                        Icons.mail,
                        AppLocalization.instance.getLocalizationFor("support"),
                        onTap: () {
                          Navigator.pop(context);
                          navigate(context, PageRoutes.supportPage);
                        },
                      ),
                      buildAccountOption(
                        theme,
                        Icons.question_answer,
                        AppLocalization.instance.getLocalizationFor("faqs"),
                        onTap: () {
                          Navigator.pop(context);
                          navigate(context, PageRoutes.faqPage);
                        },
                      ),

                      buildAccountOption(
                        theme,
                        Icons.language,
                        AppLocalization.instance
                            .getLocalizationFor("changeLanguage"),
                        onTap: () {
                          Navigator.pop(context);
                          navigate(context, PageRoutes.changeLanguageScreen);
                        },
                      ),
                      buildAccountOption(
                        theme,
                        Icons.delete,
                        AppLocalization.instance
                            .getLocalizationFor("deleteAccount"),
                        onTap: () {
                          Navigator.pop(context);
                          ConfirmDialog.showConfirmation(
                                  context,
                                  Text(AppLocalization.instance
                                      .getLocalizationFor("delete_account")),
                                  Text(AppLocalization.instance
                                      .getLocalizationFor(
                                          "delete_account_msg")),
                                  AppLocalization.instance
                                      .getLocalizationFor("no"),
                                  AppLocalization.instance
                                      .getLocalizationFor("yes"))
                              .then((value) {
                            if (value != null && value == true) {
                              Loader.showLoader(context);
                              RemoteRepository().deleteUser().then((value) {
                                Loader.dismissLoader(context);
                                Navigator.pop(context);
                                BlocProvider.of<AppCubit>(context).logOut();
                              });
                            }
                          });
                        },
                      ),
                      // buildAccountOption(
                      //   theme,
                      //   Icons.settings,
                      //   AppLocalization.instance.getLocalizationFor("settings"),
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //     navigate(context, PageRoutes.settingPage);
                      //   },
                      // ),
                      buildAccountOption(
                        theme,
                        Icons.logout,
                        AppLocalization.instance.getLocalizationFor("logout"),
                        onTap: () => ConfirmDialog.showConfirmation(
                                context,
                                Text(AppLocalization.instance
                                    .getLocalizationFor("logout")),
                                Text(AppLocalization.instance
                                    .getLocalizationFor("logout_msg")),
                                AppLocalization.instance
                                    .getLocalizationFor("no"),
                                AppLocalization.instance
                                    .getLocalizationFor("yes"))
                            .then(
                          (value) {
                            if (value != null && value == true) {
                              BlocProvider.of<AppCubit>(context).logOut();
                              Phoenix.rebirth(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (AppConfig.isDemoMode)
            Container(
              margin: EdgeInsets.all(16),
              child: BuyThisApp.developerRowVerbose(
                Colors.transparent,
                theme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildAccountOption(
    ThemeData theme,
    IconData icon,
    String text, {
    Color? iconColor,
    Function()? onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor ?? theme.primaryColor,
              size: 25,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      );

  void navigate(BuildContext context, String routeName, {dynamic arguments}) {
    if (fromHome) {
      Navigator.pushNamed(context, routeName);
    } else {
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    }
  }
}

class WalletMeGlance extends StatefulWidget {
  const WalletMeGlance({super.key});

  @override
  State<WalletMeGlance> createState() => _WalletMeGlanceState();
}

class _WalletMeGlanceState extends State<WalletMeGlance> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, PageRoutes.walletPage);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: theme.primaryColorLight,
          image: DecorationImage(
            image: const AssetImage('assets/wallet_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: theme.cardColor,
              ),
              padding: const EdgeInsets.all(9),
              child: Icon(
                Icons.flash_on,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalization.instance.getLocalizationFor("wallet"),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.cardColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<Wallet?>(
                    future: RemoteRepository().balanceWallet(),
                    builder: (BuildContext context,
                            AsyncSnapshot<Wallet?> snapshotBalance) =>
                        Text(
                      "${AppSettings.currencyIcon} ${snapshotBalance.data?.balance.toStringAsFixed(2) ?? 0}",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.cardColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Image.asset(
            //   Assets.assetsArrows,
            // ),
          ],
        ),
      ),
    );
  }
}

class UserMeGlance extends StatefulWidget {
  const UserMeGlance({super.key});

  @override
  State<UserMeGlance> createState() => _UserMeGlanceState();
}

class _UserMeGlanceState extends State<UserMeGlance> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return FutureBuilder<DriverProfile?>(
      future: LocalDataLayer().getSavedDriverProfile(),
      builder: (BuildContext context, AsyncSnapshot<DriverProfile?> snapshot) =>
          GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, PageRoutes.profilePage);
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedImage(
                      imageUrl: snapshot.hasData
                          ? snapshot.data!.user?.imageUrl
                          : null,
                      height: 80,
                      width: 80,
                      imagePlaceholder: Assets.emptyProfile,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF009D06),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (snapshot.hasData && snapshot.data != null)
                                FutureBuilder<DriverProfile?>(
                                  future: RemoteRepository().getProfile(),
                                  builder: (BuildContext context,
                                          AsyncSnapshot<DriverProfile?>
                                              snapshotRating) =>
                                      Text(
                                    snapshotRating.data?.ratings
                                            ?.toStringAsFixed(1) ??
                                        "0",
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  "0",
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 24,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.hasData
                          ? (snapshot.data!.user?.name.isNotEmpty ?? false)
                              ? snapshot.data!.user!.name
                              : AppLocalization.instance
                                  .getLocalizationFor("setup_profile")
                          : "",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.hasData
                          ? (snapshot.data!.user?.mobile_number.isNotEmpty ??
                                  false)
                              ? snapshot.data!.user!.mobile_number
                              : AppLocalization.instance
                                  .getLocalizationFor("profile_incomplete")
                          : "",
                      style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500, color: theme.hintColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
