extension DateUpdates on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  bool equalsIgnoreTime (DateTime b, {bool checkHour = false}) {
    DateTime cleanThis = DateTime (year, month, day);
    DateTime cleanB = DateTime (b.year, b.month, b.day);

    if (checkHour) {
      cleanThis.add (Duration (hours: hour));
      cleanB.add (Duration (hours: b.hour));
    }

    return cleanThis.isAtSameMomentAs(cleanB);
  }
}