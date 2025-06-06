import 'package:get_it/get_it.dart';

import '../service/user/service_client_user.dart';
import 'work_type.dart';

class WorkTypeList {
  List<WorkType> workTypes = [];

  WorkTypeList(List<WorkType> workTypes) : workTypes = workTypes;

  WorkType? findWorkType(String workTypeName) {
    WorkType? locatedWorkType;
    for (var workType in workTypes) {
      if (workType.lowercaseName == workTypeName) {
        locatedWorkType = workType;
        break;
      }
    }
    return locatedWorkType;
  }

  Iterable<Object> listItems([String filter = '']) {
    final lowerCaseFilter = filter.toLowerCase();
    return workTypes.where((element) => element.matchesFilter(lowerCaseFilter)).toList();
  }

  Future add(String userID, WorkType workType) async {
    ServiceClientUser serviceClient = GetIt.instance<ServiceClientUser>();
    final request = RequestAddWorkType(workType.name);
    await serviceClient.addWorkType(userID, request);
    workTypes.add(workType);
    workTypes.sort((a, b) => a.name.compareTo(b.name));
  }

  Future delete(WorkType workType) async {
    workTypes.remove(workType);
  }
}