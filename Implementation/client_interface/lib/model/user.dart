import 'dart:core';

import 'package:get_it/get_it.dart';

import '../service/user/service_client_user.dart';
import 'work_type.dart';

class User {
  String? userID;
  //#region CONSTRUCTION

  User();

  //#endregion

  //#region METHODS

  Future<ResultLogin> login(String email, String password) async {
    var response = await _serviceClient
        .login(RequestLogin(email: email, password: password));
    userID = response.userId;
    return ResultLogin(
        userId: response.userId,
        workTypes: response.workTypes.map((e) => WorkType(e)).toList());
  }

  Future<bool> logout() async {
    await _serviceClient.logout() as ResponseLogin;
    return true;
  }

  //#endregion

//# region FIELDS

  final ServiceClientUser _serviceClient = GetIt.instance<ServiceClientUser>();

//#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class ResultLogin {
  final String userId;
  final List<WorkType> workTypes;

  ResultLogin({required this.userId, required this.workTypes});
}

//----------------------------------------------------------------------------------------------------------------------
