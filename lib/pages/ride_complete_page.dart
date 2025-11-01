import 'package:flutter/material.dart';

import 'package:deligo_delivery/config/assets.dart';
import 'package:deligo_delivery/config/page_routes.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/ride.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';

class RideCompletePage extends StatelessWidget {
  const RideCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    Ride ride = ModalRoute.of(context)!.settings.arguments as Ride;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            Assets.assetsRideCompleted,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalization.instance.getLocalizationFor("rideCompleted"),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 100),
            child: Text(
              AppLocalization.instance.getLocalizationFor("ride_completed_msg"),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 60),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const SizedBox(),
            Column(
              children: [
                Text(
                  AppLocalization.instance.getLocalizationFor("driven"),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  // Helper.formatDistanceString(
                  //   distanceInMeters: (ride.final_distance ?? 0) * 1000,
                  //   distanceMetric: AppSettings.distanceMetric,
                  // ),
                  "${ride.final_distance?.toStringAsFixed(1) ?? 0} km",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Column(children: [
              Text(
                AppLocalization.instance.getLocalizationFor("earning"),
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Text(
                ride.fare_formatted,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ]),
            const SizedBox(),
          ]),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: CustomButton(
              label: AppLocalization.instance.getLocalizationFor("home"),
              onTap: () => Navigator.pushNamedAndRemoveUntil(context,
                  PageRoutes.homePage, (Route<dynamic> route) => false),
            ),
          ),
        ],
      ),
    );
  }
}
