import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/usecase.dart';

class GetCachedTasksUseCase implements FutureOutputUseCase<List<TaskEntity>?> {
  GetCachedTasksUseCase(this._taskRepository);

  TaskRepository _taskRepository;

  @override
  Future<List<TaskEntity>?> run() {
    return _taskRepository.getCachedTasks();
  }
}
