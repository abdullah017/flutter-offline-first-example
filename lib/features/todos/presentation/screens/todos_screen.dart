// File: lib/features/todos/presentation/screens/todos_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_offline_first_exam/features/todos/presentation/providers/todo_providers.dart';
import 'package:flutter_offline_first_exam/features/todos/presentation/widgets/add_todo_dialog.dart';
import 'package:flutter_offline_first_exam/features/todos/presentation/widgets/todo_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosScreen extends ConsumerWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosState = ref.watch(todosNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline-First Todos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(todosNotifierProvider);
            },
          ),
        ],
      ),
      body: todosState.when(
        data: (todos) => todos.isEmpty
            ? const Center(child: Text("Henüz bir görev eklenmedi."))
            : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoListItem(todo: todo);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("Bir hata oluştu: $error")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTodoDialog(
              onAdd: (description) {
                ref.read(todosNotifierProvider.notifier).addTodo(description);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}