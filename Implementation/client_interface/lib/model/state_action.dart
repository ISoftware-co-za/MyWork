import 'package:client_interfaces1/model/model_property_context.dart';

import 'model_property.dart';
import 'state_activity_base.dart';

class StateAction extends StateActivityBase {
  late final ModelProperty title;
  late final ModelProperty description;
  late final ModelProperty requester;

  late final ModelProperty initialEstimateInMinutes;
  late final ModelProperty currentDurationInMinutes;
  late final ModelProperty currentEstimateInMinutes;

  late final List<StateWorkEntry> workLog;
  late final StateWorkClose? close;

  StateAction({
    required ModelPropertyContext context,
    required super.timestamp,
    String? title,
    String? description,
    String? requester,
    int? initialEstimateInMinutes,
    int? currentDurationInMinutes,
    int? currentEstimateInMinutes,
    List<StateWorkEntry>? workLog,
    this.close}) : super(context: context) {
    this.title = ModelProperty(context: context, value: title);
    this.description = ModelProperty(context: context, value: description);
    this.requester = ModelProperty(context: context, value: requester);
    this.initialEstimateInMinutes = ModelProperty(context: context, value: initialEstimateInMinutes);
    this.currentDurationInMinutes = ModelProperty(context: context, value: currentDurationInMinutes);
    this.currentEstimateInMinutes = ModelProperty(context: context, value: currentEstimateInMinutes);

    if (workLog == null) {
      this.workLog = [];
    } else {
      this.workLog = workLog;
    }
  }
}

class StateWorkEntry {
  late final DateTime start;
  late final ModelProperty durationInMinutes;
  late final ModelProperty currentEstimateInMinutes;
  late final ModelProperty notes;

  StateWorkEntry({required ModelPropertyContext context, required this.start, int? durationInMinutes, int? currentEstimateInMinutes, String? notes}) {
    this.durationInMinutes = ModelProperty(context: context, value: durationInMinutes);
    this.currentEstimateInMinutes = ModelProperty(context: context, value: currentEstimateInMinutes);
    this.notes = ModelProperty(context: context, value: notes);
  }
}

class StateWorkClose {
  late final ModelProperty notes;

  StateWorkClose({required ModelPropertyContext context, String? notes}) {
    this.notes = ModelProperty(context: context, value: notes);
  }
}