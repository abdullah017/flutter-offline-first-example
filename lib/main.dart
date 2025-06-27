import 'package:flutter/material.dart';
import 'package:flutter_offline_first_exam/core/database/isar_service.dart';
import 'package:flutter_offline_first_exam/core/providers/app_providers.dart';
import 'package:flutter_offline_first_exam/features/todos/presentation/screens/todos_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Flutter binding'lerinin hazır olduğundan emin ol
  WidgetsFlutterBinding.ensureInitialized();

  // Isar veritabanını başlat
  final isarService = IsarService();
  final isar = await isarService.init();

  runApp(
    // Riverpod'ı tüm uygulama için etkinleştir
    // Isar instance'ını provider aracılığıyla tüm uygulamaya sun
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline-First Todos',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
        ),
      ),
      home: const TodosScreen(),
    );
  }
}