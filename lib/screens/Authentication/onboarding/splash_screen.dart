import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> leftHandMove;
  late Animation<double> rightHandMove;
  late Animation<double> leftHandRotate;
  late Animation<double> rightHandRotate;

  @override
  void initState() {
    super.initState();
    // 👏 Clapping animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    leftHandMove = Tween<double>(begin: -40, end: -5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    rightHandMove = Tween<double>(begin: 40, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    leftHandRotate = Tween<double>(begin: -0.25, end: -0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    rightHandRotate = Tween<double>(begin: 0.25, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    setUpEveryThingAndGotoApropriatePage();
  }

  setUpEveryThingAndGotoApropriatePage() async {
    // First check in-memory variable
    if (isLoggedIn) {
      await initializeHandlers();
      context.go(MyAppRouteConstant.feedScreen);
      return;
    }

    // If in-memory is false, check SharedPreferences directly as backup
    try {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getBool('initialLoginStatusKey');
      print('Splash screen check - status: $status');

      if (status != null && !status) {
        // User is logged in according to SharedPreferences
        isLoggedIn = true;
        await initializeHandlers();
        context.go(MyAppRouteConstant.feedScreen);
        return;
      }
    } catch (e) {
      print('Error reading SharedPreferences in splash: $e');
    }

    // Not logged in - go to onboarding
    await Future.delayed(const Duration(seconds: 5));
    context.push(MyAppRouteConstant.onboardingPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return SizedBox(
              width: 200.w,
              height: 200.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // LEFT HAND
                  Transform.translate(
                    offset: Offset(rightHandMove.value, 0),
                    child: Transform.rotate(
                      angle: leftHandRotate.value,
                      child: SvgPicture.asset(
                        'assets/images/clap2.svg',
                        width: 110,
                        height: 110,
                      ),
                    ),
                  ),

                  // RIGHT HAND
                  Transform.translate(
                    offset: Offset(leftHandMove.value, 0),
                    child: Transform.rotate(
                      angle: rightHandRotate.value,
                      child: SvgPicture.asset(
                        'assets/images/clap1.svg',
                        width: 110,
                        height: 110,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
