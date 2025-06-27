// File: lib/features/todos/data/repositories/todo_repository_impl.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_offline_first_exam/core/providers/app_providers.dart';
import 'package:flutter_offline_first_exam/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:flutter_offline_first_exam/features/todos/data/datasources/todo_remote_datasource.dart';
import 'package:flutter_offline_first_exam/features/todos/data/models/todo_model.dart';
import 'package:flutter_offline_first_exam/features/todos/domain/entities/todo.dart';
import 'package:flutter_offline_first_exam/features/todos/domain/repositories/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_repository_impl.g.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource _localDataSource;
  final FakeTodoRemoteDataSource _remoteDataSource;
  final Connectivity _connectivity;

  TodoRepositoryImpl(this._localDataSource, this._remoteDataSource, this._connectivity);

  @override
  Future<List<Todo>> getTodos() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final isConnected = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;

    if (isConnected) {
      try {
        final remoteTodos = await _remoteDataSource.getTodos();
        await _localDataSource.clearAll();
        await _localDataSource.saveTodos(
          remoteTodos.map((e) => TodoModel.fromEntity(e.copyWith(isSynced: true))).toList(),
        );
        return remoteTodos;
      } catch (e) {
        print("Remote fetch failed, serving from local: $e");
        final localModels = await _localDataSource.getTodos();
        return localModels.map((e) => e.toEntity()).toList();
      }
    } else {
      print("No connection, serving from local.");
      final localModels = await _localDataSource.getTodos();
      return localModels.map((e) => e.toEntity()).toList();
    }
  }

  @override
  Future<void> addTodo(Todo todo) async {
    // 1. Önce yerel veritabanına anında yaz (isSynced = false)
    await _localDataSource.addTodo(TodoModel.fromEntity(todo.copyWith(isSynced: false)));
    final connectivityResult = await _connectivity.checkConnectivity();
    final isConnected = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;

    if (isConnected) {
      try {
        await _remoteDataSource.addTodo(todo);
        // Senkronizasyon başarılı, yereldeki kaydı güncelle
        await _localDataSource.addTodo(TodoModel.fromEntity(todo.copyWith(isSynced: true)));
      } catch (e) {
        print("Failed to sync new todo with remote: $e. It's saved locally.");
      }
    }
  }
  
  @override
  Future<void> updateTodo(Todo todo) async {
    await _localDataSource.addTodo(TodoModel.fromEntity(todo.copyWith(isSynced: false)));
    final connectivityResult = await _connectivity.checkConnectivity();
    final isConnected = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;

    if (isConnected) {
      try {
        await _remoteDataSource.updateTodo(todo);
        await _localDataSource.addTodo(TodoModel.fromEntity(todo.copyWith(isSynced: true)));
      } catch (e) {
        print("Failed to sync updated todo with remote: $e.");
      }
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    await _localDataSource.deleteTodo(id);
    final connectivityResult = await _connectivity.checkConnectivity();
    final isConnected = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;

    if (isConnected) {
      try {
        await _remoteDataSource.deleteTodo(id);
      } catch (e) {
        print("Failed to sync deleted todo with remote: $e.");
        // Gelişmiş senaryo: Silinemeyen ID'leri bir listeye alıp bağlantı gelince sil.
      }
    }
  }
}

@riverpod
TodoRepository todoRepository(TodoRepositoryRef ref) {
  return TodoRepositoryImpl(
    ref.watch(todoLocalDataSourceProvider),
    ref.watch(todoRemoteDataSourceProvider),
    ref.watch(connectivityProvider),
  );
}