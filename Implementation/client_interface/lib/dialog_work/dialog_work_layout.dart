library dialog_work;

import 'package:client_interfaces1/dialog_work/control_column_base.dart';
import 'package:client_interfaces1/notification/controller_notifications.dart';
import 'package:client_interfaces1/theme_extension_dialog_work_types_filter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../custom_theme_data_app_header.dart';
import '../execution/executor.dart';
import '../model/work_type_list.dart';
import '../theme_extension_dialog_work.dart';
import '../ui_toolkit/icon_button_large.dart';
import 'dialog_work_controller.dart';
import 'list_item_work.dart';
import 'table_columns.dart';

part 'control_column_boolean.dart';
part 'control_column_list.dart';
part 'control_column_text.dart';
part 'control_work_type_list_item.dart';
part 'layout_header.dart';
part 'layout_table_body.dart';
part 'layout_table_header.dart';
part 'layout_table_row.dart';
part 'dialog_layout_work_types_filter.dart';
part 'control_work_types_filter_header.dart';

class DialogWorkLayout extends StatelessWidget {
  const DialogWorkLayout({required ControllerDialogWork controller, required WorkTypeList workTypes, super.key})
      : _controller = controller,
        _workTypes = workTypes;

  @override
  Widget build(BuildContext context) {
    ThemeExtensionWorkDialog theme = Theme.of(context).extension<ThemeExtensionWorkDialog>()!;
    return Theme(
      data: CustomThemeDataAppHeader.getTheme(),
      child: Dialog(
        alignment: Alignment.topLeft,
        child: Container(
              width: theme.width,
              height: theme.height,
              decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  border: Border.all(
                    color: Color.fromARGB(255, 50, 50, 50),
                    width: 4.0,
                  ),
                  boxShadow: [BoxShadow(color: Color.fromARGB(255, 60, 60, 60), blurRadius: 6.0, offset: Offset(6, 6))]),
              child: Column(children: [
                _DialogWorkLayoutHeader(theme: theme),
                _DialogWorkLayoutTableHeader(controller: _controller, workTypes: _workTypes, theme: theme),
                _DialogWorkLayoutTableBody(controller: _controller, theme: theme),
              ])),
      ),
    );
  }

  final ControllerDialogWork _controller;
  final WorkTypeList _workTypes;
}
