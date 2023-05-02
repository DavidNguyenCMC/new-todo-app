import 'package:flutter/material.dart';

import 'date_extension.dart';

extension DateStringX on String {
  DateTime toDate() {
    return DateTime.parse(this);
  }

  TimeOfDay toTime() {
    return TimeOfDay.fromDateTime(this.toDate());
  }

  String toMMMMYYYYString() {
    return this.toDate().toMMMMYYYYString();
  }

  String toMMMDDString() {
    return this.toDate().toMMMDDString();
  }

  String toDDMMYYString() {
    return this.toDate().toDDMMYYString();
  }

  String toMMMDDYYYYString() {
    return this.toDate().toMMMDDYYYYString();
  }

  String toHHMMString() {
    return this.toDate().toHHMMString();
  }

  String toEEEDDMMMString() {
    return this.toDate().toEEEDDMMMString();
  }

  String toEEEEDDMMMMYYYYString() {
    return this.toDate().toEEEEDDMMMMYYYYString();
  }

  int toInt() {
    return int.tryParse(this) ?? 0;
  }

  double toDouble() {
    return double.tryParse(this) ?? 0;
  }
}

extension StringX on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}
