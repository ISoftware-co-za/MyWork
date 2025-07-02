import '../../../model/properties.dart';
import '../../../ui_toolkit/form/form.dart';
import 'list_item_detail_base.dart';

class ListItemDetailAutocomplete extends ListItemDetailBase {
  final AutocompleteDataSource dataSource;
  ListItemDetailAutocomplete({required String label, required StateProperty property, required this.dataSource}) :
        super(label: label, property: property);
}
