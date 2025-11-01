import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:deligo_delivery/models/order_product.dart';
import 'package:flutter/material.dart';

import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/order.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';

class OrderInfoWidget extends StatefulWidget {
  final Order order;
  final void Function(bool isOpen) onOpenToggle;

  const OrderInfoWidget(this.order, this.onOpenToggle, {super.key});

  @override
  State<OrderInfoWidget> createState() => _OrderInfoWidgetState();
}

class _OrderInfoWidgetState extends State<OrderInfoWidget> {
  bool _showInfo = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const CloseButton(),
            const Spacer(),
            CustomButton(
              width: _showInfo ? 110 : 150,
              borderRadius: BorderRadius.circular(30),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              prefixIcon: Icon(
                _showInfo ? Icons.close_rounded : Icons.shopping_basket_rounded,
                color: theme.primaryColor,
                size: 20,
              ),
              onTap: () {
                _showInfo = !_showInfo;
                setState(() {});
                widget.onOpenToggle.call(_showInfo);
              },
              label: _showInfo
                  ? AppLocalization.instance.getLocalizationFor("closeText")
                  : AppLocalization.instance.getLocalizationFor("orderInfo"),
              labelColor: Colors.black,
              bgColor: Colors.white,
            ),
          ],
        ),
        if (_showInfo) const SizedBox(height: 16),
        if (_showInfo)
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: FadedScaleAnimation(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildInfo(
                        context,
                        AppLocalization.instance.getLocalizationFor("orderid"),
                        "#${widget.order.id}",
                        theme.textTheme.titleMedium!,
                        theme.textTheme.titleMedium!,
                        theme.colorScheme.surface,
                        const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      if ((widget.order.order_type?.toLowerCase() ??
                              "normal") !=
                          "custom")
                        for (OrderProduct op in widget.order.products ?? [])
                          buildInfo(
                              context,
                              op.vendor_product.product?.title ??
                                  AppLocalization.instance
                                      .getLocalizationFor("product"),
                              "x${op.quantity.toString()}    ${op.totalFormatted}",
                              theme.textTheme.titleMedium!,
                              theme.textTheme.titleSmall!
                                  .copyWith(color: Colors.grey),
                              theme.cardColor,
                              BorderRadius.circular(0),
                              (op.addon_choices?.isNotEmpty ?? false)
                                  ? "${AppLocalization.instance.getLocalizationFor("with")} ${op.addonChoicesToString(AppLocalization.instance.getLocalizationFor("and"))}"
                                  : null),
                      if (widget.order.notes?.isNotEmpty ?? false)
                        buildInfo(
                          context,
                          AppLocalization.instance.getLocalizationFor("notes"),
                          widget.order.notes ??
                              AppLocalization.instance
                                  .getLocalizationFor("notes"),
                          theme.textTheme.titleMedium!,
                          theme.textTheme.titleMedium!,
                          theme.cardColor,
                          BorderRadius.circular(0),
                        ),
                      if (widget.order.payment?.paymentMethod?.title
                              ?.isNotEmpty ??
                          false)
                        buildInfo(
                          context,
                          AppLocalization.instance
                              .getLocalizationFor("paymentMethod"),
                          widget.order.payment?.paymentMethod?.title ?? "",
                          theme.textTheme.titleMedium!,
                          theme.textTheme.titleMedium!,
                          theme.cardColor,
                          BorderRadius.circular(0),
                        ),
                      buildInfo(
                        context,
                        AppLocalization.instance.getLocalizationFor("cost"),
                        widget.order.totalFormatted ?? "",
                        theme.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                        theme.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                        theme.cardColor,
                        const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Container buildInfo(
  BuildContext context,
  String text1,
  String text2,
  TextStyle textStyle1,
  TextStyle textStyle2,
  Color color1,
  BorderRadius? borderRadius, [
  String? subtitle,
]) =>
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
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text1, style: textStyle1),
                if (subtitle != null) Text(subtitle, style: textStyle2),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(text2, style: textStyle1),
        ],
      ),
    );
