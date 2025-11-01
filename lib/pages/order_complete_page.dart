import 'package:flutter/material.dart';

import 'package:deligo_delivery/config/assets.dart';
import 'package:deligo_delivery/config/page_routes.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/order.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';

class OrderCompletePage extends StatelessWidget {
  const OrderCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    Order order = args["order"];
    double distance = double.tryParse("${args["distance"]}") ??
        Helper.calculateDistanceInMeters(
            order.sourceLatLng.latitude,
            order.sourceLatLng.longitude,
            order.destinationLatLng.latitude,
            order.destinationLatLng.longitude);
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
            AppLocalization.instance
                .getLocalizationFor("order_action_complete"),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 100),
            child: Text(
              AppLocalization.instance
                  .getLocalizationFor("order_completed_msg"),
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
                  Helper.formatDistanceString(
                    distanceInMeters: distance,
                    distanceMetric: AppSettings.distanceMetric,
                  ),
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
                order.deliveryFeeFormatted ?? "",
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
