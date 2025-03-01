import 'package:hive/hive.dart';

part 'password.g.dart';

@HiveType(typeId: 1)
class Password {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> entries;

  @HiveField(3)
  final bool isFavourite;

  Password({
    required this.id,
    required this.title,
    required this.entries,
    this.isFavourite = false,
  });

  Password copyWith({
    String? title,
    List<String>? entries,
    bool? isFavourite,
  }) {
    return Password(
      id: id,
      title: title ?? this.title,
      entries: entries ?? this.entries,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
