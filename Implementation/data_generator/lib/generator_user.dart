import 'dart:io';
import 'package:faker/faker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'generator_base.dart';

class GeneratorUser extends GeneratorBase {

  @override
  String get collectionName => 'users';

  GeneratorUser() : _count = _countDefault;

  @override
  String validate(List<String> arguments) {
    if (arguments.isNotEmpty) {
      _count = int.tryParse(arguments[0]) ?? _countDefault;
    }
    String? validationMessage = '';
    if (_count < 1 || _count > 1000000) {
      validationMessage += 'Count must be greater and equal to 1, and less than 1000000.';
    }
    return validationMessage;
  }

  @override
  Future generate(Db db) async {
    stdout.writeln('');
    stdout.writeln('');
    stdout.writeln('GeneratorUser: Generating $_count User documents.');

    for (int count = 1; count <= _count; ++count) {
      List<String> workTypes = _generateWorkTypesForUser();

      var user = {'email': Faker().internet.email(), 'password': Faker().internet.password(), 'workTypes': workTypes};

      var result = await db.collection('users').insertOne(user);
      if (!result.isSuccess) {
        throw Exception('Failed to insert user document: $user');
      }
      if (count % activityIndicatorCount == 0) {
        stdout.write('.');
      }
    }
  }

  @override
  void writeCommandDescription() {
    stdout.writeln('$collectionName - Adds new user documents to the user collection.');
  }

  @override
  writeCommandLineParameters() {
    stdout.writeln('    p1 on is an optional count. If not specified then defaults to 100.');
  }

  List<String> _generateWorkTypesForUser() {
    List<String> workTypes = [];

    if (Faker().randomGenerator.integer(10, min: 0) >= 5) {
      var typeCount = Faker().randomGenerator.integer(10, min: 1);
      for (int i = 0; i < typeCount; i++) {
        workTypes.add(Faker().lorem.word());
      }
    }
    return workTypes;
  }

  int _count;
  static const int _countDefault = 100;
}
