import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReusableContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final GestureTapCallback? onTap;
  final BoxDecoration? decoration;

  const ReusableContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.width,
    this.height,
    this.border,
    this.boxShadow,
    this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350.h,
        height: 55.h,
        padding: padding,
        margin: margin,
        decoration: decoration ??
            BoxDecoration(
              color: backgroundColor ?? Colors.black,
              borderRadius: borderRadius ?? BorderRadius.circular(26.0),
              border: border,
              boxShadow: boxShadow,
            ),
        child: child,
      ),
    );
  }
}
