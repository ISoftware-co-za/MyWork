library dialog_work;

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../execution/executor.dart';
import '../model/work_type_list.dart';
import '../ui_toolkit/custom_icon_buttons.dart';
import 'controller_dialog_work.dart';
import 'list_item_work.dart';
import 'table_columns.dart';

part 'dialog_work_control_column_boolean.dart';
part 'dialog_work_control_column_list.dart';
part 'dialog_work_control_column_text.dart';
part 'dialog_work_control_work_type_list_item.dart';
part 'dialog_work_layout_header.dart';
part 'dialog_work_layout_table_body.dart';
part 'dialog_work_layout_table_header.dart';
part 'dialog_work_layout_table_row.dart';
part 'dialog_work_layout_work_types_filter.dart';
part 'dialog_work_layout_work_types_filter_header.dart';
part 'dialog_work_theme.dart';

class DialogWorkLayout extends StatelessWidget {
  const DialogWorkLayout(
      {required ControllerDialogWork controller,
        required WorkTypeList workTypes,
        super.key})
      : _controller = controller,
        _workTypes = workTypes;

  @override
  Widget build(BuildContext context) {
    WorkDialogTheme theme = Theme.of(context).extension<WorkDialogTheme>()!;
    return Dialog(
        alignment: Alignment.topLeft,
        child: Container(
            width: theme.width,
            height: theme.height,
            color: Colors.white,
            child: Column(children: [
              _DialogWorkLayoutHeader(theme: theme),
              _DialogWorkLayoutTableHeader(
                  controller: _controller, workTypes: _workTypes, theme: theme),
              _DialogWorkLayoutTableBody(controller: _controller, theme: theme),
            ])));
  }

  final ControllerDialogWork _controller;
  final WorkTypeList _workTypes;
}