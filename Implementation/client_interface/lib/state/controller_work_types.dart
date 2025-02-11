import 'package:client_interfaces1/state/properties.dart';
import 'package:client_interfaces1/state/state_work_type.dart';
import 'package:get_it/get_it.dart';

import '../ui toolkit/control_form_fields.dart';
import 'controller_user.dart';
import 'facade_user.dart';

class ControllerWorkTypes implements AutocompleteDataSource {
  //#region METHODS

  void attachControllerUser(ControllerUser controllerUser) {
    _controllerUser = controllerUser;
  }

  void setWorkTypes(List<StateWorkType> workTypes) {
    _workTypes.clear();
    _workTypes.addAll(workTypes);
    _sortWorkTypes(_workTypes);
  }

  void setStateProperty(StateProperty property) {
    _property = property as StateProperty<StateWorkType>;
  }

  @override
  Iterable<Object> emptyList() {
    return _emptyList;
  }

  @override
  Iterable<Object> listItems(String filter) {
    final lowerCaseFilter = filter.toLowerCase();
    return _workTypes.where((element) => element.matchesFilter(lowerCaseFilter)).toList();
  }

  @override
  void onItemSelected(Object item) {
    assert(_property != null, 'Call ControllerWorkTypes.setStateProperty(property) before using ControllerWorkTypes.onTextEntered(text).');

    var selectedWorkType = item as StateWorkType;
    _property?.value = selectedWorkType;
  }

  @override
  Future<void> onTextEntered(String text) async {
    assert(_property != null, 'Call ControllerWorkTypes.setStateProperty(property) before using ControllerWorkTypes.onTextEntered(text).');
    assert(_controllerUser != null,
        'Call ControllerWorkTypes.attachControllerUser(userController) before using ControllerWorkTypes.onTextEntered(text).');
    assert(
        _controllerUser!.userId != null, 'It is not possible to add a work type for a user if no user is logged in.');

    String cleanText = text.trim();
    if (cleanText.isEmpty) {
      _property?.value = null;
      return;
    }
    var workType = StateWorkType(cleanText);
    var existingWorkType = _findWorkType(workType.lowerCaseName);
    if (existingWorkType != null) {
      _property?.value = existingWorkType;
      return;
    }
    _property?.value = workType;
    _workTypes.add(workType);
    _sortWorkTypes(_workTypes);
    await _facade.addWorkType(_controllerUser!.userId!, workType.name);
  }

  //#endregion

  //#region WORK TYPES

  void _sortWorkTypes(List<StateWorkType> workTypes) {
    workTypes.sort((a, b) => a.compareTo(b));
  }

  StateWorkType? _findWorkType(String workTypeName) {
    StateWorkType? locatedWorkType;
    for (var workType in _workTypes) {
      if (workType.lowerCaseName == workTypeName) {
        locatedWorkType = workType;
        break;
      }
    }
    return locatedWorkType;
  }

  //#endregion

  //#region FIELDS

  late final ControllerUser? _controllerUser;
  final List<StateWorkType> _workTypes = [];
  final List<StateWorkType> _emptyList = [];
  StateProperty<StateWorkType>? _property;
  final FacadeUser _facade = GetIt.instance<FacadeUser>();

  //#endregion
}
