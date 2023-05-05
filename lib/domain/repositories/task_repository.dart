import 'package:todo_app/domain/entities/task_entity.dart';

import '../../common/api_client/data_state.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>?> getCachedTasks();

  Future<DataState<List<TaskEntity>>> getTasks();

  Future<DataState<TaskEntity>> createTask(TaskEntity? task);

  Future<DataState<TaskEntity>> updateTask(TaskEntity? task);

  Future<DataState<bool>> deleteTask(String? taskId);

  Future<DataState<List<TaskEntity>>> searchTasks(String? text);
}
