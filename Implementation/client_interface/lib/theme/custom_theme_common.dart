import 'package:client_interfaces1/theme/theme_extension_text_field.dart';
import 'package:flutter/material.dart';

import '../ui_toolkit/form/form.dart';
import 'theme_extension_control_icon_button.dart';
import 'theme_extension_dialog_base.dart';

mixin CustomThemeCommon {
  static const double paddingWide = 16.0;
  static const double paddingNarrow = 8.0;
  static Color stealBlue = Color.fromARGB(255, 70, 130, 180);

  static final ThemeExtensionDialogBase dialogBaseTheme =
      ThemeExtensionDialogBase(
        paddingWide: paddingWide,
        paddingNarrow: paddingNarrow,
        edgeInsetsWide: EdgeInsets.all(paddingWide),
        edgeInsetsNarrow: EdgeInsets.all(paddingNarrow),
        horizontalSpacing: 8,
        verticalSpacing: 8,
        backgroundColor: Colors.white,
        borderColor: Color.fromARGB(255, 50, 50, 50),
        borderWidth: 4,
        dialogShadow: BoxShadow(color: Color.fromARGB(255, 60, 60, 60), blurRadius: 6.0, offset: Offset(6, 6)),
        dialogHeaderColor: Color.fromARGB(255, 200, 200, 200),
        dialogHeaderTextStyle: TextStyle(
          fontSize: 28,
          decoration: TextDecoration.none,
          color: Colors.black,
        ),
        filterInputDecoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          filled: true,
          fillColor: Colors.white,
          constraints: BoxConstraints(maxHeight: 28),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.zero),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.zero),
        ),
        filterTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        tableHeaderColor: Colors.black,
        tableHeaderTextStyle: TextStyle(fontSize: 16, color: Colors.white),
        normalCellTextStyle: TextStyle(fontSize: 16, color: Colors.black),
        emphasisedCellTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );

  static ThemeExtensionForm formTheme = ThemeExtensionForm(
    labelStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
    valueStyle: TextStyle(fontSize: 16.0),
    valueStyleEmphasised: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    valueStyleError: TextStyle(
      fontSize: 16.0,
      backgroundColor: Color.fromARGB(255, 255, 200, 200),
      color: Colors.red,
    ),
    valueStyleErrorEmphasised: TextStyle(
      fontSize: 20.0,
      backgroundColor: Color.fromARGB(255, 255, 200, 200),
      color: Colors.red,
    ),
    invalidMessageStyle: TextStyle(fontSize: 13.0, color: Colors.red),
    textFieldDecoration: InputDecoration(
      filled: true,
      fillColor: Color.fromARGB(255, 255, 255, 255),
      hoverColor: Color.fromARGB(255, 245, 245, 245),
      isCollapsed: true,
      contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.zero,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.zero,
      ),
    ),
    textFieldDecorationChanged: InputDecoration(
      filled: true,
      fillColor: Color.fromARGB(255, 255, 255, 235),
      hoverColor: Color.fromARGB(255, 255, 255, 245),
      isCollapsed: true,
      contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.zero,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.zero,
      ),
    ),
    textFieldDecorationError: InputDecoration(
      filled: true,
      fillColor: Color.fromARGB(255, 255, 240, 240),
      hoverColor: Color.fromARGB(255, 255, 250, 250),
      isCollapsed: true,
      contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.zero,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.zero,
      ),
    ),
    fleatherEditorHeight: 400,
  );

  static ThemeExtensionTextField textFieldTheme = ThemeExtensionTextField(
    textFieldDecoration: InputDecoration(
      filled: true,
      fillColor: Color.fromARGB(255, 255, 255, 255),
      hoverColor: Color.fromARGB(255, 245, 245, 245),
      isCollapsed: true,
      contentPadding: EdgeInsets.all(8),
      border: OutlineInputBorder(),
    ),
    textFieldDecorationError: InputDecoration(
      filled: true,
      fillColor: Color.fromARGB(255, 255, 240, 240),
      hoverColor: Color.fromARGB(255, 255, 250, 250),
      isCollapsed: true,
      contentPadding: EdgeInsets.all(8),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    ),
    invalidMessageStyle: TextStyle(fontSize: 13.0, color: Colors.red),
  );

  static ThemeExtensionControlIconButton iconButtonTheme =
      ThemeExtensionControlIconButton(
        style: ButtonStyle(
          iconSize: WidgetStateProperty.all(24.0),
          padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
          foregroundColor: WidgetStateProperty.all(CustomThemeCommon.stealBlue),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
        ),
      );
}
