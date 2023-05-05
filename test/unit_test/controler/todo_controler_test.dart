import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/data/model/task/response_models/task_model.dart';
import 'package:todo_app/data/repository_implement/task_repository_implement.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/delete_task_usecase.dart';
import 'package:todo_app/domain/usecase/get_cached_tasks_usecase.dart';
import 'package:todo_app/domain/usecase/get_tasks_usecase.dart';
import 'package:todo_app/domain/usecase/search_task_usecase.dart';
import 'package:todo_app/domain/usecase/update_task_usecase.dart';
import 'package:todo_app/presentations/pages/todo/controller/todo_controller.dart';

import '../repository/task_repository_test.mocks.dart';

void main() {
  late MockTaskService service;
  late MockTaskLocalService localDatasource;
  late TaskRepository repository;
  late TodoController todoController;

  group('Test todo cubit:\n', () {
    setUp(() {
      service = MockTaskService();
      localDatasource = MockTaskLocalService();
      repository = TaskRepositoryImpl(userService: service, taskLocalDatasource: localDatasource);

      todoController = TodoController(
        GetTaskUseCase(repository),
        GetCachedTasksUseCase(repository),
        DeleteTaskUseCase(repository),
        SearchTaskUseCase(repository),
        UpdateTaskUseCase(repository),
      );
      mockInitData(localDatasource, service);
    });

    test('The data should be init', () async {
      await todoController.initData();
      expect(todoController.state.value.tasks?.length, 2);
    });

    test('The task should be change status', () async {
      final task = TaskEntity(
        id: '1',
        name: 'Test Task',
        status: TaskStatus.inprogress,
      );
      mockInitData(localDatasource, service);
      await todoController.initData();
      mockChangeTaskStatus(localDatasource, service);
      await todoController.updateTaskStatus(task, true);
      expect(todoController.state.value.tasks?.firstWhere((element) => element.id == '1').status,
          TaskStatus.complete);
    });

    test('The task should be delete', () async {
      final task = TaskEntity(
        id: '1',
        name: 'Test Task',
        status: TaskStatus.inprogress,
      );
      mockInitData(localDatasource, service);
      await todoController.initData();
      mockDeleteTask(localDatasource, service);
      await todoController.deleteTask(task);
      expect(todoController.state.value.tasks?.length, 1);
    });

    test('The task should be search', () async {
      await todoController.onSearchTasks('Task test 1');
      expect(todoController.state.value.tasks?.length, 1);
    });
  });
}

void mockInitData(localDatasource, service) {
  when(localDatasource.getTasks()).thenAnswer((_) => Future.value([
        TaskModel(
          id: '1',
          name: 'Task test 1',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        ),
        TaskModel(
          id: '2',
          name: 'Task test 2',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        )
      ]));
  when(service.getTasks()).thenAnswer((_) => Future.value(DataSuccess([
        TaskModel(
          id: '1',
          name: 'Task test 1',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        ),
        TaskModel(
          id: '2',
          name: 'Task test 2',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        )
      ])));
  when(service.searchTasks(any)).thenAnswer((_) => Future.value(DataSuccess([
        TaskModel(
          id: '1',
          name: 'Task test 1',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        ),
        TaskModel(
          id: '2',
          name: 'Task test 2',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        )
      ])));
}

void mockChangeTaskStatus(MockTaskLocalService localDatasource, MockTaskService service) {
  when(localDatasource.updateTask(any)).thenAnswer((_) => Future.value());
  when(service.updateTask(any)).thenAnswer((_) => Future.value(DataSuccess(TaskModel(
        id: '1',
        name: 'Test Task',
        status: TaskStatus.complete.rawValue,
      ))));
  when(localDatasource.getTasks()).thenAnswer((_) => Future.value([
        TaskModel(
          id: '1',
          name: 'Task test 1',
          desc: 'Task Desc',
          status: TaskStatus.complete.rawValue,
        ),
        TaskModel(
          id: '2',
          name: 'Task test 2',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        )
      ]));
  when(service.getTasks()).thenAnswer((_) => Future.value(DataSuccess([
        TaskModel(
          id: '1',
          name: 'Task test 1',
          desc: 'Task Desc',
          status: TaskStatus.complete.rawValue,
        ),
        TaskModel(
          id: '2',
          name: 'Task test 2',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        )
      ])));
}

void mockDeleteTask(MockTaskLocalService localDatasource, MockTaskService service) {
  when(localDatasource.deleteTask(any)).thenAnswer((_) => Future.value());
  when(service.deleteTask(any)).thenAnswer((_) => Future.value(DataSuccess(true)));
  when(localDatasource.getTasks()).thenAnswer((_) => Future.value([
        TaskModel(
          id: '2',
          name: 'Task test 2',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        )
      ]));
  when(service.getTasks()).thenAnswer((_) => Future.value(DataSuccess([
        TaskModel(
          id: '2',
          name: 'Task test 2',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        )
      ])));
}
