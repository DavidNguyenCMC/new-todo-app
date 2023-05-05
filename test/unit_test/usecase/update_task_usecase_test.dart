import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/update_task_usecase.dart';

import '../repository/task_repository_test.mocks.dart';

void main() {
  group('Test Update Task UseCase:\n', () {
    final TaskRepository repository = MockTaskRepository();
    final UpdateTaskUseCase updateTaskUseCase = UpdateTaskUseCase(repository);

    test('The tasks should be update success', () async {
      when(repository.updateTask(any)).thenAnswer((_) => Future.value(DataSuccess(TaskEntity(
            name: 'Task test',
            desc: 'Task Desc',
            expiredAt: DateTime.now(),
            status: TaskStatus.complete,
          ))));

      final result = await updateTaskUseCase.run(TaskEntity(
        name: 'Task test',
        desc: 'Task Desc',
        status: TaskStatus.complete,
      ));

      expect(result.data?.status, TaskStatus.complete);
    });

    test('The tasks should be create failed', () async {
      when(repository.updateTask(any))
          .thenAnswer((_) => Future.value(DataFailed('Somthing went wrong', 400)));

      final result = await updateTaskUseCase.run(TaskEntity(
        name: 'Task test',
        desc: 'Task Desc',
        status: TaskStatus.complete,
      ));

      expect((result as DataFailed).statusCode, 400);
    });
  });
}
