import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clapmi/screens/Authentication/onboarding/onboarding_content.dart';
import 'package:clapmi/Models/onboarding_dummy.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (i) => setState(() => currentIndex = i),
            itemBuilder: (context, index) =>
                OnboardingContent(model: onboardingData[index]),
          ),

          /// BOTTOM BUTTONS
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// SKIP
                if (currentIndex != onboardingData.length - 1)
                  GestureDetector(
                    onTap: () =>
                        context.go(MyAppRouteConstant.userChoiceScreen),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 50),

                /// NEXT BUTTON
                ElevatedButton(
                  onPressed: () {
                    if (currentIndex < onboardingData.length - 1) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go(MyAppRouteConstant.login);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006FCD),
                    fixedSize: const Size(180, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
