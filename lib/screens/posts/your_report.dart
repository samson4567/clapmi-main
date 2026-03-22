import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportSentPage extends StatelessWidget {
  const ReportSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Your report has been sent.',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Thanks for reporting this. Our team will\nreview it soon. Reports are anonymous, and\nyour feedback helps keep Clapmi safe and\nrespectful for everyone.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  context.pushNamed(MyAppRouteConstant.feedScreen);
                },
                child: FancyContainer(
                  backgroundColor: AppColors.primaryColor,
                  isAsync: true,
                  height: 55,
                  radius: 50,
                  hasBorder: true,
                  borderColor: AppColors.primaryColor,
                  child: const Text(
                    'Back to Post',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
