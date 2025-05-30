import 'dart:convert';

import 'package:get/get.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/models/auth.dart';
import 'package:studymind/routes/routes.dart';
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
  final AuthService authService = AuthService();
  final StorageService storageService = StorageService();

  final Rxn<User> user = Rxn<User>();
  final RxBool isLoading = true.obs; // Initial Loading
  final RxBool isLogging = false.obs;
  final RxBool isRegistering = false.obs;
  final RxBool isLoggedIn = false.obs;

  // Check if user is logged in
  void checkAuthStatus() {
    final accessToken = storageService.get(StorageKey.accessToken);
    final refreshToken = storageService.get(StorageKey.refreshToken);
    final currentUser = storageService.get(StorageKey.user);

    if (accessToken != null && refreshToken != null && currentUser != null) {
      user.value = User.fromJson(jsonDecode(currentUser));

      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }

    isLoading.value = false;
  }

  // Login method
  Future<void> login(String email, String password) async {
    isLogging.value = true;

    authService.login(LoginRequest(email: email, password: password)).then((response) {
      if (response.success && response.data != null) {
        final AuthResponse authResponse = AuthResponse.fromJson(response.data);

        user.value = authResponse.user;
        isLoggedIn.value = true;

        // Save user data and token
        storageService.set(StorageKey.user, jsonEncode(authResponse.user));
        storageService.set(StorageKey.accessToken, authResponse.accessToken);
        storageService.set(StorageKey.refreshToken, authResponse.refreshToken);

        Notification.success("Welcome back '${authResponse.user.name}'");
        Get.offAllNamed(AppRoutes.home);
      } else {
        Notification.error(response.message);
      }

      isLogging.value = false;
    });
  }

  // Register method
  Future<void> register(String email, String password, String name) async {
    isRegistering.value = true;

    authService.register(RegisterRequest(email: email, password: password, name: name)).then((response) {
      if (response.success && response.data != null) {
        final AuthResponse authResponse = AuthResponse.fromJson(response.data);

        user.value = authResponse.user;
        isLoggedIn.value = true;

        // Save user data and token
        storageService.set(StorageKey.user, jsonEncode(authResponse.user));
        storageService.set(StorageKey.accessToken, authResponse.accessToken);
        storageService.set(StorageKey.refreshToken, authResponse.refreshToken);

        Notification.success("Welcome '${authResponse.user.name}'");
        Get.offAllNamed(AppRoutes.home);
      } else {
        Notification.error(response.message);
      }

      isRegistering.value = false;
    });
  }
}
