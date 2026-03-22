import 'package:flutter/material.dart';

class CustomTextField<T> extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Color? hintTextColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final TextStyle? textStyle;
  final TextStyle? hintStyle; // Added optional hintStyle
  final InputBorder? inputBorder;
  final int? maxLines;
  final InputDecoration? decoration;
  final Function(String)? onChanged;
  final BoxDecoration? boxDecoration;
  final bool isDropdown;
  final T? dropdownValue;
  final List<T>? dropdownItems;
  final Function(T?)? onDropdownChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.hintTextColor,
    this.backgroundColor = Colors.white,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.textStyle,
    this.hintStyle, // Allow external hintStyle customization
    this.inputBorder,
    this.borderColor,
    this.maxLines = 1,
    this.decoration,
    this.onChanged,
    this.boxDecoration,
    this.isDropdown = false,
    this.dropdownValue,
    this.dropdownItems,
    this.onDropdownChanged,
    BorderRadius? borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration ??
          BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: borderColor ?? const Color(0xFF121212),
            ),
          ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: isDropdown && dropdownItems != null
          ? DropdownButtonFormField<T>(
              initialValue: dropdownValue,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              items: dropdownItems!
                  .map((item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          item.toString(),
                          style:
                              textStyle ?? const TextStyle(color: Colors.black),
                        ),
                      ))
                  .toList(),
              onChanged: onDropdownChanged,
            )
          : TextFormField(
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              readOnly: readOnly,
              maxLines: maxLines,
              style: textStyle,
              onChanged: onChanged,
              decoration: decoration ??
                  InputDecoration(
                    hintText: hintText,
                    hintStyle: hintStyle ??
                        TextStyle(color: hintTextColor ?? Colors.grey),
                    border: inputBorder ?? InputBorder.none,
                    suffixIcon: suffixIcon,
                    prefixIcon: prefixIcon,
                  ),
            ),
    );
  }
}
