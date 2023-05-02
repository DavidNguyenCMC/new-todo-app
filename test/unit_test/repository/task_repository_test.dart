import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/data/local/datasource/task_local_datasource.dart';
import 'package:todo_app/data/task/response_models/task_model.dart';
import 'package:todo_app/data/task/task_service.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/repositories/task_repository.dart';

import 'task_repository_test.mocks.dart';

@GenerateMocks([TaskLocalDatasource, SharedPreferences], customMocks: [MockSpec<TaskService>(onMissingStub: OnMissingStub.returnDefault)])
void main() {
  group('Test the Task Repository:\n', () {
    final service = MockTaskService();
    final localDatasource = MockTaskLocalDatasource();
    final repository =
        TaskRepositoryImpl(userService: service, taskLocalDatasource: localDatasource);

    test('The tasks should be fetch from cached', () async {
      when(localDatasource.getTasks()).thenAnswer((_) => Future.value([
        TaskModel(
          name: 'Task test 1',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        ),
        TaskModel(
          name: 'Task test 2',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        )
      ]));

      final result = await repository.getCachedTasks();

      expect(result?.length, 2);
    });

    test('The tasks should be fetch from server', () async {
      when(service.getTasks()).thenAnswer((_) => Future.value(DataSuccess([
            TaskModel(
              name: 'Task test 1',
              desc: 'Task Desc',
              status: TaskStatus.inprogress.rawValue,
            ),
            TaskModel(
              name: 'Task test 2',
              desc: 'Task Desc',
              status: TaskStatus.inprogress.rawValue,
            )
          ])));
      when(localDatasource.setTasks(any)).thenAnswer((_) => Future.value());

      final result = await repository.getTasks();

      expect(result.data?.length, 2);
    });

    test('The task should be create', () async {
      when(service.createTask(any)).thenAnswer((_) => Future.value(DataSuccess(TaskModel(
            name: 'Task test',
            desc: 'Task Desc',
            status: TaskStatus.inprogress.rawValue,
          ))));

      final result = await repository.createTask(Task(
        name: 'Task test',
        desc: 'Task Desc',
        status: TaskStatus.inprogress,
      ));

      expect(result.data?.name, 'Task test');
    });

    test('The task should be update status', () async {
      when(service.updateTask(any)).thenAnswer((_) => Future.value(DataSuccess(TaskModel(
            name: 'Task test',
            status: TaskStatus.complete.rawValue,
          ))));
      when(localDatasource.updateTask(any)).thenAnswer((_) => Future.value());
      final result = await repository.updateTask(Task(
        name: 'Task test',
        desc: 'Task Desc',
        status: TaskStatus.complete,
      ));
      expect(result.data?.status, TaskStatus.complete);
    });

    test('The task should be delete', () async {
      when(service.deleteTask(any)).thenAnswer((_) => Future.value(DataSuccess(true)));
      when(localDatasource.deleteTask(any)).thenAnswer((_) => Future.value());
      final result = await repository.deleteTask('12345');
      expect(result.data, true);
    });

    test('The tasks should be searched', () async {
      when(service.getTasks()).thenAnswer((_) => Future.value(DataSuccess([
        TaskModel(
          name: 'Learning',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        ),
        TaskModel(
          name: 'Walking',
          desc: 'Task Desc',
          status: TaskStatus.inprogress.rawValue,
        )
      ])));

      final result = await repository.searchTasks('Task');

      expect(result.data?.length, 2);
    });
  });
}
