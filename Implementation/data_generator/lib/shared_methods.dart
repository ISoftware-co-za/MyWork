import 'package:mongo_dart/mongo_dart.dart';

import 'document_details.dart';

class SharedMethods {
  static Future<Map<String, dynamic>> getUserFromId(String id, Db db) async {
    var users = await db
        .collection(DocumentCollections.users)
        .find({'_id': ObjectId.fromHexString(id)}).toList();
    if (users.isEmpty) {
      throw Exception('There is no user with _id $id');
    }
    var user = users[0];
    return user;
  }
}