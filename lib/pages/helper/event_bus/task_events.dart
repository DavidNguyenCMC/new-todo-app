import '../../../models/task.dart';

class OnCreateTaskEvent {

  Task? task;

  OnCreateTaskEvent(this.task);
}

class OnUpdateTaskEvent {

  Task? task;

  OnUpdateTaskEvent(this.task);
}

class OnDeleteTaskEvent {

  Task? task;

  OnDeleteTaskEvent(this.task);
}