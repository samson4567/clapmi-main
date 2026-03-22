import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/services/image_picker_service.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_state.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditAccountPage extends StatefulWidget {
  final bool fromSignUpFlow;
  const EditAccountPage({
    super.key,
    required this.fromSignUpFlow,
  });

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  TextEditingController locationControler = TextEditingController();
  TextEditingController linksControler = TextEditingController();
  TextEditingController bioControler = TextEditingController();
  TextEditingController professionControler = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  String? displayedAvatarUrl;
  String? displayedBannerUrl;
  String? selectedAvatarFilePath;
  String? selectedBannerFilePath;
  Map? newDetails;

  initializeValue() {
    // final user = context.read<AppBloc>().state.user;
    print("This is the user of the application $profileModelG");
    displayedAvatarUrl = profileModelG?.image ?? '';
    //user?.image ?? "";
    displayedBannerUrl = userModelG?.banner;

    locationControler.text = profileModelG?.country ?? '';
    //user?.country ?? "";
    // linksControler.text = user.?.firstOrNull ?? "";
    bioControler.text = userModelG?.bio ?? '';

    //  user?.bio ?? "";
    professionControler.text = userModelG?.occupation ?? '';
    // profileModelG.occupation
    //  user?.occupation ?? "";
  }

  String? correctControlerEmptinessToNullOnAssignment(
      TextEditingController controller) {
    return (controller.text.isNotEmpty) ? controller.text : null;
  }

  @override
  void initState() {
    initializeValue();
    super.initState();
  }

  Map getUpdateDetails() {
    newDetails ??= {};
    if (locationControler.text.isNotEmpty) {
      newDetails?['location'] = locationControler.text;
    }
    if (bioControler.text.isNotEmpty) {
      newDetails?['bio'] = bioControler.text;
    }
    if (professionControler.text.isNotEmpty) {
      newDetails?['occupation'] = professionControler.text;
    }
    if (selectedBannerFilePath?.isNotEmpty == true

        // &&
        //     selectedBannerFilePath != displayedBannerUrl
        ) {
      print("dfhvdsfvdhfvjdfvhsvfhjs-True");
      newDetails?['banner'] = selectedBannerFilePath;
    }
    if (selectedAvatarFilePath?.isNotEmpty == true
        // &&
        //     selectedAvatarFilePath != displayedAvatarFilePath
        ) {
      newDetails?['profile_picture'] = selectedAvatarFilePath;
    }
    // Map otherUserDetail = {
    //   'location': locationControler.text,
    //   'links': linksControler.text,
    //   'bio': bioControler.text,
    //   'occupation': professionControler.text,
    //   "profile_picture": selectedAvatarFilePath,
    //   "banner": selectedBannerFilePath
    // };
    return newDetails ?? {};
  }

  bool checkIfValueIsNotEmpty({Map? otherUserDetail}) {
    otherUserDetail ??= getUpdateDetails();
    final result = (otherUserDetail.values
        .fold<String>(
            "", (previousValue, element) => previousValue + (element ?? ""))
        .isNotEmpty);

    return result;
  }

  updateUser() {
    // check if other user details is empty
    Map? otherUserDetail = getUpdateDetails();
    // if (!checkIfValueIsNotEmpty(otherUserDetail: otherUserDetail)) {
    //   otherUserDetail = null;
    //   return;
    // }
    print("dfhvdsfvdhfvjdfvhsvfhjs-%%%%->${userModelG?.bio}");
    context
        .read<UserBloc>()
        .add(UserDetailUpdateEvent(userDetail: otherUserDetail));
  }

  setUserDetails() {
    if (fullNameController.text.isNotEmpty &&
        occupationController.text.isNotEmpty &&
        bioControler.text.isNotEmpty) {
      context.read<UserBloc>().add(UserDetailUpdateEvent(userDetail: {
            'name': fullNameController.text,
            'occupation': occupationController.text,
            'bio': bioControler.text,
          }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        generalSnackBar('Enter Valid Details'),
      );
    }
  }

  // setInitialValues() {
  //   locationControler.text = userModelG?.location ?? "?";
  //   //  linksControler.text=userModelG. "";
  //   bioControler.text = userModelG?.bio ?? "";
  //   professionControler.text = userModelG?.occupation ?? "";
  //   fullNameController.text = profileModelG?.name ?? "";
  //   occupationController.text = userModelG?.occupation ?? "";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: buildBackArrow(context),
          title: const Text("Edit Profile"),
          actions: [
            BlocConsumer<UserBloc, UserState>(listener: (context, state) {
              if (state is UserDetailUpdateSuccessState) {
                print(
                    '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                context.goNamed(MyAppRouteConstant.feedScreen);
              }
            }, builder: (context, state) {
              return ElevatedButton(
                style: ButtonStyle(
                    side: WidgetStatePropertyAll(
                        BorderSide(color: getFigmaColor("006FCD"))),
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.transparent)),
                onPressed: () {
                  print("dfhvdsfvdhfvjdfvhsvfhjs---${[
                    getUpdateDetails(),
                    selectedBannerFilePath,
                    selectedAvatarFilePath
                  ]}");
                  if (widget.fromSignUpFlow) {
                    print(
                        '4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444');
                    setUserDetails();
                  } else {
                    print("dfhvdsfvdhfvjdfvhsvfhjs---${getUpdateDetails()}");
                    updateUser();
                  }
                },

                //  checkIfValueIsNotEmpty()
                //     ? () {
                //         if (widget.fromSignUpFlow) {
                //           setUserDetails();
                //         } else {
                //           updateUser();
                //         }
                //       }
                //     : () {
                //         context.goNamed(MyAppRouteConstant.feedScreen);
                //       },

                child: (state is UserDetailUpdateLoadingState)
                    ? Center(
                        child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation(
                                  AppColors.primaryColor),
                            )),
                      )
                    : widget.fromSignUpFlow
                        ? Text(
                            "Saveerer",
                            style: TextStyle(),
                          )
                        : (widget.fromSignUpFlow)
                            ? Text("Skip")
                            : Text("Save"),
              );
            })
          ],
        ),
        body: BlocConsumer<UserBloc, UserState>(listener: (context, state) {
          if (state is SelectBannerSuccessState) {
            selectedBannerFilePath = state.file.path;
            ScaffoldMessenger.of(context).showSnackBar(
              generalSnackBar("Banner Selected"),
            );
          }
          if (state is SelectProfilePictureSuccessState) {
            selectedAvatarFilePath = displayedAvatarUrl = state.file.path;
            ScaffoldMessenger.of(context).showSnackBar(
              generalSnackBar("Profile Picture Selected"),
            );
          }
// || state is SelectProfilePictureErrorState
          if (state is SelectBannerErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              generalSnackBar(state.errorMessage),
            );
          }
          if (state is SelectProfilePictureErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              generalSnackBar(state.errorMessage),
            );
          }
        }, builder: (context, state) {
          return BlocConsumer<AppBloc, AppState>(listener: (context, state) {
            if (state is UserUpdateSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                generalSnackBar("user updated"),
              );
            }

            if (state is UserUpdateErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                generalSnackBar(state.errorMessage),
              );
            }
          }, builder: (context, state) {
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Container(
                          color: AppColors.backgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              SizedBox(height: 10),
                              //**THIS LOOKS LIKE THE PROFILE PICTURE */
                              Container(
                                height: 54,
                                width: 54,
                                clipBehavior: Clip.hardEdge,
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: Stack(
                                  children: [
                                    profileModelG?.myAvatar != null
                                        ? Container(
                                            height: 40.w,
                                            width: 40.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                image: DecorationImage(
                                                    image: MemoryImage(
                                                        profileModelG!
                                                            .myAvatar!))),
                                          )
                                        : CustomImageView(
                                            imagePath: selectedAvatarFilePath ??
                                                displayedAvatarUrl,
                                            height: double.infinity,
                                            width: double.infinity,
                                          ),
                                    FancyContainer(
                                      backgroundColor:
                                          Colors.black.withAlpha(50),
                                      isAsync: true,
                                      action: () async {
                                        ImageSource? imageSource =
                                            await ImagePickerFunctionalities
                                                .showOptions(context);
                                        if (imageSource != null) {
                                          context.read<UserBloc>().add(
                                                SelectProfilePictureEvent(
                                                  imageSource: imageSource,
                                                ),
                                              );
                                        }
                                      },
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                          "assets/icons/galleryEdit.png",
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              if (widget.fromSignUpFlow)
                                _buildEntry(
                                    title: "Full Name",
                                    controller: fullNameController),
                              if (widget.fromSignUpFlow)
                                _buildEntry(
                                    title: "Occupation",
                                    controller: occupationController),
                              _buildEntry(
                                  title: "Bio",
                                  maxLines: 4,
                                  controller: bioControler),
                              if (!widget.fromSignUpFlow)
                                _buildEntry(
                                    title: "Profession",
                                    controller: professionControler),
                              if (!widget.fromSignUpFlow)
                                _buildEntry(
                                    title: "Location",
                                    controller: locationControler),
                              if (!widget.fromSignUpFlow)
                                _buildEntry(
                                    title: "Links", controller: linksControler),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Stack(
                      children: [
                        CustomImageView(
                          imagePath:
                              selectedBannerFilePath ?? displayedBannerUrl,
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Center(
                          child: BlocConsumer<UserBloc, UserState>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: FancyContainer(
                                      isAsync: true,
                                      action: () async {
                                        ImageSource? imageSource =
                                            await ImagePickerFunctionalities
                                                .showOptions(context);
                                        // print(
                                        //     "SDSADJSDKJSHDJSADJB${imageSource}");
                                        if (imageSource != null) {
                                          context.read<UserBloc>().add(
                                                SelectBannerEvent(
                                                  imageSource: imageSource,
                                                ),
                                              );
                                        }
                                      },
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                        "assets/icons/galleryEdit.png",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        }));
  }

  Column _buildEntry({
    Widget? specialChild,
    TextEditingController? controller,
    required String title,
    String? hint,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: getFigmaColor("5C5D5D"),
            fontWeight: FontWeight.bold,
          ),
        ),
        FancyContainer(
          backgroundColor: getFigmaColor("181919"),
          radius: 8,
          child: specialChild ??
              TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hint ?? "Enter your $title",
                  border: InputBorder.none,
                  filled: true,
                ),
              ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
