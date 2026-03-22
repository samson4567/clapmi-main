import 'dart:typed_data';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/custom_asset.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/challenge/widgets/gift_live_coin.dart';
import 'package:clapmi/screens/challenge/widgets/livestream_widget.dart';
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
