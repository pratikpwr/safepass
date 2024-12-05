import 'package:flutter/material.dart';

import '../../../core/extension/context_extension.dart';
import '../../../core/ui/padding.dart';
import '../models/password.dart';
import '../screens/password_entries_screen.dart';

class PasswordCard extends StatelessWidget {
  const PasswordCard({
    super.key,
    required this.password,
  });

  final Password password;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordDetailScreen(password: password),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 12,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  password.title[0],
                  style: context.theme.textTheme.headlineMedium,
                ),
              ),
              padding12,
              Expanded(
                child: Text(
                  password.title,
                  style: context.theme.textTheme.titleMedium,
                ),
              ),
              if (password.list.length > 1) ...[
                Text(
                  password.list.length.toString(),
                  style: context.theme.textTheme.bodyLarge,
                ),
                padding8,
              ],
              Icon(
                Icons.chevron_right_rounded,
                size: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}
