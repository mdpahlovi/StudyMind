class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String email;
  final String password;
  final String name;

  RegisterRequest({required this.email, required this.password, required this.name});

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'password': password};
}
