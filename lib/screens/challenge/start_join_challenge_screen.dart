import 'dart:async';
import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/challenge_box.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/fancy_text.dart';
import 'package:clapmi/screens/challenge/widgets/challenge_box_rep.dart';
import 'package:clapmi/screens/challenge/widgets/challenge_buttons.dart';
import 'package:clapmi/screens/challenge/widgets/combo_details.dart';
import 'package:clapmi/screens/feed/widget/challenge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class StartOrJoinChallengeScreen extends StatefulWidget {
  const StartOrJoinChallengeScreen({
    super.key,
    required this.model,
  });

  final ComboEntity model;

  @override
  State<StartOrJoinChallengeScreen> createState() =>
      _StartOrJoinChallengeScreenState();
}

class _StartOrJoinChallengeScreenState
    extends State<StartOrJoinChallengeScreen> {
  bool isLoading = false;
  DateTime? targetTime;
  String? timerCountdown;
  bool reminderStateLoading = false;
  Timer? _timer;
  num? totalGiftingPot;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    context
        .read<ChatsAndSocialsBloc>()
        .add(GetTotalGiftsEvent(comboId: widget.model.combo ?? ''));
    print("-----${widget.model.start}---------------------");
    print("This is the comboEntity ${widget.model.stake}");
    _timer = Timer.periodic((Duration(seconds: 1)), (timer) {
      final now = DateTime.now();
      final remaining = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(widget.model.start ?? '', true)
          .toLocal()
          .difference(now);
      // targetTime?.difference(now);
      if (mounted) {
        if (remaining.isNegative || remaining.inSeconds == 0) {
          setState(() {
            timerCountdown = "00hr:00mins:00secs";
          });
          timer.cancel();
        } else {
          setState(() {
            timerCountdown =
                "${remaining.inHours}hr:${remaining.inMinutes % 60}mins:${remaining.inSeconds % 60}secs";
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getFigmaColor("0D0E0E"),
      //THIS IS THE COMBO TITLE
      appBar: AppBar(
        backgroundColor: getFigmaColor("0D0E0E"),
        leading: buildBackArrow(context),
        title: FancyText(widget.model.about ?? ''),
      ),
      body: BlocConsumer<ComboBloc, ComboState>(
        listener: (context, state) {
          if (state is SetRemindalForComboErrorState) {
            setState(() {
              reminderStateLoading = false;
            });
          }
          if (state is SetReminderForComboLoadingState) {
            setState(() {
              reminderStateLoading = true;
            });
          }
          if (state is GetComboDetailErrorState) {
            setState(() {
              isLoading = false;
            });
          }
          if (state is GetComboDetailSuccessState) {
            context
                .read<ComboBloc>()
                .add(GetLiveComboEvent(combo: state.comboEntity));
          }
          if (state is SetReminderForComboSuccessState) {
            setState(() {
              reminderStateLoading = false;
              context.pop();
              popUpMessages(context, state.message);
            });
          }
          if (state is StartComboLoadingState) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is StartComboErrorState) {
            setState(() {
              isLoading = false;
            });
            popUpMessages(context, state.errorMessage);
          }
          if (state is JoinComboGroundLoadingState) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is JoinComboGroundErrorState) {
            setState(() {
              isLoading = false;
            });
            popUpMessages(context, state.errorMessage);
          }
          if (state is StartComboSuccessState) {
            Future.delayed(Duration(seconds: 5), () {
              print(
                  "This is the comboId ${widget.model.combo}-----------------");
              context
                  .read<ComboBloc>()
                  .add(GetComboDetailEvent(widget.model.combo ?? ''));
            });
          }
          if (state is JoinComboGroundSuccessState) {
            print('JOIN COMBO SUCCESSFUL');
            context
                .read<ComboBloc>()
                .add(GetComboDetailEvent(widget.model.combo ?? ''));
          }
          if (state is LeaveComboGroundErrorState) {
            setState(() {
              isLoading = false;
            });
          }
          if (state is LiveComboLoaded) {
            setState(() {
              isLoading = false;
            });
            context.pushReplacementNamed(
                MyAppRouteConstant.liveComboThreeImageScreen,
                extra: {
                  'liveCombo': state.liveCombo,
                  'comboId': widget.model.combo,
                  'brag': widget.model.brag
                });
          }
        },
        builder: (context, state) {
          return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
            listener: (context, state) {
              if (state is PotAmount) {
                totalGiftingPot = state.totalAmount;
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Column(
                  children: [
                    //  THIS IS THE BOX DECORATED WITH THE CUSTOM BACKGROUND
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin:
                          const EdgeInsets.only(top: 8.0, right: 12, left: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: getFigmaColor("181919"),
                        border: Border.all(
                          color: getFigmaColor("181919"),
                        ),
                      ),
                      child: Column(
                        children: [
                          ThemeButton(
                              height: 30,
                              width: 190,
                              radius: 8,
                              color: widget.model.status != 'LIVE'
                                  ? getFigmaColor("E77D00", 50)
                                  : getFigmaColor('8C0F00'),
                              child: Text(
                                'Starts in $timerCountdown',
                                style: TextStyle(
                                    color: widget.model.status != 'LIVE'
                                        ? getFigmaColor("FFB500")
                                        : getFigmaColor('FFE8E6'),
                                    fontSize: 10,
                                    fontFamily: 'Geist',
                                    fontWeight: FontWeight.w500),
                              )),
                          SizedBox(
                            height: 10.h,
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: SvgPicture.asset(
                                  'assets/images/Arrow.svg',
                                  fit: BoxFit.cover,
                                  width: 400.w,
                                  height: 140.h,
                                ),
                              ),
                              challengeBoxRep(
                                challengerImage:
                                    widget.model.challenger?.avatar,
                                challengerName:
                                    widget.model.challenger?.username,
                                hostImage: widget.model.host?.avatar,
                                hostName: widget.model.host?.username,
                                hostImageByte: widget.model.host?.avatarConvert,
                                challengerImageByte:
                                    widget.model.challenger?.avatarConvert,
                                status: widget.model.status,
                                stakeAmount: widget.model.stake ?? 0,
                                timerCountdown: timerCountdown ?? '',
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          widget.model.status == 'LIVE'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Spectator 0",
                                      style: TextStyle(
                                        color: getFigmaColor('FFFFFF'),
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    ThemeButton(
                                      height: 24,
                                      width: 74,
                                      radius: 8,
                                      color: getFigmaColor("8C0F00"),
                                      child: Text(
                                        widget.model.status ?? '',
                                        style: TextStyle(
                                            color: getFigmaColor("FFB9B0"),
                                            fontSize: 10),
                                      ),
                                    ),
                                  ],
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: ThemeButton(
                                    height: 24,
                                    width: 74,
                                    radius: 8,
                                    color: getFigmaColor("E77D00", 50),
                                    child: Text(
                                      widget.model.status ?? '',
                                      style: TextStyle(
                                          color: getFigmaColor("EDA401"),
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    //THIS IS THE BACKGROUND CUSTOM IMAGE
                    const SizedBox(height: 20),
                    comboDetails(context,
                        combo: widget.model,
                        totalGiftingPot: totalGiftingPot ?? 0),
                    Spacer(),
                    StartNowButtonWidget(
                      combo: widget.model,
                      isLoading: isLoading,
                      onchanged: (duration) {
                        if (duration != null) {
                          showScheduleDialog(context, duration);
                        }
                      },
                      onTap: () {
                        if (widget.model.status == 'LIVE') {
                          context.read<ComboBloc>().add(
                              JoinComboGroundEvent(widget.model.combo ?? ''));
                        } else {
                          if (widget.model.host?.profile ==
                                  profileModelG?.pid ||
                              widget.model.challenger?.profile ==
                                  profileModelG?.pid) {
                            context
                                .read<ComboBloc>()
                                .add(StartComboEvent(widget.model.combo ?? ''));
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showScheduleDialog(BuildContext context, String duration) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // Set the background color to a dark shade
            backgroundColor: getFigmaColor("121212"),
            // Apply rounded corners to the dialog
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: Column(
              // Make the column take minimum space
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: Text(
                    "Click Ok to set a remider?",
                    style: TextStyle(
                      color: getFigmaColor("FFFFFF"),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ComboBloc>().add(
                                SetReminderForComboEvent(
                                    comboID: widget.model.combo ?? '',
                                    time: duration));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: getFigmaColor("FF1616"),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: reminderStateLoading
                              ? CircularProgressIndicator.adaptive()
                              : const Text('Ok'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: reminderStateLoading
                              ? CircularProgressIndicator.adaptive()
                              : const Text('Cancel'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
