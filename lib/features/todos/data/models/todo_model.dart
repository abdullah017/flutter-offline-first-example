// File: lib/features/todos/data/models/todo_model.dart

import 'package:flutter_offline_first_exam/features/todos/domain/entities/todo.dart';
import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class TodoModel {
  // Isar'ın auto-increment ID'si. delete metodu için bu kullanılır.
  Id get isarId => fastHash(id.toString());

  @Index(unique: true, replace: true)
  final int id; // Bizim API'den gelen veya ürettiğimiz ID

  String description;
  bool completed;
  bool isSynced; // Verinin sunucu ile senkronize olup olmadığını tutar

  TodoModel({
    required this.id,
    required this.description,
    this.completed = false,
    this.isSynced = false, // Yeni oluşturulanlar varsayılan olarak senk. edilmemiştir
  });

  // Entity'den Model'e dönüşüm
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      description: todo.description,
      completed: todo.completed,
      isSynced: todo.isSynced,
    );
  }

  // Model'den Entity'ye dönüşüm
  Todo toEntity() {
    return Todo(
      id: id,
      description: description,
      completed: completed,
      isSynced: isSynced,
    );
  }
}

// Isar için stabil bir Id üretme fonksiyonu
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}