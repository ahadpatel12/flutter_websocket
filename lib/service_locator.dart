import 'package:flutter_web/core/config/shim_db.dart';
import 'package:flutter_web/core/user/user.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // config
  sl.registerLazySingleton(() => AppLocalDB());
  sl.registerLazySingleton(() => User());
}
