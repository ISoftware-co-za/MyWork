import 'package:flutter/material.dart';

mixin SizedIconButton {
  SizedBox buildSizedIconButton({required IconData icon, required ButtonStyle style, required VoidCallback onPressed}) {
    double width = style.iconSize!.resolve({})!;
    double height = width;
    EdgeInsetsGeometry? padding = style.padding!.resolve({});
    if (padding != null) {
      width += padding.horizontal;
      height += padding.vertical;
    }
    return SizedBox(
      width: width,
      height: height,
      child: IconButton(
          icon: Icon(icon), style: style, onPressed: onPressed),
    );
  }
}