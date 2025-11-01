import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField(
      {super.key, required this.child, required this.label});

  final DropdownButton child;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.hintColor.withValues(alpha: 0.23),
            ),
            color: theme.colorScheme.surface,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: theme.colorScheme.surface.withValues(alpha: 0.9)),
            child: child,
          ),
        ),
      ],
    );
  }
}
