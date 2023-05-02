import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

import '../../../common/api_client/data_state.dart';
import 'request_models/create_task_request.dart';
import 'request_models/update_task_request.dart';
import 'response_models/task_model.dart';

abstract class TaskService {
  Future<DataState<List<TaskModel>>> getTasks();

  Future<DataState<TaskModel>> createTask(CreateTaskRequest data);

  Future<DataState<TaskModel>> updateTask(UpdateTaskRequest data);

  Future<DataState<bool>> deleteTask(String? taskId);
}

class TaskServiceImpl implements TaskService {
  TaskServiceImpl() : ref = FirebaseDatabase.instance.ref();
  final DatabaseReference ref;

  @override
  Future<DataState<List<TaskModel>>> getTasks() async {
    final snapshot = await ref.child('tasks').get();
    if (snapshot.exists) {
      Map<String, dynamic> js = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
      return DataSuccess(List.from((js['data'] as Map<dynamic, dynamic>)
          .entries
          .map((e) => TaskModel.fromJson(e.key as String, e.value as Map<dynamic, dynamic>))));
    } else {
      return DataFailed('No data available.');
    }
  }

  @override
  Future<DataState<TaskModel>> createTask(CreateTaskRequest data) async {
    final postData = data.toJson();
    ref.child('tasks/data').push();
    final Map<String, Map> updates = {};
    updates['/tasks/data/${data.task.id}'] = postData;

    return ref.update(updates).then((value) => DataSuccess(data.task), onError: (e) => DataFailed(e.toString()));
  }

  @override
  Future<DataState<TaskModel>> updateTask(UpdateTaskRequest data) async {
    final postData = data.toJson();
    final Map<String, Map> updates = {};
    updates['/tasks/data/${data.task.id}'] = postData;
    return ref
        .update(updates)
        .then((value) => DataSuccess(data.task), onError: (error) => DataFailed(error.toString()));
  }

  @override
  Future<DataState<bool>> deleteTask(String? taskId) async {
    return ref
        .child('tasks/data/$taskId')
        .remove()
        .then((value) => DataSuccess(true), onError: (error) => DataFailed(error.toString()));
  }
}
