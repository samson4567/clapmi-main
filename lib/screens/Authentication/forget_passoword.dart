// ignore: unused_import
import 'package:clapmi/Models/custom_response_model.dart';
import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/Authentication/login_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccessState) {
              context.goNamed(MyAppRouteConstant.emailVerificationScreen,
                  extra: {
                    "email": _emailController.text,
                    "flow": "forgot password"
                  });
            }
            if (state is ForgotPasswordErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                generalSnackBar(state.errorMessage),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                          onPressed: () {
                            MaterialPageRoute(
                              builder: (context) => LoginPage(toFeed: null),
                            );
                          }),
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: CustomText(
                          text: 'Back',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Geist',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'Forget password',
                    color: Colors.white,
                    fontSize: 31,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Geist',
                  ),
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text:
                      'Enter emails that connected or associated to your account',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Geist',
                ),
                SizedBox(height: 20.h),
                CustomText(
                  text: 'Username or emails',
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Geist',
                ),
                SizedBox(height: 5.h),
                CustomTextField(
                  textStyle: const TextStyle(color: Colors.white),
                  backgroundColor: AppColors.secondaryColor,
                  hintText: 'joe@gmail.com',
                  controller: _emailController,
                  obscureText: false,
                  hintTextColor: Colors.grey,
                  borderColor: const Color(0xFF3D3D3D),
                  readOnly: false,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30.h),
                InkWell(
                  onTap: () {
                    if (state is! ForgotPasswordLoadingState) {
                      context.read<AuthBloc>().add(
                            ForgotPasswordEvent(
                              email: _emailController.text,
                            ),
                          );
                    }
                  },
                  child: ReusableContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.primaryColor,
                    ),
                    child: Center(
                      child: state is ForgotPasswordLoadingState
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const CustomText(
                              text: 'Submit',
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    context.push(MyAppRouteConstant.login);
                  },
                  child: ReusableContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.blue),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: CustomText(
                        text: 'Back',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
