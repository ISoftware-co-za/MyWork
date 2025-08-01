import '../../../model/model_property.dart';
import '../../../ui_toolkit/form/form.dart';
import 'list_item_detail_base.dart';

class ListItemDetailAutocomplete extends ListItemDetailBase {
  final AutocompleteDataSource dataSource;
  ListItemDetailAutocomplete({required String label, required ModelProperty property, required this.dataSource}) :
        super(label: label, property: property);
}
