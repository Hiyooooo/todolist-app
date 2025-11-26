import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final String email;
  final String memberSinceText;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.username,
    required this.email,
    required this.memberSinceText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = (name.isNotEmpty ? name[0] : 'U').toUpperCase();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          child: Text(
            initial,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@$username',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(email, style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(
                'Member since $memberSinceText',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
