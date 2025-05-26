import 'package:get/get.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/models/auth.dart';
import 'package:studymind/services/auth.dart';
import 'package:studymind/services/storage.dart';

class User {
  final int id;
  final String uid;
  final bool isActive;
  final String name;
  final String email;
  final String? phone;
  final String? photo;
  final String provider;
  final Map<String, dynamic>? otherInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.uid,
    required this.isActive,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.provider,
    required this.otherInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uid: json['uid'],
      isActive: json['isActive'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'],
      provider: json['provider'],
      otherInfo: json['otherInfo'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'isActive': isActive,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'provider': provider,
      'otherInfo': otherInfo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthResponse({required this.accessToken, required this.refreshToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: User.fromJson(json['user']),
    );
  }
}

class AuthController extends GetxController {
  // Dependencies
  final AuthService authService = AuthServiceImpl();
  final StorageService storageService = StorageServiceImpl();

  final Rxn<User> user = Rxn<User>();
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  void checkAuthStatus() async {
    final user = await storageService.get(Key.user);
    if (user != null) {
      this.user.value = User.fromJson(await user);
      isAuthenticated.value = true;
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = LoginRequest(email: email, password: password);
      final response = await authService.login(request);

      if (response.success && response.data != null) {
        user.value = response.data?.user;
        isAuthenticated.value = true;

        // Save user data and token
        await storageService.set(Key.user, response.data?.user);
        if (response.data?.accessToken != null) {
          await storageService.set(Key.accessToken, response.data?.accessToken);
        }

        Notification().success('Welcome back, ${response.data?.user.name}!');
        return true;
      } else {
        errorMessage.value = response.message;
        Notification().error(response.message);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Notification().error('An unexpected error occurred');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Register method
  Future<bool> register(String email, String password, String name) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = RegisterRequest(email: email, password: password, name: name);
      final response = await authService.register(request);

      if (response.success && response.data != null) {
        user.value = response.data?.user;
        isAuthenticated.value = true;

        // Save user data and token
        await storageService.set(Key.user, response.data?.user);
        if (response.data?.accessToken != null) {
          await storageService.set(Key.accessToken, response.data?.accessToken);
        }

        Notification().success('Welcome, ${response.data?.user.name}! Account created successfully.');
        return true;
      } else {
        errorMessage.value = response.message;
        Notification().error(response.message);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Notification().error('An unexpected error occurred');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
