import '../model/model_property.dart';
import 'model_property_change_context.dart';

class StateActivityBase extends PropertyOwner {
  final DateTime timestamp;

  StateActivityBase({required ModelPropertyChangeContext context, required this.timestamp}) : super(context);
}