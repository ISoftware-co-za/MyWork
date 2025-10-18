import 'dart:math';

import 'package:client_interfaces1/dialog_people/widget/control_list.dart';
import 'package:client_interfaces1/theme/theme_extension_spacing.dart';
import 'package:client_interfaces1/theme/theme_extension_text_field.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_theme_data_app_header.dart';
import '../../theme/theme_extension_dialog_people.dart';
import '../controller/controller_dialog_people.dart';

import 'control_header.dart';
import 'control_filter.dart';

class LayoutDialogPeople extends StatelessWidget {
  const LayoutDialogPeople({
    required Offset topLeft,
    required ControllerDialogPeople controller,
    super.key,
  }) : _topLeft = topLeft,
       _controller = controller;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ThemeExtensionSpacing themeSpacing = themeData
        .extension<ThemeExtensionSpacing>()!;
    ThemeExtensionDialogPeople themeDialogPeople = themeData
        .extension<ThemeExtensionDialogPeople>()!;
    ThemeExtensionTextField themeTextField = themeData
        .extension<ThemeExtensionTextField>()!;

    final double dialogLeft = max(0, _topLeft.dx - themeDialogPeople.width);

    return Theme(
      data: CustomThemeDataAppHeader.getTheme(),
      child: Dialog(
        alignment: Alignment.topLeft,
        insetPadding: EdgeInsets.fromLTRB(dialogLeft, _topLeft.dy, 0, 0),
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
              ControlHeader(
                controller: _controller,
                themeSpacing: themeSpacing,
                theme: themeDialogPeople,
              ),
              ControlFilter(
                filterValue: _controller.filterCriteria,
                themeSpacing: themeSpacing,
                themeDialog: themeDialogPeople,
              ),
              Expanded(
                child: ControlList(
                  controller: _controller,
                  spacingTheme: themeSpacing,
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

  final Offset _topLeft;
  final ControllerDialogPeople _controller;
}
