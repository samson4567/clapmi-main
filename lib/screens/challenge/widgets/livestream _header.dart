import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_event.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_state.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/features/livestream/presentation/widgets/recording_indicator.dart';
import 'package:clapmi/features/livestream/presentation/blocs/recording/recording_bloc.dart';
import 'package:clapmi/features/livestream/presentation/widgets/recording_controls_sheet.dart';
import 'package:clapmi/features/livestream/data/models/recording_model.dart';
import 'package:clapmi/screens/challenge/others/Single_livestream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:share_plus/share_plus.dart';

class LivestreamHeader extends StatefulWidget {
  const LivestreamHeader(
      {super.key,
      required this.comboInfo,
      required this.comboId,
      required this.timerCountdown,
      required this.onLeaveComboEvent,
      required this.bragID,
      this.totalGiftingPot,
      this.creatorEarnedClapPoints,
      this.liveChallenger,
      required this.numOfChallengers,
      required this.streamersCount,
      required this.isLiveGoingNow,
      this.showCompanionBadge = false,
      this.model});

  final LiveComboEntity comboInfo;
  final ComboInLiveStream? liveChallenger;
  final CreatePostModel? model;
  final String comboId;
  final num? totalGiftingPot;
  final num? creatorEarnedClapPoints;
  final String? timerCountdown;
  final String bragID;
  final int numOfChallengers;
  final int streamersCount;
  final Function(bool) onLeaveComboEvent;
  final bool isLiveGoingNow;
  final bool showCompanionBadge;

  @override
  State<LivestreamHeader> createState() => _LivestreamHeaderState();
}

class _LivestreamHeaderState extends State<LivestreamHeader> {
  UserModel? _hostUserProfile;
  bool _isHostProfileLoading = false;
  bool _isSendingClapRequest = false;
  bool _hasSentClapRequest = false;
  String? _loadedHostPid;

  String? get _hostPid =>
      widget.comboInfo.host?.profile ?? widget.comboInfo.onGoingCombo?.host?.profile;

  String? get _challengerPid =>
      widget.comboInfo.challenger?.profile ??
      widget.comboInfo.onGoingCombo?.challenger?.profile;

  bool get _isSpectator {
    final currentUserPid = profileModelG?.pid;
    final hostPid = _hostPid;

    if (currentUserPid == null || hostPid == null) {
      return false;
    }

    return currentUserPid != hostPid && currentUserPid != _challengerPid;
  }

  bool get _shouldShowClapButton {
    if (!_isSpectator || _hostPid == null || _isHostProfileLoading) {
      return false;
    }

    return !(_hostUserProfile?.isFriend ?? false);
  }

  String get _displayedHostName =>
      widget.comboInfo.host?.username ??
      widget.comboInfo.onGoingCombo?.host?.username ??
      profileModelG?.username ??
      profileModelG?.name ??
      '';

  String? get _displayedHostImage =>
      widget.comboInfo.host?.avatar ??
      widget.comboInfo.onGoingCombo?.host?.avatar ??
      profileModelG?.image;

  Uint8List? get _displayedHostAvatarBytes =>
      widget.comboInfo.host?.avatarConvert ??
      widget.comboInfo.onGoingCombo?.host?.avatarConvert ??
      profileModelG?.myAvatar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHostProfileIfNeeded();
    });
  }

  @override
  void didUpdateWidget(covariant LivestreamHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.comboInfo.host?.profile ?? oldWidget.comboInfo.onGoingCombo?.host?.profile) !=
        _hostPid) {
      _hostUserProfile = null;
      _isHostProfileLoading = false;
      _isSendingClapRequest = false;
      _hasSentClapRequest = false;
      _loadedHostPid = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchHostProfileIfNeeded();
      });
    }
  }

  void _fetchHostProfileIfNeeded() {
    final hostPid = _hostPid;
    if (!mounted ||
        !_isSpectator ||
        hostPid == null ||
        hostPid.isEmpty ||
        _loadedHostPid == hostPid ||
        _isHostProfileLoading) {
      return;
    }

    setState(() {
      _isHostProfileLoading = true;
      _loadedHostPid = hostPid;
    });

    context.read<AppBloc>().add(GetUserProfileEvent(userId: hostPid));
  }

  void _handleAppState(AppState state) {
    final hostPid = _hostPid;
    if (hostPid == null) {
      return;
    }

    if (state is GetUserProfileSuccess && state.userProfile.pid == hostPid) {
      if (!mounted) {
        return;
      }
      setState(() {
        _hostUserProfile = state.userProfile;
        _isHostProfileLoading = false;
        _hasSentClapRequest = state.userProfile.isFriend ?? false;
      });
    } else if (state is GetUserProfileError && _isHostProfileLoading) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isHostProfileLoading = false;
      });
    }
  }

  void _handleClapRequestState(ChatsAndSocialsState state) {
    if (!_isSendingClapRequest) {
      return;
    }

    if (state is SendClapRequestToUsersSuccessState) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSendingClapRequest = false;
        _hasSentClapRequest = true;
      });
    } else if (state is SendClapRequestToUsersErrorState) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSendingClapRequest = false;
        if (state.errorMessage
            .toLowerCase()
            .contains('already sent you a clap request')) {
          _hasSentClapRequest = true;
        }
      });
      _showClapRequestErrorModal(state.errorMessage);
    }
  }

  void _showClapRequestErrorModal(String message) {
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 18.h),
                GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(),
                  child: Container(
                    height: 44.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006FCD),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'Dismiss',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendClapRequest() {
    final hostPid = _hostPid;
    if (hostPid == null ||
        hostPid.isEmpty ||
        _hasSentClapRequest ||
        _isSendingClapRequest ||
        !_shouldShowClapButton) {
      return;
    }

    setState(() {
      _isSendingClapRequest = true;
    });

    context
        .read<ChatsAndSocialsBloc>()
        .add(SendClapRequestToUsersEvent(userPids: hostPid));
  }

  void _openHostQuickProfileModal() {
    final hostPid = _hostPid;
    if (hostPid == null || hostPid.isEmpty) {
      return;
    }

    showUserQuickProfileModal(
      context,
      userPid: hostPid,
      initialName: _displayedHostName,
      initialImageUrl: _displayedHostImage,
      initialAvatarBytes: _displayedHostAvatarBytes,
      initialIsFriend: _hostUserProfile?.isFriend,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            _handleAppState(state);
          },
        ),
        BlocListener<ChatsAndSocialsBloc, ChatsAndSocialsState>(
          listener: (context, state) {
            _handleClapRequestState(state);
          },
        ),
      ],
      child: BlocConsumer<ComboBloc, ComboState>(
        listener: (context, state) {
          if (state is LeaveComboGroundSuccessState) {
            widget.onLeaveComboEvent(true);
          }
        },
        builder: (context, state) {
          final comboInfo = widget.comboInfo;
          final liveChallenger = widget.liveChallenger;
          final model = widget.model;
          final comboId = widget.comboId;
          final totalGiftingPot = widget.totalGiftingPot;
          final creatorEarnedClapPoints = widget.creatorEarnedClapPoints;
          final bragID = widget.bragID;
          final streamersCount = widget.streamersCount;
          final numOfChallengers = widget.numOfChallengers;
          final isLiveGoingNow = widget.isLiveGoingNow;

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
                      if (widget.showCompanionBadge) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Image.asset(
                            'assets/icons/companion.png',
                            width: 22,
                            height: 22,
                          ),
                        ),
                      ],
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return EndliveStream(
                                comboId: comboId,
                                earnedClapPoints: creatorEarnedClapPoints,
                                totalGiftPoints: totalGiftingPot,
                                showGiftSummary:
                                    creatorEarnedClapPoints != null,
                              );
                            },
                          );
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
                  onTap: _openHostQuickProfileModal,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: AppAvatar(
                      imageUrl: _displayedHostImage,
                      memoryBytes: _displayedHostAvatarBytes,
                      name: _displayedHostName,
                      size: 30.w,
                      backgroundColor: Colors.grey[300]!,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: _openHostQuickProfileModal,
                          child: Text(
                            _displayedHostName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      if (_shouldShowClapButton) ...[
                        const SizedBox(width: 8),
                        _LiveClapButton(
                          isLoading: _isSendingClapRequest,
                          isRequested: _hasSentClapRequest,
                          onTap: _sendClapRequest,
                        ),
                      ],
                    ],
                  ),
                ),
                // Recording indicator
                BlocBuilder<RecordingBloc, RecordingState>(
                  builder: (context, recordingState) {
                    final isRecording = recordingState is RecordingStarted;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isRecording) ...[
                          SvgPicture.asset('assets/images/livrec.svg'),
                          SizedBox(
                            width: 5.h,
                          ),
                        ],
                        RecordingIndicator(
                          isRecording: isRecording,
                          onTap: () {
                            // Show recording controls sheet
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
                                onScreenShare: () => Navigator.pop(context),
                                onStartRecording: () {
                                  context.read<RecordingBloc>().add(
                                        StartRecording(roomId: comboId),
                                      );
                                  Navigator.pop(context);
                                },
                                onStopRecording: () {
                                  if (isRecording) {
                                    context.read<RecordingBloc>().add(
                                          StopRecording(
                                            recordingId: (recordingState
                                                    as RecordingStarted)
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
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  width: 5.h,
                ),
                //ShareIcon
                FancyContainer(
                  isAsync: false,
                  height: 30,
                  width: 40,
                  action: () async {
                    final trackingId =
                        bragID.isNotEmpty ? bragID : (model?.uuid ?? "");
                    if (comboId.isEmpty) {
                      return;
                    }
                    final result = await SharePlus.instance.share(ShareParams(
                        title: 'Check out the Livestream',
                        text:
                            'Check out the livestream on clapmi https://app.clapmi.com${MyAppRouteConstant.sharedLivestreamBase}/$comboId'));

                    if (result.status == ShareResultStatus.success &&
                        trackingId.isNotEmpty) {
                      context.read<PostBloc>().add(
                            SharePostEvent(
                              postID: trackingId,
                              //localPostModel?.uuid ?? "",
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
          ],
        );
      },
      ),
    );
  }
}

class _LiveClapButton extends StatelessWidget {
  const _LiveClapButton({
    required this.onTap,
    required this.isLoading,
    required this.isRequested,
  });

  final VoidCallback onTap;
  final bool isLoading;
  final bool isRequested;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading || isRequested ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: isRequested
              ? const Color(0xff0F1A2A)
              : const Color(0xff006FCD),
          border: isRequested
              ? Border.all(color: const Color(0xff006FCD))
              : null,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else if (isRequested) ...[
              Icon(
                Icons.check_rounded,
                color: const Color(0xff71B7FF),
                size: 18.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'Requested',
                style: TextStyle(
                  color: const Color(0xff71B7FF),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ]
            else ...[
              Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'Clap',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ],
        ),
      ),
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
