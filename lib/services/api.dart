import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:studymind/core/logger.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T? data) {
    return ApiResponse<T>(success: json['success'] ?? false, message: json['message'] ?? '', data: data);
  }
}

// services/api_service.dart

class ApiService {
  static ApiService? _instance;
  late Dio _dio;

  ApiService._() {
    _dio = Dio();
    _initializeInterceptors();
  }

  static ApiService get instance {
    _instance ??= ApiService._();
    return _instance!;
  }

  void _initializeInterceptors() {
    _dio.options = BaseOptions(
      baseUrl: 'https://your-api-base-url.com/api/v1',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final accessToken = GetStorage().read('accessToken');
          // final refreshToken = GetStorage().read('refreshToken');

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          logger.d('REQUEST: ${options.method}');
          logger.d('HEADERS: ${options.headers}');
          logger.d('DATA: ${options.data}');

          handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d('RESPONSE: ${response.statusCode}');
          logger.d('DATA: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          logger.e('ERROR: ${error.message}');
          logger.e('RESPONSE: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}
