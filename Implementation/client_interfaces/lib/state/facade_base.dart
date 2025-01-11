import 'package:client_interfaces1/execution/executor.dart';
import 'package:client_interfaces1/service/service_client.dart';
import 'package:get_it/get_it.dart';

import 'facade_work.dart';

void setupFacade() {
  var serviceClient = ServiceClient("https://localhost:5000", Executor.observability);
  GetIt.instance.registerSingleton<FacadeWork>(FacadeWork(serviceClient));
}

class FacadeBase {
  final ServiceClient serviceClient;

  FacadeBase(this.serviceClient);
}