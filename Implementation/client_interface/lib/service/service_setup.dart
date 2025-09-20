import 'package:client_interfaces1/service/work/service_client_work.dart';
import 'package:get_it/get_it.dart';

import 'activities/service_client_activities.dart';
import 'people/service_client_people.dart';
import 'users/service_client_user.dart';

void setupServiceClients() {
  final url = 'https://localhost:5000';

  var serviceClientWork = ServiceClientWork(url);
  GetIt.instance.registerSingleton<ServiceClientWork>(serviceClientWork);

  var serviceClientUser = ServiceClientUsers(url);
  GetIt.instance.registerSingleton<ServiceClientUsers>(serviceClientUser);

  var serviceClientActivity = ServiceClientActivities(url);
  GetIt.instance.registerSingleton<ServiceClientActivities>(serviceClientActivity);

  var serviceClientPeople = ServiceClientPeople(url);
  GetIt.instance.registerSingleton<ServiceClientPeople>(serviceClientPeople);
}

class FacadeBase {
  String nullToEmptyString(String? value) {
    return value ?? '';
  }
}
