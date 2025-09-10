import '../model/model_property.dart';
import 'model_property_context.dart';

class StateActivityBase extends PropertyOwner {
  final DateTime timestamp;

  StateActivityBase({required ModelPropertyContext context, required this.timestamp}) : super(context);
}