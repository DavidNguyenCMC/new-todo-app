import 'package:todo_app/common/utils/extensions/extension.dart';
import 'package:todo_app/models/task.dart';

class TaskModel extends Task {
  TaskModel({
    String? id,
    String? name,
    String? desc,
    DateTime? createAt,
    DateTime? expiredAt,
    String? status,
    String? image,
  }) : super(
          id: id,
          name: name,
          desc: desc,
          createAt: createAt,
          expiredAt: expiredAt,
          status: TaskStatusX.initFrom(status),
          image: image,
        );

  factory TaskModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return TaskModel(
      id: id,
      name: json['name'] as String?,
      desc: json['desc'] as String?,
      createAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String).toLocal(),
      expiredAt: json['expiredAt'] == null
          ? null
          : DateTime.parse(json['expiredAt'] as String).toLocal(),
      status: json['status'] == null ? null : json['status'] as String?,
      image: json['image'],
    );
  }

  factory TaskModel.fromLocalJson(Map<dynamic, dynamic> json) {
    return TaskModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      desc: json['desc'] as String?,
      createAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String).toLocal(),
      expiredAt: json['expiredAt'] == null
          ? null
          : DateTime.parse(json['expiredAt'] as String).toLocal(),
      status: json['status'] == null ? null : json['status'] as String?,
      image: json['image'],
    );
  }

  factory TaskModel.fromModel(Task? model) {
    return TaskModel(
      id: model?.id,
      name: model?.name,
      desc: model?.desc,
      createAt: model?.createAt,
      expiredAt: model?.expiredAt,
      status: model?.status?.rawValue,
      image: model?.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'createdAt': createAt?.toUtc().toIso8601String(),
      'expiredAt': expiredAt?.toUtc().toIso8601String(),
      'status': status?.rawValue,
      'image': image,
    }..removeNullAndEmpty();
  }
}
