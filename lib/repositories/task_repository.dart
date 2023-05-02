import 'package:injectable/injectable.dart';

import '../common/api_client/data_state.dart';
import '../data/local/datasource/task_local_datasource.dart';
import '../data/task/request_models/create_task_request.dart';
import '../data/task/request_models/update_task_request.dart';
import '../data/task/response_models/task_model.dart';
import '../data/task/task_service.dart';
import '../models/task.dart';

abstract class TaskRepository {
  Future<List<Task>?> getCachedTasks();

  Future<DataState<List<Task>>> getTasks();

  Future<DataState<Task>> createTask(Task? task);

  Future<DataState<Task>> updateTask(Task task);

  Future<DataState<bool>> deleteTask(String? taskId);

  Future<DataState<List<Task>>> searchTasks(String? text);
}

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(
      {required TaskService userService, required TaskLocalDatasource taskLocalDatasource})
      : _taskService = userService,
        _taskLocalDatasource = taskLocalDatasource;

  final TaskService _taskService;
  final TaskLocalDatasource _taskLocalDatasource;

  @override
  Future<DataState<Task>> createTask(Task? task) {
    return _taskService.createTask(CreateTaskRequest(task: TaskModel.fromModel(task)));
  }

  @override
  Future<DataState<bool>> deleteTask(String? taskId) async {
    final result = await _taskService.deleteTask(taskId);
    if (result.isSuccess()) {
      _taskLocalDatasource.deleteTask(taskId);
    }
    return result;
  }

  @override
  Future<DataState<List<Task>>> getTasks() async {
    final result = await _taskService.getTasks();
    if (result is DataSuccess && result.data != null) {
      _taskLocalDatasource.setTasks(result.data!);
    }
    return _taskService.getTasks();
  }

  @override
  Future<List<Task>?> getCachedTasks() async {
    return _taskLocalDatasource.getTasks();
  }

  @override
  Future<DataState<Task>> updateTask(Task task) async {
    final result =
        await _taskService.updateTask(UpdateTaskRequest(task: TaskModel.fromModel(task)));
    if (result.isSuccess()) {
      _taskLocalDatasource.updateTask(task);
    }
    return result;
  }

  @override
  Future<DataState<List<Task>>> searchTasks(String? text) async {
    final result = await _taskService.getTasks();
    List<TaskModel>? tasks;
    if (result.isSuccess() && result.data != null) {
      tasks = result.data
          ?.where((element) =>
              (element.name ?? '').toLowerCase().contains((text ?? '').toLowerCase()) ||
              (element.desc ?? '').toLowerCase().contains((text ?? '').toLowerCase()))
          .toList();
    }

    return DataSuccess(tasks);
  }
}
