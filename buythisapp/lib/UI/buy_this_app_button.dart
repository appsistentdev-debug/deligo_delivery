// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sort_child_properties_last, prefer_const_constructors

import 'package:buy_this_app/Repository/repository.dart';
import 'package:buy_this_app/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../buy_this_app.dart';
import 'buy_this_app_page.dart';

class BuyThisAppButton extends StatelessWidget {
  final String appName;
  final String codeCanyonUrl;
  final Color? color;
  final Target target;
  final double height;
  final String source;

  BuyThisAppButton(
    this.appName,
    this.codeCanyonUrl,
    this.color,
    this.target,
    this.height,
    this.source,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      onPressed: () {
        switch (target) {
          case Target.CodeCanyon:
            Repository.launchUrl(codeCanyonUrl);
            break;
          case Target.WhatsApp:
            Repository.launchUrl(
              'https://dashboard.vtlabs.dev/whatsapp.php?product_name=$appName&source=$source&redirect=1',
            );
            break;
          default:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuyThisAppPage(
                  appName.replaceAll(' ', '').toLowerCase(),
                  codeCanyonUrl,
                  source,
                ),
              ),
            );
            break;
        }
      },
      child: Text(
        S.of(context).buyThisApp,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      color: color ?? Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}

class BuyThisAppCustomButton extends StatelessWidget {
  final Widget widget;
  final String appName;
  final String codeCanyonUrl;
  final Target target;
  final String source;

  BuyThisAppCustomButton(
    this.widget,
    this.appName,
    this.codeCanyonUrl,
    this.target,
    this.source,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (target) {
          case Target.CodeCanyon:
            Repository.launchUrl(codeCanyonUrl);
            break;
          case Target.WhatsApp:
            Repository.launchUrl(
              'https://dashboard.vtlabs.dev/whatsapp.php?product_name=$appName&source=$source&redirect=1',
            );
            break;
          default:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuyThisAppPage(
                  appName.replaceAll(' ', '').toLowerCase(),
                  codeCanyonUrl,
                  source,
                ),
              ),
            );
            break;
        }
      },
      child: widget,
    );
  }
}
