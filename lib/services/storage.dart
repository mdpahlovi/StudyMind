import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class Key {
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String user = 'user';
}

abstract class StorageService {
  Future<void> set(String key, dynamic value);
  Future<dynamic> get(String key);
  Future<void> remove(String key);
}

class StorageServiceImpl implements StorageService {
  final GetStorage storage = GetStorage();

  @override
  Future<void> set(String key, dynamic value) async {
    storage.write(key, jsonEncode(value));
  }

  @override
  Future<dynamic> get(String key) async {
    final value = storage.read(key);
    if (value != null) {
      return jsonDecode(value);
    }
    return null;
  }

  @override
  Future<void> remove(String key) async {
    storage.remove(key);
  }
}
