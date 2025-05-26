import 'package:studymind/models/auth.dart';
import 'package:studymind/services/api.dart';

abstract class AuthService {
  Future<ApiResponse> login(LoginRequest request);
  Future<ApiResponse> register(RegisterRequest request);
}

class AuthServiceImpl implements AuthService {
  final ApiService apiService = ApiService();

  @override
  Future<ApiResponse> login(LoginRequest request) async {
    return await apiService.post('/auth/login', data: request.toJson());
  }

  @override
  Future<ApiResponse> register(RegisterRequest request) async {
    return await apiService.post('/auth/register', data: request.toJson());
  }
}
