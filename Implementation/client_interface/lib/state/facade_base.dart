import 'package:client_interfaces1/execution/executor.dart';
import 'package:client_interfaces1/service/work_service_client.dart';
import 'package:get_it/get_it.dart';

import '../service/user_service_client.dart';
import 'facade_user.dart';
import 'facade_work.dart';

void setupFacades() {
  final url = 'https://localhost:5000';

  var serviceClientWork = WorkServiceClient(url, Executor.observabilityFactory.createObservability());
  GetIt.instance.registerSingleton<FacadeWork>(FacadeWork(serviceClientWork));

  var serviceClientUser = UserServiceClient(url, Executor.observabilityFactory.createObservability());
  GetIt.instance.registerSingleton<FacadeUser>(FacadeUser(serviceClientUser));
}
