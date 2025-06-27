// File: lib/features/todos/presentation/widgets/todo_list_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_offline_first_exam/features/todos/domain/entities/todo.dart';
import 'package:flutter_offline_first_exam/features/todos/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoListItem extends ConsumerWidget {
  final Todo todo;
  const TodoListItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
        todo.description,
        style: TextStyle(
          decoration: todo.completed ? TextDecoration.lineThrough : null,
          color: todo.completed ? Colors.grey : null,
        ),
      ),
      leading: Checkbox(
        value: todo.completed,
        onChanged: (value) {
          ref.read(todosNotifierProvider.notifier).toggleTodo(todo.id);
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!todo.isSynced)
            const Tooltip(
              message: "Senkronize ediliyor...",
              child: Icon(Icons.sync, size: 20, color: Colors.amber),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              ref.read(todosNotifierProvider.notifier).deleteTodo(todo.id);
            },
          ),
        ],
      ),
    );
  }
}