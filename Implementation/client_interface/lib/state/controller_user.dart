import 'package:get_it/get_it.dart';

import 'controller_work_types.dart';
import 'facade_user.dart';

class ControllerUser {

  String? userId;

  ControllerUser(ControllerWorkTypes workTypesController) {
    _workTypesController = workTypesController;
  }

  Future login() async {
    var result = await _facade.login('earnestine_wuckert@oga.us', 'g[4h"rK](U');
    userId = result.userId;
    _workTypesController.setWorkTypes(result.workTypes);
  }

  final FacadeUser _facade = GetIt.instance<FacadeUser>();
  late ControllerWorkTypes _workTypesController;
}