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

  factory Password.fromEntity(Password password) {
    return Password(
      id: password.id,
      title: password.title,
      list: password.list
          .map((entry) => PasswordEntry.fromEntity(entry))
          .toList(),
    );
  }

  Password toEntity() {
    return Password(
      id: id,
      title: title,
      list: list.map((entry) => entry.toEntity()).toList(),
    );
  }
}
