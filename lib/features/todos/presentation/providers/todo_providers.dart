// File: lib/features/todos/presentation/providers/todo_providers.dart

import 'dart:math';
import 'package:flutter_offline_first_exam/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:flutter_offline_first_exam/features/todos/domain/entities/todo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_providers.g.dart';

@riverpod
class TodosNotifier extends _$TodosNotifier {
  @override
  Future<List<Todo>> build() async {
    final repository = ref.watch(todoRepositoryProvider);
    return repository.getTodos();
  }

  Future<void> addTodo(String description) async {
    final repository = ref.read(todoRepositoryProvider);
    final newTodo = Todo(
      id: Random().nextInt(999999), // Gerçek uygulamada UUID kullanılır
      description: description,
      completed: false,
    );

    // Optimistic UI
    state = AsyncData([...await future, newTodo.copyWith(isSynced: false)]);

    try {
      await repository.addTodo(newTodo);
      // Başarılı senkronizasyon sonrası UI'ı tekrar güncelle
      ref.invalidateSelf();
    } catch (e) {
      // Hata durumunda yeniden yükle
      ref.invalidateSelf();
    }
  }

  Future<void> toggleTodo(int id) async {
    final previousState = await future;
    Todo? todoToUpdate;
    final updatedList = [
      for (final todo in previousState)
        if (todo.id == id)
          (todoToUpdate = todo.copyWith(
            completed: !todo.completed,
            isSynced: false,
          ))
        else
          todo,
    ];

    state = AsyncData(updatedList);

    try {
      final repository = ref.read(todoRepositoryProvider);
      await repository.updateTodo(todoToUpdate!);
      ref.invalidateSelf();
    } catch (e) {
      state = AsyncData(previousState);
    }
  }

  Future<void> deleteTodo(int id) async {
    final previousState = await future;
    state = AsyncData(previousState.where((todo) => todo.id != id).toList());
    try {
      final repository = ref.read(todoRepositoryProvider);
      await repository.deleteTodo(id);
    } catch (e) {
      state = AsyncData(previousState);
    }
  }
}
