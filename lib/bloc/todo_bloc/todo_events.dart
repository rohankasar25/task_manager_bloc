import '../../model/todo_model.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  AddTask(this.title);
}

class ToggleTask extends TaskEvent {
  final Todo todo;
  ToggleTask(this.todo);
}

class DeleteTask extends TaskEvent {
  final int id;
  DeleteTask(this.id);
}

class SearchTasks extends TaskEvent {
  final String query;
  SearchTasks(this.query);
}
