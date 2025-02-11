import 'service_base.dart';

//----------------------------------------------------------------------------------------------------------------------

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

//----------------------------------------------------------------------------------------------------------------------

class LoginResponse extends ServiceClientResponse {
  final String userId;
  final List<String> workTypes;

  LoginResponse({required this.userId, required this.workTypes});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'],
      workTypes: List<String>.from(json['workTypes']),
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------

class AddWorkTypeRequest {
  final String workType;

  AddWorkTypeRequest({required this.workType});

  Map<String, dynamic> toJson() {
    return {
      'workType': workType,
    };
  }
}


//----------------------------------------------------------------------------------------------------------------------