import 'package:studymind/models/auth.dart';
import 'package:studymind/services/api.dart';

class AuthService {
  final ApiService apiService = ApiService();

  Future<ApiResponse> login(LoginRequest request) async {
    return await apiService.post('/auth/login', data: request.toJson());
  }

  Future<ApiResponse> register(RegisterRequest request) async {
    return await apiService.post('/auth/register', data: request.toJson());
  }
}
