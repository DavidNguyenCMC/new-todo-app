import 'package:todo_app/data/model/task/response_models/task_model.dart';
import 'package:todo_app/data/service/network/grpc/generated/todogrpc/todo.pb.dart';
import 'package:todo_app/domain/entities/task_entity.dart';

import 'mapper.dart';

class TaskModelToTodoMapper implements Mapper<TaskModel, Todo> {
  @override
  Todo map(TaskModel taskModel) {
    return Todo(
      id: taskModel.id,
      title: taskModel.name,
      description: taskModel.desc,
      createdAt: taskModel.createAt?.toUtc().toIso8601String(),
      expiredAt: taskModel.expiredAt?.toUtc().toIso8601String(),
      image: taskModel.image,
      status: taskModel.status?.rawValue,
    );
  }
}
