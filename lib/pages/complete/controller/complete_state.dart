import 'package:equatable/equatable.dart';
import 'package:todo_app/common/enums/status.dart';

import '../../../common/enums/data_source_status.dart';
import '../../../domain/entities/task_entity.dart';

class CompleteState extends Equatable {
  final List<TaskEntity>? tasks;
  final RequestStatus status;
  final DataSourceStatus dataStatus;
  final String? message;

  const CompleteState({
    this.tasks,
    this.status = RequestStatus.initial,
    this.dataStatus = DataSourceStatus.initial,
    this.message,
  });

  CompleteState copyWith({
    List<TaskEntity>? task,
    RequestStatus? status,
    DataSourceStatus? dataStatus,
    String? message,
  }) {
    return CompleteState(
      tasks: task ?? this.tasks,
      status: status ?? RequestStatus.initial,
      dataStatus: dataStatus ?? this.dataStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    this.tasks,
    this.status,
    this.dataStatus,
    this.message,
  ];
}
