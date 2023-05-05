import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/create_task_usecase.dart';

import '../repository/task_repository_test.mocks.dart';


void main() {
  group('Test Create Task UseCase:\n', () {
    final TaskRepository repository = MockTaskRepository();
    final CreateTaskUseCase createTaskUseCase = CreateTaskUseCase(repository);

    test('The tasks should be create success', () async {
      when(repository.createTask(any)).thenAnswer((_) => Future.value(DataSuccess(TaskEntity(
            name: 'Task test',
            desc: 'Task Desc',
            expiredAt: DateTime.now(),
            status: TaskStatus.inprogress,
          ))));

      final result = await createTaskUseCase.run(TaskEntity(
        name: 'Task test',
        desc: 'Task Desc',
        status: TaskStatus.inprogress,
      ));

      expect(result.data?.name, 'Task test');
    });

    test('The tasks should be create failed', () async {
      when(repository.createTask(any))
          .thenAnswer((_) => Future.value(DataFailed('Expired Time is required', 400)));

      final result = await createTaskUseCase.run(TaskEntity(
        name: 'Task test',
        desc: 'Task Desc',
        status: TaskStatus.inprogress,
      ));

      expect((result as DataFailed).statusCode, 400);
    });
  });
}
