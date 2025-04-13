part of 'service_client_user.dart';

class RequestLogin {
  final String email;
  final String password;

  RequestLogin({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class ResponseLogin extends ServiceClientResponse {
  final String userId;
  final List<String> workTypes;

  ResponseLogin({required this.userId, required this.workTypes});

  factory ResponseLogin.fromJson(Map<String, dynamic> json) {
    return ResponseLogin(
      userId: json['userId'],
      workTypes: List<String>.from(json['workTypes']),
    );
  }
}
