import 'dart:typed_data';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/extraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Widget challengeBoxRep({
  String? challengerName,
  String? challengerImage,
  String? hostName,
  String? hostImage,
  Uint8List? hostImageByte,
  Uint8List? challengerImageByte,
  String? status,
  required int stakeAmount,
  required String timerCountdown,
}) {
  return
      //THIS IS SHOWING THE MAIN DESIGN
      Container(
    margin: EdgeInsets.symmetric(horizontal: 12),
    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //HOST DETAILS OR INFORMATIONS
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hostImageByte != null
                ? Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Makes it circular like your SVG
                      image: DecorationImage(
                        image: MemoryImage(hostImageByte),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : CustomImageView(
                    imagePath: hostImage,
                    height: 45,
                    width: 45,
                  ),
            const SizedBox(height: 5),
            Text(
              hostName ?? '',
              style: TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Stake ${stakeAmount.toString()}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Image.asset(
                  "assets/icons/Group (11).png",
                  height: 20,
                  width: 20,
                ),
              ],
            )
          ],
        ),
        // const SizedBox(width: 50),
        // const Text(
        //   "VS",
        //   style: TextStyle(fontSize: 20),
        // ),
        // const SizedBox(width: 50),
        //CHALLENGER DETAILS OR INFORMATIONS
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            challengerImageByte != null
                ? Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Makes it circular like your SVG
                      image: DecorationImage(
                        image: MemoryImage(challengerImageByte),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : CustomImageView(
                    imagePath: challengerImage,
                    height: 45,
                    width: 45,
                  ),
            const SizedBox(height: 5),
            Text(
              challengerName ?? '',
              style: TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Stake ${stakeAmount.toString()}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Image.asset(
                  "assets/icons/Group (11).png",
                  height: 20,
                  width: 20,
                ),
              ],
            )
          ],
        ),
      ],
    ),
  );
}

void showLiveStreamError(BuildContext context, {ComboEntity? livecombo, String? errorMessage}) {
  bool isLoading = false;
  bool isEndingStream = false;
  
  showDialog(
      context: (context),
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(140),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return BlocConsumer<ComboBloc, ComboState>(
            listener: (context, state) {
              if (state is GetComboDetailLoadingState) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is GetComboDetailErrorState) {
                setState(() {
                  isLoading = false;
                });
              }
              if (state is GetComboDetailSuccessState) {
                setState(() {
                  isLoading = false;
                });
                context
                    .read<ComboBloc>()
                    .add(GetLiveComboEvent(combo: state.comboEntity));
                context.pop();
              }
              if (state is LiveComboLoaded) {
                context.pop();
                context.pushNamed(MyAppRouteConstant.liveComboThreeImageScreen,
                    extra: {
                      'comboId': state.liveCombo.combo,
                      'liveCombo': state.liveCombo,
                      'brag': state.liveCombo.brag,
                    });
              }
              if (state is GetLiveComboErrorState) {
                setState(() {
                  isLoading = false;
                });
              }
              if (state is LeaveComboGroundSuccessState) {
                setState(() {
                  isEndingStream = false;
                });
                // After leaving, pop the dialog and the bottom sheet
                context.pop();
              }
              if (state is LeaveComboGroundErrorState) {
                setState(() {
                  isEndingStream = false;
                });
              }
            },
            builder: (context, state) {
              // Check if user is the host of this combo
              final bool isUserHost = livecombo?.host?.profile == profileModelG?.pid;
              
              return Dialog(
                backgroundColor: getFigmaColor("121212"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  height: 220.h,
                  child: Column(
                    children: [
                      // User Profile Section
                      if (profileModelG != null)
                        _buildUserProfileSection()
                      else if (livecombo != null)
                        LiveChallengeWidget(comboModel: livecombo!)
                      else
                        SizedBox(height: 40.h),
                      SizedBox(height: 8.h),
                      // Error Message - Centered
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          errorMessage ?? "You have an ongoing live stream",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "You can only have one live stream at a time",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isEndingStream
                                    ? null
                                    : () {
                                        // End and Start new - only works if user is host
                                        if (livecombo != null && isUserHost) {
                                          setState(() {
                                            isEndingStream = true;
                                          });
                                          context.read<ComboBloc>().add(
                                              LeaveComboGroundEvent(livecombo.combo ?? ''));
                                        } else {
                                          // If not host, just close the dialog
                                          context.pop();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: getFigmaColor("006FCD"),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: isEndingStream
                                    ? CircularProgressIndicator.adaptive()
                                    : Text(isUserHost ? 'End and Start new' : 'Close'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: livecombo != null
                                    ? () {
                                        if (livecombo.type == "single") {
                                          context.read<ComboBloc>().add(
                                              GetComboDetailEvent(
                                                  livecombo.combo ?? ''));
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: getFigmaColor("006FCD"),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator.adaptive()
                                    : const Text('Rejoin Live'),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
      });
}

/// Build user profile section showing avatar and name
Widget _buildUserProfileSection() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // User Avatar
        profileModelG?.myAvatar != null
            ? Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: MemoryImage(profileModelG!.myAvatar!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[800],
                ),
                child: profileModelG?.image != null
                    ? ClipOval(
                        child: Image.network(
                          profileModelG!.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24.sp,
                      ),
              ),
        SizedBox(width: 12.w),
        // User Name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              profileModelG?.username ?? 'Your Profile',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'You have an ongoing stream',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 10.sp,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
