import 'package:client_interfaces1/ui_toolkit/control_icon_button_small.dart';
import 'package:flutter/material.dart';

import '../../execution/executor.dart';
import '../../theme/theme_extension_dialog_people.dart';

class ControlFilter extends StatefulWidget {
  const ControlFilter({
    required ValueNotifier<String> filterValue,
    required ThemeExtensionDialogPeople theme,
    super.key,
  }) : _filterValue = filterValue,
       _theme = theme;

  @override
  State<ControlFilter> createState() => _ControlFilterState();

  final ThemeExtensionDialogPeople _theme;
  final ValueNotifier<String> _filterValue;
}

class _ControlFilterState extends State<ControlFilter> {
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget._filterValue.value);
  }

  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ControlFilter.build() - "${_controller!.text}"');
    return Container(
      padding: EdgeInsets.all(widget._theme.dialogBaseTheme.padding),
      color: widget._theme.dialogBaseTheme.tableHeaderColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter people',
                contentPadding: EdgeInsets.all(8),
                filled: true,
                fillColor: Colors.white,
                constraints: BoxConstraints(maxHeight: 28),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.zero,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.zero,
                ),
              ),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              controller: _controller,
              onChanged: (text) {
                widget._filterValue.value = text;
              },
            ),
          ),
          SizedBox(
            width: widget._theme.commandColumnWidth,
            child: Center(
              child: ControlIconButtonSmall(
                icon: Icon(Icons.close),
                onPressed: () => {
                  Executor.runCommand(
                    'clearFilter',
                    'DialogPeople',
                    () => setState(() {
                      _controller!.text = "";
                      widget._filterValue.value = '';
                    }),
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
