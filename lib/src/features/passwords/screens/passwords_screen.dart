import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safepass/src/core/extension/context_extension.dart';

import '../bloc/password_bloc.dart';
import '../widgets/password_card.dart';
import 'add_password_screen.dart';

class PasswordsScreen extends StatelessWidget {
  const PasswordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('SecuPass'),
              floating: true,
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              sliver: BlocBuilder<PasswordBloc, PasswordState>(
                builder: (context, state) {
                  if (state is PasswordLoadingState) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is PasswordErrorState) {
                    return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text('Error: ${state.message}')));
                  }
                  if (state is PasswordLoadedState) {
                    if (state.passwords.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/mobile_encrypt.svg',
                                height: 200,
                                // width: 100,
                                fit: BoxFit.fitHeight,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 32),
                                child: Text(
                                  "Create, save, and manage your passwords so you can easily sign in to sites and apps.",
                                  textAlign: TextAlign.center,
                                  style: context.theme.textTheme.bodyLarge,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return SliverList.builder(
                      itemCount: state.passwords.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              "Create, save, and manage your passwords so you can easily sign in to sites and apps.",
                              textAlign: TextAlign.center,
                              style: context.theme.textTheme.bodyLarge,
                            ),
                          );
                        }
                        return PasswordCard(
                            password: state.passwords[index - 1]);
                      },
                    );
                  }
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: const Center(
                      child: Text('No data available'),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPasswordScreen(),
            ),
          ).then((_) {
            context.read<PasswordBloc>().add(FetchPasswordsEvent());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
