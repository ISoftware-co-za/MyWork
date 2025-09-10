import 'dart:io';
import 'package:faker/faker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'document_details.dart';
import 'generator_base.dart';
import 'shared_methods.dart';

class GeneratorPerson extends GeneratorBase {

  @override
  String get collectionName => DocumentCollections.people;

  GeneratorPerson() : _count = _countDefault;

  @override
  String validate(List<String> arguments) {
    if (arguments.length == 2) {
      _count = int.tryParse(arguments[0]) ?? _countDefault;
      _userId = arguments[1];
    }
    String? validationMessage = '';
    if (_count < 1 || _count > 1000000) {
      validationMessage += 'Count must be greater and equal to 1, and less than 1000000.';
    }
    if (_userId.isEmpty) {
      validationMessage +=
      'People are generated for a user. The _id of this user must be specified as the second command line parameter.';
    }
    return validationMessage;
  }

  @override
  Future generate(Db db) async {
    Map<String, dynamic> user = await SharedMethods.getUserFromId(_userId, db);

    stdout.writeln('');
    stdout.writeln('');
    stdout.writeln('GeneratorUser: Generating $_count Person documents for user ${user[UserProperties.email]}.');

    for (int count = 1; count <= _count; ++count) {
      var person = {
        PeopleProperties.userId: user['_id'],
        PeopleProperties.firstName: Faker().person.firstName(),
        PeopleProperties.lastName: Faker().person.lastName()
      };

      var result = await db.collection(collectionName).insertOne(person);
      if (!result.isSuccess) {
        throw Exception('Failed to insert user document: $person');
      }
      if (count % activityIndicatorCount == 0) {
        stdout.write('.');
      }
    }
  }

  @override
  void writeCommandDescription() {
    stdout.writeln('$collectionName - Adds new person documents to the people collection.');
  }

  @override
  writeCommandLineParameters() {
    stdout.writeln('    p1 on is an optional count. If not specified then defaults to 100.');
    stdout.writeln('    p2 is the _id of the user the activities will be generated for.');
  }

  int _count;
  static const int _countDefault = 100;
  String _userId = '';
}
