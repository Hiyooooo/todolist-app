import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final String? errorText;
  final bool isDense;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hint,
    this.prefixIcon,
    this.errorText,
    this.isDense = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: colorScheme.outline.withValues(alpha: 0.3),
        width: 1,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
    );

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      isDense: isDense,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: focusedBorder,
        errorBorder: baseBorder.copyWith(
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.2),
        ),
        focusedErrorBorder: baseBorder.copyWith(
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
        ),
      ),
    );
  }
}
