import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/usecase.dart';

class CreateTaskUseCase implements FutureUseCase<TaskEntity, DataState<TaskEntity>> {
  CreateTaskUseCase(this._taskRepository);

  TaskRepository _taskRepository;

  @override
  Future<DataState<TaskEntity>> run(TaskEntity input) {
    return _taskRepository.createTask(input);
  }
}
