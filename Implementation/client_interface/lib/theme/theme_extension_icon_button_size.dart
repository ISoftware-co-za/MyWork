import 'package:flutter/material.dart';

class ThemeExtensionIconButtonSize extends ThemeExtension<ThemeExtensionIconButtonSize> {
  final double smallIconSize;
  final double largeIconSize;
  final double smallPadding;
  final double largePadding;

  const ThemeExtensionIconButtonSize({
    required this.smallIconSize,
    required this.largeIconSize,
    required this.smallPadding,
    required this.largePadding,
  });

  @override
  ThemeExtensionIconButtonSize copyWith({
    double? smallIconSize,
    double? largeIconSize,
    double? smallPadding,
    double? largePadding,
  }) {
    return ThemeExtensionIconButtonSize(
      smallIconSize: smallIconSize ?? this.smallIconSize,
      largeIconSize: largeIconSize ?? this.largeIconSize,
      smallPadding: smallPadding ?? this.smallPadding,
      largePadding: largePadding ?? this.largePadding,
    );
  }

  @override
  ThemeExtensionIconButtonSize lerp(ThemeExtension<ThemeExtensionIconButtonSize>? other, double t) {
    if (other is! ThemeExtensionIconButtonSize) return this;
    return ThemeExtensionIconButtonSize(
      smallIconSize: smallIconSize + (other.smallIconSize - smallIconSize) * t,
      largeIconSize: largeIconSize + (other.largeIconSize - largeIconSize) * t,
      smallPadding: smallPadding + (other.smallPadding - smallPadding) * t,
      largePadding: largePadding + (other.largePadding - largePadding) * t,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ThemeExtensionIconButtonSize &&
              runtimeType == other.runtimeType &&
              smallIconSize == other.smallIconSize &&
              largeIconSize == other.largeIconSize &&
              smallPadding == other.smallPadding &&
              largePadding == other.largePadding;

  @override
  int get hashCode => smallIconSize.hashCode ^ largeIconSize.hashCode ^ smallPadding.hashCode ^ largePadding.hashCode;
}