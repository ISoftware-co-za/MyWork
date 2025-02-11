import 'dart:io';

import 'package:faker/faker.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'generator_base.dart';

class GeneratorWork extends GeneratorBase {

  @override
  String get collectionName => 'work';

  @override
  String validate(List<String> arguments) {
    if (arguments.isNotEmpty) {
      _count = int.tryParse(arguments[0]);
    }
    String? validationMessage = '';
    if (_count != null && (_count! < 1 || _count! > 1000000)) {
      validationMessage += 'Count must be greater and equal to 1, and less than 1000000.';
    }

    return validationMessage;
  }

  @override
  Future generate(Db db) async {
    var currentUsers = await db.collection('users').find().toList();

    String description;
    if (_count != null) {
      description = 'GeneratorWork: Generating $_count Work documents for ${currentUsers.length} users.';
    } else {
      description = 'GeneratorWork: Generating Work documents for ${currentUsers.length} users.';
    }
    stdout.writeln('');
    stdout.writeln('');
    stdout.writeln(description);

    int documentCount= 0;
    for (var user in currentUsers) {
      List<dynamic> workTypes = user['workTypes'] as List<dynamic>;
      String? workType = (workTypes.isNotEmpty) ? Faker().randomGenerator.element(user['workTypes']).toString() : null;
      int workCount = (_count != null) ? _count! : Faker().randomGenerator.integer(1000000, min: 0);
      for (int count = 1; count <= workCount; ++count) {
        var work = {
          'user_id': user['_id'],
          'name': Faker().lorem.sentence(),
          'type': Faker().randomGenerator.integer(10, min: 0) >= 5 ? workType : null,
          'reference': Faker().randomGenerator.integer(10, min: 0) >= 8 ? Faker().vehicle.vin() : null,
          'archived': Faker().randomGenerator.integer(10, min: 0) >= 8 ? true : false,
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
  }

  @override
  void writeCommandDescription() {
    stdout.writeln('$collectionName - Adds new work documents for each existing user in the $collectionName collection.');
  }

  @override
  writeCommandLineParameters() {
    stdout.writeln('    p1 on is an optional count. If not specified then is a random value from 0 to 1 000 000 for each user document.');
  }

  int? _count;
}
