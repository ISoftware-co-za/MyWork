part of dialog_work;

class WorkDialogTheme extends ThemeExtension<WorkDialogTheme> {
  final double width;
  final double height;
  final double padding;
  final double horizontalSpacing;
  final double verticalSpacing;
  final TextStyle headerTextStyle;

  final Color backgroundColor;

  const WorkDialogTheme({
    required this.width,
    required this.height,
    required this.padding,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.headerTextStyle,
    required this.backgroundColor,
  });

  @override
  ThemeExtension<WorkDialogTheme> copyWith() {
    return WorkDialogTheme(
      width: width,
      height: height,
      padding: padding,
      verticalSpacing: verticalSpacing,
      horizontalSpacing: horizontalSpacing,
      headerTextStyle: headerTextStyle,
      backgroundColor: backgroundColor,
    );
  }

  @override
  ThemeExtension<WorkDialogTheme> lerp(
      covariant WorkDialogTheme? other, double t) {
    if (other == null) return this;
    return WorkDialogTheme(
      width: lerpDouble(width, other.width, t)!,
      height: lerpDouble(height, other.height, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      verticalSpacing: lerpDouble(verticalSpacing, other.verticalSpacing, t)!,
      horizontalSpacing:
      lerpDouble(horizontalSpacing, other.horizontalSpacing, t)!,
      headerTextStyle:
      TextStyle.lerp(headerTextStyle, other.headerTextStyle, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }
}