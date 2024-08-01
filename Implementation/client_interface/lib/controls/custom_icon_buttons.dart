import 'package:flutter/material.dart';

//----------------------------------------------------------------------------------------------------------------------

class IconButtonAccept extends StatelessWidget with _SizedIconButton {
  final IconData icon;
  final VoidCallback onPressed;
  const IconButtonAccept(this.icon, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = Theme.of(context).extension<IconButtonAcceptTheme>()!.style;
    return buildSizedIconButton(icon: icon, style: style, onPressed: onPressed);
  }
}

//----------------------------------------------------------------------------------------------------------------------

class IconButtonAcceptTheme extends ThemeExtension<IconButtonAcceptTheme> {
  final ButtonStyle style;

  const IconButtonAcceptTheme({required this.style});

  @override
  ThemeExtension<IconButtonAcceptTheme> copyWith() {
    return IconButtonAcceptTheme(style: style);
  }

  @override
  ThemeExtension<IconButtonAcceptTheme> lerp(covariant IconButtonAcceptTheme? other, double t) {
    if (other == null) return this;
    return IconButtonAcceptTheme(
      style: ButtonStyle.lerp(style, other.style, t)!,
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------

class IconButtonReject extends StatelessWidget with _SizedIconButton {
  final IconData icon;
  final VoidCallback onPressed;
  const IconButtonReject(this.icon, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = Theme.of(context).extension<IconButtonRejectTheme>()!.style;
    return buildSizedIconButton(icon: icon, style: style, onPressed: onPressed);
  }
}

//----------------------------------------------------------------------------------------------------------------------

class IconButtonRejectTheme extends ThemeExtension<IconButtonRejectTheme> {
  final ButtonStyle style;

  const IconButtonRejectTheme({required this.style});

  @override
  ThemeExtension<IconButtonRejectTheme> copyWith() {
    return IconButtonRejectTheme(style: style);
  }

  @override
  ThemeExtension<IconButtonRejectTheme> lerp(covariant IconButtonRejectTheme? other, double t) {
    if (other == null) return this;
    return IconButtonRejectTheme(
      style: ButtonStyle.lerp(style, other.style, t)!,
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------

class IconButtonAction extends StatelessWidget with _SizedIconButton {
  final IconData icon;
  final VoidCallback onPressed;
  const IconButtonAction(this.icon, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = Theme.of(context).extension<IconButtonActionTheme>()!.style;
    return buildSizedIconButton(icon: icon, style: style, onPressed: onPressed);
  }
}

//----------------------------------------------------------------------------------------------------------------------

class IconButtonActionTheme extends ThemeExtension<IconButtonActionTheme> {
  final ButtonStyle style;

  const IconButtonActionTheme({required this.style});

  @override
  ThemeExtension<IconButtonActionTheme> copyWith() {
    return IconButtonActionTheme(style: style);
  }

  @override
  ThemeExtension<IconButtonActionTheme> lerp(covariant IconButtonActionTheme? other, double t) {
    if (other == null) return this;
    return IconButtonActionTheme(
      style: ButtonStyle.lerp(style, other.style, t)!,
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------

mixin _SizedIconButton {
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

//----------------------------------------------------------------------------------------------------------------------
