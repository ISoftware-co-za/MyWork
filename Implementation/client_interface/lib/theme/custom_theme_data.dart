import 'package:client_interfaces1/theme/theme_extension_icon_button_size.dart';
import 'package:flutter/material.dart';

import 'custom_theme_common.dart';
import 'theme_extension_dialog_people.dart';
import 'theme_extension_icon_button_accept.dart';

class CustomThemeData with CustomThemeCommon {
  static ThemeData getTheme() {
    return ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: Color.fromARGB(255, 70, 130, 180),
          secondary: Colors.black,
        ),
        useMaterial3: true,
        extensions: <ThemeExtension<dynamic>>[
          ThemeExtensionIconButtonSize(smallIconSize: 8.0, largeIconSize: 24.0, smallPadding: 2.0, largePadding: 4.0),
          ThemeExtensionIconButtonAccept(
              style: ButtonStyle(
                  iconSize: WidgetStateProperty.all(24.0),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.red))),
          ThemeExtensionDialogPeople(
              width: 800,
              height: 500,
              commandColumnWidth: 56,
              dialogBaseTheme: CustomThemeCommon.dialogBaseTheme),
          CustomThemeCommon.formTheme,
          CustomThemeCommon.textFieldTheme,
          CustomThemeCommon.iconButtonTheme
        ]).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.grey, // Default label color
      ),
      focusColor: Colors.blue,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey), // Focused underline color
      ),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2) // Focused underline color
          ),
      activeIndicatorBorder: BorderSide(color: Colors.black, width: 2), // Focused underline color
    ));
  }
}
