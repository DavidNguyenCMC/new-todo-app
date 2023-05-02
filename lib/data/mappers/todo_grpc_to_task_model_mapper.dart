import 'package:todo_app/data/generated/todo_barrel.dart';
import 'package:todo_app/data/task/response_models/task_model.dart';

import 'mapper.dart';

class TodoGrpcToTaskMapper implements Mapper<List<Todo>, List<TaskModel>> {
  @override
  List<TaskModel> map(List<Todo> todoList) {
    return todoList
        .map(
          (todo) => TaskModel(
            id: todo.id,
            name: todo.title,
            desc: todo.description,
            createAt: DateTime.parse(todo.createdAt).toLocal(),
            expiredAt: DateTime.parse(todo.expiredAt).toLocal(),
            image: todo.image,
            status: todo.status,
          ),
        )
        .toList();
  }
}
