import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/delete_task_usecase.dart';

import '../repository/task_repository_test.mocks.dart';

void main() {
  group('Test Delete Task UseCase:\n', () {
    final TaskRepository repository = MockTaskRepository();
    final DeleteTaskUseCase deleteTaskUseCase = DeleteTaskUseCase(repository);

    test('The tasks should be delete success', () async {
      when(repository.deleteTask(any)).thenAnswer((_) => Future.value(DataSuccess(true)));

      final result = await deleteTaskUseCase.run('1');

      expect(result.data, true);
    });

    test('The tasks should be delete failed', () async {
      when(repository.deleteTask(any))
          .thenAnswer((_) => Future.value(DataFailed('Somthing went wrong', 400)));

      final result = await deleteTaskUseCase.run('1');

      expect((result as DataFailed).statusCode, 400);
    });
  });
}
