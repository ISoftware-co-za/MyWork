import 'package:mongo_dart/mongo_dart.dart';

const int activityIndicatorCount = 100;

abstract class GeneratorBase {
  String get collectionName => '';

  String validate(List<String> arguments);
  Future generate(Db db) async {}
  void writeCommandDescription();
  void writeCommandLineParameters();
}
