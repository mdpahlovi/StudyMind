import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:studymind/core/logger.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/services/error.dart';
import 'package:studymind/services/storage.dart';

class DioService {
  final dio = Dio();
  final StorageService storage = StorageService();

  DioService() {
    initializeDio();
  }
  void initializeDio() {
    dio.options.baseUrl = 'https://studymind.onrender.com/api/v1';
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);
    dio.options.sendTimeout = const Duration(seconds: 60);

    dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest, onResponse: onResponse, onError: onError));
  }

  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = storage.get(StorageKey.accessToken);
    final refreshToken = storage.get(StorageKey.refreshToken);

    options.headers.putIfAbsent("Content-Type", () => "application/json");

    if (accessToken != null && refreshToken != null) {
      options.headers.addAll({"Authorization": 'Bearer $accessToken', "x-refresh-token": refreshToken});
    }

    loggerSimp.d('REQUEST => ${options.method} to ${options.path}');
    loggerSimp.d('BODY => ${jsonEncode(options.data)}');
    loggerSimp.d('QUERY => ${jsonEncode(options.queryParameters)}');

    handler.next(options);
  }

  Future<void> onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    loggerSimp.t(response.data);

    // Update access token if new access token is available
    await updateAccessToken(response);
    handler.next(response);
  }

  Future<void> onError(DioException error, ErrorInterceptorHandler handler) async {
    loggerSimp.e('ERROR: ${Error.message(error)}');

    if (error.response?.statusCode == 401) {
      await handleUnauthorized();
    }

    handler.reject(error);
  }

  Future<void> updateAccessToken(Response<dynamic>? response) async {
    try {
      final newAccessToken = response?.headers.value('x-access-token');

      if (newAccessToken != null) {
        final currentAccessToken = storage.get(StorageKey.accessToken);

        if (currentAccessToken != newAccessToken) {
          await storage.set(StorageKey.accessToken, newAccessToken);
          loggerSimp.d('Access token has been updated');
        }
      }
    } catch (e) {
      loggerSimp.e('Failed to update access token: $e');
    }
  }

  Future<void> handleUnauthorized() async {
    try {
      loggerSimp.w('Handling unauthorized access - clearing tokens');

      await storage.remove(StorageKey.accessToken);
      await storage.remove(StorageKey.refreshToken);
      await storage.remove(StorageKey.user);

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      loggerSimp.e('Failed to handle unauthorized: $e');
    }
  }
}
