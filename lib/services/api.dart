import 'package:dio/dio.dart';
import 'package:studymind/services/dio.dart';
import 'package:studymind/services/error.dart';

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;

  ApiResponse({required this.success, required this.message, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Something went wrong',
      data: json['data'],
    );
  }
}

class ApiService {
  final DioService dioService = DioService();

  Future<ApiResponse> get(String url, {queryParameters}) async {
    try {
      final response = await dioService.dio.get(url, queryParameters: queryParameters);

      return ApiResponse.fromJson(response.data);
    } catch (error) {
      final message = ErrorService.message(error as DioException);

      return ApiResponse(success: false, message: message, data: null);
    }
  }

  Future<ApiResponse> post(String url, {data}) async {
    try {
      final response = await dioService.dio.post(url, data: data);

      return ApiResponse.fromJson(response.data);
    } catch (error) {
      final message = ErrorService.message(error as DioException);

      return ApiResponse(success: false, message: message, data: null);
    }
  }

  Future<ApiResponse> patch(String url, {data}) async {
    try {
      final response = await dioService.dio.patch(url, data: data);

      return ApiResponse.fromJson(response.data);
    } catch (error) {
      final message = ErrorService.message(error as DioException);

      return ApiResponse(success: false, message: message, data: null);
    }
  }
}
