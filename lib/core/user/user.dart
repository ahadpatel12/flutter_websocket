import '../config/shim_db.dart';

class User {
  final String name;
  final String password;

  User({
    this.name = '',
    this.password = '',
  });

  static Future<void> save(User user) async {
    return await AppLocalDB.write(key: AppLocalKeys.user, value: user);
  }

  static Future<User> get() async {
    return await AppLocalDB.read(AppLocalKeys.user);
  }

  static Future<void> logout() async {
    return await AppLocalDB.delete(AppLocalKeys.user);
  }
}
