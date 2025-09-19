import 'package:flutter/material.dart';

import 'custom_theme_common.dart';
import 'theme_extension_icon_button_accept.dart';
import 'theme_extension_icon_button_reject.dart';
import 'theme_extension_icon_button_size.dart';
import 'theme_extension_app_header.dart';
import 'theme_extension_control_work_button.dart';
import 'theme_extension_dialog_work.dart';
import 'theme_extension_dialog_work_types_filter.dart';

class CustomThemeDataAppHeader with CustomThemeCommon {
  static ThemeData getTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
        primary: Color.fromARGB(255, 70, 130, 180),
        secondary: Color.fromARGB(255, 128, 128, 128),
      ),
      useMaterial3: true,
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(CustomThemeCommon.stealBlue),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: Colors.white, width: 1.0),
      ),
      extensions: <ThemeExtension<dynamic>>[
        ThemeExtensionIconButtonSize(
          smallIconSize: 8.0,
          largeIconSize: 24.0,
          smallPadding: 2.0,
          largePadding: 4.0,
        ),
        const ThemeExtensionAppHeader(
          backgroundColor: Colors.black,
          height: 64,
        ),
        ThemeExtensionIconButtonAccept(
          style: ButtonStyle(
            iconSize: WidgetStateProperty.all(24.0),
            padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
            foregroundColor: WidgetStateProperty.all(Colors.green),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        ThemeExtensionIconButtonReject(
          style: ButtonStyle(
            iconSize: WidgetStateProperty.all(24.0),
            padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
            foregroundColor: WidgetStateProperty.all(Colors.red),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        ThemeExtensionControlWorkButton(
          padding: 8,
          hoverColor: Colors.white.withValues(alpha: 0.3),
          hoverBorderWidth: 2.0,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
          ),
        ),
        ThemeExtensionDialogWork(
          width: 800,
          height: 500,
          dialogBaseTheme: CustomThemeCommon.dialogBaseTheme,
        ),
        ThemeExtensionDialogWorkTypesFilter(
          width: 300,
          height: 360,
          backgroundColor: Colors.black,
          headerTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
          workTypeTextStyle: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
        CustomThemeCommon.formTheme,
        CustomThemeCommon.textFieldTheme,
        CustomThemeCommon.iconButtonTheme
      ],
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.white),
          backgroundColor: WidgetStateProperty.all(CustomThemeCommon.stealBlue),
        ),
      ),
    );
  }
}
