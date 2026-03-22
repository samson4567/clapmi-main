import 'dart:typed_data';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/CustomImageViewer.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
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

void showLiveStreamError(BuildContext context, {ComboEntity? livecombo}) {
  bool isLoading = false;
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
                context.pushNamed(MyAppRouteConstant.liveComboThreeImageScreen,
                    extra: {
                      'comboId': state.liveCombo.combo,
                      'liveCombo': state.liveCombo,
                      'brag': state.liveCombo.brag,
                    });
              }
            },
            builder: (context, state) {
              return Dialog(
                backgroundColor: getFigmaColor("121212"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  height: 160.h,
                  child: Column(
                    children: [
                      LiveChallengeWidget(comboModel: livecombo!),
                      SizedBox(height: 6.h),
                      Text(
                        "You have an ongoing live stream",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "You can only have one live stream at a time",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.pop();
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
                                child:
                                    //  reminderStateLoading
                                    //     ? CircularProgressIndicator.adaptive()                      :
                                    const Text('End and Start new'),
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
                                onPressed: () {
                                  if (livecombo.type == "single") {
                                    context.read<ComboBloc>().add(
                                        GetComboDetailEvent(
                                            livecombo.combo ?? ''));
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
