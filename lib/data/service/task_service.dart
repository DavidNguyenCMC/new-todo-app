import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/data/model/task/request_models/create_task_request.dart';
import 'package:todo_app/data/model/task/request_models/update_task_request.dart';
import 'package:todo_app/data/model/task/response_models/task_model.dart';

abstract class TaskService {
  Future<DataState<List<TaskModel>>> getTasks();

  Future<DataState<TaskModel>> createTask(CreateTaskRequest data);

  Future<DataState<TaskModel>> updateTask(UpdateTaskRequest data);

  Future<DataState<bool>> deleteTask(String? taskId);
}
