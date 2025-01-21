import 'dart:io';
import 'package:collection/collection.dart';

import 'package:data_generator/generator_base.dart';
import 'package:data_generator/generator_user.dart';
import 'package:data_generator/generator_work.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future main(List<String> arguments) async {

  try {
    if (arguments.isEmpty) {
      _writeUsage();
      return;
    }

    var db = await Db.create("mongodb+srv://keithc:password1234@m0.ei6m1.mongodb.net/my_work?secure=true");
    await db.open();

    var stopwatch = Stopwatch()
      ..start();
    var generator = _getGenerator(arguments[0]);
    var message = generator.validate(arguments.skip(1).toList());
    if (message.isEmpty) {
      await generator.generate(db);
      stopwatch.stop();
      stdout.writeln('Done (${stopwatch.elapsed}).');
    } else {
      print(message);
    }
  } catch (e) {
    print('Error: $e');
  }
}

void _writeUsage() {
  stdout.writeln('');
  stdout.writeln('');
  stdout.writeln('Usage: data_generator collectionName p1 p2 ... pn');
  stdout.writeln('');
  stdout.writeln('Where collectionName is one of the following:');
  stdout.writeln('');
  for(var generator in _generators) {
    generator.writeCommandDescription();
    generator.writeCommandLineParameters();
    stdout.writeln('');
  }
}

GeneratorBase _getGenerator(String collectionName) {
  GeneratorBase? locatedGenerator = _generators.firstWhereOrNull((element) => element.collectionName == collectionName);
  if (locatedGenerator == null) {
    throw Exception('Unknown collection name: $collectionName');
  }
  return locatedGenerator;
}

List<GeneratorBase> _generators = [GeneratorUser(), GeneratorWork()];
