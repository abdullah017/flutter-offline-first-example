// File: lib/features/todos/data/datasources/todo_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:flutter_offline_first_exam/core/providers/app_providers.dart';
import 'package:flutter_offline_first_exam/features/todos/domain/entities/todo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_remote_datasource.g.dart';

// Bu, uzak sunucuyu taklit eden sahte bir veri kaynağıdır.
class FakeTodoRemoteDataSource {
  final Dio _dio;
  // Sahte veritabanı
  final List<Todo> _remoteTodos = [
    Todo(id: 1, description: "Riverpod öğren", completed: true),
    Todo(id: 2, description: "Isar kullan", completed: false),
    Todo(id: 3, description: "Makaleyi yaz", completed: false),
  ];

  FakeTodoRemoteDataSource(this._dio);

  Future<List<Todo>> getTodos() async {
    // Ağ gecikmesini simüle et
    await Future.delayed(const Duration(seconds: 1));
    // %10 ihtimalle hata fırlat
    // if (Random().nextDouble() < 0.1) throw Exception("500 Internal Server Error");
    return _remoteTodos;
  }

  Future<void> addTodo(Todo todo) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _remoteTodos.add(todo);
  }
  
  Future<void> updateTodo(Todo todo) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _remoteTodos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _remoteTodos[index] = todo;
    }
  }

  Future<void> deleteTodo(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _remoteTodos.removeWhere((t) => t.id == id);
  }
}

@riverpod
FakeTodoRemoteDataSource todoRemoteDataSource(TodoRemoteDataSourceRef ref) {
  return FakeTodoRemoteDataSource(ref.watch(dioProvider));
}