import 'package:deligo_delivery/config/assets.dart';
import 'package:deligo_delivery/config/page_routes.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:deligo_delivery/widgets/cached_image.dart';
import 'package:flutter/material.dart';

class BottomTabAccount extends StatelessWidget {
  const BottomTabAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(AppLocalization.instance.getLocalizationFor("account"),
            style: theme.textTheme.titleLarge),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 14),
          const UserMeGlance(),
          const SizedBox(height: 20),
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
                  Icons.drive_eta,
                  AppLocalization.instance.getLocalizationFor("rides"),
                  onTap: () {
                    Navigator.pushNamed(context, PageRoutes.ridesScreen);
                  },
                ),
                const SizedBox(height: 10),
                buildAccountOption(
                  theme,
                  Icons.star,
                  AppLocalization.instance.getLocalizationFor("ratings"),
                  onTap: () {
                    Navigator.pushNamed(context, PageRoutes.ratingsScreen);
                  },
                ),
                const SizedBox(height: 10),
                buildAccountOption(
                  theme,
                  Icons.insert_chart_rounded,
                  AppLocalization.instance.getLocalizationFor("insights"),
                  onTap: () {
                    Navigator.pushNamed(context, PageRoutes.insightPage);
                  },
                ),
                const SizedBox(height: 10),
                buildAccountOption(
                  theme,
                  Icons.account_balance_wallet,
                  AppLocalization.instance.getLocalizationFor("wallet"),
                  onTap: () {
                    Navigator.pushNamed(context, PageRoutes.walletPage);
                  },
                ),
                const SizedBox(height: 10),
                buildAccountOption(
                  theme,
                  Icons.public,
                  AppLocalization.instance.getLocalizationFor("changeLanguage"),
                  onTap: () {
                    Navigator.pushNamed(
                        context, PageRoutes.changeLanguageScreen);
                  },
                ),
                const SizedBox(height: 10),
                buildAccountOption(
                  theme,
                  Icons.mail,
                  AppLocalization.instance.getLocalizationFor("support"),
                  onTap: () {
                    Navigator.pushNamed(context, PageRoutes.supportPage);
                  },
                ),
                const SizedBox(height: 10),
                buildAccountOption(
                  theme,
                  Icons.help,
                  AppLocalization.instance.getLocalizationFor("faqs"),
                  onTap: () {
                    Navigator.pushNamed(context, PageRoutes.faqPage);
                  },
                ),
                const SizedBox(height: 10),
                buildAccountOption(
                  theme,
                  Icons.logout,
                  AppLocalization.instance.getLocalizationFor("logout"),
                  onTap: () {},
                ),
                const SizedBox(height: 50),
              ],
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
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: theme.primaryColor,
              ),
              child: Icon(
                icon,
                color: theme.scaffoldBackgroundColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
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
        onTap: () => Navigator.pushNamed(context, PageRoutes.profilePage)
            .then((value) => setState(() {})),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
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
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.hasData
                          ? (snapshot.data!.vehicletypes?.first.title
                                      .isNotEmpty ??
                                  false)
                              ? snapshot.data!.vehicletypes!.first.title
                              : AppLocalization.instance
                                  .getLocalizationFor("setup_profile")
                          : "",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedImage(
                        imageUrl: snapshot.hasData
                            ? snapshot.data!.user?.imageUrl
                            : null,
                        height: 62,
                        width: 62,
                        imagePlaceholder: Assets.emptyProfile,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.dividerColor,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
