import 'package:client_interfaces1/ui_toolkit/control_icon_button_small.dart';
import 'package:flutter/material.dart';

import '../../execution/executor.dart';
import '../../theme/theme_extension_dialog_people.dart';
import '../../theme/theme_extension_spacing.dart';

class ControlFilter extends StatefulWidget {

  const ControlFilter({
    required ValueNotifier<String> filterValue,
    required ThemeExtensionSpacing themeSpacing,
    required ThemeExtensionDialogPeople themeDialog,
    super.key,
  }) : _filterValue = filterValue,
        _themeSpacing = themeSpacing,
       _themeDialog = themeDialog;

  @override
  State<ControlFilter> createState() => _ControlFilterState();

  final ThemeExtensionSpacing _themeSpacing;
  final ThemeExtensionDialogPeople _themeDialog;
  final ValueNotifier<String> _filterValue;
}

class _ControlFilterState extends State<ControlFilter> {

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget._filterValue.value);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget._themeSpacing.edgeInsetsWide,
      color: widget._themeDialog.dialogBaseTheme.tableHeaderColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              decoration: widget._themeDialog.dialogBaseTheme.filterInputDecoration.copyWith(hintText: 'Filter text'),
              style: widget._themeDialog.dialogBaseTheme.filterTextStyle,
              controller: _controller,
              onChanged: (text) {
                Executor.runCommand(
                  'ControlFilter.onChanged',
                  'LayoutDialogPeople',
                  () => widget._filterValue.value = text,
                );
              },
            ),
          ),
          SizedBox(
            width: widget._themeDialog.commandColumnWidth,
            child: Center(
              child: ControlIconButtonSmall(
                icon: Icon(Icons.close),
                onPressed: () => {
                  Executor.runCommand(
                    'ControlIconButtonSmall.close',
                    'LayoutDialogPeople',
                    () {
                      _controller!.text = "";
                      widget._filterValue.value = '';
                    },
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

    TextEditingController? _controller;
}
