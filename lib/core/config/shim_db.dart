import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class AppLocalKeys {
  static const String boxName = 'flutter-web';
  static const String user = 'user';
  static const String userList = 'user-list';
  static const String chats = 'chat';
}

class AppLocalDB extends AppLocalKeys {
  static late Box _box;

  // initialize db
  static Future<void> init() async {
    _box = await Hive.openBox(AppLocalKeys.boxName);
    print("box initiated");
  }

  static Future<void> putString(
      {required String key, required String value}) async {
    return await _box.put(key, value);
  }

  static Future<String> getString(String key) async {
    var res = await _box.get(key);
    return res is String ? res : '';
  }

  static Future<void> putBool(
      {required String key, required bool value}) async {
    return await _box.put(key, value);
  }

  static Future<bool> getBool(String key) async {
    var res = await _box.get(key);
    return res is bool ? res : false;
  }

  static Future<void> putList(
      {required String key, required List value}) async {
    return await _box.put(key, value);
  }

  static Future<List> getList(String key) async {
    var res = await _box.get(key);
    return res is List ? res : [];
  }

  static Future<void> putObject(
      {required String key, required Object value}) async {
    return await _box.put(key, value);
  }

  static Future getObject(String key) async {
    var res = await _box.get(key);
    return res;
  }

  static Future<void> putMap(
      {required String key, required Map<String, dynamic> value}) async {
    return await _box.put(key, value);
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
    var res = await _box.get(key);
    return res is Map<String, dynamic> ? res : null;
  }

  static Future<void> putInt({required String key, required int value}) async {
    return await _box.put(key, value);
  }

  static Future<int> getInt(String key) async {
    var res = await _box.get(key);
    return res is int ? res : 0;
  }

  static Future<void> delete(String key) async {
    return await _box.delete(key);
  }

  static Future<int> deleteAll() async {
    return await _box.clear();
  }

  // close db
  Future<void> close() async {
    await _box.close();
  }
}
