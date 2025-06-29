import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:studymind/core/logger.dart';

class StorageKey {
  static const String themeMode = 'themeMode';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String user = 'user';
}

class StorageService {
  final GetStorage storage = GetStorage();

  Future<void> set(String key, dynamic value) async {
    try {
      if (value == null) {
        await storage.remove(key);
        return;
      }

      if (value is String || value is int || value is double || value is bool) {
        await storage.write(key, value);
      } else {
        await storage.write(key, jsonEncode(value));
      }
    } catch (e) {
      loggerSimp.e('StorageService: Failed to store $key - $e');
    }
  }

  dynamic get(String key) {
    try {
      final value = storage.read(key);
      if (value == null) return null;

      if (value is String) {
        try {
          return jsonDecode(value);
        } catch (e) {
          return value;
        }
      }
      return value;
    } catch (e) {
      loggerSimp.e('StorageService: Failed to get $key - $e');
      return null;
    }
  }

  Future<void> remove(String key) async {
    try {
      await storage.remove(key);
    } catch (e) {
      loggerSimp.e('StorageService: Failed to remove $key - $e');
    }
  }

  Future<void> clear() async {
    try {
      await storage.erase();
    } catch (e) {
      loggerSimp.e('StorageService: Failed to clear storage - $e');
    }
  }
}
