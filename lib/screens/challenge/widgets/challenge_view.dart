// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/challenge/widgets/single_liveStream_video_rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediasfu_mediasoup_client/mediasfu_mediasoup_client.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView(
      {super.key,
      this.hostRender,
      required this.isMobile,
      required this.mobilePlatform,
      this.challengerRender,
      this.comboInfo});
  final RTCVideoRenderer? hostRender;
  final RTCVideoRenderer? challengerRender;
  final LiveComboEntity? comboInfo;
  final bool isMobile;
  final String mobilePlatform;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 270.h,
          margin: EdgeInsets.only(top: 32.h),
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: hostRender?.srcObject != null
              ? RotatedBox(
                  quarterTurns: isMobile
                      ? mobilePlatform == "android"
                          ? -1
                          : 1
                      : 0,
                  child: RTCVideoView(
                    key: UniqueKey(),
                    hostRender!,
                    mirror: false,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Container(
                    margin: EdgeInsets.only(top: 60.h),
                    child: Column(
                      children: [
                        comboInfo?.host?.avatarConvert != null
                            ? Container(
                                width: 70.w,
                                height: 70.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    image: DecorationImage(
                                        image: MemoryImage(
                                            comboInfo!.host!.avatarConvert!))),
                              )
                            : CachedNetworkImage(
                                width: 70.w,
                                height: 70.w,
                                imageUrl: comboInfo?.host?.avatar ?? '',
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(70),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider)),
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 70,
                                    ),
                                  );
                                },
                              ),
                        Text(
                          'Waiting for the host...',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        Container(
          height: 270.h,
          width: MediaQuery.of(context).size.width / 2,
          margin: EdgeInsets.only(top: 32.h),
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: challengerRender?.srcObject != null
              ? RotatedBox(
                  quarterTurns: isMobile
                      ? mobilePlatform == "android"
                          ? -1
                          : 1
                      : 0,
                  child: RTCVideoView(
                    key: UniqueKey(),
                    challengerRender!,
                    mirror: false,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                )
              : SizedBox(
                  // margin: EdgeInsets.only(top:100),
                  height: MediaQuery.of(context).size.height / 2,
                  //  width: MediaQuery.of(context).size.width / 0.5,
                  child: Container(
                    margin: EdgeInsets.only(top: 60.h),
                    child: Column(
                      children: [
                        comboInfo?.challenger?.avatarConvert != null
                            ? Container(
                                width: 70.w,
                                height: 70.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    image: DecorationImage(
                                        image: MemoryImage(comboInfo!
                                            .challenger!.avatarConvert!))))
                            : CachedNetworkImage(
                                width: 70.w,
                                height: 70.w,
                                imageUrl: comboInfo?.challenger?.avatar ?? '',
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(70),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider)),
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 70,
                                    ),
                                  );
                                },
                              ),
                        Text(
                          'Waiting for the challenger...',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        //  ),
      ],
    );
  }
}

class ScreenShareView extends StatelessWidget {
  const ScreenShareView({
    super.key,
    this.cameraRenderer,
    this.screenshareRender,
    this.marginBottom,
    this.marginLeft,
    this.marginRight,
    this.marginTop,
    this.aspectRatio,
    required this.imageAvatar,
    required this.imageUrl,
    required this.isFullScreen,
    required this.action,
    required this.isHostLocalUser,
    required this.role,
    required this.isMobile,
    required this.mobilePlatForm,
  });
  final RTCVideoRenderer? cameraRenderer;
  final RTCVideoRenderer? screenshareRender;
  final String? imageUrl;
  final Uint8List? imageAvatar;
  final bool isFullScreen;
  final Function() action;
  final bool isHostLocalUser;
  final double? marginTop;
  final double? marginBottom;
  final double? marginLeft;
  final double? marginRight;
  final double? aspectRatio;
  final String? role;
  final bool isMobile;
  final String mobilePlatForm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: marginTop ?? 0.0,
        bottom: marginBottom ?? 0.0,
        right: marginRight ?? 0.0,
        left: marginLeft ?? 0.0,
      ),
      child: Stack(
        children: [
          if (screenshareRender?.srcObject != null)
            AspectRatio(
              aspectRatio: aspectRatio ?? 1.0,
              child: RTCVideoView(
                screenshareRender!,
                mirror: false,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
              ),
            ),
          if (isHostLocalUser)
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: Colors.grey.withValues(alpha: 0.8),
                ),
              ),
            ),
          if (isHostLocalUser)
            Positioned(
                left: 50.w,
                top: 50.h,
                child: FancyContainer(
                    child: Column(
                  children: [
                    CustomText(
                      text: "You are sharing your screen with everyone",
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    GestureDetector(
                      onTap: action,
                      child: Container(
                        width: 100.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.w),
                          color: getFigmaColor("3D3D3D"),
                        ),
                        child: CustomText(
                            text: 'Stop Sharing', color: Colors.white),
                      ),
                    )
                  ],
                ))),
          if (role == 'host')
            Positioned(
              // left: 5.w,
              top: 84.h,
              child: Container(
                height: 55.h,
                width: 55.h,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(width: 2, color: Colors.blueAccent)),
                child: SingleVideoView(
                    isMobile: isMobile,
                    mobilePlatForm: mobilePlatForm,
                    imageUrl: imageUrl ?? '',
                    boxPadding: EdgeInsets.zero,
                    imageAvatar: imageAvatar,
                    renderer: cameraRenderer,
                    profilePicMargin: EdgeInsets.zero,
                    profilePicHeight: 30.w,
                    profilePicWidth: 30.w,
                    shouldShowVideo: cameraRenderer?.srcObject != null),
              ),
            ),
          if (role == 'challenger')
            Positioned(
              right: 5.w,
              bottom: 15.h,
              child: Container(
                height: 55.w,
                width: 55.w,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(width: 2, color: Colors.blueAccent)),
                child: SingleVideoView(
                    isMobile: isMobile,
                    mobilePlatForm: mobilePlatForm,
                    imageUrl: imageUrl ?? '',
                    boxPadding: EdgeInsets.zero,
                    imageAvatar: imageAvatar,
                    renderer: cameraRenderer,
                    profilePicMargin: EdgeInsets.zero,
                    profilePicHeight: 30.w,
                    profilePicWidth: 30.w,
                    shouldShowVideo: cameraRenderer?.srcObject != null),
              ),
            ),
        ],
      ),
    );
  }
}

class DoubleScreenShareView extends StatelessWidget {
  const DoubleScreenShareView({
    super.key,
    required this.firstCamera,
    required this.firstScreenShare,
    required this.firstImageUrl,
    required this.firstAvatar,
    required this.isFullScreen,
    required this.isFirstHostLocalUser,
    required this.secondCamera,
    required this.secondScreenShare,
    required this.secondImageUrl,
    required this.isSecondHostLocalUser,
    required this.secondAvatar,
    required this.isSecondFullScreen,
    required this.isMobile,
    required this.mobilePlatForm,
  });

  final RTCVideoRenderer? firstCamera;
  final RTCVideoRenderer? firstScreenShare;
  final String? firstImageUrl;
  final bool isFirstHostLocalUser;
  final Uint8List? firstAvatar;
  final bool isFullScreen;
  final RTCVideoRenderer? secondCamera;
  final RTCVideoRenderer? secondScreenShare;
  final String? secondImageUrl;
  final bool isSecondHostLocalUser;
  final Uint8List? secondAvatar;
  final bool isSecondFullScreen;
  final bool isMobile;
  final String mobilePlatForm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 20.h, bottom: 50.h),
        child: Column(
          children: [
            ScreenShareView(
                imageUrl: firstImageUrl,
                isMobile: isMobile,
                mobilePlatForm: mobilePlatForm,
                isFullScreen: isFullScreen,
                imageAvatar: firstAvatar,
                aspectRatio: 1.35,
                role: 'host',
                action: () {},
                cameraRenderer: firstCamera,
                screenshareRender: firstScreenShare,
                isHostLocalUser: isFirstHostLocalUser),
            ScreenShareView(
                imageUrl: secondImageUrl,
                imageAvatar: secondAvatar,
                mobilePlatForm: mobilePlatForm,
                isMobile: isMobile,
                aspectRatio: 1.35,
                role: 'challenger',
                isFullScreen: isSecondFullScreen,
                screenshareRender: secondScreenShare,
                cameraRenderer: secondCamera,
                action: () {},
                isHostLocalUser: isSecondFullScreen),
          ],
        ),
      ),
    );
  }
}
