import 'package:flutter/material.dart';

extension TimeX on TimeOfDay {
  DateTime toDate() {
    final DateTime now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
  }
}
