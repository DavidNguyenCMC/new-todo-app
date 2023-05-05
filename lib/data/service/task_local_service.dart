import 'package:todo_app/data/model/task/response_models/task_model.dart';
import 'package:todo_app/domain/entities/task_entity.dart';

abstract class TaskLocalService {
  Future<List<TaskModel>?> getTasks();

  Future<void> setTasks(List<TaskEntity> tasks);

  Future<void> updateTask(TaskEntity? task);

  Future<void> deleteTask(String? taskID);
}