import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/extension/context_extension.dart';
import '../../../core/ui/padding.dart';
import '../models/password.dart';
import '../screens/password_entries_screen.dart';

class PasswordCard extends StatefulWidget {
  const PasswordCard({
    super.key,
    required this.password,
  });

  final Password password;

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to see passwords',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      return authenticated;
    } catch (e) {
      print("Authentication error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _authenticate().then((result) {
          if (result) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PasswordDetailScreen(password: widget.password),
              ),
            );
          }
        });
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
                  widget.password.title.isNotEmpty
                      ? widget.password.title[0]
                      : "",
                  style: context.theme.textTheme.headlineMedium,
                ),
              ),
              padding12,
              Expanded(
                child: Text(
                  widget.password.title,
                  style: context.theme.textTheme.titleMedium,
                ),
              ),
              if (widget.password.entries.length > 1) ...[
                Text(
                  widget.password.entries.length.toString(),
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
