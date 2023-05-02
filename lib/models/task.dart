import 'package:collection/collection.dart';

import '../common/resources/index.dart';

class Task {
  String? id;
  String? name;
  String? desc;
  DateTime? createAt;
  DateTime? expiredAt;
  TaskStatus? status;
  String? image;

  Task({
    this.id,
    this.name,
    this.desc,
    this.createAt,
    this.expiredAt,
    this.status,
    this.image,
  });
}

enum TaskStatus {
  complete, inprogress
}

extension TaskStatusX on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.complete:
        return Strings.localized.completed;
      case TaskStatus.inprogress:
        return Strings.localized.inProgress;
    }
  }

  String get rawValue {
    switch (this) {
      case TaskStatus.complete:
        return 'complete';
      case TaskStatus.inprogress:
        return 'in_progress';
    }
  }

  static TaskStatus? initFrom(String? value) {
    return TaskStatus.values
        .firstWhereOrNull((TaskStatus e) => e.rawValue.toLowerCase() == value?.toLowerCase());
  }
}
