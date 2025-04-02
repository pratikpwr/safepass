import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safepass/src/core/extension/context_extension.dart';
import 'package:safepass/src/core/ui/padding.dart';
import 'package:safepass/src/core/utils/secure_storage.dart';
import 'package:safepass/src/features/passwords/blocs/password_entry_bloc/password_entry_bloc.dart';
import 'package:safepass/src/features/passwords/blocs/passwords_bloc/password_bloc.dart';
import 'package:safepass/src/features/passwords/models/password_entry.dart';

import '../../../core/app/injection_container.dart';
import '../models/password.dart';

class PasswordDetailScreen extends StatefulWidget {
  final Password password;

  const PasswordDetailScreen({super.key, required this.password});

  @override
  State<PasswordDetailScreen> createState() => _PasswordDetailScreenState();
}

class _PasswordDetailScreenState extends State<PasswordDetailScreen> {
  @override
  void initState() {
    Future.delayed(Duration(minutes: 3)).then((_) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: "Session Timeout!",
          toastLength: Toast.LENGTH_LONG,
        );
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PasswordEntryBloc(sl())..add(GetPasswordEntries(widget.password.id)),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.password.title),
          ),
          body: BlocConsumer<PasswordEntryBloc, PasswordEntryState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is PasswordEntryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PasswordEntryErrorState) {
                  return Center(child: Text(state.failure.toString()));
                }
                if (state is PasswordEntryLoaded) {
                  return ListView.builder(
                    itemCount: state.passwordEntries.length,
                    itemBuilder: (context, index) {
                      return PasswordEntryCard(
                        entry: state.passwordEntries[index],
                        password: widget.password,
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              }),
        );
      }),
    );
  }
}

class PasswordEntryCard extends StatefulWidget {
  const PasswordEntryCard({
    super.key,
    required this.entry,
    required this.password,
  });

  final Password password;
  final PasswordEntry entry;

  @override
  State<PasswordEntryCard> createState() => _PasswordEntryCardState();
}

class _PasswordEntryCardState extends State<PasswordEntryCard> {
  bool show = false;

  String passwordValue = "";

  @override
  void initState() {
    passwordValue = SecureStorage().decryptData(widget.entry.password);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Padding(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: widget.entry.username));
                              Fluttertoast.showToast(
                                  msg: 'Username copied to clipboard!');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.copy_outlined,
                                size: 20,
                              ),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              show ? passwordValue : "∗" * 12,
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    show
                                        ? CupertinoIcons.eye_fill
                                        : CupertinoIcons.eye_slash_fill,
                                    size: 20,
                                  ),
                                ),
                              ),
                              padding4,
                              InkWell(
                                onTap: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: passwordValue));
                                  Fluttertoast.showToast(
                                      msg: 'Password copied to clipboard!');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.copy_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.entry.note?.trim().isNotEmpty ?? false) ...[
                  padding8,
                  Text(
                    'Note: ${widget.entry.note!}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ]
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         AddPasswordScreen(
                    //           passwordToUpdate: {
                    //         widget.password :
                    //         },
                    //         ),
                    //   ),
                    // ).then((_) {
                    //   // context.read<PasswordBloc>().add(FetchPasswordsEvent());
                    // });
                  },
                  child: Text(
                    'Edit',
                  ),
                ),
                padding16,
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<PasswordEntryBloc>()
                        .add(DeletePasswordEntry(widget.entry));
                    if (widget.password.entries.length == 1) {
                      // only single entry so go back and fetch passwords again
                      Future.delayed(Duration(seconds: 1)).then((_) {
                        context.read<PasswordBloc>().add(FetchPasswordsEvent());
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Text(
                    'Delete',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
