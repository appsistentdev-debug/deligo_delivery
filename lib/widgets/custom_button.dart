import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final Function? onTap;
  final Color? labelColor;
  final Color? bgColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? width;

  final Widget? prefixIcon;

  const CustomButton({
    super.key,
    this.label,
    this.onTap,
    this.labelColor,
    this.bgColor,
    this.margin,
    this.padding,
    this.prefixIcon,
    this.borderRadius,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: FadedScaleAnimation(
        fadeDuration: const Duration(milliseconds: 300),
        scaleDuration: const Duration(milliseconds: 300),
        child: Container(
          width: width ?? size.width,
          margin: margin,
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: bgColor ?? theme.primaryColor,
              borderRadius: borderRadius ?? BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: prefixIcon!,
                ),
              Expanded(
                child: Text(
                  label ??
                      AppLocalization.instance
                          .getLocalizationFor("continueText"),
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: labelColor ?? Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButtonDc extends StatelessWidget {
  final String? text;
  final Color? buttonColor;
  final Color? textColor;
  final String? prefix;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Function()? onTap;
  final TextStyle? textStyle;
  final Color? borderColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const CustomButtonDc({
    super.key,
    this.text,
    this.buttonColor,
    this.prefix,
    this.prefixIcon,
    this.onTap,
    this.prefixIconColor,
    this.textColor,
    this.textStyle,
    this.borderColor,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: margin,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                  color: borderColor ?? theme.hintColor.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding:
              WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
          elevation: WidgetStateProperty.all(0),
          backgroundColor:
              WidgetStateProperty.all(buttonColor ?? theme.primaryColor),
        ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 14.0),
                  child: Icon(prefixIcon!, color: prefixIconColor, size: 16),
                ),
              if (prefix != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 18.0),
                  child: Image.asset(
                    prefix!,
                    height: 16,
                    width: 16,
                  ),
                ),
              SizedBox(width: prefix != null || prefixIcon != null ? 10 : 0),
              Text(
                text ?? 'Continue',
                style: (textStyle ?? theme.textTheme.bodyLarge)?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor ?? theme.primaryColorLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: prefix != null || prefixIcon != null ? 10 : 0),
            ],
          ),
        ),
      ),
    );
  }
}
