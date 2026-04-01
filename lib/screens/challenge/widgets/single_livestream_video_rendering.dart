import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediasfu_mediasoup_client/mediasfu_mediasoup_client.dart';

class SingleVideoView extends StatelessWidget {
  const SingleVideoView(
      {super.key,
      this.marginTop,
      this.marginBottom,
      this.marginLeft,
      this.marginRight,
      this.imageUrl,
      this.imageAvatar,
      required this.renderer,
      required this.profilePicMargin,
      required this.isMobile,
      this.profilePicHeight,
      this.profilePicWidth,
      this.remoteRole,
      this.aspectRatio,
      this.boxPadding,
      this.videoContainerDecoration,
      required this.mobilePlatForm,
      required this.shouldShowVideo});
  final double? marginTop;
  final double? marginBottom;
  final double? marginLeft;
  final double? marginRight;
  final double? aspectRatio;
  final RTCVideoRenderer? renderer;
  final bool shouldShowVideo;
  final Uint8List? imageAvatar;
  final String? imageUrl;
  final EdgeInsetsGeometry profilePicMargin;
  final double? profilePicWidth;
  final double? profilePicHeight;
  final String? remoteRole;
  final Decoration? videoContainerDecoration;
  final EdgeInsets? boxPadding;
  final bool isMobile;
  final String mobilePlatForm;

  double get _resolvedAspectRatio {
    if (aspectRatio != null && aspectRatio! > 0) {
      return aspectRatio!;
    }

    final width = renderer?.videoWidth ?? 0;
    final height = renderer?.videoHeight ?? 0;
    if (width > 0 && height > 0) {
      return width / height;
    }

    return isMobile ? 9 / 16 : 16 / 9;
  }

  @override
  Widget build(BuildContext context) {
    return shouldShowVideo
        ? Container(
            // height: height,
            // width: width,
            // margin: EdgeInsets.only(
            //   top: marginTop ?? 0.0,
            //   left: marginLeft ?? 0.0,
            //   right: marginRight ?? 0.0,
            //   bottom: marginBottom ?? 0.0,
            // ),
            decoration: videoContainerDecoration,
            child: AspectRatio(
              aspectRatio: _resolvedAspectRatio,
              child: isMobile
                  //Render the Mobile producer (Either for android or IOS)
                  ? RotatedBox(
                      quarterTurns: mobilePlatForm == "android" ? -1 : 1,
                      child: RTCVideoView(placeholderBuilder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.w),
                              border: Border.all(
                                  color: Colors.lightBlue, width: 2)),
                        );
                      },
                          mirror: false,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                          renderer!),
                    )
                  //Render the web Producer from landscape mode OR Laptop
                  : RTCVideoView(placeholderBuilder: (context) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                            border:
                                Border.all(color: Colors.lightBlue, width: 2)),
                      );
                    },
                      mirror: false,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      renderer!),
            ),
          )
        : Padding(
            padding: boxPadding ?? EdgeInsets.only(bottom: 100.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  imageAvatar != null
                      ? Container(
                          width: profilePicWidth ?? 100,
                          height: profilePicHeight ?? 100,
                          decoration: BoxDecoration(
                              // color: Colors.grey.withAlpha(210),
                              borderRadius:
                                  BorderRadius.circular(profilePicWidth ?? 100),
                              image: DecorationImage(
                                  image: MemoryImage(imageAvatar!))),
                        )
                      : CachedNetworkImage(
                          width: profilePicWidth,
                          height: profilePicHeight,
                          imageUrl: imageUrl ?? '',
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      (profilePicWidth ?? 100)),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover)),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(
                                      profilePicWidth ?? 100)),
                              child: Icon(Icons.person),
                            );
                          },
                        ),
                  if (remoteRole != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'Waiting for $remoteRole to turn on video...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
  }
}
