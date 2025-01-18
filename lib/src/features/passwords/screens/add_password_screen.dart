import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safepass/src/core/extension/context_extension.dart';
import 'package:safepass/src/core/ui/padding.dart';
import 'package:safepass/src/core/ui/textfield_item.dart';
import 'package:safepass/src/core/utils/password_generator.dart';
import 'package:safepass/src/core/utils/secure_storage.dart';
import 'package:safepass/src/features/passwords/blocs/passwords_bloc/password_bloc.dart';
import 'package:safepass/src/features/passwords/models/password_entry.dart';
import 'package:uuid/uuid.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({
    super.key,
    this.password,
    // this.passwordToUpdate,
  });

  // /// password to be updated and its entry
  // final Map<Password, int>? passwordToUpdate;
  final String? password;

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _titleController = TextEditingController();
  final _siteController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _noteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _passwordController.text = widget.password ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelledTextFieldItem(
                  controller: _titleController,
                  title: 'Title',
                  keyboardType: TextInputType.name,
                  hintText: 'Enter title',
                  validator: (value) {
                    // if (value == null || value.isEmpty) {
                    //   return 'Please enter title';
                    // }
                    return null;
                  },
                ),
                padding8,
                LabelledTextFieldItem(
                  controller: _siteController,
                  title: 'Site*',
                  hintText: 'Enter web address',
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter website';
                    }
                    return null;
                  },
                ),
                padding8,
                LabelledTextFieldItem(
                  controller: _usernameController,
                  title: 'Username*',
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username for this site';
                    }
                    return null;
                  },
                ),
                padding8,
                LabelledTextFieldItem(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  title: 'Password*',
                  hintText: 'Enter current password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid password';
                    }
                    return null;
                  },
                  suffix: IconButton(
                    onPressed: () {
                      final result = PasswordGenerator.generatePassword();

                      setState(() {
                        _passwordController.text = result;
                      });
                    },
                    icon: Icon(
                      Icons.auto_awesome,
                    ),
                  ),
                ),
                padding4,
                Text(
                  " Make sure you're saving your current password for this site",
                  style: context.theme.textTheme.labelMedium,
                ),
                padding8,
                LabelledTextFieldItem(
                  controller: _noteController,
                  hintText: 'Add note',
                  title: 'Note',
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _savePassword(),
                    child: Text(
                      'Save Password'.toUpperCase(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _savePassword() {
    if (_formKey.currentState!.validate()) {
      final encryptedPassword =
          SecureStorage().encryptData(_passwordController.text);

      var uuid = Uuid();

      final entry = PasswordEntry(
        username: _usernameController.text,
        password: encryptedPassword,
        site: _siteController.text,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        id: uuid.v4(),
        parentId: uuid.v4(),
      );

      context.read<PasswordBloc>().add(AddPasswordEvent(
            entry: entry,
            title: _titleController.text.isNotEmpty
                ? _titleController.text
                : _siteController.text,
          ));

      Future.delayed(Duration(milliseconds: 300)).then((_) {
        if (widget.password != null) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      });
    }
  }
}
