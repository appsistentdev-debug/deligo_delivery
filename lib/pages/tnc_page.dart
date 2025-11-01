import 'package:deligo_delivery/flavors.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TncPage extends StatelessWidget {
  const TncPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text(AppLocalization.instance.getLocalizationFor("tnc"),
            style: theme.textTheme.titleMedium!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            )),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 30),
          F.appFlavor == Flavor.deligo
              ? SvgPicture.asset(
                  isDark
                      ? 'assets/flavors/logo/deligo/logo_light.svg'
                      : 'assets/flavors/logo/deligo/logo.svg',
                  height: 100,
                  width: 100,
                )
              : Image.asset(
                  isDark ? F.logoLight : F.logo,
                  height: 100,
                  width: 100,
                ),
          const SizedBox(height: 30),
          Text(
            AppSettings.terms,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
          ),
        ],
      ),
    );
  }
}
