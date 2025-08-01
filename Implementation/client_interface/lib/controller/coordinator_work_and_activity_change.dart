import 'package:client_interfaces1/model/model_property_context.dart';
import 'package:flutter/foundation.dart';

import 'coordinator_base.dart';

class CoordinatorWorkAndActivityChange extends CoordinatorBase {

  late final ValueListenable<bool> isChanged;

  CoordinatorWorkAndActivityChange(ModelPropertyContext workPropertyContext, ModelPropertyContext activityPropertyContext)
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

  final ModelPropertyContext _workPropertyContext;
  final ModelPropertyContext _activityPropertyContext;
  final ValueNotifier<bool> _isChanged = ValueNotifier<bool>(false);
}