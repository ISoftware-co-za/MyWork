import 'package:mongo_dart/mongo_dart.dart';

const int activityIndicatorCount = 100;

abstract class GeneratorBase {
  String validate();
  Future generate(Db db) async {}
}
