import 'package:grpc/grpc.dart';

import '../data/db.dart';
import '../generated/todo_barrel.dart';

class TodoService extends TodoServiceBase {
  @override
  Future<TodoCreateResponse> createTodo(
      ServiceCall call, TodoCreateRequest request) async {
    todos.add({
      'id': request.todo.id,
      'title': request.todo.title,
      'description': request.todo.description,
      'createdAt': request.todo.createdAt,
      'image': request.todo.image,
      'status': request.todo.status,
      'expiredAt': request.todo.expiredAt,
    });
    return TodoCreateResponse(result: true);
  }

  @override
  Future<TodoReadResponse> readTodo(
      ServiceCall call, TodoReadRequest request) async {
    print(request.id.isNotEmpty);
    if (request.id.isNotEmpty) {
      final todo = findTodo(request.id);
      return TodoReadResponse(todos: todo);
    }
    final List<Todo> listTodo = getTodoList();
    return TodoReadResponse(todos: listTodo);
  }

  @override
  Future<TodoUpdateResponse> updateTodo(
      ServiceCall call, TodoUpdateRequest request) async {
    var target =
        todos.firstWhere((element) => element['id'] == request.todo.id);
    target['id'] = request.todo.id;
    target['title'] = request.todo.title;
    target['description'] = request.todo.description;
    target['image'] = request.todo.image;
    target['status'] = request.todo.status;
    target['createdAt'] = request.todo.createdAt;
    target['expiredAt'] = request.todo.expiredAt;
    return TodoUpdateResponse(result: true);
  }

  @override
  Future<TodoDeleteResponse> deleteTodo(
      ServiceCall call, TodoDeleteRequest request) async {
    todos.removeWhere((e) => e['id'] == request.id);
    return TodoDeleteResponse(result: true);
  }
}

List<Todo> findTodo(String id) {
  return todos.where((e) => e['id'] == id).map(convertToTodo).toList();
}

List<Todo> getTodoList() {
  return todos.map(convertToTodo).toList();
}

Todo convertToTodo(Map todo) => Todo.fromJson(
    '{"1": "${todo['id']}", "2":"${todo['title']}", "3":"${todo['description']}", "4":"${todo['image']}", "5":"${todo['status']}", "6":"${todo['createdAt']}", "7":"${todo['expiredAt']}"}');
