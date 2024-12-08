import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safepass/src/features/passwords/blocs/passwords_bloc/password_bloc.dart';

import 'src/core/app/injection_container.dart' as di;
import 'src/core/ui/theme.dart';
import 'src/core/ui/util.dart';
import 'src/core/utils/secure_storage.dart';
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

  await SecureStorage.init();

  // dependency injections initialization
  di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View
        .of(context)
        .platformDispatcher
        .platformBrightness;

    MaterialTheme theme =
    MaterialTheme(createTextTheme(context, "Quicksand", "Poppins"));

    return BlocProvider(
      create: (context) => PasswordBloc(di.sl()),
      child: MaterialApp(
        title: 'SecuPass',
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: PasswordsScreen(),
      ),
    );
  }
}
