import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/custom_container.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/customtext.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/Authentication/account_signup.dart';
import 'package:clapmi/screens/Authentication/googlesigin_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class UserChoiceScreen extends StatefulWidget {
  const UserChoiceScreen({super.key});

  @override
  State<UserChoiceScreen> createState() => _UserChoiceScreenState();
}

class _UserChoiceScreenState extends State<UserChoiceScreen> {
  void _openWebView(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsandWebView(videoUrl: url),
      ),
    );
  }

  String _getErrorMessage(Map<String, dynamic>? errorMessage) {
    print("dfbkfdsjfdjskfjkbfkbfdksbf>>$errorMessage");
    if (errorMessage == null) return 'An error occurred';

    if (errorMessage['userdata'] != null &&
        errorMessage['userdata'] is List &&
        (errorMessage['userdata'] as List).isNotEmpty) {
      return errorMessage['userdata'][0].toString();
    }

    if (errorMessage['password'] != null &&
        errorMessage['password'] is List &&
        (errorMessage['password'] as List).isNotEmpty) {
      return errorMessage['password'][0].toString();
    }
    if (errorMessage["theMessage"] != null) {
      return errorMessage["theMessage"];
    }
    // if(errorMessage.contains(""))

    return 'An error occurred';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Logo Centered
                Center(
                  child: SvgPicture.asset(
                    'assets/images/clapmi1.svg',
                    width: 50.w,
                    height: 50.w,
                  ),
                ),
                SizedBox(height: 60.h),

                /// Title
                const CustomText(
                  text: 'Get Started',
                  color: Colors.white,
                  fontSize: 31,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
                SizedBox(height: 30.h),

                BlocListener<UserBloc, UserState>(
                  listener: (context, state) {
                    // TODO: implement listener
                    if (state is GetUserDetailsSuccessState) {
                      if (state.userEntity.name == null) {
                        context.goNamed(MyAppRouteConstant.buildYourFeedScreen);
                      } else {
                        context.goNamed(MyAppRouteConstant.feedScreen);
                      }
                    }
                  },
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is UserLoginSuccessState) {
                        // Navigate to home or show success
                        context.read<UserBloc>().add(GetUserDetailsEvent(""));
                        // Navigator.pushReplacementNamed(context, '/home');
                      }

                      if (state is UserLoginErrorState) {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_getErrorMessage(state.errorMessage)),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is GoogleSigupLoadingState;
                      return GestureDetector(
                        onTap: isLoading
                            ? null
                            : () {
                                context
                                    .read<AuthBloc>()
                                    .add(GoogleSignuPEvent());
                              },
                        child: ReusableContainer(
                          height: 60.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isLoading)
                                  SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                    ),
                                  )
                                else ...[
                                  Image.asset('assets/icons/avater.png'),
                                  SizedBox(width: 10.w),
                                  const CustomText(
                                    text: 'Sign up with Google',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    fontFamily: 'Geist',
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),

                /// Sign up with Email
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SignupAccount(), // Replace with your screen
                      ),
                    );
                  },
                  child: ReusableContainer(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: AppColors.primaryColor,
                    ),
                    child: const Center(
                      child: CustomText(
                        text: 'Sign up with email',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Geist',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                /// Divider with "or"
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.dealColors)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: const CustomText(
                        text: 'or',
                        color: AppColors.dealColors,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.dealColors)),
                  ],
                ),
                SizedBox(height: 30.h),

                /// Create account
                GestureDetector(
                  onTap: () =>
                      context.goNamed(MyAppRouteConstant.accountsignup),
                  child: ReusableContainer(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: AppColors.primaryColor,
                    ),
                    child: const Center(
                      child: CustomText(
                        text: 'Create account',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                /// Terms with clickable links
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Geist',
                              ),
                              children: [
                                const TextSpan(
                                  text: 'By signing up, you agree to the ',
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () =>
                                        _openWebView('https://clapmi.com'),
                                    child: const Text(
                                      'Terms of services',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.blue,
                                        fontFamily: 'Geist',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: ' and\n'),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () =>
                                        _openWebView('https://clapmi.com'),
                                    child: const Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 13,
                                        fontFamily: 'Geist',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: ', including '),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () =>
                                        _openWebView('https://clapmi.com'),
                                    child: const Text(
                                      'Cookie Use',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 13,
                                        fontFamily: 'Geist',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
                SizedBox(height: 40.h),

                /// Already have an account?
                Column(
                  children: [
                    const CustomText(
                      text: 'Already have an account?',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lato',
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () => context.pushNamed(MyAppRouteConstant.login),
                      child: ReusableContainer(
                        height: 60.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent,
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        child: const Center(
                          child: CustomText(
                            text: 'Sign in',
                            fontFamily: 'Geist',
                            color: AppColors.dealColors,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
