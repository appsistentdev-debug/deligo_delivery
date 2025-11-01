import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final String? label;
  final double? labelHeight;
  final Widget? prefix;
  final int? maxLines;
  final bool? readOnly;
  final Widget? suffix;
  final bool? autofocus;
  final bool restrictHeight;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final GestureTapCallback? onTap;
  final TextCapitalization? textCapitalization;
  final TextAlignVertical? textAlignVertical;
  final Color? fillColor;
  final bool? isChat;

  const EntryField({
    super.key,
    this.hintText,
    this.initialValue,
    this.label,
    this.labelHeight,
    this.prefix,
    this.maxLines,
    this.readOnly,
    this.suffix,
    this.keyboardType,
    this.autofocus,
    this.fillColor,
    this.isChat,
    this.controller,
    this.onTap,
    this.textCapitalization,
    this.textAlignVertical,
    this.restrictHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label ?? '',
            style: theme.textTheme.bodySmall!.copyWith(color: theme.hintColor),
          ),
        if (label != null) SizedBox(height: labelHeight ?? 13),
        SizedBox(
          height: restrictHeight ? 64 : null,
          //height: null,
          child: TextFormField(
            onTap: onTap,
            controller: controller,
            maxLines: maxLines,
            initialValue: initialValue,
            readOnly: readOnly ?? false,
            keyboardType: keyboardType,
            autofocus: autofocus ?? false,
            textAlignVertical: textAlignVertical,
            textCapitalization:
                textCapitalization ?? TextCapitalization.sentences,
            decoration: InputDecoration(
              filled: true,
              prefixIcon: prefix,
              suffixIcon: suffix,
              hintText: hintText,
              hintStyle:
                  theme.textTheme.bodyLarge!.copyWith(color: theme.hintColor),
              // contentPadding:
              //     const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              fillColor: fillColor?? theme.colorScheme.surface,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isChat !=null && isChat!? Colors.transparent : theme.hintColor.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isChat !=null && isChat!? Colors.transparent :  theme.hintColor.withValues(alpha: 0.2),
                ),
              ),
            ),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ),
      ],
    );
  }
}
