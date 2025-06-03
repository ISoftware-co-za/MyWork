import 'package:flutter/material.dart';

class IconButtonSizeThemeExtension extends ThemeExtension<IconButtonSizeThemeExtension> {
  final double smallIconSize;
  final double largeIconSize;
  final double smallPadding;
  final double largePadding;

  const IconButtonSizeThemeExtension({
    required this.smallIconSize,
    required this.largeIconSize,
    required this.smallPadding,
    required this.largePadding,
  });

  @override
  IconButtonSizeThemeExtension copyWith({
    double? smallIconSize,
    double? largeIconSize,
    double? smallPadding,
    double? largePadding,
  }) {
    return IconButtonSizeThemeExtension(
      smallIconSize: smallIconSize ?? this.smallIconSize,
      largeIconSize: largeIconSize ?? this.largeIconSize,
      smallPadding: smallPadding ?? this.smallPadding,
      largePadding: largePadding ?? this.largePadding,
    );
  }

  @override
  IconButtonSizeThemeExtension lerp(ThemeExtension<IconButtonSizeThemeExtension>? other, double t) {
    if (other is! IconButtonSizeThemeExtension) return this;
    return IconButtonSizeThemeExtension(
      smallIconSize: smallIconSize + (other.smallIconSize - smallIconSize) * t,
      largeIconSize: largeIconSize + (other.largeIconSize - largeIconSize) * t,
      smallPadding: smallPadding + (other.smallPadding - smallPadding) * t,
      largePadding: largePadding + (other.largePadding - largePadding) * t,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IconButtonSizeThemeExtension &&
              runtimeType == other.runtimeType &&
              smallIconSize == other.smallIconSize &&
              largeIconSize == other.largeIconSize &&
              smallPadding == other.smallPadding &&
              largePadding == other.largePadding;

  @override
  int get hashCode => smallIconSize.hashCode ^ largeIconSize.hashCode ^ smallPadding.hashCode ^ largePadding.hashCode;
}