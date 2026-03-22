import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FancyText extends StatefulWidget {
  final String text;
  final Color? textColor;
  final double? size;
  final FontWeight? weight;
  final TextAlign? textAlign;
  final TextStyle? rawTextStyle;
  final Function()? action;
  final bool? isAsync;
  final String? imageAsset;
  final double? imageSize;
  final double? fontSize;

  // noAli
  const FancyText(this.text,
      {super.key,
      this.textColor,
      this.size,
      this.weight,
      this.textAlign,
      this.rawTextStyle,
      this.action,
      this.isAsync,
      this.imageAsset,
      this.imageSize,
      this.fontSize});

  @override
  State<FancyText> createState() => _FancyTextState();
}

class _FancyTextState extends State<FancyText> {
  bool isLoading = false;
  TextStyle textStyle = TextStyle();

  @override
  Widget build(BuildContext context) {
    textStyle = TextStyle(
      color: widget.textColor,
      fontSize: widget.size,
      fontWeight: widget.weight,
      fontFamily: 'Poppins',
    );

    // widget.hasBorder ??= false;
    // widget.borderColor ??= const Color(0xFF000000);
    return !isLoading
        ? GestureDetector(
            onTap: (widget.action != null)
                ? (widget.isAsync ?? true)
                    ? () async {
                        isLoading = true;
                        if (mounted) setState(() {});
                        await Future.delayed(const Duration(seconds: 1));
                        await widget.action?.call();
                        isLoading = false;
                        if (mounted) setState(() {});
                      }
                    : () {
                        widget.action?.call();
                      }
                : null,
            child: Text(
              widget.text,
              style: widget.rawTextStyle ?? textStyle,
              textAlign: widget.textAlign,
            ),
          )
        : Container(
            child: const Center(
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator.adaptive()),
            ),
          );
  }
}
