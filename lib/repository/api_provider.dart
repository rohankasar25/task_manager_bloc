import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/todo_model.dart';

class TodoApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final list = json.decode(response.body) as List;
      return list.take(20).map((e) => Todo.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch todos');
  }

  Future<Todo> addTodo(String title) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'completed': false}),
    );

    return Todo.fromJson(json.decode(response.body));
  }

  Future<void> updateTodo(Todo todo) async {
    await http.patch(
      Uri.parse('$_baseUrl/${todo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'completed': todo.completed}),
    );
  }

  Future<void> deleteTodo(int id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
  }
}
