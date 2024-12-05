import 'package:hive/hive.dart';

part 'password_entry.g.dart';

@HiveType(typeId: 0)
class PasswordEntry {
  @HiveField(0)
  final String id; // Unique string ID for each entry

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final String site;

  @HiveField(4)
  final String? note;

  PasswordEntry({
    required this.id,
    required this.username,
    required this.password,
    required this.site,
    this.note,
  });

  factory PasswordEntry.fromEntity(PasswordEntry entry) {
    return PasswordEntry(
      id: entry.id,
      username: entry.username,
      password: entry.password,
      site: entry.site,
      note: entry.note,
    );
  }

  PasswordEntry toEntity() {
    return PasswordEntry(
      id: id,
      username: username,
      password: password,
      site: site,
      note: note,
    );
  }
}
