import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';

import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/ride.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';

class RideInfoWidget extends StatefulWidget {
  final Ride ride;

  const RideInfoWidget(this.ride, {super.key});

  @override
  State<RideInfoWidget> createState() => _RideInfoWidgetState();
}

class _RideInfoWidgetState extends State<RideInfoWidget> {
  bool _showInfo = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomButton(
          width: 150,
          borderRadius: BorderRadius.circular(30),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              _showInfo ? Icons.close_rounded : Icons.shopping_basket_rounded,
              color: theme.primaryColor,
              size: 20,
            ),
          ),
          onTap: () => setState(() => _showInfo = !_showInfo),
          label: _showInfo
              ? AppLocalization.instance.getLocalizationFor("closeText")
              : AppLocalization.instance.getLocalizationFor("rideInfo"),
          bgColor: Colors.white,
          labelColor: Colors.black,
        ),
        if (_showInfo) const SizedBox(height: 16),
        if (_showInfo)
          FadedScaleAnimation(
            child: Column(
              children: [
                buildInfo(
                  context,
                  AppLocalization.instance.getLocalizationFor("bookingId"),
                  "#${widget.ride.id}",
                  theme.textTheme.titleMedium!,
                  theme.textTheme.titleMedium!,
                  theme.cardColor,
                  const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                if (widget.ride.getMetaValue("package_type") != null)
                  buildInfo(
                    context,
                    AppLocalization.instance.getLocalizationFor("packageType"),
                    widget.ride.getMetaValue("package_type")!,
                    theme.textTheme.titleMedium!,
                    theme.textTheme.titleMedium!,
                    theme.scaffoldBackgroundColor,
                    BorderRadius.circular(0),
                  ),
                buildInfo(
                  context,
                  AppLocalization.instance.getLocalizationFor("rideType"),
                  "${widget.ride.vehicle_type?.title}",
                  theme.textTheme.titleMedium!,
                  theme.textTheme.titleMedium!,
                  theme.scaffoldBackgroundColor,
                  BorderRadius.circular(0),
                ),
                buildInfo(
                  context,
                  AppLocalization.instance.getLocalizationFor("paymentMethod"),
                  "${widget.ride.payment?.paymentMethod?.title}",
                  theme.textTheme.titleMedium!,
                  theme.textTheme.titleMedium!,
                  theme.scaffoldBackgroundColor,
                  BorderRadius.circular(0),
                ),
                buildInfo(
                  context,
                  AppLocalization.instance.getLocalizationFor("rideCost"),
                  widget.ride.fare_formatted,
                  theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                  theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                  theme.scaffoldBackgroundColor,
                  const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Container buildInfo(
    BuildContext context,
    String text1,
    String text2,
    TextStyle textStyle1,
    TextStyle textStyle2,
    Color color1,
    BorderRadius? borderRadius,
  ) =>
      Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text1, style: textStyle1),
            const SizedBox(width: 6),
            Text(text2, style: textStyle2),
          ],
        ),
      );
}
