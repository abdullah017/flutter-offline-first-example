// File: lib/features/todos/data/datasources/todo_local_datasource.dart

import 'package:flutter_offline_first_exam/core/providers/app_providers.dart';
import 'package:flutter_offline_first_exam/features/todos/data/models/todo_model.dart';
import 'package:isar/isar.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_local_datasource.g.dart';

class TodoLocalDataSource {
  final Isar _isar;
  TodoLocalDataSource(this._isar);

  Future<List<TodoModel>> getTodos() async {
    return _isar.todoModels.where().findAll();
  }

  Future<void> saveTodos(List<TodoModel> todos) async {
    await _isar.writeTxn(() async {
      await _isar.todoModels.putAll(todos);
    });
  }
  
  Future<void> addTodo(TodoModel todo) async {
    await _isar.writeTxn(() async {
      await _isar.todoModels.put(todo);
    });
  }

  Future<void> deleteTodo(int id) async {
    await _isar.writeTxn(() async {
      await _isar.todoModels.delete(fastHash(id.toString()));
    });
  }
  
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.todoModels.clear();
    });
  }
}

@riverpod
TodoLocalDataSource todoLocalDataSource(TodoLocalDataSourceRef ref) {
  return TodoLocalDataSource(ref.watch(isarProvider));
}