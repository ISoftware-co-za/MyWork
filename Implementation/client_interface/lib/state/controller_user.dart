import 'package:client_interfaces1/state/work_type.dart';
import 'package:get_it/get_it.dart';

import 'facade_user.dart';
import 'shared.dart';

class ControllerUser {
  Future<List<WorkType>> login() async {
    var result = await _facade.login('earnestine_wuckert@oga.us', 'g[4h"rK](U');
    _sharedData.userId = result.userId;
    return result.workTypes;
  }

  Future logout() async {
    await _facade.logout();
  }

  final FacadeUser _facade = GetIt.instance<FacadeUser>();
  final ServiceSharedData _sharedData = GetIt.instance<ServiceSharedData>();
}
