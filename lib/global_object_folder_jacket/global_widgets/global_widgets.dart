import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:go_router/go_router.dart';

export 'customTextfiled.dart';
export 'customText.dart';
export 'CustomImageViewer.dart';
export 'video_trimmer_widget.dart';
export 'custom_container.dart';

// ignore: must_be_immutable
class CircularContainer extends StatelessWidget {
  Widget? child;
  double? radius;
  Color? color;
  CircularContainer({super.key, this.child, this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: color ?? AppColors.primaryColor),
      height: radius ?? 50,
      width: radius ?? 50,
      child: child,
    );
  }
}

// ignore: must_be_immutable
class FancyContainer extends StatefulWidget {
  Widget? child;
  double? radius;
  Color? backgroundColor;
  Color? borderColor;
  double? borderThickness;

  bool? hasBorder;
  double? height;
  double? width;
  List<BoxShadow> shadows = [];
  Function()? action;
  EdgeInsets? padding;
  final Alignment? alignment;
  final bool? isAsync;
  final bool? nulledAlign;
  final BoxConstraints? constraints;
  Widget? loadingWidget;
  final bool displayLoadingWidget;

  // noAli
  FancyContainer({
    super.key,
    this.child,
    this.radius,
    this.backgroundColor,
    this.borderColor,
    this.hasBorder,
    this.height,
    this.width,
    this.action,
    this.shadows = const [],
    this.padding,
    this.alignment,
    this.isAsync = false,
    this.constraints,
    this.nulledAlign,
    this.loadingWidget,
    this.borderThickness,
    this.displayLoadingWidget = true,
  });

  @override
  State<FancyContainer> createState() => _FancyContainerState();
}

Container circularContainer({Widget? child, double? radius, Color? color}) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
        shape: BoxShape.circle, color: color ?? AppColors.primaryColor),
    height: radius ?? 50,
    width: radius ?? 50,
    child: child,
  );
}

class _FancyContainerState extends State<FancyContainer> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    widget.hasBorder ??= false;
    widget.borderColor ??= const Color(0xFF000000);
    Widget displayedWidget = Container(
      constraints: widget.constraints,
      clipBehavior: Clip.hardEdge,
      padding: widget.padding,
      alignment: (widget.nulledAlign ?? false)
          ? null
          : widget.alignment ?? Alignment.center,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        boxShadow: widget.shadows,
        borderRadius: BorderRadius.circular(widget.radius ?? 8),
        color: widget.backgroundColor,
        border: widget.hasBorder!
            ? Border.all(
                color: widget.borderColor!,
                width: widget.borderThickness?.toDouble() ?? 1)
            : null,
      ),
      child: widget.child,
    );

    Widget displayedWidgetWithActionability = GestureDetector(
        onTap: (widget.action != null)
            ? (widget.isAsync ?? true)
                ? () async {
                    isLoading = true;
                    setState(() {});
                    await Future.delayed(const Duration(seconds: 1));
                    await widget.action?.call();
                    isLoading = false;
                    setState(() {});
                  }
                : () {
                    widget.action?.call();
                  }
            : null,
        child: displayedWidget);
    return !isLoading
        ? displayedWidgetWithActionability
        : (widget.displayLoadingWidget)
            ? widget.loadingWidget ??
                SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator.adaptive()),
                    ),
                  ),
                )
            : displayedWidget;
  }
}

// ignore: must_be_immutable
class TitleMoreAndBodyWidget extends StatelessWidget {
  String title;
  void Function()? seeAllFunction;
  Widget body;
  Widget? othetSideButton;

  final bool? isSeeAll;

  TitleMoreAndBodyWidget({
    super.key,
    required this.title,
    this.seeAllFunction,
    required this.body,
    this.isSeeAll,
    this.othetSideButton,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? style = Theme.of(context).textTheme.bodyMedium;
    return Column(
      children: [
        Row(
          children: [
            Text(title, style: style),
            const Expanded(child: SizedBox()),
            othetSideButton ??
                SeeAllOrNot(
                    isSeeAll ?? false,
                    TextButton(
                        onPressed: () {
                          seeAllFunction?.call();
                        },
                        child: Text("", style: style))),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        body
      ],
    );
  }
}

class SeeAllOrNot extends StatelessWidget {
  bool isTrue;

  Widget wdgy;
  SeeAllOrNot(this.isTrue, this.wdgy, {super.key});

  @override
  Widget build(BuildContext context) {
    return (isTrue)
        ? wdgy
        : const SizedBox(
            height: 2,
            width: 2,
          );
  }
}

class PillButton extends StatefulWidget {
  final Widget? child;
  final Color? backgroundColor;
  final Color? borderColor;
  final Function()? onTap;
  final Function()? onPressed; // Added optional onPressed
  final bool? isAsync;
  final double? height;
  final double? width;
  final EdgeInsets? padding;

  const PillButton({
    super.key,
    this.child,
    this.backgroundColor,
    this.onTap,
    this.onPressed, // Make onPressed optional
    this.isAsync = false,
    this.height,
    this.width,
    this.padding,
    this.borderColor,
    BorderRadius? borderRadius, // borderColor is optional
  });

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  @override
  Widget build(BuildContext context) {
    bool hasBorder = widget.borderColor !=
        null; // Border is shown if borderColor is provided

    return GestureDetector(
      onTap:
          widget.onTap ?? widget.onPressed, // Handle both onTap and onPressed
      child: FancyContainer(
        radius: 70,
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        backgroundColor: widget.backgroundColor ?? AppColors.primaryColor,
        action: widget.onTap ?? widget.onPressed, // Ensure action is triggered
        isAsync: widget.isAsync,
        height: widget.height,
        width: widget.width,
        borderColor: widget.borderColor,
        hasBorder: hasBorder, // Border visibility controlled by hasBorder
        child: widget.child,
      ),
    );
  }
}

Widget buildBackArrow(BuildContext context) {
  return Visibility(
    visible: !(ModalRoute.of(context)?.isFirst ?? true),
    child: Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: SizedBox(
        height: 30,
        width: 30,
        child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: const Icon(Icons.chevron_left)),
      ),
    ),
  );
}

SnackBar generalSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: AppColors.primaryColor,
  );
}

SnackBar generalErrorSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red[900],
  );
}

SnackBar generalSuccessSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green[900],
  );
}

// empty widget
// empty widget

Widget comingSoonWidget = SizedBox(
  width: 250.0,
  child: AnimatedTextKit(
    animatedTexts: [
      ColorizeAnimatedText('Coming Soon',
          textStyle: TextStyle(
            fontSize: 40.0,
            fontFamily: 'Horizon',
            fontWeight: FontWeight.w900,
          ),
          colors: [
            Colors.purple,
            Colors.blue,
            Colors.yellow,
            Colors.red,
          ],
          speed: Duration(milliseconds: 500)),
    ],
    isRepeatingAnimation: true,
    repeatForever: true,
    pause: Duration.zero,
    onTap: () {},
  ),
);

Widget buildEmptyWidget(String message, [Widget? actionChild]) {
  return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
        SvgPicture.asset("assets/images/empty_state.svg"),
        const SizedBox(height: 20),
        if (actionChild != null) actionChild
      ]));
}
