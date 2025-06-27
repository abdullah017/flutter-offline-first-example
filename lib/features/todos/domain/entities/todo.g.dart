// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => _$TodoImpl(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      completed: json['completed'] as bool,
      isSynced: json['isSynced'] as bool? ?? true,
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'completed': instance.completed,
      'isSynced': instance.isSynced,
    };
