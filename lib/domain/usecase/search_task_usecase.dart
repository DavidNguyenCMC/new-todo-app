import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/usecase.dart';

class SearchTaskUseCase implements FutureUseCase<String?, DataState<List<TaskEntity>>> {
  SearchTaskUseCase(this._taskRepository);
  TaskRepository _taskRepository;
  @override
  Future<DataState<List<TaskEntity>>> run(String? input) {
    return _taskRepository.searchTasks(input);
  }
}