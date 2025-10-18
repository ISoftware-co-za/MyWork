library dialog_work;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_theme_data_app_header.dart';
import '../../execution/executor.dart';
import '../../model/work_type_list.dart';
import '../../theme/theme_extension_dialog_base.dart';
import '../../theme/theme_extension_dialog_work.dart';
import '../../theme/theme_extension_dialog_work_types_filter.dart';
import '../../theme/theme_extension_spacing.dart';
import '../../ui_toolkit/control_icon_button_large.dart';
import '../../ui_toolkit/control_icon_button_normal.dart';
import '../controller/column_boolean.dart';
import '../controller/column_collection.dart';
import '../controller/column_list.dart';
import '../controller/column_text.dart';
import '../controller/controller_dialog_work.dart';
import '../controller/list_item_work.dart';
import 'control_column_base.dart';

part 'control_column_boolean.dart';
part 'control_column_list.dart';
part 'control_column_text.dart';
part 'control_work_type_list_item.dart';
part 'layout_header.dart';
part 'layout_table_body.dart';
part 'layout_table_header.dart';
part 'layout_table_row.dart';
part 'layout_dialog_work_types_filter.dart';
part 'control_work_types_filter_header.dart';

class LayoutDialogWork extends StatelessWidget {
  const LayoutDialogWork({
    required ControllerDialogWork controller,
    required WorkTypeList workTypes,
    required VoidCallback onAddWorkPressed,
    super.key,
  }) : _controller = controller,
       _workTypes = workTypes,
       _onAddWorkPressed = onAddWorkPressed;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ThemeExtensionSpacing spacingTheme = themeData.extension<ThemeExtensionSpacing>()!;
    ThemeExtensionDialogWork dialogTheme = themeData.extension<ThemeExtensionDialogWork>()!;

    return Theme(
      data: CustomThemeDataAppHeader.getTheme(),
      child: Dialog(
        alignment: Alignment.topLeft,
        child: Container(
          width: dialogTheme.width,
          height: dialogTheme.height,
          decoration: BoxDecoration(
            color: dialogTheme.dialogBaseTheme.backgroundColor,
            border: Border.all(
              color: dialogTheme.dialogBaseTheme.borderColor,
              width: dialogTheme.dialogBaseTheme.borderWidth,
            ),
            boxShadow: [dialogTheme.dialogBaseTheme.dialogShadow],
          ),
          child: Column(
            children: [
              _DialogWorkLayoutHeader(
                spacingTheme: spacingTheme,
                dialogTheme: dialogTheme,
                onAddPressed: _onAddWorkPressed,
              ),
              _DialogWorkLayoutTableHeader(
                controller: _controller,
                workTypes: _workTypes,
                spacingTheme: spacingTheme,
                dialogTheme: dialogTheme,
              ),
              _DialogWorkLayoutTableBody(controller: _controller, spacingTheme: spacingTheme, dialogTheme: dialogTheme),
            ],
          ),
        ),
      ),
    );
  }

  final ControllerDialogWork _controller;
  final WorkTypeList _workTypes;
  final VoidCallback _onAddWorkPressed;
}
