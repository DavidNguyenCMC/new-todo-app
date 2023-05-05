import 'package:get/get.dart';

import '../../../common/api_client/data_state.dart';
import '../../../common/enums/data_source_status.dart';
import '../../../common/enums/status.dart';
import '../../../common/event/event_bus_mixin.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../helper/event_bus/task_events.dart';
import 'complete_state.dart';

class CompleteController extends GetxController with EventBusMixin {
  CompleteController(this._taskRepository) {
    listenEvent<OnCreateTaskEvent>((_) => _getTasks());
    listenEvent<OnUpdateTaskEvent>((_) => _getTasks());
    listenEvent<OnDeleteTaskEvent>((_) => _getTasks());
  }

  TaskRepository _taskRepository;
  final Rx<CompleteState> state = CompleteState().obs;

  Future<void> initData() async {
    _getTasks();
  }

  Future<void> _getTasks() async {
    state(state.value.copyWith(dataStatus: DataSourceStatus.loading));
    try {
      final result = await _taskRepository.getCachedTasks();
      if (result != null) {
        final tasks = result.where((element) => element.status == TaskStatus.complete).toList();
        state(state.value.copyWith(task: tasks, dataStatus: DataSourceStatus.refreshing));
      } else {
        state(state.value.copyWith(dataStatus: DataSourceStatus.failed));
      }
      _fetchTasks();
    } catch (e) {
      state(state.value.copyWith(dataStatus: DataSourceStatus.failed));
    }
  }

  Future<void> _fetchTasks() async {
    state(state.value.copyWith(dataStatus: DataSourceStatus.refreshing));
    try {
      final result = await _taskRepository.getTasks();
      if (result is DataSuccess) {
        final tasks =
            result.data?.where((element) => element.status == TaskStatus.complete).toList();
        state(state.value.copyWith(
            task: tasks,
            dataStatus:
                (tasks?.isNotEmpty ?? false) ? DataSourceStatus.success : DataSourceStatus.empty));
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
      final result = await _taskRepository.deleteTask(task!.id!);
      if (result is DataSuccess) {
        final newTasks = state.value.tasks?..removeWhere((element) => element.id == task.id);
        state(state.value.copyWith(
            task: newTasks,
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
}
