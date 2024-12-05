import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import 'src/core/ui/theme.dart';
import 'src/core/ui/util.dart';
import 'src/features/passwords/bloc/password_bloc.dart';
import 'src/features/passwords/models/password.dart';
import 'src/features/passwords/models/password_entry.dart';
import 'src/features/passwords/screens/passwords_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);

  // Register adapters
  Hive.registerAdapter(PasswordAdapter());
  Hive.registerAdapter(PasswordEntryAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    MaterialTheme theme =
        MaterialTheme(createTextTheme(context, "Quicksand", "Poppins"));

    return BlocProvider(
      create: (_) => PasswordBloc()..add(FetchPasswordsEvent()),
      child: MaterialApp(
        title: 'SecuPass',
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (_) => PasswordBloc()..add(FetchPasswordsEvent()),
          child: PasswordsScreen(),
        ),
      ),
    );
  }
}
