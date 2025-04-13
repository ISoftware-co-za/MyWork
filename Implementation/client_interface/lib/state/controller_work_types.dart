import 'package:get_it/get_it.dart';

import '../ui toolkit/form/theme_form.dart';
import 'facade_user.dart';
import 'properties.dart';
import 'shared.dart';
import 'work_type.dart';

class ControllerWorkTypes extends AutocompleteFormFieldDataSource {
//#region PROPERTIES

  final List<WorkType> workTypes = [];

//#endregion

//#region METHODS

  void setWorkTypes(Iterable<WorkType> newWorkTypes) {
    workTypes.clear();
    workTypes.addAll(newWorkTypes);
    _sortWorkTypes(workTypes);
  }

  void setStateProperty(StateProperty property) {
    _property = property as StateProperty<WorkType>;
  }

  @override
  Iterable<Object> emptyList() {
    return _emptyList;
  }

  @override
  Iterable<Object> listItems([String filter = '']) {
    final lowerCaseFilter = filter.toLowerCase();
    return workTypes
        .where((element) => element.matchesFilter(lowerCaseFilter))
        .toList();
  }

  @override
  void onItemSelected(Object item) {
    assert(_property != null,
        'Call ControllerWorkTypes.setStateProperty(property) before using ControllerWorkTypes.onTextEntered(text).');

    var selectedWorkType = item as WorkType;
    _property?.value = selectedWorkType;
  }

  @override
  Future onTextEntered(String text) async {
    assert(_property != null,
        'Call ControllerWorkTypes.setStateProperty(property) before using ControllerWorkTypes.onTextEntered(text).');
    assert(_serviceSharedData.userId != null,
        'It is not possible to add a work type for a user if no user is logged in.');

    String cleanText = text.trim();
    if (cleanText.isEmpty) {
      _property?.value = null;
      return;
    }
    var workType = WorkType(cleanText);
    var existingWorkType = _findWorkType(workType.lowercaseName);
    if (existingWorkType != null) {
      _property?.value = existingWorkType;
      return;
    }
    await _facade.addWorkType(_serviceSharedData.userId!, workType.name);
    _property?.value = workType;
    workTypes.add(workType);
    _sortWorkTypes(workTypes);
  }

//#endregion

//#region PRIVATE METHODS

  void _sortWorkTypes(List<WorkType> workTypes) {
    workTypes.sort((a, b) => a.compareTo(b));
  }

  WorkType? _findWorkType(String workTypeName) {
    WorkType? locatedWorkType;
    for (var workType in workTypes) {
      if (workType.lowercaseName == workTypeName) {
        locatedWorkType = workType;
        break;
      }
    }
    return locatedWorkType;
  }

//#endregion

//#region FIELDS

  final List<WorkType> _emptyList = [];
  StateProperty<WorkType>? _property;
  final FacadeUser _facade = GetIt.instance<FacadeUser>();
  final ServiceSharedData _serviceSharedData =
      GetIt.instance<ServiceSharedData>();

//#endregion
}
