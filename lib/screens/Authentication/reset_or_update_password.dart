import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class ResetOrUpdatePassword extends StatefulWidget {
  bool? isReset;
  final String email;
  final String token;

  ResetOrUpdatePassword(
      {super.key,
      this.isReset = true,
      required this.email,
      required this.token});

  @override
  State<ResetOrUpdatePassword> createState() => _ResetOrUpdatePasswordState();
}

class _ResetOrUpdatePasswordState extends State<ResetOrUpdatePassword> {
  final TextEditingController passwordCondtroller = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccessState) {
              context
                  .goNamed(MyAppRouteConstant.login, extra: {"toFeed": true});
            }
            if (state is ResetPasswordErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.errorMessage));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Center(child: Image.asset('assets/images/clapmi.png')),
                SizedBox(height: 25.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text:
                        '${(widget.isReset ?? true) ? "Reset" : "Update"} Password',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Geist',
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'Enter your new password',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Geist',
                  ),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  textStyle:
                      const TextStyle(color: Color.fromARGB(255, 153, 60, 60)),
                  backgroundColor: AppColors.secondaryColor,
                  hintText: 'Password',
                  controller: passwordCondtroller,
                  obscureText: false,
                  hintTextColor: Colors.grey,
                  readOnly: false,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  textStyle: const TextStyle(color: Colors.white),
                  backgroundColor: AppColors.secondaryColor,
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  obscureText: false,
                  hintTextColor: Colors.grey,
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
                PillButton(
                  isAsync: true,
                  onTap: () {
                    context.read<AuthBloc>().add(ResetPasswordEvent(
                        token: widget.token,
                        email: widget.email,
                        password: passwordCondtroller.text,
                        confirmPassword: confirmPasswordController.text));
                  },
                  child: ReusableContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.primaryColor,
                    ),
                    child: const Center(
                      child: CustomText(
                        text: 'Reset Password',
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
