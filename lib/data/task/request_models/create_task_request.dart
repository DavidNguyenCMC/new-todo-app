import '../response_models/task_model.dart';

class CreateTaskRequest {
  CreateTaskRequest({required this.task});

  final TaskModel task;

  Map<String, dynamic> toJson() {
    return task.toJson();
  }
}
