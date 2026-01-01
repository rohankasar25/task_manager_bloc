import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_bloc/screens/search_appbar.dart';

import '../bloc/authentication_bloc/authentication_bloc.dart';
import '../bloc/authentication_bloc/authentication_events.dart';
import '../bloc/todo_bloc/todo_bloc.dart';
import '../bloc/todo_bloc/todo_events.dart';
import '../bloc/todo_bloc/todo_state.dart';
import '../utils.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskBloc>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple.withOpacity(0.5),
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                final shouldLogout = await showConfirmationDialog(
                  context: context,
                  title: 'Logout',
                  message: 'Are you sure you want to logout?',
                  confirmText: 'Logout',
                );

                if (shouldLogout) {
                  context.read<AuthBloc>().add(LogoutRequested());
                }
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchAppBar(
              onChanged: (value) => bloc.add(SearchTasks(value)),
            ),
          ),
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const LoadingView();
          }

          if (state is TaskError) {
            return ErrorView(
              message: state.message,
              onRetry: () => bloc.add(LoadTasks()),
            );
          }

          if (state is TaskLoaded) {
            if (state.todos.isEmpty) {
              if (state.isSearching) {
                return const SearchEmptyView();
              }
              return const EmptyView();
            }

            return RefreshIndicator(
              onRefresh: () async => bloc.add(LoadTasks()),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.todos.length,
                itemBuilder: (_, index) {
                  return TodoCard(
                    todo: state.todos[index],
                    onToggle: () => bloc.add(ToggleTask(state.todos[index])),
                    onDelete: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final shouldDelete = await showConfirmationDialog(
                        context: context,
                        title: 'Delete Task',
                        message: 'This task will be permanently deleted.',
                        confirmText: 'Delete',
                      );

                      if (shouldDelete) {
                        bloc.add(DeleteTask(state.todos[index].id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Task deleted')),
                        );
                      }
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskSheet(context, bloc),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context, TaskBloc bloc) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isValid = controller.text.trim().isNotEmpty &&
                controller.text.trim().length <= 100;

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                top: 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New Task',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// ✅ Validated TextField
                    TextFormField(
                      controller: controller,
                      autofocus: true,
                      maxLength: 100,
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() {}),
                      onFieldSubmitted: (_) {
                        if (formKey.currentState!.validate()) {
                          bloc.add(AddTask(controller.text.trim()));
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Task added')),
                          );
                        }
                      },
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) {
                          return 'Task title cannot be empty';
                        }
                        if (text.length < 3) {
                          return 'Task title must be at least 3 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter task title',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ✅ Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isValid
                              ? Colors.purple
                              : Colors.purple.withOpacity(0.4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isValid
                            ? () {
                                if (formKey.currentState!.validate()) {
                                  bloc.add(AddTask(controller.text.trim()));
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Task added')),
                                  );
                                }
                              }
                            : null,
                        child: const Text(
                          'Add Task',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
