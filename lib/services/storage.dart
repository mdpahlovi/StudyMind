import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class StorageKey {
  static const String themeMode = 'themeMode';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String user = 'user';
}

class StorageService {
  final GetStorage storage = GetStorage();

  void set(String key, dynamic value) {
    storage.write(key, jsonEncode(value));
  }

  dynamic get(String key) {
    final value = storage.read(key);
    if (value != null) {
      return jsonDecode(value);
    }
    return null;
  }

  void remove(String key) {
    storage.remove(key);
  }
}
