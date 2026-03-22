import 'package:clapmi/core/security/secure_key.dart';
import 'package:clapmi/core/services/simple_persistent_offline_storage_handler.dart';
import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  final bool? toFeed;
  const LoginPage({super.key, required this.toFeed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        SimplePersistentOfflineStorageHandler()
            .save<int>(SecureKey.appPostauthUsecount, 0);
      },
    );
  }

  final TextEditingController _emailOrUsernameController =
      TextEditingController(text: kDebugMode ? "" : "");
  final TextEditingController _passwordController =
      TextEditingController(text: kDebugMode ? "" : "");

  bool isPasswordVisible = false;

  String? emailOrUsernameError;
  String? passwordError;

  bool _isValidEmail(String input) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(input);
  }

  bool _isValidUsername(String input) {
    final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{3,15}$');
    return usernameRegExp.hasMatch(input);
  }

  bool _isValidPassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  void _validateAndLogin() {
    setState(() {
      emailOrUsernameError = null;
      passwordError = null;

      final input = _emailOrUsernameController.text.trim();

      if (input.isEmpty) {
        emailOrUsernameError = "Email or username is required";
      } else if (!_isValidEmail(input) && !_isValidUsername(input)) {
        emailOrUsernameError = "Enter a valid email or username";
      }

      if (_passwordController.text.isEmpty) {
        passwordError = "Password is required";
      } else if (!_isValidPassword(_passwordController.text)) {
        passwordError = "Password must be at least 6 characters";
      }
    });

    if (emailOrUsernameError == null && passwordError == null) {
      context.read<AuthBloc>().add(
            UserLoginEvent(
              email: _emailOrUsernameController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  void launchUrlParsing(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      print("This is the url here $url");
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: SingleChildScrollView(
            child: BlocListener<UserBloc, UserState>(
              listener: (context, state) {
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
                  // Email/Password login success
                  if (state is UserLoginSuccessState) {
                    context.read<UserBloc>().add(GetUserDetailsEvent(""));
                  }

                  // Email/Password login error
                  if (state is UserLoginErrorState) {
                    print('This is the error state ${state.errorMessage}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_getErrorMessage(state.errorMessage)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      /// Back Button
                      if (context.canPop())
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                              CustomText(
                                text: 'Back',
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Geist',
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 30.h),

                      /// Title
                      CustomText(
                        text: 'Sign in',
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                      SizedBox(height: 20.h),

                      /// Email or Username Label
                      CustomText(
                        text: 'Username or Email',
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                      SizedBox(height: 8.h),

                      /// Email or Username Field
                      CustomTextField(
                        textStyle: const TextStyle(color: Colors.white),
                        backgroundColor: AppColors.secondaryColor,
                        hintText: 'Email/Username',
                        controller: _emailOrUsernameController,
                        obscureText: false,
                        hintTextColor:
                            const Color(0xFFE0E0E0), // off-white placeholder
                        borderColor: const Color(0xFF3D3D3D),
                        readOnly: false,
                        // FIX: Removed onChanged that caused full rebuild on each keystroke
                        // Error will be cleared when user focuses on field instead
                        borderRadius: BorderRadius.circular(30.r),
                      ),

                      if (emailOrUsernameError != null) ...[
                        SizedBox(height: 4.h),
                        CustomText(
                          text: emailOrUsernameError!,
                          color: Colors.red,
                          fontSize: 12.sp,
                        ),
                      ],

                      SizedBox(height: 16.h),

                      /// Password Field
                      CustomText(
                        text: 'Password',
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        textStyle: const TextStyle(color: Colors.white),
                        backgroundColor: AppColors.secondaryColor,
                        hintText: 'Password',
                        hintTextColor: const Color(0xFFE0E0E0),
                        controller: _passwordController,
                        obscureText: !isPasswordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.remove_red_eye
                                : Icons.visibility_off_sharp,
                            color: Colors.grey,
                          ),
                        ),
                        borderColor: const Color(0xFF3D3D3D),
                        readOnly: false,
                        // FIX: Removed onChanged that caused full rebuild on each keystroke
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      if (passwordError != null) ...[
                        SizedBox(height: 4.h),
                        CustomText(
                          text: passwordError!,
                          color: Colors.red,
                          fontSize: 12.sp,
                        ),
                      ],

                      /// Forgot Password
                      GestureDetector(
                        onTap: () =>
                            context.goNamed(MyAppRouteConstant.forgetPassowrd),
                        child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(top: 8.h),
                          child: const CustomText(
                            text: 'Forgot Password?',
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      /// Sign in Button
                      PillButton(
                        height: 60.h,
                        onTap: state is UserLoginLoadingState
                            ? null
                            : _validateAndLogin,
                        borderRadius: BorderRadius.circular(30.r),
                        child: state is UserLoginLoadingState
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const CustomText(
                                text: 'Sign in',
                                color: Colors.white,
                                fontFamily: 'Geist',
                              ),
                      ),

                      SizedBox(height: 20.h),

                      /// Divider with "or"
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: AppColors.dealColors, height: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: const CustomText(
                              text: 'or',
                              color: AppColors.dealColors,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                              child: Divider(
                                  color: AppColors.dealColors, height: 1)),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      /// Google Sign in Button
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is GoogleSigupSuccessState) {
                            // Navigate to home or show success
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Login successful!')),
                            );
                            // Navigator.pushReplacementNamed(context, '/home');
                          } else if (state is GoogleSigupErrorState) {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Login failed: ${state.errorMessage}'),
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
                                border: Border.all(color: Colors.blue),
                                color: Colors.black,
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
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        ),
                                      )
                                    else ...[
                                      Image.asset('assets/icons/avater.png'),
                                      SizedBox(width: 10.w),
                                      const CustomText(
                                        text: 'Sign in with Google',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Colors.white,
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
                      SizedBox(height: 25.h),

                      /// Sign Up Redirect
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context.goNamed(MyAppRouteConstant.accountsignup);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'New user? ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19.sp,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19.sp,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
