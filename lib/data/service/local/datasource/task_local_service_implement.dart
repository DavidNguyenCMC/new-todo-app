import 'dart:convert';

import 'package:todo_app/data/model/task/response_models/task_model.dart';
import 'package:todo_app/data/service/task_local_service.dart';
import 'package:todo_app/domain/entities/task_entity.dart';

import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

class TaskLocalServiceImplement implements TaskLocalService {
  TaskLocalServiceImplement(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  Future<List<TaskModel>?> getTasks() async {
    final String? data = _sharedPrefs.get(SharedPrefsKey.tasks);
    if (data == null) {
      return null;
    }
    return List<TaskModel>.from((jsonDecode(data) as List<dynamic>).map<TaskModel>(
      (dynamic x) => TaskModel.fromLocalJson(x as Map<String, dynamic>),
    ));
  }

  @override
  Future<void> setTasks(List<TaskEntity> tasks) async {
    await _sharedPrefs.put(SharedPrefsKey.tasks, jsonEncode(tasks));
  }

  @override
  Future<void> updateTask(TaskEntity? task) async {
    final List<TaskModel>? tasks = await getTasks();
    final index = tasks?.indexWhere((element) => element.id == task?.id) ?? -1;
    if (index >= 0) {
      tasks?[index] = TaskModel.fromModel(task);
      setTasks(List.from((tasks ?? []).map((e) => e)));
    }
  }

  @override
  Future<void> deleteTask(String? taskID) async {
    final List<TaskModel>? tasks = await getTasks();
    tasks?.removeWhere((element) => element.id == taskID);
    setTasks(List.from((tasks ?? []).map((e) => e)));
  }
}
