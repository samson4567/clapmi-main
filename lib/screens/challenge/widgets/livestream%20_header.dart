import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/screens/challenge/others/Single_livestream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:share_plus/share_plus.dart';

class LivestreamHeader extends StatelessWidget {
  const LivestreamHeader(
      {super.key,
      required this.comboInfo,
      required this.comboId,
      required this.timerCountdown,
      required this.onLeaveComboEvent,
      required this.bragID,
      this.totalGiftingPot,
      this.liveChallenger,
      required this.numOfChallengers,
      required this.streamersCount,
      required this.isLiveGoingNow,
      this.model});

  final LiveComboEntity comboInfo;
  final ComboInLiveStream? liveChallenger;
  final CreatePostModel? model;
  final String comboId;
  final num? totalGiftingPot;
  final String? timerCountdown;
  final String bragID;
  final int numOfChallengers;
  final int streamersCount;
  final Function(bool) onLeaveComboEvent;
  final bool isLiveGoingNow;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComboBloc, ComboState>(
      listener: (context, state) {
        if (state is LeaveComboGroundSuccessState) {
          onLeaveComboEvent(true);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Top Bar (About Text + Icons) ======
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      comboInfo.about ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          onLeaveComboEvent(true);
                        },
                        icon: const Icon(Icons.close,
                            size: 22, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                // Avatar - Show HOST for single streams, current user for multiple
                GestureDetector(
                    child: comboInfo.type == 'single'
                        ? (comboInfo.host?.avatarConvert != null
                            ? Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                        image: MemoryImage(
                                            comboInfo.host!.avatarConvert!))),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    height: 30.w,
                                    width: 30.w,
                                    imageUrl: comboInfo.host?.avatar ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.person),
                                    ),
                                    errorWidget: (context, error, trace) =>
                                        Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.person),
                                    ),
                                  ),
                                ),
                              ))
                        : (profileModelG?.myAvatar != null
                            ? Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                        image: MemoryImage(
                                            profileModelG!.myAvatar!))),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    height: 30.w,
                                    width: 30.w,
                                    imageUrl: profileModelG?.image ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.person),
                                    ),
                                    errorWidget: (context, error, trace) =>
                                        Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.person),
                                    ),
                                  ),
                                ),
                              ))),
                const SizedBox(width: 8),
                // Username - Show HOST for single streams, current user for multiple
                Text(
                  comboInfo.type == 'single'
                      ? comboInfo.host?.username ?? ''
                      : profileModelG?.username ?? '',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      fontFamily: 'Poppins'),
                ),
                const Spacer(),
                //ShareIcon
                FancyContainer(
                  isAsync: false,
                  height: 30,
                  width: 40,
                  action: () async {
                    // Use bragID for livestream share (primary), fallback to model?.uuid
                    final shareId = bragID.isNotEmpty ? bragID : (model?.uuid ?? '');
                    if (shareId.isEmpty) {
                      return;
                    }
                    final result = await SharePlus.instance.share(ShareParams(
                        title: 'Check out the Post',
                        text:
                            'Check out the livestream  on clapmi https://app.clapmi.com/posts/$shareId'));

                    if (result.status == ShareResultStatus.success) {
                      context.read<PostBloc>().add(
                            SharePostEvent(
                              postID: shareId,
                            ),
                          );
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/images/Mic.svg',
                    width: 26,
                    height: 26,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 10),
                // NUMBER OF STREAMERS COUNT
                Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/profile-2.svg',
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        streamersCount.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (!isLiveGoingNow)
                  GestureDetector(
                    onTap: () {
                      // 🔥 Dispatch your event here
                      context.read<BragBloc>().add(SingleBragChallengersEvent(
                          contextType: 'live',
                          list: 'recent',
                          status: 'pending',
                          brags: bragID));

                      bool ishost =
                          comboInfo.host?.profile == profileModelG?.pid;
                      // 🔥 Then open the modal
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => ishost
                              ? const AcceptRequestsModal()
                              : ChallengeRequestsModal(
                                  hostAvatar: comboInfo.host?.avatarConvert,
                                  hostImageUrl: comboInfo.host?.avatar,
                                ));
                    },
                    child: Container(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/blow.svg',
                            width: 18,
                            height: 18,
                            fit: BoxFit.scaleDown,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            numOfChallengers.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            if (comboInfo.type == "multiple" || isLiveGoingNow)
              Row(
                children: [
                  // Coin section.
                  GestureDetector(
                    onTap: () {
                      //If it is normal combo
                      comboInfo.stake != null
                          ? showModalBottomSheet(
                              context: context,
                              builder: (context) => TotalPotWidgetModal(
                                totalPot: 2 * (comboInfo.stake ?? 0).toInt(),
                                streamers: [
                                  Streamer(
                                      name: comboInfo.host?.username ?? '',
                                      amount: comboInfo.stake?.toInt() ?? 0,
                                      imageUrl: comboInfo.host?.avatar,
                                      avatar: comboInfo.host?.avatarConvert),
                                  Streamer(
                                      name:
                                          comboInfo.challenger?.username ?? '',
                                      amount: comboInfo.stake?.toInt() ?? 0,
                                      imageUrl: comboInfo.challenger?.avatar,
                                      avatar:
                                          comboInfo.challenger?.avatarConvert),
                                ],
                              ),
                              // if the information is coming from restful API
                            )
                          : comboInfo.onGoingCombo?.stake != null
                              ? showModalBottomSheet(
                                  context: context,
                                  builder: (context) => TotalPotWidgetModal(
                                    totalPot: 2 *
                                        (comboInfo.onGoingCombo?.stake ?? 0)
                                            .toInt(),
                                    streamers: [
                                      Streamer(
                                        name: comboInfo.host?.username ?? '',
                                        amount: comboInfo.onGoingCombo?.stake
                                                ?.toInt() ??
                                            0,
                                        imageUrl: comboInfo.host?.avatar,
                                        avatar: comboInfo.host?.avatarConvert,
                                      ),
                                      Streamer(
                                          name: comboInfo.onGoingCombo
                                                  ?.challenger?.username ??
                                              '',
                                          amount: comboInfo.onGoingCombo?.stake
                                                  ?.toInt() ??
                                              0,
                                          imageUrl: comboInfo
                                              .onGoingCombo?.challenger?.avatar,
                                          avatar: comboInfo.onGoingCombo
                                              ?.challenger?.avatarConvert),
                                    ],
                                  ),
                                  //If the response is coming from websocketting
                                )
                              : showModalBottomSheet(
                                  context: context,
                                  builder: (context) => TotalPotWidgetModal(
                                    totalPot: 2 *
                                        (int.tryParse(liveChallenger
                                                    ?.comboGround?.stake ??
                                                '0') ??
                                            0),
                                    streamers: [
                                      Streamer(
                                          name: comboInfo.host?.username ?? '',
                                          amount: (int.tryParse(liveChallenger
                                                      ?.comboGround?.stake ??
                                                  '0') ??
                                              0),
                                          imageUrl: comboInfo.host?.avatar,
                                          avatar:
                                              comboInfo.host?.avatarConvert),
                                      Streamer(
                                          name: liveChallenger
                                                  ?.challenger?.username ??
                                              '',
                                          amount: (int.tryParse(liveChallenger
                                                      ?.comboGround?.stake ??
                                                  '0') ??
                                              0),
                                          imageUrl:
                                              liveChallenger?.challenger?.image,
                                          avatar: liveChallenger
                                              ?.challenger?.avatar),
                                    ],
                                  ),
                                );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          Image.asset('assets/images/deb.png', height: 18),
                          const SizedBox(width: 6),
                          Text(
                            (totalGiftingPot ?? 0).toStringAsFixed(0),
                            style: const TextStyle(
                              color: Color(0xFFFFE8B1),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Trophy section.. The total pot button
                  GestureDetector(
                    onTap: () {
                      print(
                          "${comboInfo.stake} amount staked in the livestreaming");
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return TotalPotBottomSheet(
                                totalAmountInPot: totalGiftingPot.toString(),
                                totalStake: comboInfo.stake != null
                                    ? '${2 * (comboInfo.stake ?? 0).toInt()}'
                                    : comboInfo.onGoingCombo?.stake != null
                                        ? '${2 * (comboInfo.onGoingCombo?.stake ?? 0).toInt()}'
                                        : '${2 * (int.tryParse(liveChallenger?.comboGround?.stake ?? '0') ?? 0)}');
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          Image.asset('assets/icons/giftings.png', height: 18),
                          const SizedBox(width: 6),
                          //THIS IS A NULLABLE THING TO ADDRESS
                          //**THIS IS TO SHOW THE STAKE AMOUNT */
                          liveChallenger?.challenger != null
                              ? Text(
                                  '${2 * (int.tryParse(liveChallenger?.comboGround?.stake ?? '0') ?? 0)}',
                                  style: const TextStyle(
                                    color: Color(0xFFFFE8B1),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                )
                              : comboInfo.hasOngoingCombo == true
                                  ? Text(
                                      '${2 * (comboInfo.onGoingCombo?.stake ?? 0).toInt()}',
                                      style: const TextStyle(
                                        color: Color(0xFFFFE8B1),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    )
                                  : Text(
                                      '${2 * (comboInfo.stake ?? 0).toInt()}',
                                      style: const TextStyle(
                                        color: Color(0xFFFFE8B1),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (comboInfo.type == 'multiple' || isLiveGoingNow)
              SizedBox(height: 5.h),
            // ====== Players Row ======
            if (comboInfo.type == "multiple" || isLiveGoingNow)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          child: comboInfo.host?.avatarConvert != null
                              ? Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                          image: MemoryImage(
                                              comboInfo.host!.avatarConvert!))),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 6.h),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      height: 20.w,
                                      width: 20.w,
                                      imageUrl: comboInfo.host?.avatar ?? '',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.person),
                                      ),
                                      errorWidget: (context, error, trace) =>
                                          Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.person),
                                      ),
                                    ),
                                  ),
                                )),
                      const SizedBox(width: 8),
                      Text(
                        comboInfo.host?.username ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  //
                  comboInfo.challenger != null
                      ? challengerRenderObject(
                          avatarConvert: comboInfo.challenger?.avatarConvert,
                          imageUrl: comboInfo.challenger?.avatar,
                          username: comboInfo.challenger?.username,
                        )
                      : comboInfo.onGoingCombo?.challenger != null
                          ? challengerRenderObject(
                              avatarConvert: comboInfo
                                  .onGoingCombo?.challenger?.avatarConvert,
                              imageUrl:
                                  comboInfo.onGoingCombo?.challenger?.avatar,
                              username:
                                  comboInfo.onGoingCombo?.challenger?.username,
                            )
                          : challengerRenderObject(
                              //avatarConvert: liveChallenger?.challenger?.
                              imageUrl: liveChallenger?.challenger?.image,
                              username: liveChallenger?.challenger?.username,
                            )
                ],
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 140.w,
              ),
              child: buildTimerCapsule(
                  timerCountdown ?? ''), // pass LiveComboEntity instance
            )
          ],
        );
      },
    );
  }
}

LiveComboEntity? access;

Widget buildTimerCapsule(String timerCountdown) {
  return CustomPaint(
    painter: GradientBorderPainter(
      strokeWidth: 2,
      radius: 999,
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFFF2400), // left red-orange
          Color(0xFF0075FF), // right blue
        ],
      ),
    ),
    child: Container(
      width: 70.w,
      height: 20.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        timerCountdown, // extract duration from entity
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class GradientBorderPainter extends CustomPainter {
  final double strokeWidth;
  final double radius;
  final Gradient gradient;

  GradientBorderPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget challengerRenderObject(
    {Uint8List? avatarConvert, String? imageUrl, String? username}) {
  return Row(
    children: [
      GestureDetector(
          child: avatarConvert != null
              ? Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image:
                          DecorationImage(image: MemoryImage(avatarConvert))),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      height: 20.w,
                      width: 20.w,
                      imageUrl: imageUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.person),
                      ),
                      errorWidget: (context, error, trace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person),
                      ),
                    ),
                  ),
                )),
      const SizedBox(width: 8),
      Text(
        username ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ],
  );
}
