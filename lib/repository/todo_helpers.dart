import 'package:hive/hive.dart';

import '../model/todo_model.dart';
import 'api_provider.dart';

class TodoRepository {
  final TodoApiService api;
  final Box box;

  TodoRepository(this.api, this.box);

  Future<List<Todo>> fetchRemoteTodos() async {
    return api.fetchTodos();
  }

  List<Todo> getCachedTodos() {
    final cached = box.get('todos', defaultValue: []);
    return (cached as List)
        .map((e) => Todo.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> cacheTodos(List<Todo> todos) async {
    await box.put(
      'todos',
      todos.map((e) => e.toJson()).toList(),
    );
  }

  Future<Todo> addTodo(String title) async {
    return api.addTodo(title);
  }

  Future<void> updateTodo(Todo todo) async {
    await api.updateTodo(todo);
  }

  Future<void> deleteTodo(int id) async {
    await api.deleteTodo(id);
  }
}
