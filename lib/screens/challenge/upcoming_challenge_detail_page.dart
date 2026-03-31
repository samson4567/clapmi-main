// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/challenge_box.dart';
import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/brag/data/models/brag_challengers.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/fancy_text.dart';
import 'package:clapmi/screens/challenge/widgets/buildImage2.dart';
import 'package:clapmi/screens/challenge/widgets/challenge_buttons.dart';
import 'package:clapmi/screens/challenge/widgets/gift_live_coin.dart';
import 'package:clapmi/screens/feed/widget/challenge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// I need to get the timing information of the combo challenge.
// The status of the combo [pending, upcoming]
// The live duration information.
// ignore: must_be_immutable
//The title of the combo
//I need a challenge Id here also...
class UpcomingChallengeDetailPage extends StatefulWidget {
  final ProfileModel? host;
  final BragChallengersModel? challenge;
  final String postId;

  const UpcomingChallengeDetailPage(
      {super.key,
      required this.host,
      required this.challenge,
      required this.postId});

  @override
  State<UpcomingChallengeDetailPage> createState() =>
      _UpcomingChallengeDetailPageState();
}

class _UpcomingChallengeDetailPageState
    extends State<UpcomingChallengeDetailPage> {
  bool canStart = false;
  String? timerCountdown;
  bool comboStateLoading = false;
  // ComboEntity? comboDetails;
  bool isLoading = false;
  bool declineLoading = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    print(widget.challenge?.start);
    _timer = Timer.periodic((Duration(seconds: 1)), (timer) {
      final now = DateTime.now();
      final remaining = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(widget.challenge?.start ?? '', true)
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

  String? durationString;

  @override
  Widget build(BuildContext context) {
    // Check if this is a single type combo (no challenger)
    final isSingleCombo = widget.challenge?.challenger == null ||
        widget.challenge?.challenger.username == null ||
        widget.challenge?.challenger.username?.isEmpty == true;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: getFigmaColor('0D0E0E'),
            leading: FancyContainer(
                radius: 40,
                height: 40,
                width: 40,
                child: buildBackArrow(context)
                // Image.asset("assets/icons/randAvatarImage-1.png"),
                ),
            //THE COMBO TITLE WHICH IS "ABOUT" FOR HAVING ACCEPTED COMBO
            //TITLE FOR WHEN THE BRAG IS CHALLENGED
            title: FancyText(
              widget.challenge?.title ?? '',
              size: 16,
              rawTextStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )),
        backgroundColor: getFigmaColor("0D0E0E"),
        body: BlocListener<BragBloc, BragState>(
          listener: (context, state) {
            if (state is ChallengeDeclinedLoading) {
              setState(() {
                declineLoading = true;
              });
            }
            if (state is AcceptChallengeLoadingState) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is AcceptChallengeSuccessState) {
              setState(() {
                isLoading = false;
              });
              _showChallengeSentDialog(context);
            }
            if (state is AcceptChallengeErrorState) {
              setState(() {
                isLoading = false;
                declineLoading = false;
              });
              popUpMessages(context, state.errorMessage);
            }
            if (state is ChallengeDeclined) {
              setState(() {
                declineLoading = false;
              });
              popUpMessages(context, state.message);
            }
          },
          child: BlocConsumer<ComboBloc, ComboState>(
            listener: (context, state) {
              if (state is GetComboDetailSuccessState) {
                print('THIS IS THE COMBO DETAILS BEING CALLED');
                setState(() {
                  comboStateLoading = false;
                });
                print("This is combo ${state.comboEntity.stake}");
                context.pushNamed(MyAppRouteConstant.startOrjoin,
                    extra: state.comboEntity);
              }
              if (state is GetComboDetailLoadingState) {
                setState(() {
                  comboStateLoading = true;
                  context.pop();
                });
              }
              if (state is RescheduleChallengeLoading) {
                setState(() {
                  comboStateLoading = true;
                });
              }

              if (state is RescheduleChallengeState) {
                setState(() {
                  comboStateLoading = false;
                });
                context.pop();
                _showChallengeSentDialog(context, message: "Schedule Sent");
              }
            },
            builder: (context, state) {
              // Use SingleLivestreamCard for single type combos
              if (isSingleCombo) {
                // Create a ComboEntity from BragChallengersModel data
                final comboEntity = ComboEntity(
                  combo: widget.challenge?.combo,
                  about: widget.challenge?.title,
                  type: 'single',
                  brag: widget.postId,
                  duration: widget.challenge?.duration,
                  start: widget.challenge?.start,
                  status: widget.challenge?.status,
                  stake: widget.challenge?.stake?.toInt(),
                  host: LiveUser(
                    profile: widget.host?.pid,
                    avatar: widget.host?.image,
                    username: widget.host?.username,
                    avatarConvert: widget.host?.myAvatar,
                  ),
                  challenger: null,
                );

                return SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SingleLivestreamCard(
                          comboModel: comboEntity,
                          onStartNow: () {
                            context.read<ComboBloc>().add(GetComboDetailEvent(
                                widget.challenge?.combo ?? ''));
                          },
                          onJoinNow: () {
                            context.read<ComboBloc>().add(GetComboDetailEvent(
                                widget.challenge?.combo ?? ''));
                          },
                          onVote: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.black,
                                isScrollControlled: true,
                                builder: (context) {
                                  return GiftLiveCoin(
                                    host: comboEntity.host,
                                    challenger: null,
                                    comboId: comboEntity.combo ?? '',
                                    contextType: 'standard',
                                    onGoingComboId: '',
                                    isLiveOngoing: false,
                                  );
                                });
                          },
                        ),
                        const SizedBox(height: 20),
                        //THE BRAG CHALLENGE DETAILS OR THE COMBO DETAILS DEPENDING ON THE STATE OF THE APP
                        _buildMiddleSection(context),
                        const SizedBox(height: 20),
                        //BUTTONS FOR WHEN THE USER WANTS TO ACCEPT OR DECLINE THE CHALLENGE
                        AcceptButtonWidget(
                          isLoading: isLoading,
                          declineLoading: declineLoading,
                          onchanged: (duration) {
                            if (duration != null) {
                              showScheduleDialog(context, duration);
                            }
                          },
                          declineFunction: () {
                            context.read<BragBloc>().add(DeclineChallengeEvent(
                                widget.challenge?.challenge ?? ''));
                          },
                          onTap: () {
                            context.read<BragBloc>().add(AcceptChallengeEvent(
                                widget.challenge?.challenge ?? ''));
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }

              // Default layout for multi-participant combos
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      //THE BOX SHOWING THE DETAILS OF THE COMBO
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: getFigmaColor("181919"),
                            border: Border.all(
                              color: getFigmaColor("464747"),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ThemeButton(
                                    height: 30,
                                    width: 190,
                                    radius: 8,
                                    color: getFigmaColor("593407"),
                                    child: Text(
                                      'Starts in $timerCountdown',
                                      style: TextStyle(
                                          color: getFigmaColor("EDA401"),
                                          fontSize: 10,
                                          fontFamily: 'Geist',
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                              Stack(
                                children: [
                                  //THE BACKGROUND ARROW IMAGE IS HERE
                                  SvgPicture.asset(
                                    'assets/images/Arrow.svg',
                                    fit: BoxFit.cover,
                                    width: 400.w,
                                    height: 140.h,
                                  ),
                                  _buildChallengeImage2(),
                                ],
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: ThemeButton(
                                  height: 24,
                                  width: 74,
                                  radius: 8,
                                  color: getFigmaColor("593407"),
                                  child: Text(
                                    widget.challenge?.status ?? '',
                                    style: TextStyle(
                                        color: getFigmaColor("EDA401"),
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //THE BRAG CHALLENGE DETAILS OR THE COMBO DETAILS DEPENDING ON THE STATE OF THE APP
                      _buildMiddleSection(context),
                      Spacer(),
                      //BUTTONS FOR WHEN THE USER WANTS TO ACCEPT OR DECLINE THE CHALLENGE
                      AcceptButtonWidget(
                        isLoading: isLoading,
                        declineLoading: declineLoading,
                        onchanged: (duration) {
                          if (duration != null) {
                            showScheduleDialog(context, duration);
                          }
                        },
                        declineFunction: () {
                          context.read<BragBloc>().add(DeclineChallengeEvent(
                              widget.challenge?.challenge ?? ''));
                        },
                        onTap: () {
                          context.read<BragBloc>().add(AcceptChallengeEvent(
                              widget.challenge?.challenge ?? ''));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

//ALERT DIALOG AFTER SUCCESSFUL IMPLEMENTATION OF THE ACCEPT CHALLENGE
  void _showChallengeSentDialog(BuildContext context, {String? message}) {
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
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              // "Challenge Sent" text
              Text(
                message ?? 'Challenge Accepted',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // context.goNamed(MyAppRouteConstant.startOrjoin,)
                    //THIS IS WHEN I WANT TO CLOSE THE CHALLENGE HAVING ACCEPTED IT
                    //I WILL CHANGE THE BUTTONS AND THE STATE OF THE SCREEN BETTER STILL
                    // context.goNamed(MyAppRouteConstant.feedScreen);
                    if (message == "Schedule Sent") {
                      context.goNamed(MyAppRouteConstant.feedScreen);
                    } else {
                      context.goNamed(MyAppRouteConstant.challenge,
                          extra: true);
                      // print('This is pressing to get comboDetails');
                      // context.read<ComboBloc>().add(
                      //     GetComboDetailEvent(widget.challenge?.combo ?? ''));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
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
                    "Are you sure you want to reshedule this challenge?",
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
                                RescheduleChallengeEvent(
                                    postID: widget.challenge?.challenge ?? '',
                                    newTime: duration));
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
                          child: comboStateLoading
                              ? CircularProgressIndicator.adaptive()
                              : const Text('Yes'),
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
                          child: comboStateLoading
                              ? CircularProgressIndicator.adaptive()
                              : const Text('No'),
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

  //THIS IS THE WIDGET SHOWING BELOW THE CUSTOM CONTAINER
  Widget _buildMiddleSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'View brag post',
              style: TextStyle(
                color: getFigmaColor("646565"),
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            FancyContainer(
              hasBorder: true,
              radius: 30,
              borderColor: AppColors.primaryColor,
              action: () {
                context.goNamed(MyAppRouteConstant.postScreen,
                    extra: widget.postId);
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'View brag Post',
                    style: TextStyle(
                        fontFamily: 'Geist',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: getFigmaColor("FFFFFF")),
                  )),
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Winner",
              style: TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: getFigmaColor("646565"),
              ),
            ),
            Text(
              "By highest number of points",
              style: TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: getFigmaColor("FFFFFF"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Live Duration",
              style: TextStyle(
                  fontFamily: 'Geist',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: getFigmaColor("646565")),
            ),
            Text(
              widget.challenge?.duration ?? '',
              style: TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: getFigmaColor("FFFFFF"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildChallengeImage2() {
    return
        //THE TIMING INDICATOR EITHER COMBO OR CHALLENGE STATE
        // ThemeButton(
        //     height: 30,
        //     width: 190,
        //     radius: 8,
        //     color: getFigmaColor("593407"),
        //     child: Text(
        //       'Starts in $timerCountdown',
        //       style: TextStyle(
        //           color: getFigmaColor("EDA401"),
        //           fontSize: 10,
        //           fontFamily: 'Geist',
        //           fontWeight: FontWeight.w500),
        //     )),
        //THIS IS SHOWING THE MAIN DESIGN

        Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //THIS IS THE HOST INFORMATION AT THE CHALLENGE POINT
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //FIRST CHECCK IF THE IMAGE IS AVAILABLE FOR THE COMBO SIDE AND THEN THE CHALLENGE TIME
              //IF THE COMBO DETAILS IS NULL, THEN IT WILL RESORT TO THE CHALLENG VALUES.
              widget.host!.myAvatar != null
                  ? Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image: MemoryImage(widget.host!.myAvatar!))),
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.host?.image ?? '',
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: imageProvider)),
                        );
                      },
                      height: 50,
                      width: 50,
                    ),
              const SizedBox(height: 5),
              Text(
                widget.host?.username ?? '',
                style: TextStyle(
                  fontFamily: 'Geist',
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 5),
              // if (comboDetails != null)
              //   Row(
              //     children: [
              //       Text(
              //         'Stake 500',
              //         style: TextStyle(
              //           fontFamily: 'Poppins',
              //           fontWeight: FontWeight.w700,
              //           fontSize: 13,
              //         ),
              //       ),
              //       Image.asset(
              //         "assets/icons/Group (11).png",
              //         height: 20,
              //         width: 20,
              //       ),
              //     ],
              //   )
            ],
          ),
          //THIS IS THE CHALLENGER INFORMATION OR DETAILS...
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.challenge!.challenger.imageConvert != null
                  ? Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image: MemoryImage(
                                  widget.challenge!.challenger.imageConvert!))),
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.challenge?.challenger.image ?? '',
                      height: 45,
                      width: 45,
                    ),
              const SizedBox(height: 5),
              Text(
                widget.challenge?.challenger.username ?? '',
                style: TextStyle(
                  fontFamily: 'Geist',
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Stake ${widget.challenge?.stake}',
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
}

class LiveUpcoming extends StatefulWidget {
  final Function(String) indexchangingFunction;
  const LiveUpcoming({super.key, required this.indexchangingFunction});

  @override
  State<LiveUpcoming> createState() => _LiveUpcomingState();
}

class _LiveUpcomingState extends State<LiveUpcoming> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color.fromARGB(255, 140, 124, 124)),
      ),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.black.withAlpha(100),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  selectedIndex = 1;
                  widget.indexchangingFunction.call("Live");
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: (selectedIndex == 1) ? Colors.white : Colors.black,
                  ),
                  height: 30,
                  child: Text("Live",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            !(selectedIndex == 1) ? Colors.white : Colors.black,
                      )),
                ),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  selectedIndex = 2;
                  widget.indexchangingFunction.call("Upcoming");
                  setState(() {});
                },
                child: Container(
                  height: 30,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: (selectedIndex == 2) ? Colors.white : Colors.black,
                  ),
                  child: Text("Upcoming",
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            !(selectedIndex == 2) ? Colors.white : Colors.black,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
