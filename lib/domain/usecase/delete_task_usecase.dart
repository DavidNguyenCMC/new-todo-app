import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/usecase.dart';

class DeleteTaskUseCase implements FutureUseCase<String?, DataState<bool>> {
  DeleteTaskUseCase(this._taskRepository);
  TaskRepository _taskRepository;

  @override
  Future<DataState<bool>> run(String? input) {
    return _taskRepository.deleteTask(input);
  }
}