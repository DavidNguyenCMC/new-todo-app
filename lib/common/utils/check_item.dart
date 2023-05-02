import 'dart:math';

import 'package:equatable/equatable.dart';

class CheckItem<T> extends Equatable {
  CheckItem({required this.value, this.checked = false});

  final int _id = Random().nextInt(10000);
  T value;
  bool checked;

  @override
  List<Object?> get props => <Object?>[_id];
}
