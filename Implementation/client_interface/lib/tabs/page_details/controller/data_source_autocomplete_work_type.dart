import 'package:client_interfaces1/model/work_type_list.dart';
import 'package:client_interfaces1/ui_toolkit/form/form.dart';

import '../../../model/work_type.dart';
import '../../../model/model_property.dart';

class DataSourceAutocompleteWorkType extends AutocompleteDataSource {

  DataSourceAutocompleteWorkType(String userID, WorkTypeList workTypes, ModelProperty<String>? property)
      : _workTypes = workTypes, _property = property;

  @override
  Iterable<Object> emptyList() {
    return _emptyList;
  }

  @override
  Iterable<Object> listItems([String filter = '']) {
    return _workTypes.listItems(filter);
  }

  @override
  void onItemSelected(Object item) {
    var selectedWorkType = item as WorkType;
    _property?.value = selectedWorkType.name;
  }

  @override
  void onTextEntered(String text) {
    if (text.isEmpty) {
      _property?.value = '';
      return;
    }
    var workType = WorkType(text);
    var existingWorkType = _workTypes.findWorkType(workType.lowercaseName);
    if (existingWorkType != null) {
      _property?.value = workType.name;
      return;
    }
    _property?.value = workType.name;
    _workTypes.add(workType);
  }

  final List<WorkType> _emptyList = [];
  final WorkTypeList _workTypes;
  final ModelProperty<String>? _property;
  
}