import 'package:client_interfaces1/dialog_people/widget/control_list.dart';
import 'package:client_interfaces1/theme/theme_extension_text_field.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_theme_data_app_header.dart';
import '../../theme/theme_extension_dialog_people.dart';
import '../controller/controller_dialog_people.dart';

import 'control_header.dart';
import 'control_filter.dart';

class LayoutDialogPeople extends StatelessWidget {
  const LayoutDialogPeople({
    required ControllerDialogPeople controller,
    super.key,
  }) : _controller = controller;
  @override
  Widget build(BuildContext context) {
    ThemeExtensionDialogPeople themeDialogPeople = Theme.of(
      context,
    ).extension<ThemeExtensionDialogPeople>()!;
    ThemeExtensionTextField themeTextField = Theme.of(
      context,
    ).extension<ThemeExtensionTextField>()!;

    return Theme(
      data: CustomThemeDataAppHeader.getTheme(),
      child: Dialog(
        alignment: Alignment.topLeft,
        child: Container(
          width: themeDialogPeople.width,
          height: themeDialogPeople.height,
          decoration: BoxDecoration(
            color: themeDialogPeople.dialogBaseTheme.backgroundColor,
            border: Border.all(
              color: themeDialogPeople.dialogBaseTheme.borderColor,
              width: themeDialogPeople.dialogBaseTheme.borderWidth,
            ),
            boxShadow: [themeDialogPeople.dialogBaseTheme.dialogShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              ControlHeader(controller: _controller, theme: themeDialogPeople),
              ControlFilter(
                filterValue: _controller.filterCriteria,
                theme: themeDialogPeople,
              ),
              Expanded(
                child: ControlList(
                  controller: _controller,
                  dialogTheme: themeDialogPeople,
                  textFieldTheme: themeTextField,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final ControllerDialogPeople _controller;
}
