import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//----------------------------------------------------------------------------------------------------------------------

class ProviderHover extends InheritedWidget {
  final ControllerHover controller;

  ProviderHover({
    required this.controller,
    required Widget child,
    super.key,
  }) : super(
    child: Listener(
      onPointerHover: (event) => controller._processPointerHover(event),
      child: child,));

  @override
  bool updateShouldNotify(ProviderHover oldWidget) {
    return controller != oldWidget.controller;
  }

  static ProviderHover of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProviderHover>()!;
  }
}

//----------------------------------------------------------------------------------------------------------------------

class ControllerHover {

  //#region CONSTANTS
  
  static const String workDetails = 'WorkDetails';
  
  //#endregion
  
  //#region METHODS

  Object registerHoverableWidget(
      {required String name, required GlobalKey widgetKey, bool isVisible = false, required Function(bool) onHover}) {
    var widget = _HoverableWidget(key: widgetKey, isVisible: isVisible, onHover: onHover);
    _hoverableWidgets[name] = widget;
    return widget;
  }

  void setVisibility({required String name, required bool isVisible}) {
    _HoverableWidget? hoverableWidget = _hoverableWidgets[name];
    if (hoverableWidget != null) {
      hoverableWidget.isVisible = isVisible;
      if (_lastPosition != null) {
        _determineIfPointerOverWidget(hoverableWidget, _lastPosition!);
      }
    }
  }
  
  //#endregion
  
  //#region PRIVATE METHODS

  void _processPointerHover(PointerHoverEvent event) {
    _lastPosition = event.position;
    for (var widget in _hoverableWidgets.values) {
      _determineIfPointerOverWidget(widget, _lastPosition!);
    }
  }

  void _determineIfPointerOverWidget(_HoverableWidget widget, Offset lastPosition) {
    if (widget.isVisible) {
      var renderBox = widget.key.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        var position = renderBox.globalToLocal(lastPosition);
        var isHovered = renderBox.paintBounds.contains(position);
        if (widget.isHover != isHovered) {
          widget.isHover = isHovered;
          widget.onHover(isHovered);
        }
      }
    }
  }
  
  //#endregion
  
  //#region FIELDS

  final Map<String, _HoverableWidget> _hoverableWidgets = {};
  Offset? _lastPosition;
  
  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class _HoverableWidget {

  //#region PROPERTIES

  final GlobalKey key;
  final Function(bool) onHover;
  bool isHover = false;
  bool isVisible;

  //#endregion

  //#region CONSTRUCTION

  _HoverableWidget({
    required this.key,
    required this.isVisible,
    required this.onHover,
  });

  //#endregion
}
