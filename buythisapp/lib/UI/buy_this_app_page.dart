// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_interpolation_to_compose_strings, deprecated_member_use, prefer_const_literals_to_create_immutables

import 'package:buy_this_app/Repository/repository.dart';
import 'package:buy_this_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class BuyThisAppPage extends StatelessWidget {
  final String appName;
  final String codeCanyonUrl;
  final String source;

  BuyThisAppPage(this.appName, this.codeCanyonUrl, this.source);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff549A13),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Color(0xff549A13),
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(),
                  Text(
                    S.of(context).buyThis + '\n' + S.of(context).templateNow,
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    S.of(context).flutterTemplateOnlyNoBackend,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Repository.launchUrl(codeCanyonUrl);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                        padding: MaterialStateProperty.all(EdgeInsets.all(8))),
                    icon: Image.asset(
                      "images/ic_codecanyon.png",
                      package: "buy_this_app",
                      height: 40,
                    ),
                    label: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'Get it on '),
                        TextSpan(
                            text: 'CodeCanyon',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer(flex: 2),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(flex: 2),
                  Text(
                    S.of(context).buyThisAppWith +
                        '\n' +
                        S.of(context).completeBackend,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Spacer(),
                  Text(
                    S.of(context).fullAppSolutionWithCompleteBackend,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Repository.launchUrl(
                          'https://dashboard.vtlabs.dev/whatsapp.php?product_name=$appName&source=$source&redirect=1');
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xff549A13)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                        padding: MaterialStateProperty.all(EdgeInsets.all(8))),
                    icon: Image.asset(
                      "images/ic_whatsapp.png",
                      package: "buy_this_app",
                      height: 40,
                    ),
                    label: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: S.of(context).messageOn + ' '),
                        TextSpan(
                            text: 'WhatsApp',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      style: TextStyle(fontSize: 16, letterSpacing: 1),
                    ),
                  ),
                  Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
