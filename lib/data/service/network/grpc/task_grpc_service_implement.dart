import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/data/mappers/task_model_to_todo_mapper.dart';
import 'package:todo_app/data/mappers/todo_grpc_to_task_model_mapper.dart';
import 'package:todo_app/data/model/task/request_models/create_task_request.dart';
import 'package:todo_app/data/model/task/request_models/update_task_request.dart';
import 'package:todo_app/data/model/task/response_models/task_model.dart';
import 'package:todo_app/data/service/network/grpc/generated/todogrpc/todo.pbgrpc.dart';
import 'package:todo_app/data/service/task_service.dart';

class TaskGrpcService implements TaskService {
  ClientChannel clientChannel;

  TaskGrpcService({
    required this.clientChannel,
  });

  @override
  Future<DataState<TaskModel>> createTask(CreateTaskRequest data) async {
    final stub = TodoServiceClient(clientChannel);
    try {
      await stub.createTodo(TodoCreateRequest(
        todo: TaskModelToTodoMapper().map(data.task),
      ));
      return DataSuccess(data.task);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<bool>> deleteTask(String? taskId) async {
    final stub = TodoServiceClient(clientChannel);
    try {
      await stub.deleteTodo(
        TodoDeleteRequest(id: taskId),
      );
      return DataSuccess(true);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<List<TaskModel>>> getTasks() async {
    final stub = TodoServiceClient(clientChannel);
    try {
      var response = await stub.readTodo(TodoReadRequest());
      return DataSuccess(TodoGrpcToTaskMapper().map(response.todos));
    } catch (_) {
      return DataFailed('No data available.');
    }
  }

  @override
  Future<DataState<TaskModel>> updateTask(UpdateTaskRequest data) async {
    final stub = TodoServiceClient(clientChannel);
    try {
      await stub.updateTodo(TodoUpdateRequest(
        todo: TaskModelToTodoMapper().map(data.task),
      ));
      return DataSuccess(data.task);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
