import '../service_client_base.dart';

class LoadWorkDetails {
  String? description;

  LoadWorkDetails({this.description});
}

class LoadWorkDetailsResponse extends ServiceClientResponse {
  LoadWorkDetails details;

  LoadWorkDetailsResponse({required this.details});

  factory LoadWorkDetailsResponse.fromJson(Map<String, dynamic> json) {
    var details = json['details'] as Map<String, dynamic>?;
    return LoadWorkDetailsResponse(
      details: LoadWorkDetails(
          description: details!['description']
      ),
    );
  }
}