// ignore_for_file: deprecated_member_use
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/screens/challenge/others/widgets/live_buy_point_button.dart' show ClapLiveStreamButton, BuyPointButton, GiftLiveButton, LiveInteractionButton, SpectatorsInteractionButton, buttonWidget, BoostSuccessWidget, PopRecord, PopRecordVariant, SingleLiveScheduler;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

typedef ClickLiveButton = Function(bool);

class LiveStreamBottomSession extends StatefulWidget {
  const LiveStreamBottomSession({
    super.key,
    required this.sendComment,
    required this.comboId,
    required this.bragID,
    required this.comboInfo,
    required this.onLiveMicPressed,
    required this.isMicEnabled,
    required this.onLiveCameraPressed,
    required this.isCameraEnable,
    required this.onShareScreenPressed,
    required this.isScreenShared,
    required this.onLiveRecordingPressed,
    required this.isLiveRecording,
    required this.onEnlargeScreenPressed,
    required this.isScreenEnlarged,
    required this.onExitPressed,
    required this.onTurnedOffPressed,
    required this.onUserClappEvent,
    required this.isLiveOngoing,
    required this.liveChallenger,
    this.forceSpectatorControls = false,
  });

  final Function(LiveGroundComment) sendComment;
  final String comboId;
  final LiveComboEntity comboInfo;
  final ClickLiveButton onLiveMicPressed;
  final bool isMicEnabled;
  final ClickLiveButton onLiveCameraPressed;
  final bool isCameraEnable;
  final ClickLiveButton onShareScreenPressed;
  final bool isScreenShared;
  final ClickLiveButton onLiveRecordingPressed;
  final bool isLiveRecording;
  final ClickLiveButton onEnlargeScreenPressed;
  final bool isScreenEnlarged;
  final ClickLiveButton onExitPressed;
  final ClickLiveButton onTurnedOffPressed;
  final ClickLiveButton onUserClappEvent;
  final String bragID;
  final bool isLiveOngoing;
  final LiveGifter? liveChallenger;
  final bool forceSpectatorControls;

  @override
  State<LiveStreamBottomSession> createState() =>
      _LiveStreamBottomSessionState();
}

class _LiveStreamBottomSessionState extends State<LiveStreamBottomSession> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 45.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Comment Box
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: getFigmaColor("3D3D3D"),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade700, width: 1),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Comment",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: getFigmaColor("3D3D3D"),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (commentController.text.isNotEmpty) {
                            context.read<ChatsAndSocialsBloc>().add(
                                  CommentInComboEvent(
                                      userPid: profileModelG?.pid ?? '',
                                      comboId:
                                          //widget.comboInfo.hasOngoingCombo == false ?
                                          widget.comboId,
                                      //: widget.comboInfo.onGoingCombo?.combo ?? '',
                                      avatar: profileModelG?.image ?? '',
                                      comment: commentController.text.trim(),
                                      username: profileModelG?.username ?? '',
                                      contextType:
                                          widget.comboInfo.hasOngoingCombo ==
                                                  true
                                              ? 'standard'
                                              : 'standard',
                                      onGoingCombo: widget
                                              .comboInfo.onGoingCombo?.combo ??
                                          ''),
                                );
                            var comment = LiveGroundComment(
                              user: profileModelG?.myAvatar != null
                                  ? LiveReactionUser(
                                      message: commentController.text.trim(),
                                      username: profileModelG?.username,
                                      avatarConvert: profileModelG?.myAvatar)
                                  : LiveReactionUser(
                                      message: commentController.text.trim(),
                                      username: profileModelG?.username,
                                      avatar: profileModelG?.image ?? ''),
                            );
                            widget.sendComment(comment);
                          }
                          commentController.clear();
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/seg.svg',
                          width: 22,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // If the inside Live is ongoing; check if the user is not host
              // or if the user is not challenger
              if (widget.isLiveOngoing &&
                  widget.comboInfo.host?.profile != profileModelG?.pid &&
                  (widget.comboInfo.onGoingCombo?.challenger?.profile !=
                          profileModelG?.pid ||
                      widget.liveChallenger?.pid == profileModelG?.pid))
                GiftLiveButton(
                  widget: widget,
                  isLiveOnGoing: widget.isLiveOngoing,
                ),
              //When the user is a spectator in normal multiple Livestream
              if (!widget.isLiveOngoing &&
                  widget.comboInfo.host?.profile != profileModelG?.pid &&
                  widget.comboInfo.challenger?.profile != profileModelG?.pid)
                GiftLiveButton(
                  widget: widget,
                  isLiveOnGoing: widget.isLiveOngoing,
                ),
              const SizedBox(width: 10),
              // Buy Coin
              if (widget.isLiveOngoing &&
                  widget.comboInfo.host?.profile != profileModelG?.pid &&
                  (widget.comboInfo.onGoingCombo?.challenger?.profile !=
                          profileModelG?.pid ||
                      widget.liveChallenger?.pid == profileModelG?.pid))
                BuyPointButton(),
              if (!widget.isLiveOngoing &&
                  widget.comboInfo.host?.profile != profileModelG?.pid &&
                  widget.comboInfo.challenger?.profile != profileModelG?.pid)
                BuyPointButton(),
              //if the current user is not the challenger
              if (!widget.isLiveOngoing &&
                  widget.comboInfo.host?.profile != profileModelG?.pid &&
                  widget.comboInfo.challenger?.profile != profileModelG?.pid)
                const SizedBox(width: 10),
              // Clap Icon
              //if the current user is not the challenger
              if (widget.isLiveOngoing) ClapLiveStreamButton(widget: widget),
              if (!widget.isLiveOngoing &&
                  widget.comboInfo.host?.profile != profileModelG?.pid &&
                  widget.comboInfo.challenger?.profile != profileModelG?.pid)
                ClapLiveStreamButton(widget: widget),
            ],
          ),
          SizedBox(height: 10.h),
          //TODO: to implement isLiveOngoing
          (!widget.forceSpectatorControls &&
                  widget.isLiveOngoing &&
                  (widget.comboInfo.host?.profile == profileModelG?.pid ||
                      widget.comboInfo.onGoingCombo?.challenger?.profile ==
                          profileModelG?.pid ||
                      widget.liveChallenger?.pid == profileModelG?.pid))
              ? LiveInteractionButton(widget: widget)
              :
              //  : SpectatorsInteractionButton(widget: widget),

              ///THIS CONDITION IN THE ROW IS TO CHECK IF THE USER IS A HOST OR A CHALLENGER
              (!widget.forceSpectatorControls &&
                      !widget.isLiveOngoing &&
                      (widget.comboInfo.host?.profile == profileModelG?.pid ||
                          widget.comboInfo.challenger?.profile ==
                              profileModelG?.pid))
                  //  widget.isLiveOngoing
                  ? LiveInteractionButton(widget: widget)
                  : SpectatorsInteractionButton(widget: widget)
        ],
      ),
    );
  }
}
