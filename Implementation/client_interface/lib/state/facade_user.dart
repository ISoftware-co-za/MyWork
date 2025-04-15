import 'dart:core';

import '../service/user/service_client_user.dart';
import 'work_type.dart';

class FacadeUser {
  //#region CONSTRUCTION

  FacadeUser(this._serviceClient);

  //#endregion

  //#region METHODS

  Future<ResultLogin> login(String email, String password) async {
    var response = await _serviceClient
        .login(RequestLogin(email: email, password: password));
    return ResultLogin(
        userId: response.userId,
        workTypes: response.workTypes.map((e) => WorkType(e)).toList());
  }

  Future<bool> logout() async {
    await _serviceClient.logout() as ResponseLogin;
    return true;
  }

  Future<bool> addWorkType(String userId, String workType) async {
    await _serviceClient.addWorkType(
        userId, RequestAddWorkType(workType: workType));
    return true;
  }

  //#endregion

//# region FIELDS

  final ServiceClientUser _serviceClient;

//#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class ResultLogin {
  final String userId;
  final List<WorkType> workTypes;

  ResultLogin({required this.userId, required this.workTypes});
}

//----------------------------------------------------------------------------------------------------------------------
