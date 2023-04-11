extension StringEmptyExtension on String {
  String emptyText (String defaultText) {
    if (isEmpty) {
      return defaultText;
    } else {
      return this;
    }
  }
}