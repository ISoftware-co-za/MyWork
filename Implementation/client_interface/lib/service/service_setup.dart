import 'package:client_interfaces1/service/work/service_client_work.dart';
import 'package:get_it/get_it.dart';

import 'user/service_client_user.dart';

void setupFacades() {
  final url = 'https://localhost:5000';

  var serviceClientWork = ServiceClientWork(url);
  GetIt.instance.registerSingleton<ServiceClientWork>(serviceClientWork);

  var serviceClientUser = ServiceClientUser(url);
  GetIt.instance.registerSingleton<ServiceClientUser>(serviceClientUser);
}

class FacadeBase {
  String nullToEmptyString(String? value) {
    return value ?? '';
  }
}
