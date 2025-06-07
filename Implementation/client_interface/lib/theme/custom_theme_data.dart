import 'package:client_interfaces1/ui_toolkit/control_custom_icon_buttons.dart';
import 'package:client_interfaces1/ui_toolkit/form/form.dart';
import 'package:flutter/material.dart';

class CustomThemeData {
  static ThemeData getTheme() {
    return ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: Colors.red,
          secondary: Colors.black,
        ),
        useMaterial3: true,
        extensions: <ThemeExtension<dynamic>>[
          IconButtonAcceptTheme(
              style: ButtonStyle(
                  iconSize: WidgetStateProperty.all(24.0),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
                  foregroundColor: WidgetStateProperty.all(Colors.green))),
          IconButtonRejectTheme(
              style: ButtonStyle(
                  iconSize: WidgetStateProperty.all(24.0),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
                  foregroundColor: WidgetStateProperty.all(Colors.red))),
          IconButtonActionTheme(
              style: ButtonStyle(
                  iconSize: WidgetStateProperty.all(24.0),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(2.0)),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.red))),
          const FormTheme(
            labelStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
            valueStyle: TextStyle(fontSize: 16.0),
            valueStyleError:
            TextStyle(fontSize: 16.0, backgroundColor: Color.fromARGB(255, 255, 200, 200), color: Colors.red),
            textFieldDecoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 255),
                hoverColor: Color.fromARGB(255, 245, 245, 245),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero)),
            textFieldDecorationChanged: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 235),
                hoverColor: Color.fromARGB(255, 255, 255, 245),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero)),
            textFieldDecorationError: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 255, 240, 240),
                hoverColor: Color.fromARGB(255, 255, 250, 250),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(3.0, 4.0, 3.0, 4.0),
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero)),
            fleatherEditorHeight: 400,
          )
        ]).copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.grey, // Default label color
        ),
        focusColor: Colors.blue,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Focused underline color
        ),
        focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2) // Focused underline color
        ),
        activeIndicatorBorder: BorderSide(color: Colors.black, width: 2), // Focused underline color
      )
    );
  }
}
