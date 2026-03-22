import 'package:clapmi/core/security/secure_key.dart';
import 'package:clapmi/core/services/simple_persistent_offline_storage_handler.dart';
import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignupAccount extends StatefulWidget {
  const SignupAccount({super.key});

  @override
  State<SignupAccount> createState() => _SignupAccountState();
}

class _SignupAccountState extends State<SignupAccount> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isAgreed = false;

  String? fullNameError;
  String? usernameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

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

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  void _validateAndSignUp() {
    setState(() {
      fullNameError = null;
      usernameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;

      if (_fullnameController.text.trim().isEmpty) {
        fullNameError = "Full name is required";
      }
      if (_usernameController.text.trim().isEmpty) {
        usernameError = "Username is required";
      }
      if (_emailController.text.trim().isEmpty) {
        emailError = "Email is required";
      } else if (!_isValidEmail(_emailController.text.trim())) {
        emailError = "Enter a valid email";
      }
      if (_passwordController.text.isEmpty) {
        passwordError = "Password is required";
      } else if (_passwordController.text.length < 6) {
        passwordError = "Password must be at least 6 characters";
      }
      if (_confirmPasswordController.text.isEmpty) {
        confirmPasswordError = "Confirm password is required";
      } else if (_confirmPasswordController.text != _passwordController.text) {
        confirmPasswordError = "Passwords do not match";
      }
    });

    if (fullNameError == null &&
        usernameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      if (!_isAgreed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please agree to the terms and conditions',
              style: TextStyle(fontFamily: 'Raleway'),
            ),
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(NewUserSignUpEvent(
            fullName: _fullnameController.text.trim(),
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
          ));
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: CustomText(
          text: 'Back',
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is NewUserSignUpSuccessState) {
            context.goNamed(
              MyAppRouteConstant.emailVerificationScreen,
              extra: {
                "email": _emailController.text,
                "flow": "Sign Up",
              },
            );
          }
          if (state is NewUserSignUpErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(generalSnackBar(state.errorMessage));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'Sign up',
                    color: Colors.white,
                    fontSize: 31,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Geist',
                  ),
                  SizedBox(height: 15.h),

                  /// Full Name
                  CustomText(
                    text: 'Full Name',
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextField(
                    textStyle: const TextStyle(color: Colors.white),
                    backgroundColor: AppColors.secondaryColor,
                    hintText: 'John Doe',
                    controller: _fullnameController,
                    borderColor: const Color(0xFF3D3D3D),
                    obscureText: false,
                    hintTextColor: Colors.grey,
                    readOnly: false,
                    onChanged: (_) {
                      if (fullNameError != null) {
                        setState(() => fullNameError = null);
                      }
                    },
                  ),
                  if (fullNameError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: CustomText(
                        text: fullNameError!,
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  SizedBox(height: 10.h),

                  /// Username
                  CustomText(
                    text: 'Username',
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextField(
                    textStyle: const TextStyle(color: Colors.white),
                    backgroundColor: AppColors.secondaryColor,
                    hintText: '@username',
                    controller: _usernameController,
                    obscureText: false,
                    hintTextColor: Colors.grey,
                    borderColor: const Color(0xFF3D3D3D),
                    readOnly: false,
                    onChanged: (_) {
                      if (usernameError != null) {
                        setState(() => usernameError = null);
                      }
                    },
                  ),
                  if (usernameError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: CustomText(
                        text: usernameError!,
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  SizedBox(height: 10.h),

                  /// Email
                  CustomText(
                    text: 'Email',
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  CustomTextField(
                    textStyle: const TextStyle(color: Colors.white),
                    backgroundColor: AppColors.secondaryColor,
                    hintText: 'joedoe@gmail.com',
                    controller: _emailController,
                    borderColor: const Color(0xFF3D3D3D),
                    obscureText: false,
                    hintTextColor: Colors.grey,
                    readOnly: false,
                    onChanged: (_) {
                      if (emailError != null) {
                        setState(() => emailError = null);
                      }
                    },
                  ),
                  if (emailError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: CustomText(
                        text: emailError!,
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  SizedBox(height: 10.h),

                  /// Password
                  CustomText(
                    text: 'Password',
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  CustomTextField(
                    textStyle: const TextStyle(color: Colors.white),
                    backgroundColor: AppColors.secondaryColor,
                    hintText: '**********',
                    controller: _passwordController,
                    obscureText: true,
                    hintTextColor: Colors.grey,
                    borderColor: const Color(0xFF3D3D3D),
                    readOnly: false,
                    onChanged: (_) {
                      if (passwordError != null) {
                        setState(() => passwordError = null);
                      }
                    },
                  ),
                  if (passwordError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: CustomText(
                        text: passwordError!,
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  SizedBox(height: 10.h),

                  /// Confirm Password
                  CustomText(
                    text: 'Confirm Password',
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  CustomTextField(
                    textStyle: const TextStyle(color: Colors.white),
                    backgroundColor: AppColors.secondaryColor,
                    hintText: '************',
                    controller: _confirmPasswordController,
                    obscureText: !_isPasswordVisible,
                    hintTextColor: Colors.grey,
                    borderColor: const Color(0xFF3D3D3D),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 24.sp,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    readOnly: false,
                    onChanged: (_) {
                      if (confirmPasswordError != null) {
                        setState(() => confirmPasswordError = null);
                      }
                    },
                  ),
                  if (confirmPasswordError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: CustomText(
                        text: confirmPasswordError!,
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  SizedBox(height: 10.h),

                  /// Agreement
                  Row(
                    children: [
                      Checkbox(
                        value: _isAgreed,
                        onChanged: (value) {
                          setState(() {
                            _isAgreed = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: CustomText(
                          text: 'I agree to the terms and conditions',
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  /// Create Account Button
                  Center(
                    child: PillButton(
                      backgroundColor: AppColors.darkBlueColor,
                      isAsync: true,
                      onTap: state is NewUserSignUpLoadingState
                          ? null
                          : _validateAndSignUp,
                      child: state is NewUserSignUpLoadingState
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const CustomText(
                              text: 'Sign Up',
                              color: Colors.white,
                            ),
                    ),
                  ),
                  SizedBox(height: 20.h),

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
                  SizedBox(height: 10.h),
                  BlocListener<UserBloc, UserState>(
                    listener: (context, state) {
                      if (state is GetUserDetailsSuccessState) {
                        if (state.userEntity.name == null) {
                          context
                              .goNamed(MyAppRouteConstant.buildYourFeedScreen);
                        } else {
                          context.goNamed(MyAppRouteConstant.feedScreen);
                        }
                      }
                    },
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is UserLoginSuccessState) {
                          // Navigate to home or show success
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Login successful!')),
                          // );
                          context.read<UserBloc>().add(GetUserDetailsEvent(""));
                          // Navigator.pushReplacementNamed(context, '/home');
                        } //else

                        if (state is UserLoginErrorState) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(_getErrorMessage(state.errorMessage)),
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
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: 'Have an account?',
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed(
                          MyAppRouteConstant.login,
                          extra: {"toFeed": false},
                        ),
                        child: const CustomText(
                          text: ' Sign In',
                          color: AppColors.primaryColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
