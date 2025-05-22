part of 'service_client_user.dart';

class RequestAddWorkType {
  final String workType;

  RequestAddWorkType(this.workType);

  Map<String, dynamic> toJson() {
    return {
      'workType': workType,
    };
  }
}
