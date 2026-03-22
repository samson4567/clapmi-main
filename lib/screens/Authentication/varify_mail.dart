import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String flow;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.flow,
  });

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  bool _isTyping = false;
  bool isFiled = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onInputChange(String value) {
    if (value.length == 1) {
      FocusScope.of(context).nextFocus();
    } else {
      FocusScope.of(context).previousFocus();
    }
    if (!_isTyping) {
      setState(() {
        _isTyping = true;
      });
    }
    if (_controllers.any((element) => element.text.isEmpty)) {
      isFiled = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Screen background
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar background
        elevation: 0,
        leading: buildBackArrow(context),
        title: const Text(
          'Back',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Geist',
          ),
        ),
      ),
      body: Container(
        color: Colors.black, // Ensures full black background
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is VerifyNewSignUpEmailSuccessState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.message));
              context.goNamed(MyAppRouteConstant.login, extra: {
                "toFeed": false,
              });
            }
            if (state is VerifyNewSignUpEmailErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.errorMessage));
            }
            if (state is VerifyForgotPasswordErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.errorMessage));
            }
            if (state is VerifyForgotPasswordSuccessState) {
              context.goNamed(MyAppRouteConstant.resetOrUpdatePasswordPassword,
                  extra: {"email": widget.email, "token": state.refreshToken});
            }
            if (state is ResendVerificationCodeErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.errorMessage));
            }
            if (state is ResendVerificationCodeSuccessState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.message));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  const Text(
                    'Email Verification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Geist',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    'A 6-digit confirmation code will be sent to your email for you to input below.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Geist',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 90.w),
                    child: const Text(
                      'Enter 6-digit code here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Geist',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => Container(
                        width: 40.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _isTyping ? Colors.red : Colors.grey),
                          color: Colors.black, // Black background for inputs
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            if (_controllers[index].text.length > 1) {
                              _controllers[index].text = value.split("").last;
                              FocusScope.of(context).nextFocus();
                            } else {
                              _onInputChange(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    child: Focus(
                      child: PillButton(
                        onTap: () {
                          String otp =
                              _controllers.map((e) => e.text).toList().join();

                          (widget.flow == "forgot password")
                              ? context.read<AuthBloc>().add(
                                  VerifyForgotPasswordEvent(
                                      email: widget.email, otp: otp))
                              : context.read<AuthBloc>().add(
                                    VerifyNewSignUpEmailEvent(
                                        email: widget.email, otp: otp),
                                  );
                        },
                        isAsync: true,
                        height: 60,
                        child: const Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FancyContainer(
                    isAsync: true,
                    height: 70,
                    radius: 40,
                    action: () {
                      context.read<AuthBloc>().add(
                            ResendVerificationCodeEvent(
                              email: widget.email,
                            ),
                          );
                    },
                    hasBorder: true,
                    borderColor: AppColors.primaryColor,
                    backgroundColor:
                        Colors.black, // Black background for resend
                    child: (state is ResendVerificationCodeLoadingState)
                        ? AspectRatio(
                            aspectRatio: 1,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: AppColors.backgroundColor,
                            ),
                          )
                        : const Text(
                            "Resend Code",
                            style: TextStyle(color: Colors.white),
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
