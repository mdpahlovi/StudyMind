import 'package:dio/dio.dart';
import 'package:studymind/services/dio.dart';

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

  Future<ApiResponse> get(String url) async {
    try {
      final response = await dioService.dio.get(url);

      return ApiResponse.fromJson(response.data);
    } catch (error) {
      late String? message;

      if (error is DioException) {
        if (error.response != null) {
          message = error.response?.data['message'];
        } else {
          message = error.message;
        }
      }

      return ApiResponse(success: false, message: message ?? 'Something went wrong', data: null);
    }
  }

  Future<ApiResponse> post(String url, {data}) async {
    try {
      final response = await dioService.dio.post(url, data: data);

      return ApiResponse.fromJson(response.data);
    } catch (error) {
      late String? message;

      if (error is DioException) {
        if (error.response != null) {
          message = error.response?.data['message'];
        } else {
          message = error.message;
        }
      }
      return ApiResponse(success: false, message: message ?? 'Something went wrong', data: null);
    }
  }
}
