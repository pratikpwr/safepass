extension StringExtension on String? {
  String capitalizeFirstLetter() {
    if (this == null || this!.isEmpty) return this ?? '';
    return this![0].toUpperCase() + this!.substring(1);
  }
}