import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/challenge/others/widgets/live_buy_point_button.dart'
    show
        ClapLiveStreamButton,
        BuyPointButton,
        GiftLiveButton,
        LiveInteractionButton,
        SpectatorsInteractionButton,
        buttonWidget,
        BoostSuccessWidget,
        PopRecord,
        PopRecordVariant,
        SingleLiveScheduler;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class SingleLiveStreaming extends StatefulWidget {
  const SingleLiveStreaming({super.key});

  @override
  State<SingleLiveStreaming> createState() => _SingleLiveStreamingState();
}

class _SingleLiveStreamingState extends State<SingleLiveStreaming> {
  final TextEditingController _commentController = TextEditingController();
  bool showPopup = false;
  bool _isMinimized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background live video placeholder
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?fit=crop&w=800&q=80',
                fit: BoxFit.cover,
              ),
            ),

            // Overlay gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            // Header section
            _buildHeader(context),
            // Comments section
            Positioned(
              bottom: 100.h,
              left: 10.w,
              right: 10.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildComment("Adam Shady", "😂😂🤣"),
                  SizedBox(height: 6.h),
                  _buildGift(
                    "Leah Sanny",
                    "Leah6",
                    "2",
                    const Color.fromRGBO(238, 27, 65, 1),
                    const Color.fromRGBO(238, 27, 65, 0.1),
                    const Color.fromRGBO(92, 14, 28, 1),
                  ),
                ],
              ),
            ),

            // Comment bar
            Positioned(
              bottom: 45.h,
              left: 10.w,
              right: 10.w,
              child: Container(
                height: 45.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xff4647474d),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Comment",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Image.asset('assets/images/pipi.png'),
                  ],
                ),
              ),
            ),

            // Bottom icons
            Positioned(
              bottom: 5.h,
              left: 10,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomIcon('assets/images/Mic (1).svg'),
                  _bottomIcon('assets/icons/Screen share.svg'),
                  _bottomIcon('assets/icons/Record.svg'),
                  _bottomIcon('assets/images/Live video.svg'),
                  _bottomIcon('assets/icons/View size (1).svg'),
                  GestureDetector(
                      onTap: () {
                        // showModalBottomSheet(
                        //   backgroundColor: Colors.transparent,
                        //   context: context,
                        //   isScrollControlled: true,
                        //   builder: (_) => const EndliveStream(),
                        // );
                      },
                      child: _bottomIcon('assets/images/Leave.svg')),
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => ScreenSharingIcon(
                            onPress: () {},
                          ),
                        );
                      },
                      child: _bottomIcon('assets/images/Screen share.svg')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomIcon(String path) {
    return SvgPicture.asset(
      path,
      width: 32.w,
      height: 32.w,
      fit: BoxFit.cover,
      placeholderBuilder: (context) => Container(
        width: 32.w,
        height: 32.w,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          strokeWidth: 1.5,
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildComment(String user, String message) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.r,
          backgroundImage: const NetworkImage(
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?fit=crop&w=100&q=80',
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          user,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp),
        ),
        SizedBox(width: 6.w),
        Text(message, style: TextStyle(color: Colors.white, fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildGift(
    String sender,
    String receiver,
    String coins,
    Color color1,
    Color color2,
    Color color3,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.r,
          backgroundImage: const NetworkImage(
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?fit=crop&w=100&q=80',
          ),
        ),
        SizedBox(width: 8.w),
        Text(sender,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp)),
        SizedBox(width: 6.w),
        Container(
          height: 40,
          width: 165,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2, color3],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            children: [
              Image.asset('assets/icons/mini.png'),
              SizedBox(width: 4.w),
              Text("Lo $receiver",
                  style: TextStyle(color: Colors.white, fontSize: 12.sp)),
              SizedBox(width: 6.w),
              SizedBox(width: 2.w),
              _bottomIcon('assets/images/openmoji_coin.svg'),
            ],
          ),
        ),
      ],
    );
  }

  // HEADER SECTION
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Designer earn more than front devs',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.h,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(255, 255, 255, 0.5),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      print('Minimize button clicked');
                      setState(() {
                        _isMinimized = !_isMinimized;
                      });
                    },
                    icon: const Icon(Icons.minimize,
                        size: 25.98, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close,
                        size: 25.98,
                        color: Color.fromRGBO(255, 255, 255, 0.173)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Row(
            children: [
              GestureDetector(
                child: profileModelG?.myAvatar != null
                    ? Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image: MemoryImage(profileModelG!.myAvatar!)),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            height: 30.w,
                            width: 30.w,
                            imageUrl: profileModelG?.image ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const Icon(Icons.person),
                            errorWidget: (context, error, trace) =>
                                const Icon(Icons.person),
                          ),
                        ),
                      ),
              ),
              SizedBox(width: 2.w),
              Text(profileModelG!.name.toString(),
                  style: const TextStyle(color: Colors.white)),
              SizedBox(width: 40.w),
              GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const TopViewersModal(),
                    );
                  },
                  child: _bottomIcon('assets/images/Mic.svg')),
              SizedBox(width: 5.w),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const AcceptRequestsModal(),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(61, 61, 61, 5),
                      borderRadius: BorderRadius.circular(25)),
                  height: 36.h,
                  width: 57.w,
                  child: Center(
                      child: SvgPicture.asset('assets/images/profile-2.svg',
                          width: 20.w, height: 20.w)),
                ),
              ),
              SizedBox(width: 2.w),

              // 👇 Challenge Requests Button
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => ChallengeRequestsModal(
                      hostAvatar: profileModelG!.myAvatar,
                      hostImageUrl: profileModelG!.image,
                    ),
                  );
                },
                child: SvgPicture.asset('assets/images/cha.svg',
                    width: 32.w, height: 32.w),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border:
                      Border.all(color: const Color.fromARGB(161, 0, 36, 31)),
                  borderRadius: BorderRadius.circular(25)),
              height: 34.h,
              width: 94.w,
              child: Center(
                  child: Text('2:00:00',
                      style: TextStyle(
                          fontSize: 13.h, fontWeight: FontWeight.w600))),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// CHALLENGE REQUESTS MODAL
// ----------------------------------------------------------------------------
// - this spectators
class ChallengeRequestsModal extends StatefulWidget {
  const ChallengeRequestsModal(
      {super.key, required this.hostImageUrl, required this.hostAvatar});
  final String? hostImageUrl;
  final Uint8List? hostAvatar;

  @override
  State<ChallengeRequestsModal> createState() => _ChallengeRequestsModalState();
}

class _ChallengeRequestsModalState extends State<ChallengeRequestsModal> {
  int? newBoostPoint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60.w,
              height: 4.h,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [Image.asset('assets/images/226.png')],
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: BlocConsumer<BragBloc, BragState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state is SingleBragChallengersErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.errorMessage),
                    ),
                  );
                }

                if (state is SingleLiveAcceptChallengeSuccessState) {
                  Navigator.pop(context); // close modal
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const ChallengePop(),
                  );
                }
              },
              builder: (context, state) {
                if (state is SingleBragChallengersLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (state is SingleBragChallengersErrorState) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is SingleBragChallengersSuccessState) {
                  print("${state.challengers}");
                  final challengers = state.challengers;

                  if (challengers.isEmpty) {
                    return const Center(
                      child: Text(
                        "No challenge requests yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: challengers.length,
                    itemBuilder: (context, index) {
                      final c = challengers[index];
                      newBoostPoint =
                          int.tryParse(challengers[index].boostPoints);
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage: c.imageConvert != null
                                      ? MemoryImage(c.imageConvert!)
                                      : NetworkImage(c.challengerImage),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.challengerUsername,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp)),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/openmoji_coin.svg'),
                                        SizedBox(width: 3.w),
                                        Text(c.stake.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp)),
                                        SizedBox(width: 10.w),
                                        Image.asset('assets/images/timer.png'),
                                        SizedBox(width: 3.w),
                                        Text(c.duration.toString(),
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12.sp)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pop();
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  isScrollControlled: true,
                                  // ignore: avoid_types_as_parameter_names
                                  builder: (_) => Boost(
                                    challengeId: c.challenge,
                                    challengerAvatar: c.imageConvert,
                                    challengerImageUrl: c.challengerImage,
                                    hostAvatar: widget.hostAvatar,
                                    hostImageUrl: widget.hostImageUrl ?? '',
                                    onBoost: (value) {
                                      // print("This is the value $value");
                                      // if (mounted) {
                                      //   context.pop();
                                      // }
                                      // setState(() {
                                      //   newBoostPoint = value! + newBoostPoint!;
                                      // });
                                    },
                                  ),
                                );
                                //  context.pop();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/images/vic.svg'),
                                    SizedBox(width: 4.w),
                                    Text("Boost: ${newBoostPoint.toString()}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: 4.w),
                                    SvgPicture.asset('assets/images/add.svg'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ACCEPT CHOICE  REQUESTS MODAL
// --

class AcceptRequestsModal extends StatelessWidget {
  const AcceptRequestsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Handle bar
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

          Row(children: [Image.asset('assets/images/226.png')]),
          SizedBox(height: 10.h),

          // ------------------------------------------------------
          // 🔥 ONE SINGLE BLOC-CONSUMER HANDLING ALL STATES
          // ------------------------------------------------------
          Expanded(
            child: BlocConsumer<BragBloc, BragState>(
              listener: (context, state) {
                // -----------------------
                // Challenger Fetch Errors
                // -----------------------
                if (state is SingleBragChallengersErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.errorMessage),
                    ),
                  );
                }

                // -----------------------
                // Accept Success
                // -----------------------
                if (state is SingleLiveAcceptChallengeSuccessState) {
                  Navigator.pop(context); // close modal
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const ChallengePop(),
                  );
                }

                // -----------------------
                // Decline Success
                // -----------------------
                if (state is SingeLiveChallengeDeclined) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.message),
                    ),
                  );
                }

                // -----------------------
                // Accept Error
                // -----------------------
                if (state is SingleLiveAcceptChallengeErrorState) {
                  print("-----${state.errorMessage}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.errorMessage),
                    ),
                  );
                }
              },
              builder: (context, state) {
                // --------------------------
                // LOADING STATE
                // --------------------------
                if (state is SingleBragChallengersLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                // --------------------------
                // ERROR STATE
                // --------------------------
                if (state is SingleBragChallengersErrorState) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                // --------------------------
                // SUCCESS → SHOW LIST
                // --------------------------
                if (state is SingleBragChallengersSuccessState) {
                  final challengers = state.challengers;

                  if (challengers.isEmpty) {
                    return const Center(
                      child: Text(
                        "No challenge requests yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: challengers.length,
                    itemBuilder: (context, index) {
                      final c = challengers[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // -----------------------
                            // LEFT USER INFO
                            // -----------------------
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage:
                                      NetworkImage(c.challengerImage),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.challengerUsername,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/openmoji_coin.svg'),
                                        SizedBox(width: 3.w),
                                        Text(
                                          c.stake.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Image.asset('assets/images/timer.png'),
                                        SizedBox(width: 3.w),
                                        Text(
                                          c.duration.toString(),
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // -----------------------
                            // ACCEPT BUTTON
                            // -----------------------
                            GestureDetector(
                              onTap: () {
                                context.read<BragBloc>().add(
                                      SingleLiveAcceptChallengeEvent(
                                          c.challenge),
                                    );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Accept",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // -----------------------
                            // REJECT BUTTON
                            // -----------------------
                            GestureDetector(
                              onTap: () {
                                context.read<BragBloc>().add(
                                      SingleLiveDeclineChallengeEvent(
                                          c.challenge),
                                    );
                              },
                              child: Image.asset(
                                'assets/images/x (1).png',
                                width: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                // Fallback
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TopViewersModal extends StatelessWidget {
  const TopViewersModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60.w,
              height: 4.h,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: Text(
              'Top Viewers',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 20.h),
            ),
          ),
          Divider(
            thickness: 0.2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 9,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage: NetworkImage(
                                'https://randomuser.me/api/portraits/men/$index.jpg'),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Spiritangel$index",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp)),
                              Row(
                                children: [],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("250k",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Geist',
                                  fontSize: 12.sp)),
                          SizedBox(width: 4.w),
                          SizedBox(width: 3.w),
                          SvgPicture.asset('assets/images/openmoji_coin.svg'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChallengePop extends StatelessWidget {
  const ChallengePop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 238.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60.w,
              height: 4.h,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: Text(
              'Make a Stake to begin the \n            Challenge?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 20.h),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(25.r),
                  color: Color(0XFF181919),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Row(
                  children: [
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const BuyPointsScreen(),
                        );
                      },
                      child: Text("Buy Point ",
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold)),
                    ),
                    SvgPicture.asset('assets/images/openmoji_coin.svg'),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(25.r),
                  color: Color(0XFF002F56),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Row(
                  children: [
                    SizedBox(width: 4.w),
                    Text(" Stake ",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold)),
                    SvgPicture.asset('assets/images/openmoji_coin.svg'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ScreenSharingIcon extends StatelessWidget {
  const ScreenSharingIcon({super.key, required this.onPress});
  final VoidCallback onPress;

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top drag handle
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

          // Title
          Text(
            'Share your screen with viewers?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          // Subtitle
          Text(
            'Your screen content will be visible to everyone in\nthe livestream.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30.h),
          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton(
                text: "Cancel",
                color: const Color(0xFF181919),
                textColor: Colors.white,
                borderColor: Colors.blueAccent,
                onTap: () => Navigator.pop(context),
              ),
              _actionButton(
                  text: "Start now",
                  color: const Color(0XFF006FCD),
                  textColor: Colors.white,
                  borderColor: Color(0XFF006FCD),
                  onTap: onPress),
            ],
          ),
        ],
      ),
    );
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
}

class EndliveStream extends StatelessWidget {
  final String comboId;
  final num? earnedClapPoints;
  final num? totalGiftPoints;
  final bool showGiftSummary;

  const EndliveStream({
    super.key,
    required this.comboId,
    this.earnedClapPoints,
    this.totalGiftPoints,
    this.showGiftSummary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: showGiftSummary ? 400.h : 280.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top drag handle
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

          if (showGiftSummary) ...[
            _giftSummaryCard(),
            SizedBox(height: 18.h),
          ],

          // Title
          Text(
            'Leave live session',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),

          // Subtitle
          Text(
            'Are you sure you want to leave the livestream?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30.h),

          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton(
                text: "Cancel",
                color: const Color(0xFF181919),
                textColor: Colors.white,
                borderColor: Colors.blueAccent,
                onTap: () => Navigator.pop(context),
              ),
              _actionButton(
                text: "Continue",
                color: const Color(0XFF006FCD),
                textColor: Colors.white,
                borderColor: Color(0XFF006FCD),
                onTap: () {
                  context.read<ComboBloc>().add(LeaveComboGroundEvent(comboId));
                  context.go(MyAppRouteConstant.feedScreen);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _giftSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141417),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          _giftMetric(
            title: 'Your clap points earned',
            value: earnedClapPoints ?? 0,
          ),
          SizedBox(height: 12.h),
          Divider(
            color: Colors.white.withOpacity(0.08),
            height: 1,
          ),
          SizedBox(height: 12.h),
          _giftMetric(
            title: 'Total gifts given',
            value: totalGiftPoints ?? 0,
          ),
        ],
      ),
    );
  }

  Widget _giftMetric({
    required String title,
    required num value,
  }) {
    return Row(
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F24),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: Image.asset(
              value == 0
                  ? 'assets/icons/crying.png'
                  : 'assets/icons/commentcoin.png',
              width: 22.w,
              height: 22.w,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.68),
                  fontSize: 12.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _formatClapPoints(value),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatClapPoints(num value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
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
}

class NoLivestreamGiftPrompt extends StatefulWidget {
  const NoLivestreamGiftPrompt({super.key});

  @override
  State<NoLivestreamGiftPrompt> createState() => _NoLivestreamGiftPromptState();
}

class _NoLivestreamGiftPromptState extends State<NoLivestreamGiftPrompt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFF101013),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/icons/crying.png',
                width: 78.w,
                height: 78.w,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'No gifts yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Keep engaging your audience. We will keep reminding you every 5 minutes until your first gift drops in.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontSize: 13.sp,
                height: 1.5,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F6BFF),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Center(
                  child: Text(
                    'Keep streaming',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyPointsScreen extends StatefulWidget {
  const BuyPointsScreen({super.key});

  @override
  State<BuyPointsScreen> createState() => _BuyPointsScreenState();
}

class _BuyPointsScreenState extends State<BuyPointsScreen> {
  String selectedWallet = 'Clapmi wallet';
  int? selectedAmount;
  bool isPasswordVisible = false;
  final TextEditingController customAmountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          width: 440.w,
          height: 542.h,
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0F),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Buy Points',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Wallet Selection
                  Text(
                    'Select Credit Wallet',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _buildWalletOption('Clapmi wallet'),
                      SizedBox(width: 10.w),
                      _buildWalletOption('Web3 wallet'),
                    ],
                  ),
                  SizedBox(height: 25.h),

                  /// Point Selection
                  Text(
                    'Select Clap Point Amount',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _buildPointOption(250),
                      SizedBox(width: 10.w),
                      _buildPointOption(500),
                      SizedBox(width: 10.w),
                      _buildPointOption(1000),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  /// Custom Input
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1D),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/openmoji_coin.svg'),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            controller: customAmountController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Custom',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),

                  /// Password Field
                  Text(
                    'Account Password',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1D),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Enter Password',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  /// Top Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedWallet.isNotEmpty &&
                                (selectedAmount != null ||
                                    customAmountController.text.isNotEmpty)
                            ? const Color(0xFF007BFF)
                            : Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      onPressed: () {
                        // Handle top up logic
                      },
                      child: Text(
                        'Top up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Wallet Option Builder
  Widget _buildWalletOption(String name) {
    final isSelected = selectedWallet == name;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedWallet = name),
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1D),
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? Border.all(color: Colors.blueAccent, width: 1.5)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  /// Point Option Builder
  Widget _buildPointOption(int amount) {
    final isSelected = selectedAmount == amount;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedAmount = amount),
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1D),
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? Border.all(color: Colors.blueAccent, width: 1.5)
                : null,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/openmoji_coin.svg'),
              SizedBox(width: 6.w),
              Text(
                '$amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalPotWidgetModal extends StatelessWidget {
  final int totalPot;
  final List<Streamer> streamers;

  const TotalPotWidgetModal({
    super.key,
    required this.totalPot,
    required this.streamers,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              const Color(0xFF8B3A3A), // Dark red
              const Color(0xFF2C1F1F), // Very dark red/brown
              const Color(0xFF1A2332), // Dark blue-gray
              const Color(0xFF1E3A5F), // Deep blue
            ],
            stops: const [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top bar indicator
            Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header with enhanced styling
            const Text(
              'Streamers Stakes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),

            // Divider line with gradient
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Total pot with enhanced glow effect
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFD700).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                totalPot.toString(),
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  shadows: [
                    Shadow(
                      color: Color(0xFFFFD700),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Divider line
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Streamers with improved layout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: streamers
                  .map((s) => _StreamerCard(
                        name: s.name,
                        amount: s.amount,
                        imageUrl: s.imageUrl,
                        avatar: s.avatar,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamerCard extends StatelessWidget {
  final String name;
  final int amount;
  final String? imageUrl;
  final Uint8List? avatar;

  const _StreamerCard({
    required this.name,
    required this.amount,
    required this.imageUrl,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with enhanced border and glow
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                name == 'Railly'
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFF4ECDC4),
                name == 'Railly'
                    ? const Color(0xFFFF8E53)
                    : const Color(0xFF44A08D),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: (name == 'Railly'
                        ? const Color(0xFFFF6B6B)
                        : const Color(0xFF4ECDC4))
                    .withOpacity(0.4),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1A1A2E),
            ),
            child: avatar != null
                ? Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: MemoryImage(avatar!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : (imageUrl != null && imageUrl!.endsWith('.svg'))
                    ? Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2A2A3E),
                        ),
                        child: Center(
                          child: Text(
                            name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFF2A2A3E),
                        backgroundImage:
                            imageUrl != null ? NetworkImage(imageUrl!) : null,
                        child: imageUrl == null
                            ? Text(
                                name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
          ),
        ),
        const SizedBox(height: 12),

        // Streamer name
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),

        // Amount with coin icon
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFFD700).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFD700).withOpacity(0.2),
                ),
                child: SvgPicture.asset('assets/icons/coin.svg'),
              ),
              const SizedBox(width: 6),
              Text(
                '$amount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Streamer {
  final String name;
  final int amount;
  final String? imageUrl;
  final Uint8List? avatar;

  Streamer({
    required this.name,
    required this.amount,
    required this.avatar,
    required this.imageUrl,
  });
}

class Boost extends StatefulWidget {
  final String challengeId;
  final Function(int?) onBoost;
  final String hostImageUrl;
  final String challengerImageUrl;
  final Uint8List? hostAvatar;
  final Uint8List? challengerAvatar;
  const Boost({
    super.key,
    required this.challengeId,
    required this.onBoost,
    required this.hostImageUrl,
    required this.challengerImageUrl,
    required this.hostAvatar,
    required this.challengerAvatar,
  });

  @override
  State<Boost> createState() => _BoostState();
}

class _BoostState extends State<Boost> {
  final TextEditingController _controller = TextEditingController();
  String walletCoin = "";
  bool isLoading = false;
  bool isButtonActive = false;
  double inputBoostPoint = 0;

  @override
  void initState() {
    context.read<WalletBloc>().add(GetAvailableCoinEvent());

    _controller.addListener(
      () {
        if (inputBoostPoint > 0 &&
            inputBoostPoint < (double.tryParse(walletCoin) ?? 0.0)) {
          setState(() {
            isButtonActive = true;
          });
        } else {
          setState(() {
            isButtonActive = false;
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add Boost points",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 26, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          // Input container
          BlocConsumer<WalletBloc, WalletState>(
            listener: (context, state) {
              if (state is AvailableClappCoinLoaded) {
                walletCoin = state.amount;
              }
            },
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF19191C),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Enter clap point",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14.sp)),
                          TextField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                inputBoostPoint = double.tryParse(val) ?? 0;
                              });
                            },
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "0",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Balance:",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14.sp)),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on,
                                color: Colors.amber, size: 20),
                            SizedBox(width: 4.w),
                            Text(
                              walletCoin.toString(),
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: Colors.blue, width: 1.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: () {},
                          child: Text("Buy Clap Points",
                              style: TextStyle(fontSize: 12.sp)),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          // Boost button
          BlocConsumer<BragBloc, BragState>(
            listener: (context, state) {
              if (state is BoostPointLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is BoostPointLoaded) {
                setState(() {
                  context.pop();
                  print("Boost successful");
                  isLoading = false;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: BoostSuccessWidget(
                              hostImageUrl: widget.hostImageUrl,
                              challengerImageUrl: widget.challengerImageUrl,
                              hostAvatar: widget.hostAvatar,
                              challengerAvatar: widget.challengerAvatar),
                        );
                      });
                });
              }
              if (state is BragChallengersErrorState) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: isButtonActive
                    ? () {
                        context.read<BragBloc>().add(BoostChallengePoint(
                            challengeId: widget.challengeId,
                            boostPoint: inputBoostPoint.toInt()));
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  height: 65.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isButtonActive
                        ? Colors.blue
                        : Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bolt, color: Colors.yellow),
                            SizedBox(width: 8.w),
                            Text(
                              "Boost",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class TotalPotBottomSheet extends StatelessWidget {
  const TotalPotBottomSheet(
      {super.key, required this.totalAmountInPot, required this.totalStake});

  final String totalAmountInPot;
  final String totalStake;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 12,
        left: 16,
        right: 16,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E0E),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Drag Handle
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 20),

          /// Title
          const Text(
            'Total Pot',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          /// Highlight Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B2239),
                  Color(0xFF0E2E4E),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// LEFT CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Trophy + Amount
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/pot2.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            totalAmountInPot, // "500,500"
                            style: const TextStyle(
                              color: Color(0xFFFFD88A),
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// Subtitle
                      const Text(
                        'Gift your favorite streamer and get a share of the pot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                /// RIGHT TICKET ICON
                Image.asset(
                  'assets/icons/loggift.png',
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// Gift Pot Row
          _infoRow(
            title: 'Gift Pot',
            value: totalAmountInPot,
            imagePath: 'assets/icons/pot2.png',
          ),

          const SizedBox(height: 20),

          /// Total Stake Row
          _infoRow(
            title: 'Total Stake',
            value: totalStake,
            imagePath: 'assets/icons/dee.png',
          ),

          const SizedBox(height: 16),

          Divider(color: Colors.grey.shade800),

          const SizedBox(height: 16),

          /// Total Row
          Row(
            children: [
              Image.asset(
                'assets/icons/pot2.png',
                height: 40,
                width: 40,
              ),
              SizedBox(width: 12),
              Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              SvgPicture.asset(
                'assets/icons/coin.svg',
                height: 50,
                fit: BoxFit.contain,
              ),
              Text(
                totalAmountInPot,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _infoRow({
    required String title,
    required String value,
    required String imagePath,
  }) {
    final bool isAssetImage = imagePath.startsWith('assets/');

    return Row(
      children: [
        /// Title
        Text(
          title,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 16,
          ),
        ),

        const Spacer(),

        /// Icon (asset or emoji)
        if (isAssetImage)
          Image.asset(
            imagePath,
            height: 22,
            width: 22,
            fit: BoxFit.contain,
          )
        else
          Text(
            imagePath,
            style: const TextStyle(fontSize: 22),
          ),

        const SizedBox(width: 6),

        /// Value
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class LivestreamerrrHandler extends StatelessWidget {
  const LivestreamerrrHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 380,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LiveChallengeWidget(),
              const SizedBox(height: 26),
              const Text(
                "You have an ongoing live stream.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You can only have one live stream at a time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: const [
                  Expanded(
                    child: _ActionButton(
                      label: "End And Start New",
                      color: Color(0xFF4FC3F7),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: _ActionButton(
                      label: "Rejoin Live",
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;

  const _ActionButton({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class LiveChallengeWidget extends StatelessWidget {
  const LiveChallengeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: const GradientBoxBorder(
          width: 2,
          gradient: LinearGradient(
            colors: [Colors.red, Colors.blue],
          ),
        ),
      ),
      child: Stack(
        children: [
          // Background SVG (optional decorative element)
          Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              "assets/images/pill_arrows.svg",
              height: 30,
              width: 120,
              fit: BoxFit.contain,
            ),
          ),

          // Main content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAvatar(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  //_LiveIndicator(),
                  SizedBox(height: 2),
                  Text(
                    "Host",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "VS",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Challenger",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              _buildAvatar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
        color: Colors.grey.shade300,
      ),
      child: const Icon(
        Icons.person,
        size: 18,
        color: Colors.white,
      ),
    );
  }
}

Widget _buildAvatar2() {
  return Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 1),
      color: Colors.grey.shade300,
    ),
    child: const Icon(
      Icons.person,
      size: 18,
      color: Colors.white,
    ),
  );
}
