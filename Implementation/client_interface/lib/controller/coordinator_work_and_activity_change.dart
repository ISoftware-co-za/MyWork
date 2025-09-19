import 'package:client_interfaces1/model/model_property_change_context.dart';
import 'package:flutter/foundation.dart';

import 'coordinator_base.dart';

class CoordinatorWorkAndActivityChange extends CoordinatorBase {

  late final ValueListenable<bool> isChanged;

  CoordinatorWorkAndActivityChange(ModelPropertyChangeContext workPropertyContext, ModelPropertyChangeContext activityPropertyContext)
      : _workPropertyContext = workPropertyContext,
        _activityPropertyContext = activityPropertyContext {
    isChanged = _isChanged;

    _workPropertyContext.hasChanges.addListener(_onHasChangesChanged);
    _activityPropertyContext.hasChanges.addListener(_onHasChangesChanged);
  }

  void _onHasChangesChanged() {
    _isChanged.value = _workPropertyContext.hasChanges.value ||
        _activityPropertyContext.hasChanges.value;
  }

  final ModelPropertyChangeContext _workPropertyContext;
  final ModelPropertyChangeContext _activityPropertyContext;
  final ValueNotifier<bool> _isChanged = ValueNotifier<bool>(false);
}