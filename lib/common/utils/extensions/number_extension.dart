import 'package:intl/intl.dart';

extension numX on num {
  String toPercent() {
    final NumberFormat format = NumberFormat.decimalPercentPattern(decimalDigits: 2);
    return format.format(this);
  }

  String toDefaultCurrencyFormat({int? decimalDigits}) {
    return (this < 0 ? '-' : '') + (r'$') + abs().toStringAsFixed(decimalDigits ?? 2);
  }

  String toMinuteString() {
    return '${this} mins';
  }

  String toHourFromMinute() {
    if (this >= 60) {
      final int hour = this ~/ 60;
      final num minute = this - hour * 60;
      if (minute > 0) {
        return '${hour}h${this - hour * 60}m';
      } else {
        return '${hour}h';
      }
    }
    return '${this}m';
  }

  String ordinal() {
    if (!(this >= 1)) {
      throw Exception('Invalid number');
    }

    if (this >= 11 && this <= 13) {
      return 'th';
    }

    switch (this % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
