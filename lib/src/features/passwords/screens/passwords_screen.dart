import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safepass/src/core/app/injection_container.dart';
import 'package:safepass/src/core/ui/padding.dart';
import 'package:safepass/src/core/utils/utils.dart';
import 'package:safepass/src/features/password_generator/screens/password_generator_screen.dart';
import 'package:safepass/src/features/passwords/repository/password_repository.dart';

import '../../../core/extension/context_extension.dart';
import '../blocs/passwords_bloc/password_bloc.dart';
import '../widgets/password_card.dart';
import 'add_password_screen.dart';

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({super.key});

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _optionsButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<PasswordBloc>()..add(FetchPasswordsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('SafePass'),
                  floating: true,
                  centerTitle: true,
                  actions: [
                    IconButton(
                      key: _optionsButtonKey,
                      onPressed: () {
                        _showOverlay(context);
                      },
                      icon: Icon(Icons.more_vert_rounded),
                    )
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  sliver: BlocBuilder<PasswordBloc, PasswordState>(
                    builder: (context, state) {
                      if (state is PasswordLoading) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is PasswordErrorState) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              state.failure.toString(),
                            ),
                          ),
                        );
                      }
                      if (state is PasswordLoaded) {
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
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 32),
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
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
              padding16,
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PasswordGeneratorScreen(),
                    ),
                  ).then((_) {
                    context.read<PasswordBloc>().add(FetchPasswordsEvent());
                  });
                },
                child: const Icon(Icons.auto_awesome),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showOverlay(ctx) {
    // Find the render box of the options button
    final RenderBox? renderBox =
        _optionsButtonKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    // Calculate position
    final Size size = renderBox.size;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _removeOverlay,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // The actual menu
          Positioned(
            top: position.dy + size.height,
            right: 10,
            width: 230,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuItem(
                        "Import from Excel",
                        Icons.file_present_rounded,
                        () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx', 'xls'],
                          );

                          if (result != null) {
                            final filePath = result.files.single.path;
                            if (filePath != null) {
                              final result = await sl<PasswordRepository>()
                                  .importDataFromExcel(filePath);

                              result.fold(
                                (l) => Fluttertoast.showToast(
                                    msg: "Failed to import data"),
                                (r) => ctx
                                    .read<PasswordBloc>()
                                    .add(FetchPasswordsEvent()),
                              );
                            } else {
                              Fluttertoast.showToast(msg: "Failed to get file");
                            }
                          } else {
                            Fluttertoast.showToast(msg: "Failed to get file");
                          }

                          _removeOverlay();
                        },
                      ),
                      _buildMenuItem(
                        'Export to Excel',
                        Icons.save,
                        () {
                          showDialog(
                            context: ctx,
                            builder: (_) => AlertDialog(
                              title: Text(
                                'Are you sure?',
                                textAlign: TextAlign.center,
                              ),
                              content: Text(
                                'Exporting passwords to an Excel sheet will store them in an unencrypted format. Ensure you save the file in a secure location and delete it after use to protect your data. ',
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    authenticateUser().then((result) {
                                      if (result) {
                                        sl<PasswordRepository>()
                                            .exportDataToExcel();

                                        Navigator.pop(ctx);
                                      }
                                    });
                                  },
                                  child: Text("Export"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: Text("Cancel"),
                                ),
                              ],
                            ),
                          );
                          _removeOverlay();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Add overlay to the widget tree
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
