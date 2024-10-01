import 'dart:io';

import 'package:faker/faker.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'generator_base.dart';

class GeneratorWork extends GeneratorBase {
  GeneratorWork({required int count, int? numberOfTypes})
      : _count = count,
        _numberOfTypes = numberOfTypes ?? 5;

  @override
  String validate() {
    String? validationMessage = '';
    if (_count < 1 || _count > 1000000) {
      validationMessage += 'Count must be greater and equal to 1, and less than 1000000.';
    }
    if (_numberOfTypes < 0 || _numberOfTypes > 1000) {
      validationMessage += 'Number of types must be greater than or equal to 0, and less that 1000.';
    }
    return validationMessage;
  }

  @override
  Future generate(Db db) async {
    stdout.writeln('');
    stdout.writeln('');
    stdout.writeln('GeneratorWork: Generating $_count Work records with $_numberOfTypes types.');
    List<String> types = _listTypes(_numberOfTypes);

    for (int count = 1; count <= _count; ++count) {
      var work = {
        'name': Faker().lorem.sentence(),
        'type': (_numberOfTypes > 0)
            ? Faker().randomGenerator.element(types)
            : null,
        'reference': Faker().randomGenerator.integer(10, min: 0) >= 8
            ? Faker().vehicle.vin()
            : null,
        'archived': Faker().randomGenerator.integer(10, min: 0) >= 8
            ? true
            : false,
      };
      var result = await db.collection('work').insertOne(work);
      if (!result.isSuccess) {
        throw Exception('Failed to insert work record: $work');
      }
      if (count % activityIndicatorCount == 0) {
        stdout.write('.');
      }
    }
  }

  List<String> _listTypes(int numberOfTypes) {
    var types = <String>[];
    for (int count = 1; count <= numberOfTypes; ++count) {
      types.add(Faker().job.title());
    }
    return types;
  }

  final int _count;
  final int _numberOfTypes;
}
