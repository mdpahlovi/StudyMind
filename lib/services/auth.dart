import 'package:dio/dio.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/models/auth.dart';
import 'package:studymind/services/api.dart';

abstract class AuthService {
  Future<ApiResponse<AuthResponse>> login(LoginRequest request);
  Future<ApiResponse<AuthResponse>> register(RegisterRequest request);
}

class AuthServiceImpl implements AuthService {
  final ApiService apiService = ApiService.instance;

  @override
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await apiService.post('/auth/login', data: request.toJson());

      if (response.statusCode == 200) {
        final user = AuthResponse.fromJson(response.data['data']);
        return ApiResponse<AuthResponse>(
          success: true,
          message: response.data['message'] ?? 'User logged in successfully',
          data: user,
        );
      } else {
        return ApiResponse<AuthResponse>(success: false, message: response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      return _handleDioError<AuthResponse>(e);
    } catch (e) {
      return ApiResponse<AuthResponse>(success: false, message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await apiService.post('/auth/register', data: request.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        final user = AuthResponse.fromJson(response.data['data']);
        return ApiResponse<AuthResponse>(
          success: true,
          message: response.data['message'] ?? 'Registration successful',
          data: user,
        );
      } else {
        return ApiResponse<AuthResponse>(success: false, message: response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      return _handleDioError<AuthResponse>(e);
    } catch (e) {
      return ApiResponse<AuthResponse>(success: false, message: 'Unexpected error: ${e.toString()}');
    }
  }

  ApiResponse<T> _handleDioError<T>(DioException e) {
    String message;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        message = e.response?.data['message'] ?? 'Server error';
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.unknown:
        message = 'Network error';
        break;
      default:
        message = 'Something went wrong';
    }

    return ApiResponse<T>(success: false, message: message);
  }
}
