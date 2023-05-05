import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/get_cached_tasks_usecase.dart';

import '../repository/task_repository_test.mocks.dart';

void main() {
  group('Test Get Cached Tasks:\n', () {
    final TaskRepository repository = MockTaskRepository();
    final GetCachedTasksUseCase getCachedTasksUseCase = GetCachedTasksUseCase(repository);

    test('The tasks should be fetch from cached', () async {
      when(repository.getCachedTasks()).thenAnswer((_) => Future.value([
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
          ]));

      final result = await getCachedTasksUseCase.run();

      expect(result?.length, 2);
    });
  });
}
