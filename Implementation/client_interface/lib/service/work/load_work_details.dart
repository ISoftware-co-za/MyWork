import '../service_client_base.dart';

class LoadWorkDetails {
  String? description;

  LoadWorkDetails({this.description});
}

class WorkDetailsResponse extends ServiceClientResponse {
  LoadWorkDetails details;

  WorkDetailsResponse({required this.details});

  factory WorkDetailsResponse.fromJson(Map<String, dynamic> json) {
    var details = json['details'] as Map<String, dynamic>?;
    return WorkDetailsResponse(
      details: LoadWorkDetails(
          description: details!['description']
      ),
    );
  }
}