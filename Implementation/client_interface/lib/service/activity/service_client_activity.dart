import 'dart:convert';

import '../service_client_base.dart';
import 'create_activity.dart';

class ServiceClientActivity extends ServiceClientBase {
  ServiceClientActivity(super.baseUrl);

  Future<ServiceClientResponse?> create(String workID, RequestCreateActivity request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work/$workID');
    final body = jsonEncode(request.toJson());
    final response = await httpPost(uri, headers, body);
    return processResponse(response, 201,
            () => ResponseCreateActivity.fromJson(jsonDecode(response.body)))!;
  }
}