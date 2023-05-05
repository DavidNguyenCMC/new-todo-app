import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/common/enums/status.dart';
import 'package:todo_app/common/event/event_bus_mixin.dart';
import 'package:todo_app/common/utils/photo_utils.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/usecase/create_task_usecase.dart';
import 'package:todo_app/domain/usecase/update_task_usecase.dart';
import 'package:todo_app/presentations/pages/helper/event_bus/task_events.dart';
import 'package:uuid/uuid.dart';

import 'create_task_state.dart';

class CreateTaskController extends GetxController with EventBusMixin {
  CreateTaskController(
    this._createTaskUseCase,
    this._updateTaskUseCase,
  );

  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final Rx<CreateTaskState> state = CreateTaskState().obs;

  void initData(TaskEntity? task) {
    state(state.value.copyWith(
      task: task,
      name: task?.name,
      desc: task?.desc,
    ));
  }

  void changeTaskName(String? name) {
    state(state.value.copyWith(name: name));
  }

  void changeTaskDesc(String? desc) {
    state(state.value.copyWith(desc: desc));
  }

  void changeTaskExpiredDate(DateTime? date) {
    state(state.value.copyWith(expiredTime: date));
  }

  void changeTaskImage(File? file, [Uint8List? imageByte]) {
    state(state.value.copyWith(image: file, imageByte: imageByte));
  }

  Future<void> updateTask() async {
    state(state.value.copyWith(status: RequestStatus.requesting));
    try {
      String? base64Image = await _getBase64Image(state.value.image, state.value.imageByte) ??
          state.value.task?.image;
      final task = TaskEntity(
        id: state.value.task?.id,
        name: state.value.name,
        desc: state.value.desc,
        createAt: state.value.task?.createAt,
        expiredAt: state.value.expiredTime ?? state.value.task?.expiredAt,
        status: state.value.task?.status,
        image: base64Image,
      );
      final result = await _updateTaskUseCase.run(task);
      if (result is DataSuccess) {
        state(state.value.copyWith(status: RequestStatus.success));
        shareEvent(OnUpdateTaskEvent(task));
      } else {
        state(state.value.copyWith(status: RequestStatus.failed, message: result.message));
      }
    } catch (e) {
      state(state.value.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<void> createTask() async {
    state(state.value.copyWith(status: RequestStatus.requesting));
    try {
      String? base64Image = await _getBase64Image(state.value.image, state.value.imageByte);
      final task = TaskEntity(
        id: Uuid().v1(),
        name: state.value.name,
        desc: state.value.desc,
        createAt: DateTime.now(),
        expiredAt: state.value.expiredTime,
        status: TaskStatus.inprogress,
        image: base64Image,
      );
      final result = await _createTaskUseCase.run(task);
      if (result is DataSuccess) {
        state(state.value.copyWith(status: RequestStatus.success));
        shareEvent(OnCreateTaskEvent(task));
      } else {
        state(state.value.copyWith(status: RequestStatus.failed));
      }
    } catch (e) {
      state(state.value.copyWith(status: RequestStatus.failed, message: e.toString()));
    }
  }

  Future<String?> _getBase64Image(File? file, [Uint8List? imageByte]) async {
    final Uint8List? imageBytes = imageByte ?? await file?.readAsBytes();
    final reduceSizeImage = await reduceImageQualityAndSize(imageBytes);
    String? base64Image = reduceSizeImage == null ? null : base64Encode(reduceSizeImage);
    return base64Image;
  }
}
