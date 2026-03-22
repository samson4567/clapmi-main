
import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/custom_container.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/customtext.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class passwordLink extends StatefulWidget {
  const passwordLink({super.key});

  @override
  State<passwordLink> createState() => _passwordLinkState();
}

class _passwordLinkState extends State<passwordLink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.h),
          child: Column(
            children: [
              Center(
                child: Image.asset('assets/images/clapmi.png'),
              ),
              SizedBox(
                height: 40.h,
              ),
              const CustomText(
                text: 'A link has being sent to your mail',
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontFamily: 'Geist',
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () => context.goNamed(MyAppRouteConstant.resetspassword),
                child: ReusableContainer(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.primaryColor,
                  ),
                  child: const Center(
                    child: CustomText(
                      text: 'Sign in',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
