import 'package:equatable/equatable.dart';
import 'package:todo_app/common/enums/data_source_status.dart';
import 'package:todo_app/common/enums/status.dart';
import 'package:todo_app/domain/entities/task_entity.dart';

class TodoState extends Equatable {
  final List<TaskEntity>? tasks;
  final RequestStatus status;
  final DataSourceStatus dataStatus;
  final String? message;

  const TodoState({
    this.tasks,
    this.status = RequestStatus.initial,
    this.dataStatus = DataSourceStatus.initial,
    this.message,
  });

  TodoState copyWith({
    List<TaskEntity>? tasks,
    RequestStatus? status,
    DataSourceStatus? dataStatus,
    String? message,
  }) {
    return TodoState(
      tasks: tasks ?? this.tasks,
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
