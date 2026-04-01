import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

class AcceptButtonWidget extends StatefulWidget {
  const AcceptButtonWidget({
    super.key,
    required this.onchanged,
    required this.onTap,
    required this.isLoading,
    required this.declineFunction,
    required this.declineLoading,
  });

  final Function() onTap;
  final Function() declineFunction;
  final Function(String?) onchanged;
  final bool isLoading;
  final bool declineLoading;

  @override
  State<AcceptButtonWidget> createState() => _AcceptButtonWidgetState();
}

class _AcceptButtonWidgetState extends State<AcceptButtonWidget> {
  String? durationString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: PillButton(
            backgroundColor: getFigmaColor('006FCD'),
            height: 55.h,
            onTap: widget.onTap,
            child: widget.isLoading
                ? CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  )
                : Text(
                    "Accept",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: getFigmaColor("FFFFFF"),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: PillButton(
                      borderColor: getFigmaColor('006FCD'),
                      backgroundColor: Colors.transparent,
                      height: 55.h,
                      child: Text(
                        durationString ?? "Accept & Reschedule",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: getFigmaColor("FFFFFF"),
                        ),
                      ),
                    ),
                  ),
                  value: durationString,
                  items: [
                    "5 minutes",
                    "15 minutes",
                    "30 minutes",
                    "60 minutes",
                    "2 hours",
                    "6 hours"
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      durationString = value;
                      widget.onchanged(value);
                    });
                    // onchanged(value);
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: PillButton(
                  borderColor: getFigmaColor('B51400'),
                  backgroundColor: getFigmaColor('B51400'),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) {
                        return DeclineCombo(
                          onConfirm: () {
                            Navigator.pop(context); // close modal
                            widget.declineFunction(); // perform action
                          },
                        );
                      },
                    );
                  },
                  height: 55.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/trash.svg"),
                      SizedBox(width: 8),
                      widget.declineLoading
                          ? CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation(
                                  getFigmaColor("FFFFFF")),
                              backgroundColor: Colors.white,
                            )
                          : Text(
                              "Decline",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: getFigmaColor("FFFFFF"),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 20)
      ],
    );
  }
}

class StartNowButtonWidget extends StatefulWidget {
  const StartNowButtonWidget({
    super.key,
    required this.onTap,
    required this.isLoading,
    required this.combo,
    required this.onchanged,
  });

  final Function()? onTap;
  final bool isLoading;
  final Function(String?) onchanged;
  final ComboEntity combo;

  @override
  State<StartNowButtonWidget> createState() => _StartNowButtonWidgetState();
}

class _StartNowButtonWidgetState extends State<StartNowButtonWidget> {
  String? durationString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   padding: const EdgeInsets.all(2.0),
        // child:
        PillButton(
          height: 50.h,
          backgroundColor: widget.combo.status != 'LIVE'
              ? profileModelG?.pid == widget.combo.host?.profile
                  ? AppColors.primaryColor
                  : profileModelG?.pid == widget.combo.challenger?.profile
                      ? AppColors.primaryColor
                      : Colors.grey
              : AppColors.primaryColor,
          onTap: widget.onTap,
          padding: EdgeInsets.zero,
          child: widget.isLoading
              ? CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                )
              : widget.combo.status == 'LIVE'
                  ? Center(
                      child: Text(
                        "Join now",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: getFigmaColor("FFFFFF")),
                      ),
                    )
                  : Center(
                      child: Text(
                        "Start now",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: getFigmaColor("FFFFFF")),
                      ),
                    ),
        ),
        //  ),
        if (widget.combo.status != 'LIVE') const SizedBox(height: 5),
        if (widget.combo.status != 'LIVE')
          Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: PillButton(
                          borderColor: getFigmaColor('006FCD'),
                          backgroundColor: Colors.transparent,
                          height: 55.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications_outlined),
                              durationString != null
                                  ? Text(
                                      "Before $durationString",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: getFigmaColor("FFFFFF"),
                                      ),
                                    )
                                  : Text(
                                      "Remind Me",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: getFigmaColor("FFFFFF"),
                                      ),
                                    ),
                            ],
                          )),
                    ),
                    value: durationString,
                    items: [
                      //"5 minutes",
                      "15 minutes",
                      "30 minutes",
                      "60 minutes",
                      "2 hours",
                      "6 hours"
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        durationString = value;
                        widget.onchanged(value);
                      });
                      // onchanged(value);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              //This is the share button for liveStreaming
              FancyContainer(
                height: 50.h,
                action: () {
                  SharePlus.instance.share(ShareParams(
                      title: 'Join the LiveStream on Clapmi',
                      text:
                          "Join Livestream on clapmi https://app.clapmi.com${MyAppRouteConstant.sharedLivestreamBase}/${widget.combo.combo}"));
                },
                width: 50.h,
                backgroundColor: Colors.white,
                radius: 50,
                child: SvgPicture.asset("assets/images/Vector.svg"),
              ),
            ],
          ),
      ],
    );
  }
}

class DeclineCombo extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeclineCombo({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 60.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Are you Sure you want to decline this challenge.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton(
                text: "No",
                color: const Color(0xFF181919),
                textColor: Colors.white,
                borderColor: Color(0XFF006FCD),
                onTap: () => Navigator.pop(context),
              ),
              _actionButton(
                text: "Yes",
                color: const Color(0XFFFF1616),
                textColor: Colors.white,
                borderColor: Color(0XFF006FCD),
                onTap: onConfirm, // Call the function passed
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _actionButton({
  required String text,
  required Color color,
  required Color textColor,
  required Color borderColor,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.h,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

      // context.read<ComboBloc>().add(LeaveComboGroundEvent(comboId));
      //             context.go(MyAppRouteConstant.feedScreen);
