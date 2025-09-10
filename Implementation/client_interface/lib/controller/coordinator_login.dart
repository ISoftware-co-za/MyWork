import 'package:client_interfaces1/model/work_type_list.dart';

import 'controller_user.dart';
import 'controller_work_types.dart';
import 'coordinator_base.dart';

class CoordinatorLogin extends CoordinatorBase {
  CoordinatorLogin(
      ControllerUser controllerUser, ControllerWorkTypes controllerWorkTypes)
      : _controllerUser = controllerUser,
        _controllerWorkTypes = controllerWorkTypes;

  Future login() async {
    final result = await _controllerUser.user.login('konopelski.ellie@franecki.us', '\$6^NIuB,6Y');
    _controllerWorkTypes.workTypes = WorkTypeList(result.workTypes);
  }

  final ControllerUser _controllerUser;
  final ControllerWorkTypes _controllerWorkTypes;
}
