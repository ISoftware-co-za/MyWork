import '../service_client_base.dart';

class WorkDetails {
  String? description;

  WorkDetails({this.description});
}

class WorkDetailsResponse extends ServiceClientResponse {
  WorkDetails details;

  WorkDetailsResponse({required this.details});

  factory WorkDetailsResponse.fromJson(Map<String, dynamic> json) {
    var details = json['details'] as Map<String, dynamic>?;
    return WorkDetailsResponse(
      details: WorkDetails(
          description: details!['description']
      ),
    );
  }
}