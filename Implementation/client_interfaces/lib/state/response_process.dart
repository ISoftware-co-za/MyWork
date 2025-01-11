import 'package:client_interfaces1/service/validation_problem_response.dart';
import 'package:client_interfaces1/service/work.dart';

import '../service/service_client.dart';
import 'state_work.dart';

class ResponseProcessFactory {
  static ResponseProcess? createWorkProcessResponse(ServiceClientResponse? responseBody, StateWork work) {
    if (responseBody is WorkCreateResponse) {
      return ResponseProcessWorkCreated(responseBody, work);
    } else if (responseBody is ValidationProblemResponse) {
      return ResponseProcessWorkValidationProblem(responseBody, work);
    } else {
      return null;
    }
  }
}

abstract class ResponseProcess {
  void process();
}

class ResponseProcessWorkCreated extends ResponseProcess {
  ResponseProcessWorkCreated(WorkCreateResponse response, StateWork work) : _response = response, _work = work;

  @override
  void process() {
    _work.id = _response.id;
  }

  final WorkCreateResponse _response;
  final StateWork _work;
}

class ResponseProcessWorkValidationProblem extends ResponseProcess {
  ResponseProcessWorkValidationProblem(ValidationProblemResponse response, StateWork work) : _response = response, _work = work;

  @override
  void process() {
    _work.invalidate(_response.errors);
  }

  final ValidationProblemResponse _response;
  final StateWork _work;
}

