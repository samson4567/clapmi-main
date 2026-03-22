import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is DeleteAccountSuccessState) {
            context.goNamed(MyAppRouteConstant.login, extra: {"toFeed": true});
          }
          if (state is DeleteAccountErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(generalSnackBar(state.errorMessage));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete your clapmi account permanently.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Do you want to delete your account?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'You are about to delete your account.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15.sp,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 40.h),

                // Delete + Cancel buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state is DeleteAccountLoadingState)
                      const CircularProgressIndicator()
                    else
                      PillButton(
                        backgroundColor: Colors.transparent,
                        borderColor: Colors.red,
                        width: 160.w,
                        height: 50.h,
                        onTap: () async {
                          TextEditingController cntrler =
                              TextEditingController();

                          String? password = await showDialog<String?>(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FancyContainer(
                                  nulledAlign: true,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 20,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Enter your password to delete",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: cntrler,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            hintText:
                                                "Enter your account's password",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        FancyContainer(
                                          action: () {
                                            context.pop(cntrler.text);
                                          },
                                          height: 50,
                                          child: const Center(
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                          if (password != null && password.isNotEmpty) {
                            context.read<UserBloc>().add(
                                  DeleteAccountEvent(password: password),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              generalSnackBar("Please enter your password"),
                            );
                          }
                        },
                        child: Text(
                          'Delete Account',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    SizedBox(width: 15.w),
                    PillButton(
                      backgroundColor: const Color(0xFF2E6BE6),
                      borderColor: const Color(0xFF2E6BE6),
                      width: 160.w,
                      height: 50.h,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                PillButton(
                  backgroundColor: const Color(0xFF2E6BE6),
                  borderColor: Colors.transparent,
                  width: double.infinity,
                  height: 55.h,
                  onTap: () {
                    // Handle update account action
                  },
                  child: Center(
                    child: Text(
                      'Update Account',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
