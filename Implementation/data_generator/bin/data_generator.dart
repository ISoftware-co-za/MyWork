import 'dart:io';

import 'package:data_generator/generator_work.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future main(List<String> arguments) async {

  var db = await Db.create("mongodb+srv://keithc:password1234@m0.ei6m1.mongodb.net/M0?secure=true");
  await db.open();

  // Todo: Check the connection before generating data

  // Todo: Map the arguments to the specified generator
  var stopwatch = Stopwatch()..start();
  var generator = GeneratorWork(count: 1000, numberOfTypes: 10);
  var message = generator.validate();
  if (message.isEmpty) {
    await generator.generate(db);
    stopwatch.stop();
    stdout.writeln('Done (${stopwatch.elapsed}).');
  } else {
    print(message);
  }
}
