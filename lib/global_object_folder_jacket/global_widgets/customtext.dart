import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final String fontFamily;
  final TextStyle? style; // Optional TextStyle parameter
  final TextAlign? textAlign;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w600,
    this.fontFamily = 'Geist',
    this.style,
    this.textAlign, // Optional TextStyle
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ??
        TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
        );

    return Text(
      text,
      style: textStyle,
    );
  }
}
