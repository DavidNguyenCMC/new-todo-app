import 'dart:async';

import 'package:get/get.dart';
import 'package:todo_app/common/event/event_bus_mixin.dart';
import 'package:todo_app/domain/usecase/delete_task_usecase.dart';
import 'package:todo_app/domain/usecase/get_cached_tasks_usecase.dart';
import 'package:todo_app/domain/usecase/get_tasks_usecase.dart';
import 'package:todo_app/domain/usecase/search_task_usecase.dart';
import 'package:todo_app/domain/usecase/update_task_usecase.dart';
import 'package:todo_app/pages/todo/controller/todo_state.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/enums/data_source_status.dart';
import '../../../common/enums/status.dart';
import '../../../domain/entities/task_entity.dart';
import '../../helper/event_bus/task_events.dart';

class TodoController extends GetxController with EventBusMixin {
  TodoController(
    this._getTaskUseCase,
    this._getCachedTasksUseCase,
    this._deleteTaskUseCase,
    this._searchTaskUseCase,
    this._updateTaskUseCase,
  ) {
    listenEvent<OnCreateTaskEvent>((_) => _fetchTasks());
    listenEvent<OnUpdateTaskEvent>((_) => _fetchTasks());
  }

  final GetTaskUseCase _getTaskUseCase;
  final GetCachedTasksUseCase _getCachedTasksUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final SearchTaskUseCase _searchTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;

  final Rx<TodoState> state = TodoState().obs;

  Future<void> initData() async {
    _getTasks();
  }

  Future<void> _getTasks() async {
    state(state.value.copyWith(dataStatus: DataSourceStatus.loading));
    try {
      final result = await _getCachedTasksUseCase.run();
      if (result != null) {
        state(state.value.copyWith(tasks: result, dataStatus: DataSourceStatus.refreshing));
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
      final result = await _getTaskUseCase.run();
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
      final result = await _searchTaskUseCase.run(text!);
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

  Future<void> deleteTask(TaskEntity? task) async {
    if (task?.id == null) {
      return;
    }
    state(state.value.copyWith(status: RequestStatus.requesting));
    try {
      final result = await _deleteTaskUseCase.run(task?.id);
      if (result is DataSuccess) {
        final newTasks = state.value.tasks?..removeWhere((element) => element.id == task?.id);
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
      state(state.value.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> updateTaskStatus(TaskEntity? task, bool value) async {
    if (task?.id == null) {
      return;
    }
    state(state.value.copyWith(status: RequestStatus.requesting));
    final newTask = TaskEntity(
      id: task?.id,
      name: task?.name,
      desc: task?.desc,
      createAt: task?.createAt,
      expiredAt: task?.expiredAt,
      status: value ? TaskStatus.complete : TaskStatus.inprogress,
      image: task?.image,
    );
    try {
      final result = await _updateTaskUseCase.run(newTask);
      if (result is DataSuccess) {
        final List<TaskEntity> newTasks = List.from(state.value.tasks ?? []);
        final index = newTasks.indexWhere((element) => element.id == newTask.id);
        if (index >= 0) {
          newTasks[index] = newTask;
        }
        state(state.value
            .copyWith(status: RequestStatus.success, message: result.message, tasks: newTasks));
        // await _fetchTasks();
        shareEvent(OnUpdateTaskEvent(task));
      } else {
        state(state.value.copyWith(status: RequestStatus.failed, message: result.message));
      }
    } catch (e) {
      state(state.value.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  void onSortByTitle() {
    final values = List<TaskEntity>.from(state.value.tasks ?? [])
      ..sort((a, b) {
        return (a.name ?? '').compareTo(b.name ?? '');
      });

    state(state.value.copyWith(tasks: values));
  }

  void onSortByDesc() {
    final values = List<TaskEntity>.from(state.value.tasks ?? [])
      ..sort((a, b) {
        return (a.desc ?? '').compareTo(b.desc ?? '');
      });

    state(state.value.copyWith(tasks: values));
  }

  void onSortByDate() {
    final values = List<TaskEntity>.from(state.value.tasks ?? [])
      ..sort((a, b) {
        return (a.createAt ?? DateTime.now()).compareTo(b.createAt ?? DateTime.now());
      });

    state(state.value.copyWith(tasks: values));
  }
}
