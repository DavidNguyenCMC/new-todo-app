import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/get_tasks_usecase.dart';

import '../repository/task_repository_test.mocks.dart';


void main() {
  group('Test Get Task UseCase:\n', () {
    final TaskRepository repository = MockTaskRepository();
    final GetTaskUseCase getTaskUseCase = GetTaskUseCase(repository);

    test('The tasks should be fetch success', () async {
      when(repository.getTasks()).thenAnswer((_) => Future.value(DataSuccess([
            TaskEntity(
              name: 'Task test 1',
              desc: 'Task Desc',
              status: TaskStatus.inprogress,
            ),
            TaskEntity(
              name: 'Task test 2',
              desc: 'Task Desc',
              status: TaskStatus.inprogress,
            )
          ])));

      final result = await getTaskUseCase.run();

      expect(result.data?.length, 2);
    });

    test('The tasks should be fetch failure', () async {
      when(repository.getTasks())
          .thenAnswer((_) => Future.value(DataFailed('Some thing went wrong', 400)));

      final result = await getTaskUseCase.run();

      expect((result as DataFailed).statusCode, 400);
    });
  });
}
