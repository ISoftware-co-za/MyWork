import 'dart:core';

import '../service/user_request_response.dart';
import '../service/user_service_client.dart';
import 'state_work_type.dart';

class FacadeUser {
  //#region CONSTRUCTION

  FacadeUser(this._serviceClient);

  //#endregion

  //#region METHODS

  Future<ResultLogin> login(String email, String password) async {
    var response = await _serviceClient.login(LoginRequest(email: email, password: password)) as LoginResponse;
    return ResultLogin(userId: response.userId, workTypes:  response.workTypes.map((e) => StateWorkType(e)).toList());
  }

  Future<bool> addWorkType(String userId, String workType) async {
    await _serviceClient.addWorkType(userId, AddWorkTypeRequest(workType: workType));
    return true;
  }

  //#endregion

//# region FIELDS

  final UserServiceClient _serviceClient;

//#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class ResultLogin {
  final String userId;
  final List<StateWorkType> workTypes;

  ResultLogin({required this.userId, required this.workTypes});
}

//----------------------------------------------------------------------------------------------------------------------
