import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safepass/src/core/extension/context_extension.dart';
import 'package:safepass/src/core/ui/padding.dart';
import 'package:safepass/src/features/passwords/models/password_entry.dart';

import '../models/password.dart';

class PasswordDetailScreen extends StatelessWidget {
  final Password password;

  PasswordDetailScreen({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(password.title),
      ),
      body: ListView.builder(
          itemCount: password.list.length,
          itemBuilder: (context, index) {
            return PasswordEntryCard(entry: password.list[index]);
          }),
    );
  }
}

class PasswordEntryCard extends StatefulWidget {
  const PasswordEntryCard({
    super.key,
    required this.entry,
  });

  final PasswordEntry entry;

  @override
  State<PasswordEntryCard> createState() => _PasswordEntryCardState();
}

class _PasswordEntryCardState extends State<PasswordEntryCard> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                text: 'Site: ',
                style: context.theme.textTheme.labelLarge,
                children: [
                  TextSpan(
                    text: widget.entry.site,
                    style: context.theme.textTheme.labelLarge
                        ?.copyWith(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            padding8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: context.theme.textTheme.titleMedium,
                ),
                padding4,
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        widget.entry.username,
                        style: context.theme.textTheme.bodyLarge,
                      )),
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: widget.entry.username));
                        },
                        child: Icon(
                          Icons.copy_outlined,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            padding8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: context.theme.textTheme.titleMedium,
                ),
                padding4,
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          show
                              ? widget.entry.password
                              : "*" * widget.entry.password.length,
                          style: context.theme.textTheme.bodyLarge,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                show = !show;
                              });
                            },
                            child: Icon(
                              show
                                  ? CupertinoIcons.eye_fill
                                  : CupertinoIcons.eye_slash_fill,
                              size: 20,
                            ),
                          ),
                          padding16,
                          InkWell(
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: widget.entry.password));
                              Fluttertoast.showToast(
                                  msg: 'Password copied to clipboard!');
                            },
                            child: Icon(
                              Icons.copy_outlined,
                              size: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            padding8,
            Text(
              'Note: ${widget.entry.note ?? "no note"}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
