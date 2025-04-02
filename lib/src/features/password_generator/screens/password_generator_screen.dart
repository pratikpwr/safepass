// password_generator_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safepass/src/core/extension/context_extension.dart';
import 'package:safepass/src/core/ui/padding.dart';
import 'package:safepass/src/features/password_generator/blocs/password_generate_bloc.dart';
import 'package:safepass/src/features/passwords/screens/add_password_screen.dart';

class PasswordGeneratorScreen extends StatelessWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordGenerateBloc(),
      child: const PasswordGeneratorView(),
    );
  }
}

class PasswordGeneratorView extends StatefulWidget {
  const PasswordGeneratorView({super.key});

  @override
  State<PasswordGeneratorView> createState() => _PasswordGeneratorViewState();
}

class _PasswordGeneratorViewState extends State<PasswordGeneratorView> {
  int length = 12;
  bool useSymbols = true;
  bool useNumbers = true;
  bool useLowercase = true;
  bool useUppercase = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<PasswordGenerateBloc, PasswordGenerateState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Instantly generate a new secure & random password',
                    style: context.theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                padding24,
                Text(
                  'Minimum Length',
                  style: context.theme.textTheme.bodyLarge,
                ),
                padding8,
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: length.toDouble(),
                        min: 6,
                        max: 24,
                        divisions: 18,
                        onChanged: (value) {
                          setState(() {
                            length = value.floor();
                          });
                        },
                      ),
                    ),
                    Text(
                      '$length',
                      style: context.theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
                padding16,
                CheckboxListTile(
                  title: Text(
                    'Allow Symbols (!@#\$%^&*()+)',
                    style: context.theme.textTheme.bodyLarge,
                  ),
                  value: useSymbols,
                  onChanged: (value) {
                    setState(() {
                      useSymbols = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    'Allow Numbers (0-9)',
                    style: context.theme.textTheme.bodyLarge,
                  ),
                  value: useNumbers,
                  onChanged: (value) {
                    setState(() {
                      useNumbers = value ?? false;
                    });
                  },
                ),
                // CheckboxListTile(
                //   title: Text(
                //     'Allow Lowercase (abc)',
                //     style: context.theme.textTheme.titleMedium,
                //   ),
                //   value: useLowercase,
                //   onChanged: (value) {
                //     setState(() {
                //       useLowercase = value ?? false;
                //     });
                //   },
                // ),
                CheckboxListTile(
                  title: Text(
                    'Allow Uppercase (ABC)',
                    style: context.theme.textTheme.bodyLarge,
                  ),
                  value: useUppercase,
                  onChanged: (value) {
                    setState(() {
                      useUppercase = value ?? false;
                    });
                  },
                ),
                padding16,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.password,
                          style: context.theme.textTheme.titleLarge
                              ?.copyWith(fontSize: 20),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: state.password),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password copied to clipboard'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (state.password.trim().isNotEmpty)
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddPasswordScreen(password: state.password),
                          ),
                        );
                      },
                      child: Text('Save this Password!'),
                    ),
                  ),
                padding16,
                Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<PasswordGenerateBloc>()
                          .add(PasswordGenerateEvent(
                            length: length,
                            useLowercase: useLowercase,
                            useUppercase: useUppercase,
                            useNumbers: useNumbers,
                            useSymbols: useSymbols,
                          ));
                    },
                    child: Text(
                      'Generate Password'.toUpperCase(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
