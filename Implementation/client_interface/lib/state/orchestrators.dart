import 'controller_user.dart';
import 'controller_work_types.dart';
import 'work_type.dart';

class OrchestratorLogin {
  OrchestratorLogin(
      ControllerUser controllerUser, ControllerWorkTypes controllerWorkTypes)
      : _controllerUser = controllerUser,
        _controllerWorkTypes = controllerWorkTypes;

  Future login() async {
    final List<WorkType> workTypes = await _controllerUser.login();
    _controllerWorkTypes.setWorkTypes(workTypes);
  }

  final ControllerUser _controllerUser;
  final ControllerWorkTypes _controllerWorkTypes;
}
