import 'dart:core';

import 'package:get_it/get_it.dart';

import '../service/users/service_client_user.dart';
import 'work_type.dart';

class User {
  String? userID;

  Future<ResultLogin> login(String email, String password) async {
    var response = await _serviceClient
        .login(LoginRequest(email: email, password: password));
    userID = response.userId;
    return ResultLogin(
        userId: response.userId,
        workTypes: response.workTypes.map((e) => WorkType(e)).toList());
  }

  Future<bool> logout() async {
    await _serviceClient.logout();
    return true;
  }

  final ServiceClientUsers _serviceClient = GetIt.instance<ServiceClientUsers>();
}

//----------------------------------------------------------------------------------------------------------------------

class ResultLogin {
  final String userId;
  final List<WorkType> workTypes;

  ResultLogin({required this.userId, required this.workTypes});
}