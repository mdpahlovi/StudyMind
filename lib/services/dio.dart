import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:studymind/core/logger.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/routes/routes.dart';
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

    dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest, onResponse: onResponse, onError: onError));
  }

  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await storage.get(StorageKey.accessToken);
    final refreshToken = await storage.get(StorageKey.refreshToken);

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
    updateAccessToken(response);
    handler.next(response);
  }

  Future<void> onError(DioException error, ErrorInterceptorHandler handler) async {
    loggerSimp.e('ERROR: ${error.response?.data}');

    if (error.response?.statusCode == 401) {
      handleUnauthorize();
    } else {
      if (error.response != null) {
        Notification().error(error.response?.data['message'] ?? 'Something went wrong');
      } else {
        Notification().error(error.message ?? 'Something went wrong');
      }
    }

    handler.reject(error);
  }

  void updateAccessToken(Response<dynamic>? response) {
    final newAccessToken = response?.headers['x-access-token'];
    final currentAccessToken = storage.get(StorageKey.accessToken);

    if (newAccessToken != null && currentAccessToken != newAccessToken) {
      storage.set(StorageKey.accessToken, newAccessToken);
    }
  }

  void handleUnauthorize() {
    storage.remove(StorageKey.accessToken);
    storage.remove(StorageKey.refreshToken);

    Get.offAllNamed(AppRoutes.login);
  }
}
