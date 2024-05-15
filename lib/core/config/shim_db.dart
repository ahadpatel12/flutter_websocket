import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class AppLocalKeys {
  String boxName = 'flutter-web';
}

class AppLocalDB extends AppLocalKeys {
  late Box box;
  // initialize db
  Future<void> init() async {
    box = Hive.box(boxName);
  }

  Future<void> write<T>({required String key, required T value}) async {
    return await box.put(key, value);
  }

  Future<T> read<T>(String key) async {
    return await box.get(key);
  }

  // close db
  Future<void> close() async {
    await box.close();
  }
}
