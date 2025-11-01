// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_conditional_assignment, prefer_const_constructors

import 'package:buy_this_app/Repository/repository.dart';
import 'package:buy_this_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DeveloperRow extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  String? _imageSrc;
  String? _developerSrc;

  static DeveloperRow opus(Color backgroundColor, Color textColor) {
    DeveloperRow developerRow = DeveloperRow(backgroundColor, textColor);
    developerRow.developer = "https://opuslab.works/";
    developerRow.imageSrc = "images/logo_opus.png";
    return developerRow;
  }

  static DeveloperRow opusDark(Color backgroundColor, Color textColor) {
    DeveloperRow developerRow = DeveloperRow(backgroundColor, textColor);
    developerRow.developer = "https://opuslab.works/";
    developerRow.imageSrc = "images/logo_opus_white.png";
    return developerRow;
  }

  static DeveloperRow verbose(Color backgroundColor, Color textColor) {
    DeveloperRow developerRow = DeveloperRow(backgroundColor, textColor);
    developerRow.developer = "https://verbosetechlabs.com/";
    developerRow.imageSrc = "images/logo_verbose.png";
    return developerRow;
  }

  static DeveloperRow verboseDark(Color backgroundColor, Color textColor) {
    DeveloperRow developerRow = DeveloperRow(backgroundColor, textColor);
    developerRow.developer = "https://verbosetechlabs.com/";
    developerRow.imageSrc = "images/logo_verbose_white.png";
    return developerRow;
  }

  set imageSrc(String imageSrc) => _imageSrc = imageSrc;

  set developer(String developer) => _developerSrc = developer;

  DeveloperRow(this.backgroundColor, this.textColor) {
    if (_developerSrc == null) _developerSrc = "https://opuslab.works/";
    if (_imageSrc == null) _imageSrc = "images/logo_opus.png";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Repository.launchUrl(_developerSrc!),
      child: Container(
        height: 55,
        color: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).developedBy,
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            Spacer(),
            Expanded(
              flex: 5,
              child: Image.asset(
                _imageSrc!,
                package: "buy_this_app",
                // width: 160,
              ),
            )
          ],
        ),
      ),
    );
  }
}
