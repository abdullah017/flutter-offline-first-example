// File: lib/features/todos/domain/repositories/todo_repository.dart

import 'package:flutter_offline_first_exam/features/todos/domain/entities/todo.dart';

// Bu soyut sınıf, veri katmanının nasıl davranması gerektiğini tanımlar.
// Presentation katmanı sadece bu arayüzü bilir.
abstract interface class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(int id);
}