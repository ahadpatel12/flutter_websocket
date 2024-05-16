import 'package:uuid/uuid.dart';

import '../config/shim_db.dart';

class User {
  final String? id;
  final String name;
  final String password;

  User({
    this.id,
    this.name = '',
    this.password = '',
  });

  User copyWith({
    String? id,
    String? name,
    String? password,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        password: password ?? this.password,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        password: json["password"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": const Uuid().v1(),
        "name": name,
        "password": password,
      };

  static Future<void> save(User user) async {
    var userList = await AppLocalDB.getList(AppLocalKeys.userList);
    if (userList.isNotEmpty) {
      userList.add(user);
      await AppLocalDB.putList(key: AppLocalKeys.user, value: userList);
    }
    return await AppLocalDB.putObject(key: AppLocalKeys.user, value: user);
  }

  static Future<User?> get() async {
    var res = await AppLocalDB.getMap(AppLocalKeys.user);
    if (res != null) {
      User.fromJson(res);
    }
    return null;
  }

  static Future<void> logout() async {
    return await AppLocalDB.delete(AppLocalKeys.user);
  }
}
