import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_bloc/bloc/todo_bloc/todo_events.dart';
import 'package:task_manager_bloc/bloc/todo_bloc/todo_state.dart';

import '../../model/todo_model.dart';
import '../../repository/todo_helpers.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TodoRepository repository;

  List<Todo> _allTodos = [];
  List<Todo> _visibleTodos = [];
  String _searchQuery = '';

  TaskBloc(this.repository) : super(TaskLoading()) {
    on<LoadTasks>(_loadTasks);
    on<AddTask>(_addTask);
    on<ToggleTask>(_toggleTask);
    on<DeleteTask>(_deleteTask);
    on<SearchTasks>(_search);
  }

  Future<void> _loadTasks(LoadTasks event, Emitter emit) async {
    emit(TaskLoading());

    // 1️⃣ Load local cache first
    _allTodos = repository.getCachedTodos();
    _visibleTodos = List.from(_allTodos);

    if (_allTodos.isNotEmpty) {
      emit(TaskLoaded(_visibleTodos));
      return; // ⛔ STOP HERE — do NOT call API
    }

    // 2️⃣ Only call API if cache is EMPTY
    try {
      final remote = await repository.fetchRemoteTodos();
      _allTodos = remote;
      _visibleTodos = List.from(_allTodos);
      await repository.cacheTodos(_allTodos);
      emit(TaskLoaded(_visibleTodos));
    } catch (_) {
      emit(TaskError('No internet connection'));
    }
  }

  Future<void> _addTask(AddTask event, Emitter emit) async {
    final optimistic = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      title: event.title,
      completed: false,
    );

    _allTodos.insert(0, optimistic);
    _visibleTodos = List.from(_allTodos);
    emit(TaskLoaded(_visibleTodos));
    await repository.cacheTodos(_allTodos);

    try {
      final serverTodo = await repository.addTodo(event.title);
      final index = _allTodos.indexWhere((e) => e.id == optimistic.id);
      _allTodos[index] = serverTodo;
      _visibleTodos = List.from(_allTodos);
      emit(TaskLoaded(_visibleTodos));
      await repository.cacheTodos(_allTodos);
    } catch (_) {}
  }

  Future<void> _toggleTask(ToggleTask event, Emitter emit) async {
    final updated = event.todo.copyWith(completed: !event.todo.completed);

    final index = _allTodos.indexWhere((e) => e.id == updated.id);
    _allTodos[index] = updated;

    _visibleTodos = List.from(_allTodos);
    emit(TaskLoaded(_visibleTodos));
    await repository.cacheTodos(_allTodos);

    try {
      await repository.updateTodo(updated);
    } catch (_) {}
  }

  Future<void> _deleteTask(DeleteTask event, Emitter emit) async {
    _allTodos.removeWhere((e) => e.id == event.id);
    _visibleTodos = List.from(_allTodos);

    emit(TaskLoaded(_visibleTodos));
    await repository.cacheTodos(_allTodos);

    try {
      await repository.deleteTodo(event.id);
    } catch (_) {}
  }

  void _search(SearchTasks event, Emitter emit) {
    _searchQuery = event.query;
    if (event.query.isEmpty) {
      _visibleTodos = List.from(_allTodos);
    } else {
      _visibleTodos = _allTodos
          .where(
              (e) => e.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
    }
    emit(TaskLoaded(_visibleTodos, isSearching: _searchQuery.isNotEmpty));
  }
}
