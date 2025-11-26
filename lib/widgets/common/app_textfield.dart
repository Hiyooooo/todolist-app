import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? errorText;

  final bool isDense;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.validator,
    this.errorText,
    this.isDense = false, // default normal
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: colorScheme.outline.withOpacity(0.3),
        width: 1,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
    );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        suffixIcon: suffix,
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.5),

        contentPadding: isDense
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        isDense: isDense,
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
