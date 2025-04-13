part of form;

abstract class AutocompleteFormFieldDataSource {
  Iterable<Object> emptyList();
  Iterable<Object> listItems(String filter);
  void onItemSelected(Object item);
  Future onTextEntered(String text);
}
