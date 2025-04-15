import 'package:client_interfaces1/service/work/service_client_work.dart';
import 'package:get_it/get_it.dart';

import '../service/user/service_client_user.dart';
import 'facade_user.dart';
import 'facade_work.dart';

void setupFacades() {
  final url = 'https://localhost:5000';

  var serviceClientWork = ServiceClientWork(url);
  GetIt.instance.registerSingleton<FacadeWork>(FacadeWork(serviceClientWork));

  var serviceClientUser = ServiceClientUser(url);
  GetIt.instance.registerSingleton<FacadeUser>(FacadeUser(serviceClientUser));
}

class FacadeBase {
  String nullToEmptyString(String? value) {
    return value ?? '';
  }
}
