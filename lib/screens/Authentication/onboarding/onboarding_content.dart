import 'package:clapmi/Models/onboarding_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingContent extends StatefulWidget {
  final OnboardingModel model;

  const OnboardingContent({super.key, required this.model});

  @override
  State<OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<OnboardingContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Animations
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;

  late Animation<Offset> _descriptionSlide;
  late Animation<double> _descriptionFade;

  late Animation<double> _imageScale;

  @override
  void initState() {
    super.initState();

    // 🔥 8-second controller
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // 🔵 Title drops in during first 3 seconds
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, -1.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
    ));

    _titleFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.30, curve: Curves.easeOut),
    ));

    // 🔶 Description slides up between 3–7 seconds
    _descriptionSlide = Tween<Offset>(
      begin: const Offset(0, 0.7),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
    ));

    _descriptionFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.80, curve: Curves.easeOut),
    ));

    // 🟣 Image pop-in over entire 8 seconds
    _imageScale = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOutExpo),
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 120.w, vertical: 30.h),
              child: SvgPicture.asset(
                'assets/images/clapmi1.svg',
                width: 50,
                height: 50,
              ),
            ),
            Positioned.fill(
              child: Transform.scale(
                scale: _imageScale.value,
                child: Image.asset(
                  widget.model.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: FancyContainer(
                radius: 20,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔵 TITLE
                    Opacity(
                      opacity: _titleFade.value,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: Text(
                          widget.model.blueText,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Color(0XFF8F9090),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔶 DESCRIPTION
                    Opacity(
                      opacity: _descriptionFade.value,
                      child: SlideTransition(
                        position: _descriptionSlide,
                        child: Text(
                          widget.model.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
