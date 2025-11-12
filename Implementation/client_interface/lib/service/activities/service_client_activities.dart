import 'dart:convert';

import '../service_client_base.dart';
import '../update_entity.dart';
import 'create_activity.dart';
import 'list_work_activities_response.dart';

class ServiceClientActivities extends ServiceClientBase {
  ServiceClientActivities(super.baseUrl);

  Future<ListWorkActivitiesResponse> listWorkActivities(String workID) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work/$workID/activities');
    final response = await httpGet(uri, headers);
    return processResponse(response, 200,
            () => ListWorkActivitiesResponse.fromJson(jsonDecode(response.body)))!
        as ListWorkActivitiesResponse;
  }

  Future<ServiceClientResponse?> create(String workID, CreateActivityRequest request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work/$workID/activities');
    final body = jsonEncode(request.toJson());
    final response = await httpPost(uri, headers, body);
    return processResponse(response, 201,
            () => CreateActivityResponse.fromJson(jsonDecode(response.body)))!;
  }

  Future<ServiceClientResponse?> update(String workID, String activityID, ChangeEntityRequest request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work/${workID}/activities/$activityID');
    final body = jsonEncode(request.toJson());
    final response = await httpPatch(uri, headers, body);
    return processResponse(response, 207, () => ChangeEntityResponse.fromJson(jsonDecode(response.body)))!;
  }

  Future delete(String workId, String id) async {
    Map<String, String> headers = setupCommonHeaders();
    var uri = generateUri('/work/$workId/activities/$id');
    final response = await httpDelete(uri, headers);
    processResponse(response, 204, () => null);
  }
}