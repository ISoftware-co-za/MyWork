import 'dart:convert';

import 'package:http/http.dart' as http;

import 'parent.dart';

class ServiceClient {

  Future<List<Parent>> getParents() async {
    http.Response? response;

    try
    {
      var uri = "$_baseUrl/data";
      response = await http.get(Uri.parse(uri));
    }
    catch (e)
    {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      List<Parent> parents = list.map((item) => Parent.fromJson(item)).toList();
      return parents;
    } else {
      throw Exception('Failed to load parents');
    }
  }

  static const String _baseUrl = "http://localhost:8080";

}
