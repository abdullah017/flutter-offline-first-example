// File: lib/features/todos/domain/entities/todo.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required int id,
    required String description,
    required bool completed,
    // Senkronizasyon durumu için UI'da kullanılabilecek opsiyonel bir alan
    @Default(true) bool isSynced,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
