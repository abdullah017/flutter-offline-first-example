// File: lib/core/providers/app_providers.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_providers.g.dart';

// Bu provider, main.dart'ta override edilecek.
@riverpod
Isar isar(IsarRef ref) {
  throw UnimplementedError('Isar provider was not overridden');
}

@riverpod
Dio dio(DioRef ref) {
  return Dio();
}

@riverpod
Connectivity connectivity(ConnectivityRef ref) {
  return Connectivity();
}