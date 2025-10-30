import 'dart:io';

import 'package:data_generator/shared_methods.dart';
import 'package:faker/faker.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'document_details.dart';
import 'generator_base.dart';

class GeneratorWork extends GeneratorBase {
  @override
  String get collectionName => 'work';

  @override
  String validate(List<String> arguments) {
    if (arguments.length == 2) {
      _count = int.tryParse(arguments[0]);
      _userId = arguments[1];
    }
    String? validationMessage = '';
    if (_count != null && (_count! < 1 || _count! > 1000000)) {
      validationMessage +=
          'Count must be greater and equal to 1, and less than 1000000.';
    }
    if (_userId.isEmpty) {
      validationMessage +=
          'Work is generated for a user. The _id of this user must be specified as the second command line parameter.';
    }
    return validationMessage;
  }

  @override
  Future generate(Db db) async {
    Map<String, dynamic> user = await SharedMethods.getUserFromId(_userId, db);

    String description = 'GeneratorWork: Generating $_count Work documents for ${user[UserProperties.email]}.';
    stdout.writeln('');
    stdout.writeln('');
    stdout.writeln(description);

    int documentCount = 0;
    List<dynamic> workTypes = user['workTypes'] as List<dynamic>;
    String? workType = (workTypes.isNotEmpty)
        ? Faker().randomGenerator.element(user['workTypes']).toString()
        : null;
    int workCount = (_count != null)
        ? _count!
        : Faker().randomGenerator.integer(1000000, min: 0);
    for (int count = 1; count <= workCount; ++count) {
      var work = {
        WorkProperties.userId: user['_id'],
        WorkProperties.name: Faker().lorem.sentence(),
        WorkProperties.type:
            Faker().randomGenerator.integer(10, min: 0) >= 5 ? workType : null,
        WorkProperties.reference: Faker().randomGenerator.integer(10, min: 0) >= 8
            ? Faker().vehicle.vin()
            : null,
        WorkProperties.archived:
            Faker().randomGenerator.integer(10, min: 0) >= 8 ? true : false,
      };
      var result = await db.collection('work').insertOne(work);
      if (!result.isSuccess) {
        throw Exception('Failed to insert work record: $work');
      }
      if (documentCount % activityIndicatorCount == 0) {
        stdout.write('.');
      }
      ++documentCount;
    }
  }

  @override
  void writeCommandDescription() {
    stdout.writeln(
        '$collectionName - Adds new work documents for each existing user in the $collectionName collection.');
  }

  @override
  writeCommandLineParameters() {
    stdout.writeln(
        '    p1 on is an optional count. If not specified then is a random value from 0 to 1 000 000 for each user document.');
    stdout.writeln(
        '    p2 is the _id of the user the activities will be generated for.');
  }

  int? _count;
  String _userId = '';
}
