import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/password_bloc.dart';
import '../widgets/password_card.dart';
import 'add_password_screen.dart';

class PasswordsScreen extends StatelessWidget {
  const PasswordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecuPass'),
        centerTitle: true,
      ),
      body: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          if (state is PasswordLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PasswordErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is PasswordLoadedState) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: state.passwords.length,
              itemBuilder: (context, index) {
                return PasswordCard(password: state.passwords[index]);
              },
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPasswordScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
