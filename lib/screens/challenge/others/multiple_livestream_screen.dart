import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/screens/challenge/others/Live_combo_three_image_present.dart';
import 'package:clapmi/screens/challenge/widgets/challenge_view.dart';
import 'package:clapmi/screens/challenge/widgets/single_livestream_video_rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediasfu_mediasoup_client/mediasfu_mediasoup_client.dart';

class MultipleLiveStreamScreen extends StatelessWidget {
  const MultipleLiveStreamScreen(
      {super.key,
      required this.hostScreenShareRender,
      required this.challengerScreenShareRender,
      required this.hostRender,
      required this.widget,
      required this.isFullScreen,
      required this.challengerRender,
      required this.screenshareRender,
      required this.renderer,
      required this.role,
      required this.hasOngoingCombo,
      required this.isMobile,
      required this.mobilePlatForm});

  final RTCVideoRenderer? hostScreenShareRender;
  final RTCVideoRenderer? challengerScreenShareRender;
  final RTCVideoRenderer? hostRender;
  final LiveComboThreeImageScreen widget;
  final bool isFullScreen;
  final RTCVideoRenderer? challengerRender;
  final RTCVideoRenderer? screenshareRender;
  final RTCVideoRenderer? renderer;
  final String role;
  final bool hasOngoingCombo;
  final bool isMobile;
  final String mobilePlatForm;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //**THIS IS FOR DOUBLE VIEWS               */
        //-------------------------------------------
        //WHEN THE SPECTATOR IS WATCHING BOTH HOST AND CHALLENGER SHARING SCREEN
        if (hostScreenShareRender?.srcObject != null &&
            challengerScreenShareRender?.srcObject != null)
          DoubleScreenShareView(
            firstCamera: hostRender,
            firstScreenShare: hostScreenShareRender,
            isMobile: isMobile,
            mobilePlatForm: mobilePlatForm,
            firstImageUrl: widget.comboInfo.host?.avatar,
            firstAvatar: widget.comboInfo.host?.avatarConvert,
            isFullScreen: isFullScreen,
            isFirstHostLocalUser: false,
            secondCamera: challengerRender,
            secondScreenShare: challengerScreenShareRender,
            secondImageUrl: widget.comboInfo.challenger?.avatar,
            secondAvatar: widget.comboInfo.challenger?.avatarConvert,
            isSecondFullScreen: isFullScreen,
            isSecondHostLocalUser: false,
          ),
        //**WHEN THE HOST IS THE LOCALUSER AND THE REMOTE USER IS THE CHALLENGER */
        if (screenshareRender?.srcObject != null &&
            challengerScreenShareRender?.srcObject != null)
          DoubleScreenShareView(
              firstCamera: renderer,
              isMobile: isMobile,
              firstScreenShare: screenshareRender,
              mobilePlatForm: mobilePlatForm,
              firstImageUrl: widget.comboInfo.host?.avatar,
              firstAvatar: widget.comboInfo.host?.avatarConvert,
              isFullScreen: isFullScreen,
              isFirstHostLocalUser: true,
              secondCamera: challengerRender,
              secondScreenShare: challengerScreenShareRender,
              secondImageUrl: hasOngoingCombo
                  ? widget.comboInfo.onGoingCombo?.challenger?.avatar
                  : widget.comboInfo.challenger?.avatar,
              secondAvatar: hasOngoingCombo
                  ? widget.comboInfo.onGoingCombo?.challenger?.avatarConvert
                  : widget.comboInfo.challenger?.avatarConvert,
              isSecondHostLocalUser: false,
              isSecondFullScreen: isFullScreen),
        //**WHEN THE HOST IS THE REMOTE USER AND THE CHALLENGER IS THE LOCALUSER */
        if (hostScreenShareRender?.srcObject != null &&
            screenshareRender?.srcObject != null)
          DoubleScreenShareView(
              firstCamera: hostRender,
              isMobile: isMobile,
              mobilePlatForm: mobilePlatForm,
              firstScreenShare: hostScreenShareRender,
              firstAvatar: widget.comboInfo.host?.avatarConvert,
              firstImageUrl: widget.comboInfo.host?.avatar,
              isFullScreen: isFullScreen,
              isFirstHostLocalUser: false,
              secondCamera: renderer,
              secondScreenShare: screenshareRender,
              secondAvatar: hasOngoingCombo
                  ? widget.comboInfo.onGoingCombo?.challenger?.avatarConvert
                  : widget.comboInfo.challenger?.avatarConvert,
              secondImageUrl: hasOngoingCombo
                  ? widget.comboInfo.onGoingCombo?.challenger?.avatar
                  : widget.comboInfo.challenger?.avatar,
              isSecondHostLocalUser: true,
              isSecondFullScreen: isFullScreen),
        //------------------------------------------------------------

        //**THIS IS SINGLE VIEW FOR SCREEN SHARE */
        //---------------------------------------
        hostScreenShareRender?.srcObject != null
            ? ScreenShareView(
                isMobile: isMobile,
                imageUrl: widget.comboInfo.host?.avatar,
                mobilePlatForm: mobilePlatForm,
                imageAvatar: widget.comboInfo.host?.avatarConvert,
                role: 'host',
                isFullScreen: isFullScreen,
                screenshareRender: hostScreenShareRender,
                cameraRenderer: hostRender,
                action: () {},
                isHostLocalUser: false)
            : screenshareRender?.srcObject != null
                ? ScreenShareView(
                    isMobile: isMobile,
                    mobilePlatForm: mobilePlatForm,
                    imageUrl:
                        widget.comboInfo.host?.profile == profileModelG?.pid
                            ? widget.comboInfo.host?.avatar
                            : widget.comboInfo.challenger?.avatar,
                    role: 'host',
                    imageAvatar:
                        widget.comboInfo.host?.profile == profileModelG?.pid
                            ? widget.comboInfo.host?.avatarConvert
                            : widget.comboInfo.challenger?.avatarConvert,
                    isFullScreen: isFullScreen,
                    screenshareRender: screenshareRender,
                    cameraRenderer: renderer,
                    action: () {},
                    isHostLocalUser: true)
                : challengerScreenShareRender?.srcObject != null
                    ? ScreenShareView(
                        isMobile: isMobile,
                        imageUrl: widget.comboInfo.challenger?.avatar,
                        mobilePlatForm: mobilePlatForm,
                        imageAvatar: widget.comboInfo.challenger?.avatarConvert,
                        role: 'challenger',
                        isFullScreen: isFullScreen,
                        screenshareRender: challengerScreenShareRender,
                        cameraRenderer: challengerRender,
                        action: () {},
                        isHostLocalUser: false)
                    : SizedBox.shrink(),

        //** WIDGET RENDERING FOR SPECTATORS AND WHEN SCREEN IS NOT SHARED */
        if (role == 'spectator' &&
            challengerScreenShareRender?.srcObject == null &&
            hostScreenShareRender?.srcObject == null)
          ChallengeView(
            challengerRender: challengerRender,
            hostRender: hostRender,
            comboInfo: widget.comboInfo,
            isMobile: isMobile,
            mobilePlatform: mobilePlatForm,
          ),
        //** SHOW CHALLENGER AS THE REMOTE PERSON TO THE LOCAL USER(HOST) */
        //** AND THE CHALLENGER IS NOT SHARING SCREEN */
        if (role == 'host' &&
            challengerScreenShareRender?.srcObject == null &&
            screenshareRender?.srcObject == null)
          SingleVideoView(
            isMobile: isMobile,
            mobilePlatForm: mobilePlatForm,
            remoteRole: 'challenger',
            imageUrl: hasOngoingCombo
                ? widget.comboInfo.onGoingCombo?.challenger?.avatar
                : widget.comboInfo.challenger?.avatar ?? '',
            imageAvatar: hasOngoingCombo
                ? widget.comboInfo.onGoingCombo?.challenger?.avatarConvert
                : widget.comboInfo.challenger?.avatarConvert,
            marginTop: 38.h,
            renderer: challengerRender!,
            profilePicMargin: EdgeInsets.only(top: 190.h, left: 115.w),
            profilePicHeight: 100.w,
            profilePicWidth: 100.w,
            shouldShowVideo: challengerRender?.srcObject != null,
            boxPadding: null,
          ),
        //** SHOW HOST AS THE REMOTE PERSON TO THE LOCAL USER(CHALLENGER) */
        //** AND THE HOST IS NOT SHARING SCREEN */
        if (role == 'challenger' &&
            hostScreenShareRender?.srcObject == null &&
            screenshareRender?.srcObject == null)
          SingleVideoView(
            remoteRole: 'host',
            isMobile: isMobile,
            mobilePlatForm: mobilePlatForm,
            marginTop: 38.h,
            imageUrl: widget.comboInfo.host?.avatar ?? '',
            imageAvatar: widget.comboInfo.host?.avatarConvert,
            renderer: hostRender!,
            profilePicMargin: EdgeInsets.only(top: 190.h, left: 115.w),
            profilePicHeight: 100.w,
            profilePicWidth: 100.w,
            shouldShowVideo: hostRender?.srcObject != null,
            boxPadding: null,
          ),
        //** THIS IS LOCAL USER VIDEO VIEW WITHOUT SCREEN RENDERING */
        if (role != 'spectator' &&
            screenshareRender?.srcObject == null &&
            challengerScreenShareRender?.srcObject == null &&
            hostScreenShareRender?.srcObject == null)
          Align(
            alignment: Alignment(0.7.w, 0.43.h),
            child: Container(
              height: 200.h,
              width: 140.w,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleVideoView(
                renderer: renderer!,
                isMobile: isMobile,
                mobilePlatForm: mobilePlatForm,
                profilePicMargin: EdgeInsets.only(top: 65.h, left: 1.w),
                imageUrl: widget.comboInfo.host?.profile == profileModelG?.pid
                    ? widget.comboInfo.host?.avatar
                    : hasOngoingCombo
                        ? widget.comboInfo.onGoingCombo?.challenger?.avatar
                        : widget.comboInfo.challenger?.avatar ?? '',
                imageAvatar:
                    widget.comboInfo.host?.profile == profileModelG?.pid
                        ? widget.comboInfo.host?.avatarConvert
                        : hasOngoingCombo
                            ? widget.comboInfo.onGoingCombo?.challenger
                                ?.avatarConvert
                            : widget.comboInfo.challenger?.avatarConvert,
                profilePicHeight: 50.w,
                profilePicWidth: 50.w,
                shouldShowVideo: renderer?.srcObject != null,
                boxPadding: null,
              ),
            ),
          ),
      ],
    );
  }
}
