import 'package:hive/hive.dart';

import 'password_entry.dart';

part 'password.g.dart';

@HiveType(typeId: 1)
class Password {
  @HiveField(0)
  final String id; // Unique string ID for each password group

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<PasswordEntry> list;

  Password({
    required this.id,
    required this.title,
    required this.list,
  });

  Password copyWith({
    String? title,
    List<PasswordEntry>? list,
  }) {
    return Password(
      id: id,
      title: title ?? this.title,
      list: list ?? this.list,
    );
  }
}
