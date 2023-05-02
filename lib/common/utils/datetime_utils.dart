DateTime startOfDay([DateTime? dateTime]) {
  final DateTime date = dateTime ?? DateTime.now();
  return DateTime(
    date.year,
    date.month,
    date.day,
  );
}

DateTime endOfDay([DateTime? dateTime]) {
  final DateTime date = dateTime ?? DateTime.now();
  return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}

DateTime joinDateTime(DateTime? date, DateTime? time) {
  final DateTime dateX = date ?? DateTime.now();
  final DateTime timeX = time ?? DateTime.now();
  return DateTime(dateX.year, dateX.month, dateX.day, timeX.hour, timeX.minute, timeX.second, 000);
}
