import 'package:clapmi/features/onboarding/data/models/other_user_model.dart';
import 'package:clapmi/features/onboarding/domain/entities/other_user_entity.dart';
import 'package:clapmi/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ConnectWithUserScreen extends StatefulWidget {
  const ConnectWithUserScreen({super.key});

  @override
  State<ConnectWithUserScreen> createState() => _ConnectWithUserScreenState();
}

class _ConnectWithUserScreenState extends State<ConnectWithUserScreen> {
  List<OtherUserEntity> listOfOtherUsersModel = [];

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(GetRandonUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            context.pushNamed(
              MyAppRouteConstant.editProfile,
              extra: {"fromSignUpFlow": true},
            );
          },
          child: const Text("Skip"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pushNamed(
                MyAppRouteConstant.editProfile,
                extra: {"fromSignUpFlow": true},
              );
            },
            child: const Text("Continue"),
          ),
        ],
      ),
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is GetRandomUserErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(generalSnackBar(state.errorMessage));
          }
          if (state is GetRandomUserSuccessState) {
            listOfOtherUsersModel = state.randomUsers;
          }
        },
        builder: (context, state) {
          if (state is GetRandomUserLoadingState) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }
          if (state is GetRandomUserErrorState) {
            return const Center(child: Text("An error has occurred"));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OnboardingBloc>().add(GetRandonUserEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Build Your Feed", style: titleStyle),
                  SizedBox(height: 4.h),
                  Text(
                    "Connect with users",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white.withOpacity(0.56),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (listOfOtherUsersModel.isEmpty)
                    buildEmptyWidget("No Suggested User")
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listOfOtherUsersModel.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final user = listOfOtherUsersModel[index];
                        final hasImage =
                            user.image != null && user.image!.trim().isNotEmpty;
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 70.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: Row(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: 40.w,
                                  height: 40.h,
                                  child: hasImage
                                      ? CustomImageView(imagePath: user.image)
                                      : Image.asset(
                                          "assets/images/default_profile.png",
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name ?? "N/A",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      user.occupation ?? "N/A",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              ClappedButton(
                                userModel: OtherUserModel.fromEntity(user),
                              ),
                            ],
                          ),
                        );
                      },
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

class ClappedButton extends StatefulWidget {
  final OtherUserModel userModel;

  const ClappedButton({super.key, required this.userModel});

  @override
  State<ClappedButton> createState() => _ClappedButtonState();
}

class _ClappedButtonState extends State<ClappedButton> {
  bool clappedOrNot = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is SendClapRequestToUsersSuccessState &&
            state.userPids.contains(widget.userModel.pid)) {
          setState(() => clappedOrNot = true);
          ScaffoldMessenger.of(context)
              .showSnackBar(generalSuccessSnackBar("Request sent"));
        }
        if (state is SendClapRequestToUsersRequestPendingState &&
            state.userPids.contains(widget.userModel.pid)) {
          setState(() => clappedOrNot = true);
          ScaffoldMessenger.of(context)
              .showSnackBar(generalErrorSnackBar("Request already sent"));
        }
        if (state is SendClapRequestToUsersErrorState &&
            state.userPids.contains(widget.userModel.pid)) {
          setState(() => clappedOrNot = false);
        }
      },
      builder: (context, state) {
        final isLoading = state is SendClapRequestToUsersLoadingState &&
            state.idsOFUsersThatWereSentRequest.contains(widget.userModel.pid);

        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  context.read<OnboardingBloc>().add(
                        SendClapRequestToUsersEvent(
                          userPids: [widget.userModel.pid],
                        ),
                      );
                },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: clappedOrNot ? AppColors.primaryColor : Colors.transparent,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      backgroundColor: AppColors.backgroundColor,
                    ),
                  )
                : Text(
                    clappedOrNot ? "Clapped" : "Clap",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color:
                          clappedOrNot ? Colors.white : AppColors.primaryColor,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
