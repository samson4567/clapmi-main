import 'dart:typed_data';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/custom_asset.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/challenge/widgets/gift_live_coin.dart';
import 'package:clapmi/screens/challenge/widgets/livestream_widget.dart';
import 'package:clapmi/features/livestream/presentation/blocs/recording/recording_bloc.dart';
import 'package:clapmi/features/livestream/presentation/widgets/recording_controls_sheet.dart';
import 'package:clapmi/features/livestream/data/models/recording_model.dart';
import 'package:clapmi/screens/challenge/widgets/send_request_modal.dart';
import 'package:clapmi/screens/walletSystem/buy_points/buy_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ClapLiveStreamButton extends StatelessWidget {
  const ClapLiveStreamButton({
    super.key,
    required this.widget,
  });

  final LiveStreamBottomSession widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ChatsAndSocialsBloc>().add(ClapInComboEvent(
            userPid: profileModelG?.pid ?? '',
            username: profileModelG?.username ?? '',
            avatar: profileModelG?.image ?? '',
            contextType: widget.comboInfo.hasOngoingCombo == true
                ? 'standard'
                : 'standard',
            onGoingCombo: widget.comboInfo.onGoingCombo?.combo ?? '',
            comboId:
                // widget.comboInfo.hasOngoingCombo == false?
                widget.comboId
            //  : widget.comboInfo.onGoingCombo?.combo ?? ''
            ));
        widget.onUserClappEvent(true);
      },
      child: Image.asset(
        "assets/icons/commentclap.png",
        height: 40,
      ),
    );
  }
}

class BuyPointButton extends StatelessWidget {
  const BuyPointButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (_) => BuyPoints(
            onPress: () {},
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/icons/commentaddcoin.png", height: 25),
          const SizedBox(height: 2),
          const Text("Buy coin",
              style: TextStyle(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }
}

class GiftLiveButton extends StatelessWidget {
  const GiftLiveButton({
    super.key,
    required this.widget,
    required this.isLiveOnGoing,
  });

  final LiveStreamBottomSession widget;
  final bool isLiveOnGoing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.black,
          isScrollControlled: true,
          builder: (context) {
            return GiftLiveCoin(
                host: widget.comboInfo.host,
                challenger: isLiveOnGoing
                    ? widget.comboInfo.onGoingCombo?.challenger
                    : widget.comboInfo.challenger,
                isLiveOngoing: isLiveOnGoing,
                comboId: widget.comboId,
                contextType: isLiveOnGoing == true ? 'standard' : 'standard',
                onGoingComboId: widget.comboInfo.onGoingCombo?.combo ?? '',
                liveChallenger: widget.liveChallenger);
          },
        );
        //ADD GIFTING TO THE LOCAL USER
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/icons/commentcoin.png", height: 25),
          const SizedBox(height: 2),
          const Text("Gift coin",
              style: TextStyle(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }
}

class LiveInteractionButton extends StatelessWidget {
  const LiveInteractionButton({
    super.key,
    required this.widget,
  });

  final LiveStreamBottomSession widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buttonWidget(
            widget.isMicEnabled ? Appassets.liveMic : Appassets.liveMicOff,
            widget.onLiveMicPressed,
            isEnabled: widget.isMicEnabled),
        buttonWidget(
            widget.isCameraEnable
                ? Appassets.liveVideo
                : Appassets.liveVideoOff,
            widget.onLiveCameraPressed,
            isEnabled: widget.isCameraEnable),
        buttonWidget(Appassets.liveScreenshare, widget.onShareScreenPressed,
            isEnabled: widget.isScreenShared),
        buttonWidget(Appassets.liveRecording, widget.onLiveRecordingPressed,
            isEnabled: !widget.isCameraEnable,
            isCamera: !widget.isCameraEnable),
        // buttonWidget(
        //     Appassets.liveEnlarge, widget.onEnlargeScreenPressed,
        //     isEnabled: widget.isScreenEnlarged),
        buttonWidget(Appassets.liveExit, widget.onExitPressed),
        //  buttonWidget(Appassets.liveTurnedOff, widget.onTurnedOffPressed)
        // Hamburger menu for recording controls
        BlocBuilder<RecordingBloc, RecordingState>(
          builder: (context, recordingState) {
            final isRecording = recordingState is RecordingStarted;
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => RecordingControlsSheet(
                    recordingStatus: isRecording
                        ? RecordingStatus.recording
                        : RecordingStatus.idle,
                    recordingId: isRecording
                        ? (recordingState as RecordingStarted)
                            .recording
                            .recordingId
                        : null,
                    onStartRecording: () {
                      context.read<RecordingBloc>().add(
                            StartRecording(roomId: widget.comboId),
                          );
                      Navigator.pop(context);
                    },
                    onStopRecording: () {
                      if (isRecording) {
                        context.read<RecordingBloc>().add(
                              StopRecording(
                                recordingId:
                                    (recordingState as RecordingStarted)
                                        .recording
                                        .recordingId,
                              ),
                            );
                      }
                      Navigator.pop(context);
                    },
                    onClose: () => Navigator.pop(context),
                  ),
                );
              },
              child: Container(
                height: 35.w,
                width: 35.w,
                decoration: BoxDecoration(
                  color: getFigmaColor('3D3D3D'),
                  borderRadius: BorderRadius.circular(25.w),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/hanbumger.svg',
                    width: 10.w,
                    height: 10.w,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SpectatorsInteractionButton extends StatelessWidget {
  const SpectatorsInteractionButton({
    super.key,
    required this.widget,
  });

  final LiveStreamBottomSession widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buttonWidget(Appassets.liveSpeaker, (value) {}, isEnabled: true),
          // buttonWidget(
          //     Appassets.liveEnlarge, widget.onEnlargeScreenPressed,
          //     isEnabled: widget.isScreenEnlarged),
          buttonWidget(Appassets.liveChallenge, (value) {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isScrollControlled: true,
              builder: (_) => SendChallengeRequest(
                conboInfomation: widget.comboInfo,
                bragID: widget.bragID,
                liveChallenger: widget.liveChallenger,
              ),
            );
          }, isEnabled: true),
          buttonWidget(Appassets.liveExit, widget.onExitPressed),
        ],
      ),
    );
  }
}

Widget buttonWidget(String assetName, Function(bool) onPress,
    {bool? isEnabled, bool? isCamera}) {
  return GestureDetector(
    onTap: () {
      print("Pressing the button here");
      if (isEnabled == true) {
        onPress(false);
      } else {
        onPress(true);
      }
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 4.h),
      height: 35.w,
      width: 35.w,
      decoration: BoxDecoration(
          color: assetName == Appassets.liveChallenge
              ? getFigmaColor('3D3D3D')
              : isCamera != null
                  ? isCamera == false
                      ? Colors.white
                      : getFigmaColor("3D3D3D")

                  //getFigmaColor("E5022D")
                  : isEnabled == null
                      ? getFigmaColor("E5022D")
                      : isEnabled == true
                          ? Colors.white
                          : getFigmaColor('3D3D3D'),
          //getFigmaColor('E5022D'),
          borderRadius: BorderRadius.circular(25.w)),
      child: SvgPicture.asset(
        height: 10.w,
        width: 10.w,
        color: assetName == Appassets.liveChallenge
            ? null
            : isCamera != null
                ? isCamera == false
                    ? Colors.black
                    : Colors.white
                : isEnabled == null
                    ? Colors.white
                    : isEnabled
                        ? Colors.black
                        : Colors.white,
        clipBehavior: Clip.hardEdge,
        assetName,
        fit: BoxFit.none,
      ),
    ),
  );
}

class BoostSuccessWidget extends StatelessWidget {
  const BoostSuccessWidget({
    super.key,
    required this.hostImageUrl,
    required this.challengerImageUrl,
    required this.hostAvatar,
    required this.challengerAvatar,
  });
  final String hostImageUrl;
  final String challengerImageUrl;
  final Uint8List? hostAvatar;
  final Uint8List? challengerAvatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          Align(
            alignment: AlignmentGeometry.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(Icons.cancel_outlined)),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 15.r,
                  backgroundImage: hostAvatar != null
                      ? MemoryImage(hostAvatar!)
                      : NetworkImage(hostImageUrl)),
              SizedBox(
                width: 7.w,
              ),
              Image.asset('assets/images/lil.png'),
              const SizedBox(width: 6),
              const Text("·",
                  style: TextStyle(color: Colors.blue, fontSize: 30)),
              const SizedBox(width: 6),
              Image.asset('assets/images/blue.png'),
              SizedBox(
                width: 7.w,
              ),
              CircleAvatar(
                  radius: 15.r,
                  backgroundImage: challengerAvatar != null
                      ? MemoryImage(challengerAvatar!)
                      : NetworkImage(challengerImageUrl)),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          CustomText(
            text: "Point boosted",
            color: Colors.white,
          ),
          SizedBox(
            height: 3.h,
          ),
          CustomText(
            text: "Your point has been boosted",
            color: Colors.grey,
          ),
          SizedBox(
            height: 5.h,
          ),
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Container(
              width: 250.w,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 5.h,
              ),
              child: Center(
                  child: CustomText(
                text: "Proceed",
                color: Colors.white,
              )),
            ),
          )
        ],
      ),
    );
  }
}

enum PopRecordVariant { initial, confirm }

class PopRecord extends StatelessWidget {
  final PopRecordVariant variant;
  final VoidCallback onNo;
  final VoidCallback? onLater;
  final VoidCallback onYes;

  const PopRecord({
    super.key,
    this.variant = PopRecordVariant.initial,
    required this.onNo,
    this.onLater,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: variant == PopRecordVariant.initial
          ? _InitialVariant(
              onNo: onNo,
              onLater: onLater ?? () {},
              onYes: onYes,
            )
          : _ConfirmVariant(
              onNo: onNo,
              onYes: onYes,
            ),
    );
  }
}

// ─────────────────────────────────────────
// Initial variant  →  "Record your livestream"
// ─────────────────────────────────────────
class _InitialVariant extends StatelessWidget {
  final VoidCallback onNo;
  final VoidCallback onLater;
  final VoidCallback onYes;

  const _InitialVariant({
    required this.onNo,
    required this.onLater,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      height: 271,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0E0E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/icons/dee.svg',
              width: 365,
              height: 271,
            ),
          ),
          // Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/icons/dee.svg',
              width: 365,
              height: 271,
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Record your livestream ? ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _PopButton(
                          label: 'No',
                          onTap: onNo,
                          style: _PopButtonStyle.dark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PopButton(
                          label: 'Later',
                          onTap: onLater,
                          style: _PopButtonStyle.dark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PopButton(
                          label: 'Yes',
                          onTap: onYes,
                          style: _PopButtonStyle.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // video.svg floating above card
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'assets/icons/vidis.svg',
                width: 96,
                height: 96,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Confirm variant  →  "Want to record your stream"
// ─────────────────────────────────────────
class _ConfirmVariant extends StatelessWidget {
  final VoidCallback onNo;
  final VoidCallback onYes;

  const _ConfirmVariant({
    required this.onNo,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 408,
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0E0E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Background
          Positioned.fill(
            child: Positioned.fill(
              child: SvgPicture.asset(
                'assets/icons/dee.svg',
                width: 365,
                height: 271,
              ),
            ),
          ),
          Positioned.fill(
            child: Positioned.fill(
              child: SvgPicture.asset(
                'assets/icons/dee.svg',
                width: 365,
                height: 271,
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon + title inline
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/vidis.svg',
                        width: 52,
                        height: 52,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Want to record your stream',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _PopButton(
                          label: 'No',
                          onTap: onNo,
                          style: _PopButtonStyle.outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PopButton(
                          label: 'Yes',
                          onTap: onYes,
                          style: _PopButtonStyle.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Shared button
// ─────────────────────────────────────────
enum _PopButtonStyle { dark, outlined, blue }

class _PopButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final _PopButtonStyle style;

  const _PopButton({
    required this.label,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: style == _PopButtonStyle.blue
              ? const Color(0xFF2196F3)
              : const Color(0xFF1E1E22),
          borderRadius: BorderRadius.circular(30),
          border: style == _PopButtonStyle.outlined
              ? Border.all(color: const Color(0xFF2196F3), width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class SingleLiveScheduler extends StatelessWidget {
  final VoidCallback onInstantLive;
  final VoidCallback onScheduleLive;
  final bool isDisabled;

  const SingleLiveScheduler({
    super.key,
    required this.onInstantLive,
    required this.onScheduleLive,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 30),

          // Title
          const Text(
            "Select Option",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5, // line-height: 150%
              letterSpacing: 0,
            ),
          ),

          const SizedBox(height: 30),

          // Instant Live
          _OptionTile(
            icon: 'assets/icons/vidi.svg',
            label: 'Start instant live',
            onTap: isDisabled ? () {} : onInstantLive,
            isDisabled: isDisabled,
          ),

          const SizedBox(height: 20),

          // Schedule Live (Highlighted)
          _OptionTile(
            icon: 'assets/icons/add.svg', // change to your asset
            label: 'Schedule live for later',
            onTap: isDisabled ? () {} : onScheduleLive,
            isHighlighted: true,
            isDisabled: isDisabled,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Option Tile
// ─────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isHighlighted;
  final bool isDisabled;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isHighlighted = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isHighlighted
                ? const Color(0xFF3A3A3C)
                : const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(20),
            border: isHighlighted
                ? Border.all(
                    color: const Color(0xFF2196F3),
                    width: 2,
                  )
                : null,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 32,
                height: 32,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
