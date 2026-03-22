import 'dart:math';

import 'package:clapmi/global_object_folder_jacket/global_widgets/fancy_text.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ShowcaseWidget extends StatefulWidget {
  final ShowCaseController theShowCaseController;
  const ShowcaseWidget({super.key, required this.theShowCaseController});

  @override
  State<ShowcaseWidget> createState() => _ShowcaseWidgetState();
}

class _ShowcaseWidgetState extends State<ShowcaseWidget>
    with TickerProviderStateMixin {
  @override
  initState() {
    widget.theShowCaseController.theAnimationController =
        theAnimationController = AnimationController(vsync: this);
    widget.theShowCaseController.theFaderAnimationController =
        theFaderAnimationController = AnimationController(vsync: this);

    super.initState();
    widget.theShowCaseController.updaterFunction = () {
      setState(() {});
    };
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        // theFaderAnimationController.duration = 1.seconds;
        theFaderAnimationController.reset();
        theFaderAnimationController.forward();
        theLinearStepLoaderController.animateNext();
      },
    );
  }

  late AnimationController theLineAnimationController =
      AnimationController(vsync: this);
  late LinearStepLoaderController theLinearStepLoaderController =
      LinearStepLoaderController(
          currentIndex: () => widget.theShowCaseController.currentIndex,
          count: widget
              .theShowCaseController.theListOfConfigurationDetails!.length,
          onStepAnimationEnd: () async {
            widget.theShowCaseController.next();

            setState(() {});
            if (widget.theShowCaseController.currentIndex !=
                widget.theShowCaseController.theListOfConfigurationDetails!
                        .length -
                    1) {
              // widget.theShowCaseController.currentIndex++;

              theLinearStepLoaderController.animateNext();
            } else {
              await theLinearStepLoaderController.animateNext();
              try {
                context.pop();
              } catch (e) {
                theLinearStepLoaderController.pauseAnimation();
              }
            }
            // animatetilTheEnd
          },
          vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: _buildMainBody());
  }

  GestureDetector _buildMainBody() {
    return GestureDetector(
      onTapDown: (details) {
        theLinearStepLoaderController.pauseAnimation();
      },
      onTapUp: (details) {
        theLinearStepLoaderController.resumeAnimation();
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            widget
                .theShowCaseController
                .theListOfConfigurationDetails![
                    widget.theShowCaseController.currentIndex]
                .backgroundWidget
                .animate(
                    // controller: widget.theShowCaseController
                    //     .theFaderAnimationController,
                    autoPlay: true)
                .fadeIn(),
            Align(
              alignment: widget
                  .theShowCaseController
                  .theListOfConfigurationDetails![
                      widget.theShowCaseController.currentIndex]
                  .messageBoxAlignment,
              child: FancyContainer(
                width: 200,
                nulledAlign: true,
                backgroundColor: Colors.blue,
                radius: 12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FancyText(
                    widget
                        .theShowCaseController
                        .theListOfConfigurationDetails![
                            widget.theShowCaseController.currentIndex]
                        .instructions,
                    // "dbfdjsfbdsfjdbsfkjbdsfkjbdf,df,sdf,dsf sdf sdf dsf dslfdsmfsdfsdfsd,fsdf dsfsdf dsfsdf",
                    textColor: Colors.white,
                    weight: FontWeight.bold,
                  ),
                ),
              )
                  .animate(
                    controller: widget
                        .theShowCaseController.theFaderAnimationController,
                    autoPlay: false,
                  )
                  .fadeIn(
                    delay: .5.seconds,
                    duration: 1.seconds,
                  ),
            ),
            (widget
                        .theShowCaseController
                        .theListOfConfigurationDetails![
                            widget.theShowCaseController.currentIndex]
                        .pointerWidget ??
                    const Icon(
                      Icons.arrow_back,
                      size: 20,
                    ))
                .animate(
                  controller:
                      widget.theShowCaseController.theAnimationController,
                  autoPlay: false,
                )
                .rotate(
                    end: widget
                        .theShowCaseController
                        .theListOfConfigurationDetails![
                            widget.theShowCaseController.currentIndex]
                        .pointerAngle,
                    begin: widget
                        .theShowCaseController
                        .theListOfConfigurationDetails![
                            widget.theShowCaseController.previousIndex]
                        .pointerAngle)
                .align(
                    end: widget
                        .theShowCaseController
                        .theListOfConfigurationDetails![
                            widget.theShowCaseController.currentIndex]
                        .pointerAlignment,
                    begin: widget
                        .theShowCaseController
                        .theListOfConfigurationDetails![
                            widget.theShowCaseController.previousIndex]
                        .pointerAlignment),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        theLinearStepLoaderController.resetCurrentAnimation();
                        widget.theShowCaseController.prev();

                        theLinearStepLoaderController.animateNext();
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          FancyText(
                            "Previous",
                            textColor: Colors.white,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        theLinearStepLoaderController.endCurrentAnimation();
                        widget.theShowCaseController.next();

                        theLinearStepLoaderController.animateNext();
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          FancyText(
                            "Next",
                            textColor: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: LinearStepLoader(
                theLinearStepLoaderController: theLinearStepLoaderController,
              ),
            )
          ],
        ),
      ),
    );
  }

  late AnimationController theAnimationController;
  late AnimationController theFaderAnimationController;

  Offset? mousePosition;
}

class LinearStepLoader extends StatefulWidget {
  // final int currentIndex;

  final LinearStepLoaderController theLinearStepLoaderController;
  const LinearStepLoader({
    super.key,
    required this.theLinearStepLoaderController,
  });

  @override
  State<LinearStepLoader> createState() => _LinearStepLoaderState();
}

class _LinearStepLoaderState extends State<LinearStepLoader>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.theLinearStepLoaderController.animateNext();
      },
      child: Row(
          children:
              widget.theLinearStepLoaderController.theListOfAnimationController
                  .map(
                    (e) => FancyContainer(
                      // action: () {
                      //   // e.reset();
                      //   // e.forward();
                      // },
                      nulledAlign: true,
                      width: MediaQuery.sizeOf(context).width /
                          widget.theLinearStepLoaderController.count,
                      child: Stack(
                        children: [
                          FancyContainer(
                            backgroundColor: Colors.grey,
                            height: 5,
                            width: double.infinity,
                          ),
                          FancyContainer(
                            height: 5,
                            backgroundColor: Colors.blue,
                            width: double.infinity,
                          ).animate(controller: e, autoPlay: false).scaleX(
                              begin: 0,
                              end: 1,
                              alignment: Alignment.centerLeft,
                              duration: 5.seconds)
                        ],
                      ),
                    ),
                  )
                  .toList()),
    );
  }
}

class LinearStepLoaderController {
  bool internalCheck = false;
  bool onLongTapIsActive = false;
  final int count;

  final Future Function() onStepAnimationEnd;
  final int Function() currentIndex;

  Function() updaterFunction = () {};
  LinearStepLoaderController(
      {required this.count,
      required this.onStepAnimationEnd,
      required this.currentIndex,
      required TickerProvider vsync}) {
    theListOfAnimationController = List.generate(
      count,
      (index) {
        return AnimationController(vsync: vsync);
      },
    );
  }
  bool isPaused = false;
  pauseAnimation() {
    theListOfAnimationController[currentIndex()].stop();
    isPaused = true;
  }

  resetCurrentAnimation() {
    theListOfAnimationController[currentIndex()].reset();

    // ();
  }

  endCurrentAnimation() {
    theListOfAnimationController[currentIndex()].value = 1;
  }

  resumeAnimation() async {
    await theListOfAnimationController[currentIndex()].forward();
    await onStepAnimationEnd();
    updaterFunction();
    isPaused = false;
  }

  List<AnimationController> theListOfAnimationController = [];
  animateNext() async {
    theListOfAnimationController[currentIndex()].reset();
    await theListOfAnimationController[currentIndex()].forward();
    await onStepAnimationEnd();
    updaterFunction();
  }
}

class ShowcaseStepModel {
  final double pointerAngle;
  final String instructions;
  final String? description;

  final Alignment messageBoxAlignment;
  final Alignment pointerAlignment;
  final Widget backgroundWidget;
  Widget? pointerWidget;

  // assets/images/HTCGW-image-1.png
  final List<String> tags;

  ShowcaseStepModel({
    required this.pointerAngle,
    required this.messageBoxAlignment,
    required this.pointerAlignment,
    required this.backgroundWidget,
    this.tags = const [],
    required this.instructions,
    this.description,
    this.pointerWidget,
  }) {
    pointerWidget ??= SizedBox();
  }
}

class ShowCaseController {
  AnimationController? theAnimationController;
  AnimationController? theFaderAnimationController;
  int currentIndex = 0;
  int previousIndex = 0;
  Function() updaterFunction = () {};
  List<ShowcaseStepModel>? theListOfConfigurationDetails = [];
  ShowCaseController({this.theListOfConfigurationDetails}) {
    theListOfConfigurationDetails ??= [
      ShowcaseStepModel(
          pointerAngle: (pi / 180) * 0,
          messageBoxAlignment: Alignment(0, .2),
          pointerAlignment: Alignment(.5, -.2),
          backgroundWidget: FancyContainer(
            backgroundColor: Colors.black,
            child: Image.asset("assets/images/HTCGW-image-1.png"),
          ),
          tags: [],
          // for fan pov and creator pov
          description: 'Earn as a creator or a fan ',
          instructions:
              "Explore clapmi's ComboGround either as creator or as regular fan and get to enjoy unique benefit of the combo ground ",
          pointerWidget: SizedBox()),
      ShowcaseStepModel(
          pointerAngle: (pi / 180) * 22.5,
          messageBoxAlignment: Alignment(0, -.4),
          pointerAlignment: Alignment(-.6, .8),
          backgroundWidget: FancyContainer(
            backgroundColor: Colors.black,
            child: Image.asset("assets/images/HTCGW-image-2.png"),
          ),
          tags: [], // for fan pov and creator pov
          instructions:
              "sdbjsdjsakdjsdjsdbskdbdjb sd sdjsdjksbdjbd dsds dskbdksdbsd dsdjs dkjbsd dd "),
      ShowcaseStepModel(
          pointerAngle: (pi / 180) * 135,
          messageBoxAlignment: Alignment(0, .2),
          pointerAlignment: Alignment(-1, -.4),
          backgroundWidget: FancyContainer(
            backgroundColor: Colors.black,
            child: Image.asset("assets/images/HTCGW-image-4.png"),
          ),
          tags: [], // for fan pov and creator pov
          instructions:
              "sdbjsdjsakdjsdjsdbskdbdjb sd sdjsdjksbdjbd dsds dskbdksdbsd dsdjs dkjbsd dd "),
    ];
  }

  next() {
    previousIndex = currentIndex;
    currentIndex++;

    try {
      theListOfConfigurationDetails![currentIndex];
    } catch (e) {
      currentIndex = 0;
    }

    updaterFunction();
    theAnimationController?.reset();
    theAnimationController?.forward();
    updaterFunction();
    theFaderAnimationController?.reset();
    theFaderAnimationController?.forward();
    updaterFunction();
    // setState(() {});
  }

  prev() {
    previousIndex = currentIndex;
    currentIndex--;

    try {
      theListOfConfigurationDetails![currentIndex];
    } catch (e) {
      currentIndex = 0;
    }

    updaterFunction();
    theAnimationController?.reset();
    theAnimationController?.forward();
    updaterFunction();
    theFaderAnimationController?.reset();
    theFaderAnimationController?.forward();
    updaterFunction();
    // setState(() {});
  }
}
