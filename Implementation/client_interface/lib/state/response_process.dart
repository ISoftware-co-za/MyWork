import '../service/service_client_base.dart';
import '../service/work/service_client_work.dart';
import 'state_work.dart';

class ResponseProcessFactory {
  static ResponseProcess? createWorkProcessResponse(
      ServiceClientResponse? responseBody, StateWork work) {
    if (responseBody is ResponseWorkCreate) {
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
  ResponseProcessWorkCreated(ResponseWorkCreate response, StateWork work)
      : _response = response,
        _work = work;

  @override
  void process() {
    _work.id = _response.id;
  }

  final ResponseWorkCreate _response;
  final StateWork _work;
}

class ResponseProcessWorkValidationProblem extends ResponseProcess {
  ResponseProcessWorkValidationProblem(
      ValidationProblemResponse response, StateWork work)
      : _response = response,
        _work = work;

  @override
  void process() {
    _work.invalidate(_response.errors);
  }

  final ValidationProblemResponse _response;
  final StateWork _work;
}
