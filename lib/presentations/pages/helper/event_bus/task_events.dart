import 'package:todo_app/domain/entities/task_entity.dart';

class OnCreateTaskEvent {

  TaskEntity? task;

  OnCreateTaskEvent(this.task);
}

class OnUpdateTaskEvent {

  TaskEntity? task;

  OnUpdateTaskEvent(this.task);
}

class OnDeleteTaskEvent {

  TaskEntity? task;

  OnDeleteTaskEvent(this.task);
}