import 'dart:convert';
import 'package:injectable/injectable.dart';

import '../../../models/task.dart';
import '../../task/response_models/task_model.dart';
import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class TaskLocalDatasource {
  Future<List<TaskModel>?> getTasks();

  Future<void> setTasks(List<Task> tasks);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String? taskID);
}

class TaskLocalDatasourceImpl implements TaskLocalDatasource {
  TaskLocalDatasourceImpl(this._sharedPrefs);

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
  Future<void> setTasks(List<Task> tasks) async {
    await _sharedPrefs.put(SharedPrefsKey.tasks, jsonEncode(tasks));
  }

  @override
  Future<void> updateTask(Task task) async {
    final List<TaskModel>? tasks = await getTasks();
    final index = tasks?.indexWhere((element) => element.id == task.id) ?? -1;
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
