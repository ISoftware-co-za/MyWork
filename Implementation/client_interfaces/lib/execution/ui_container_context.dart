class UIContainerContext {

  // #region PROPERTIES

  String? get currentContainer => _currentContainer.toString().split('.').last;
  UIContainer? _currentContainer;

  // #endregion

  // #region METHODS

  void setCurrentContainer(UIContainer container) {
    _currentContainer = container;
  }

  void openModal(UIContainer container) {
    _containerUnderModal = _currentContainer;
    _currentContainer = container;
  }

  void closeModal() {
    _currentContainer = _containerUnderModal;
    _containerUnderModal = null;
  }

  // #endregion

  // #region FIELDS

  UIContainer? _containerUnderModal;

  // #endregion
}

enum UIContainer {

  tabWorkDetails,
  tabTasks

}