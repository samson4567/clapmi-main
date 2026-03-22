import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clapmi/core/app_variables.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

class SurfaceAnimationPanel extends StatefulWidget {
  const SurfaceAnimationPanel({super.key});

  @override
  State<SurfaceAnimationPanel> createState() => _SurfaceAnimationPanelState();
}

class _SurfaceAnimationPanelState extends State<SurfaceAnimationPanel>
    with TickerProviderStateMixin {
  final colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  final colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontFamily: 'Horizon',
  );
  final isComingWidget = SizedBox(
    child: DefaultTextStyle(
      style: const TextStyle(
        fontSize: 50.0,
        fontFamily: 'Bobbers',
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            'Coming Soon',
            speed: Duration(seconds: 1),
          ),
        ],
        onTap: () {},
        repeatForever: true,
      ),
    ),
  );

  Widget isCom = SizedBox(
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
  bool isDoingForward = false;

  @override
  initState() {
    super.initState();
    theclapAnimationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // color: Colors.red,
        child: Center(
            child: SizedBox(
          child: Stack(
            children: [
              SvgPicture.asset(
                'assets/images/clap2.svg',
                width: 60,
                height: 60,
              )
                  .animate(
                    onComplete: (controller) {
                      controller.repeat();
                      // if (isDoingForward) {
                      //   controller.forward();
                      //   isDoingForward = false;
                      // } else {
                      //   controller.reverse();
                      //   isDoingForward = true;
                      // }
                    },
                  )
                  .slideX(
                    end: clapWidth,
                    begin: -clapWidth,
                    curve: Curves.easeIn,
                    duration: clapDurationInSeconds.seconds,
                  )
                  .then()
                  .slideX(
                    begin: clapWidth,
                    end: -clapWidth,
                    curve: Curves.easeIn,
                    duration: clapDurationInSeconds.seconds,
                  ),
              SvgPicture.asset(
                'assets/images/clap1.svg',
                width: 60,
                height: 60,
              )
                  .animate(
                    onComplete: (controller) {
                      controller.repeat();

                      // if (isDoingForward) {
                      //   controller.forward();
                      //   isDoingForward = false;
                      // } else {
                      //   controller.reverse();
                      //   isDoingForward = true;
                      // }
                    },
                  )
                  .slideX(
                    end: -clapWidth,
                    begin: clapWidth,
                    curve: Curves.easeIn,
                    duration: clapDurationInSeconds.seconds,
                  )
                  .then()
                  .slideX(
                    begin: -clapWidth,
                    end: clapWidth,
                    curve: Curves.easeIn,
                    duration: clapDurationInSeconds.seconds,
                  ),
            ],
          ),
        )
                .animate(
                  controller: theclapAnimationController,
                  autoPlay: true,
                  onComplete: (controller) {
                    // controller.repeat();
                  },
                )
                .slideY(
                  end: -3,
                  begin: .5,
                  curve: Curves.easeIn,
                  duration: 3.seconds,
                )
                .fadeOut(delay: 1.seconds, duration: 1.seconds)),
      ),
    );

    // Scaffold(
    //   body: GestureDetector(
    //     // onTap: () {
    //     //   print("dfbdhfdvfjvdfjdsfjdsvf");
    //     //   theclapAnimationController.reset();
    //     //   theclapAnimationController.forward();
    //     //   setState(() {});
    //     // },
    //     child:   ),
    // );
  }

  double clapWidth = .3;
  double clapDurationInSeconds = .5;
}
