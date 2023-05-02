import '../response_models/task_model.dart';

class UpdateTaskRequest {
  UpdateTaskRequest({required this.task});

  final TaskModel task;

  Map<String, dynamic> toJson() {
    return task.toJson();
  }
}
