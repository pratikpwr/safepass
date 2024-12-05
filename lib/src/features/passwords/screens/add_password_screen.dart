import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safepass/src/features/passwords/bloc/password_bloc.dart';
import 'package:safepass/src/features/passwords/models/password.dart';
import 'package:safepass/src/features/passwords/models/password_entry.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final password = Password(
                  id: DateTime.now().toString(), // Generate a unique ID
                  title: _titleController.text,
                  list: [
                    PasswordEntry(
                      username: _usernameController.text,
                      password: _passwordController.text,
                      site: _titleController.text,
                      note: _noteController.text.isEmpty
                          ? null
                          : _noteController.text,
                      id: DateTime.now().toString(),
                    ),
                  ],
                );

                context.read<PasswordBloc>().add(AddPasswordEvent(password));

                Navigator.pop(context);
              },
              child: const Text('Save Password'),
            ),
          ],
        ),
      ),
    );
  }
}
