import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safepass/src/core/extension/context_extension.dart';
import 'package:safepass/src/core/ui/padding.dart';
import 'package:safepass/src/core/ui/textfield_item.dart';
import 'package:safepass/src/core/utils/secure_storage.dart';
import 'package:safepass/src/features/passwords/bloc/password_bloc.dart';
import 'package:safepass/src/features/passwords/models/password.dart';
import 'package:safepass/src/features/passwords/models/password_entry.dart';
import 'package:uuid/uuid.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({
    super.key,
    this.passwordToUpdate,
  });

  /// password to be updated and its entry
  final Map<Password, int>? passwordToUpdate;

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
    if (widget.passwordToUpdate != null) {
      final password = widget.passwordToUpdate!.keys.first;
      final entry = password.list[widget.passwordToUpdate!.values.first];
      _titleController.text = password.title;
      _siteController.text = entry.site;
      _usernameController.text = entry.username;
      _passwordController.text = SecureStorage().decryptData(entry.password);
      _noteController.text = entry.note ?? "";
    }
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

      Password pass;
      if (widget.passwordToUpdate != null) {
        final password = widget.passwordToUpdate!.keys.first;
        final entry = password.list[widget.passwordToUpdate!.values.first];
        pass = password.copyWith(
          title: _titleController.text,
          list: password.list.map((item) {
            if (item.id == entry.id) {
              return item.copyWith(
                username: _usernameController.text,
                password: encryptedPassword,
                site: _siteController.text,
                note:
                    _noteController.text.isEmpty ? null : _noteController.text,
              );
            }
            return item;
          }).toList(),
        );
      } else {
        var uuid = Uuid();
        pass = Password(
          id: uuid.v4(), // Generate a unique ID
          title: _titleController.text,
          list: [
            PasswordEntry(
              username: _usernameController.text,
              password: encryptedPassword,
              site: _siteController.text,
              note: _noteController.text.isEmpty ? null : _noteController.text,
              id: uuid.v4(),
            ),
          ],
        );
      }

      context.read<PasswordBloc>().add(AddPasswordEvent(pass));

      Navigator.pop(context);
    }
  }
}
