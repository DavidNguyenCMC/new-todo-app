import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/usecase.dart';

class UpdateTaskUseCase implements FutureUseCase<TaskEntity, DataState<TaskEntity>> {
  UpdateTaskUseCase(this._taskRepository);

  TaskRepository _taskRepository;

  @override
  Future<DataState<TaskEntity>> run(TaskEntity input) {
    return _taskRepository.updateTask(input);
  }
}
