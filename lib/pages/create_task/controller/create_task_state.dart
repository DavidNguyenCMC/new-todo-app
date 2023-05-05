import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/common/enums/status.dart';

import '../../../domain/entities/task.dart';

class CreateTaskState extends Equatable {
  const CreateTaskState({
    this.name,
    this.desc,
    this.status = RequestStatus.initial,
    this.message,
    this.task,
    this.expiredTime,
    this.image,
    this.imageByte,
  });

  final String? name;
  final String? desc;
  final DateTime? expiredTime;
  final RequestStatus status;
  final String? message;
  final Task? task;
  final File? image;
  final Uint8List? imageByte;

  CreateTaskState copyWith({
    Task? task,
    String? name,
    String? desc,
    RequestStatus? status,
    String? message,
    DateTime? expiredTime,
    File? image,
    Uint8List? imageByte,
  }) {
    return CreateTaskState(
      task: task ?? this.task,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      status: status ?? RequestStatus.initial,
      message: message ?? this.message,
      expiredTime: expiredTime ?? this.expiredTime,
      image: image ?? this.image,
      imageByte: imageByte ?? this.imageByte,
    );
  }

  @override
  List<Object?> get props => [
        this.task,
        this.name,
        this.desc,
        this.status,
        this.message,
        this.expiredTime,
        this.image,
        this.imageByte,
      ];
}
