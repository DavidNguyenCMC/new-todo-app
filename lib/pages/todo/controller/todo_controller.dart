import 'dart:async';

import 'package:get/get.dart';
import 'package:todo_app/common/event/event_bus_mixin.dart';
import 'package:todo_app/configs/grpc_config.dart';
import 'package:todo_app/data/service/grpc/task_grpc_service.dart';
import 'package:todo_app/pages/todo/controller/todo_state.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/enums/data_source_status.dart';
import '../../../common/enums/status.dart';
import '../../../models/task.dart';
import '../../../repositories/task_repository.dart';
import '../../helper/event_bus/task_events.dart';

class TodoController extends GetxController with EventBusMixin {
  TodoController(
    this._taskRepository,
  ) {
    listenEvent<OnCreateTaskEvent>((_) => _fetchTasks());
    listenEvent<OnUpdateTaskEvent>((_) => _fetchTasks());
  }

  final TaskRepository _taskRepository;

  final Rx<TodoState> state = TodoState().obs;

  Future<void> initData() async {
    _getTasks();
  }

  Future<void> _getTasks() async {
    state(state.value.copyWith(dataStatus: DataSourceStatus.loading));
    try {
      final result = await _taskRepository.getCachedTasks();
      if (result != null) {
        state(state.value
            .copyWith(tasks: result, dataStatus: DataSourceStatus.refreshing));
      } else {
        state(state.value.copyWith(dataStatus: DataSourceStatus.failed));
      }
      await _fetchTasks();
    } catch (e) {
      state(state.value.copyWith(dataStatus: DataSourceStatus.failed));
    }
  }

  Future<void> _fetchTasks() async {
    state(state.value.copyWith(dataStatus: DataSourceStatus.refreshing));
    try {
      final result = await _taskRepository.getTasks();
      if (result is DataSuccess) {
        state(state.value.copyWith(
            tasks: result.data,
            dataStatus: (result.data?.isNotEmpty ?? false)
                ? DataSourceStatus.success
                : DataSourceStatus.empty));
      } else {
        state(state.value.copyWith(dataStatus: DataSourceStatus.failed));
      }
    } catch (e) {
      state(state.value.copyWith(dataStatus: DataSourceStatus.failed));
    }
  }

  Future<void> onSearchTasks(String? text) async {
    if ((text ?? '').isEmpty) {
      await _fetchTasks();
      return;
    }
    state(state.value.copyWith(dataStatus: DataSourceStatus.refreshing));
    try {
      final result = await _taskRepository.searchTasks(text!);
      if (result is DataSuccess) {
        state(state.value.copyWith(
            tasks: result.data,
            dataStatus: (result.data?.isNotEmpty ?? false)
                ? DataSourceStatus.success
                : DataSourceStatus.empty));
      } else {
        state(state.value.copyWith(dataStatus: DataSourceStatus.failed));
      }
    } catch (e) {
      state(state.value.copyWith(dataStatus: DataSourceStatus.failed));
    }
  }

  Future<void> onRefresh() async {
    _fetchTasks();
  }

  Future<void> deleteTask(Task? task) async {
    if (task?.id == null) {
      return;
    }
    state(state.value.copyWith(status: RequestStatus.requesting));
    try {
      final result = await _taskRepository.deleteTask(task!.id!);
      if (result is DataSuccess) {
        final newTasks = state.value.tasks
          ?..removeWhere((element) => element.id == task.id);
        state(state.value.copyWith(
            tasks: newTasks,
            status: RequestStatus.success,
            dataStatus: (newTasks?.isNotEmpty ?? false)
                ? DataSourceStatus.success
                : DataSourceStatus.empty));
        shareEvent(OnDeleteTaskEvent(task));
      } else {
        state(state.value.copyWith(
          status: RequestStatus.failed,
          message: result.message,
        ));
      }
    } catch (e) {
      state(state.value
          .copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> updateTaskStatus(Task? task, bool value) async {
    if (task?.id == null) {
      return;
    }
    state(state.value.copyWith(status: RequestStatus.requesting));
    final newTask = Task(
      id: task?.id,
      name: task?.name,
      desc: task?.desc,
      createAt: task?.createAt,
      expiredAt: task?.expiredAt,
      status: value ? TaskStatus.complete : TaskStatus.inprogress,
      image: task?.image,
    );
    try {
      final result = await _taskRepository.updateTask(newTask);
      if (result is DataSuccess) {
        final List<Task> newTasks = List.from(state.value.tasks ?? []);
        final index =
            newTasks.indexWhere((element) => element.id == newTask.id);
        if (index >= 0) {
          newTasks[index] = newTask;
        }
        state(state.value.copyWith(
            status: RequestStatus.success,
            message: result.message,
            tasks: newTasks));
        // await _fetchTasks();
        shareEvent(OnUpdateTaskEvent(task));
      } else {
        state(state.value
            .copyWith(status: RequestStatus.failed, message: result.message));
      }
    } catch (e) {
      state(state.value
          .copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  void onSortByTitle() {
    final values = List<Task>.from(state.value.tasks ?? [])
      ..sort((a, b) {
        return (a.name ?? '').compareTo(b.name ?? '');
      });

    state(state.value.copyWith(tasks: values));
  }

  void onSortByDesc() {
    final values = List<Task>.from(state.value.tasks ?? [])
      ..sort((a, b) {
        return (a.desc ?? '').compareTo(b.desc ?? '');
      });

    state(state.value.copyWith(tasks: values));
  }

  void onSortByDate() {
    final values = List<Task>.from(state.value.tasks ?? [])
      ..sort((a, b) {
        return (a.createAt ?? DateTime.now())
            .compareTo(b.createAt ?? DateTime.now());
      });

    state(state.value.copyWith(tasks: values));
  }
}
