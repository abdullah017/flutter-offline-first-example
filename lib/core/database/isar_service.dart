import 'package:flutter_offline_first_exam/features/todos/data/models/todo_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    // Eğer açık bir instance yoksa yenisini aç
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TodoModelSchema], // Veritabanı şemalarını buraya ekle
        directory: dir.path,
      );
    }
    // Zaten açıksa onu döndür
    return Future.value(Isar.getInstance());
  }
}
