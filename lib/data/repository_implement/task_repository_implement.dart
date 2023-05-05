import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/data/model/task/request_models/create_task_request.dart';
import 'package:todo_app/data/model/task/request_models/update_task_request.dart';
import 'package:todo_app/data/model/task/response_models/task_model.dart';
import 'package:todo_app/data/service/task_local_service.dart';
import 'package:todo_app/data/service/task_service.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(
      {required TaskService userService, required TaskLocalService taskLocalDatasource})
      : _taskService = userService,
        _taskLocalDatasource = taskLocalDatasource;

  final TaskService _taskService;
  final TaskLocalService _taskLocalDatasource;

  @override
  Future<DataState<TaskEntity>> createTask(TaskEntity? task) {
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
  Future<DataState<List<TaskEntity>>> getTasks() async {
    final result = await _taskService.getTasks();
    if (result is DataSuccess && result.data != null) {
      _taskLocalDatasource.setTasks(result.data!);
    }
    return _taskService.getTasks();
  }

  @override
  Future<List<TaskEntity>?> getCachedTasks() async {
    return _taskLocalDatasource.getTasks();
  }

  @override
  Future<DataState<TaskEntity>> updateTask(TaskEntity? task) async {
    final result =
        await _taskService.updateTask(UpdateTaskRequest(task: TaskModel.fromModel(task)));
    if (result.isSuccess()) {
      _taskLocalDatasource.updateTask(task);
    }
    return result;
  }

  @override
  Future<DataState<List<TaskEntity>>> searchTasks(String? text) async {
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
