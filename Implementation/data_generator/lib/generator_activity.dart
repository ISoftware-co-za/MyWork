import 'dart:io';
import 'dart:math';

import 'package:data_generator/document_details.dart';
import 'package:data_generator/shared_methods.dart';
import 'package:faker/faker.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'generator_base.dart';

class GeneratorActivity extends GeneratorBase {
  @override
  String get collectionName => DocumentCollections.activities;

  @override
  String validate(List<String> arguments) {
    if (arguments.length == 2) {
      _count = int.tryParse(arguments[0]);
      _userId = arguments[1];
    }
    String? validationMessage = '';
    if (_count != null && (_count! < 1 || _count! > 1000000)) {
      validationMessage +=
          'Count must be greater and equal to 1, and less than 1000000. The count is the first command line parameter.';
    }
    if (_userId.isEmpty) {
      validationMessage +=
          'Activities are generated for a user. The _id of this user must be specified as the second command line parameter.';
    }
    return validationMessage;
  }

  @override
  Future generate(Db db) async {
    Map<String, dynamic> user = await SharedMethods.getUserFromId(_userId, db);

    var work = await db.collection(DocumentCollections.work).find({WorkProperties.userId: user['_id']}).toList();
    var people =
        await db.collection(DocumentCollections.people).find().toList();
    var activityStates = ['Idle', 'Busy', 'Done', 'Paused', 'Cancelled'];

    stdout.writeln('');
    stdout.writeln('');
    stdout.writeln(
        'Generating $_count ${DocumentCollections.activities} for the user _id=$_userId');

    int documentCount = 0;
    var faker = Faker();
    for (int count = 0; count < _count!; ++count) {

      var workIndex = faker.randomGenerator.integer(work.length);
      var workId = work[workIndex]['_id'];
      var activity = {
        ActivitiesProperties.userId: user['_id'],
        ActivitiesProperties.workId: workId,
        ActivitiesProperties.what: _generateSentence(80),
        ActivitiesProperties.state: activityStates[faker.randomGenerator.integer(activityStates.length)]
      };

      if (faker.randomGenerator.integer(10) >= 5) {
        activity[ActivitiesProperties.why] = _generateSentence(240);
      }

      if (faker.randomGenerator.integer(10) >= 7) {
        activity[ActivitiesProperties.notes] = _generateSentence(240);
      }

      int dueDateIndicator = faker.randomGenerator.integer(10);
      if (dueDateIndicator <= 1) {
        activity[ActivitiesProperties.dueDate] = _dateWithOffset(-30);
      } else if (dueDateIndicator >= 7) {
        activity[ActivitiesProperties.dueDate] = _dateWithOffset(90);
      }

      var result = await db.collection(collectionName).insertOne(activity);
      if (!result.isSuccess) {
        throw Exception('Failed to insert user document: $activity');
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
        '$collectionName - Add activities to the work of the specified user.');
  }

  @override
  writeCommandLineParameters() {
    stdout.writeln(
        '    p1 is the number of activities to be added.');
    stdout.writeln(
        '    p2 is the _id of the user the activities will be generated for.');
  }

  String _dateWithOffset(int offset) {
    DateTime date = DateTime.now().add(Duration(days: offset));
    return date.toIso8601String().split('T').first;
  }

  String _generateSentence(int maxLength) {
    var faker = Faker();
    List<String> words = faker.lorem.words(faker.randomGenerator.integer(80, min: 3));
    String sentence = words.join(' ');
    sentence = sentence[0].toUpperCase() + sentence.substring(1) + '.';
    return sentence.substring(0, min(sentence.length, maxLength));
  }

  int? _count;
  String _userId = '';
}
