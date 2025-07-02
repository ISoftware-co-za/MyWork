import 'package:client_interfaces1/model/work_type_list.dart';

import 'controller_user.dart';
import 'controller_work_types.dart';

class CoordinatorLogin {
  CoordinatorLogin(
      ControllerUser controllerUser, ControllerWorkTypes controllerWorkTypes)
      : _controllerUser = controllerUser,
        _controllerWorkTypes = controllerWorkTypes;

  Future login() async {
    final result = await _controllerUser.user.login('leonard.haley@grady.info', 'KEp[+BnDI;');
    _controllerWorkTypes.workTypes = WorkTypeList(result.workTypes);
  }

  final ControllerUser _controllerUser;
  final ControllerWorkTypes _controllerWorkTypes;
}
