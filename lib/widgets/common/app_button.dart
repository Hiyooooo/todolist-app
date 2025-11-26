import 'package:flutter/material.dart';

enum AppButtonType { primary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isFullWidth;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isFullWidth = true,
    this.icon,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isFullWidth = true,
    this.icon,
  }) : type = AppButtonType.primary;

  const AppButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.isFullWidth = true,
    this.icon,
  }) : type = AppButtonType.outline;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isFullWidth = false,
    this.icon,
  }) : type = AppButtonType.text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = _buildChild(theme);

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          child: child,
        );
        break;
      case AppButtonType.outline:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.colorScheme.primary, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          child: child,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: child,
        );
        break;
    }

    if (!isFullWidth) return button;

    return SizedBox(width: double.infinity, child: button);
  }

  Widget _buildChild(ThemeData theme) {
    final textStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );

    if (icon == null) {
      return Text(label, style: textStyle);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(label, style: textStyle),
      ],
    );
  }
}
