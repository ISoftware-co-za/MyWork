import 'package:flutter/material.dart';

class ThemeExtensionIconButtonSize extends ThemeExtension<ThemeExtensionIconButtonSize> {
  final double smallIconSize;
  final double normalIconSize;
  final double largeIconSize;
  final double smallPadding;
  final double normalPadding;
  final double largePadding;

  const ThemeExtensionIconButtonSize({
    required this.smallIconSize,
    required this.normalIconSize,
    required this.largeIconSize,
    required this.smallPadding,
    required this.normalPadding,
    required this.largePadding,
  });

  @override
  ThemeExtensionIconButtonSize copyWith({
    double? smallIconSize,
    double? normalIconSize,
    double? largeIconSize,
    double? smallPadding,
    double? normalPadding,
    double? largePadding,
  }) {
    return ThemeExtensionIconButtonSize(
      smallIconSize: smallIconSize ?? this.smallIconSize,
      normalIconSize: normalIconSize ?? this.normalIconSize,
      largeIconSize: largeIconSize ?? this.largeIconSize,
      smallPadding: smallPadding ?? this.smallPadding,
      normalPadding: normalPadding ?? this.normalPadding,
      largePadding: largePadding ?? this.largePadding,
    );
  }

  @override
  ThemeExtensionIconButtonSize lerp(ThemeExtension<ThemeExtensionIconButtonSize>? other, double t) {
    if (other is! ThemeExtensionIconButtonSize) return this;
    return ThemeExtensionIconButtonSize(
      smallIconSize: smallIconSize + (other.smallIconSize - smallIconSize) * t,
      normalIconSize: normalIconSize + (other.normalIconSize - normalIconSize) * t,
      largeIconSize: largeIconSize + (other.largeIconSize - largeIconSize) * t,
      smallPadding: smallPadding + (other.smallPadding - smallPadding) * t,
      normalPadding: normalPadding + (other.normalPadding - normalPadding) * t,
      largePadding: largePadding + (other.largePadding - largePadding) * t,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ThemeExtensionIconButtonSize &&
              runtimeType == other.runtimeType &&
              smallIconSize == other.smallIconSize &&
              normalIconSize == other.normalIconSize &&
              largeIconSize == other.largeIconSize &&
              smallPadding == other.smallPadding &&
              normalPadding == other.normalPadding &&
              largePadding == other.largePadding;

  @override
  int get hashCode => smallIconSize.hashCode ^ normalIconSize.hashCode ^ largeIconSize.hashCode ^ smallPadding.hashCode ^ normalPadding.hashCode ^ largePadding.hashCode;
}