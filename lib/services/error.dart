import 'package:dio/dio.dart';

class ErrorService {
  static String message(DioException error) {
    if (error.response != null) {
      return error.response?.data['message'] ?? 'Something went wrong';
    } else {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return 'Connection error';
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout';
        case DioExceptionType.sendTimeout:
          return 'Send timeout';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout';
        default:
          return 'Something went wrong';
      }
    }
  }
}
