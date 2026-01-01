import '../../model/todo_model.dart';

abstract class TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Todo> todos;
  final bool isSearching;
  TaskLoaded(this.todos, {this.isSearching = false});
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
