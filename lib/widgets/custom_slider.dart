import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({super.key, required this.title, this.onSlide});

  final String title;
  final Function? onSlide;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 16),
      child: SlideAction(
          outerColor: theme.primaryColor,
          onSubmit: onSlide as Future? Function(),
          sliderButtonIcon:
              Icon(Icons.double_arrow_rounded, color: theme.primaryColor),
          innerColor: theme.cardColor,
          sliderButtonIconSize: 28,
          sliderButtonIconPadding: 12,
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.cardColor,
              fontWeight: FontWeight.w600,
            ),
          )),
    );
  }
}
