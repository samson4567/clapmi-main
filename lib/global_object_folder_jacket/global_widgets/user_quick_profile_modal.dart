import 'dart:typed_data';

import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_event.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_state.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/features/user/data/models/creator_leaderboard_model.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Future<void> showUserQuickProfileModal(
  BuildContext context, {
  required String userPid,
  String? initialName,
  String? initialImageUrl,
  Uint8List? initialAvatarBytes,
  bool? initialIsFriend,
}) {
  if (userPid.isEmpty) {
    return Future.value();
  }

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.75),
    builder: (_) {
      return UserQuickProfileModal(
        launchContext: context,
        userPid: userPid,
        initialName: initialName,
        initialImageUrl: initialImageUrl,
        initialAvatarBytes: initialAvatarBytes,
        initialIsFriend: initialIsFriend,
      );
    },
  );
}

class UserQuickProfileModal extends StatefulWidget {
  const UserQuickProfileModal({
    super.key,
    required this.launchContext,
    required this.userPid,
    this.initialName,
    this.initialImageUrl,
    this.initialAvatarBytes,
    this.initialIsFriend,
  });

  final BuildContext launchContext;
  final String userPid;
  final String? initialName;
  final String? initialImageUrl;
  final Uint8List? initialAvatarBytes;
  final bool? initialIsFriend;

  @override
  State<UserQuickProfileModal> createState() => _UserQuickProfileModalState();
}

class _UserQuickProfileModalState extends State<UserQuickProfileModal> {
  UserModel? _userProfile;
  CreatorRankingModel? _ranking;
  String? _pendingRequestId;
  String? _actionMessage;
  bool _isProfileLoading = true;
  bool _isRankingLoading = true;
  bool _isSendingClapRequest = false;
  bool _isRemovingRequest = false;
  bool _hasRequested = false;

  bool get _isSelf => profileModelG?.pid == widget.userPid;

  String get _displayName {
    return _userProfile?.username ??
        _userProfile?.name ??
        widget.initialName ??
        'User';
  }

  String? get _displayImageUrl {
    return _userProfile?.image ?? widget.initialImageUrl;
  }

  Uint8List? get _displayAvatarBytes {
    return widget.initialAvatarBytes;
  }

  String get _rankLabel {
    if (_isRankingLoading) {
      return 'Loading...';
    }

    final rank = _ranking?.leaderboardRank;
    if (rank == null || rank <= 0) {
      return 'Not ranked';
    }

    return 'No. $rank';
  }

  String get _levelLabel {
    if (_isRankingLoading) {
      return 'Lvl: ...';
    }

    final levelName = _ranking?.level.name;
    if (levelName == null || levelName.isEmpty) {
      return 'Lvl: --';
    }

    return 'Lvl: $levelName';
  }

  String? get _levelIconAsset {
    final normalized = _ranking?.level.name.toLowerCase().trim();
    switch (normalized) {
      case 'prime':
        return 'assets/icons/prime.png';
      case 'elite':
        return 'assets/icons/elite.png';
      case 'icon':
        return 'assets/icons/ic.png';
      case 'legend':
        return 'assets/icons/legend1.png';
      default:
        return null;
    }
  }

  String get _primaryActionLabel {
    if (_pendingRequestId != null) {
      return 'Unclap request';
    }

    if (_hasRequested || (_userProfile?.isFriend ?? false)) {
      return 'Requested';
    }

    return 'Clap request';
  }

  bool get _canTriggerPrimaryAction {
    if (_isSelf || _isSendingClapRequest || _isRemovingRequest) {
      return false;
    }

    if (_pendingRequestId != null) {
      return true;
    }

    return !(_hasRequested || (_userProfile?.isFriend ?? false));
  }

  @override
  void initState() {
    super.initState();
    _hasRequested = widget.initialIsFriend ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<AppBloc>().add(GetUserProfileEvent(userId: widget.userPid));
      context
          .read<UserBloc>()
          .add(GetCreatorLeaderboardEvent(creator: widget.userPid));
      context.read<ChatsAndSocialsBloc>().add(const GetClapRequestEvent());
    });
  }

  void _handleAppState(AppState state) {
    if (state is! GetUserProfileSuccess && state is! GetUserProfileError) {
      return;
    }

    if (state is GetUserProfileSuccess &&
        state.userProfile.pid == widget.userPid) {
      setState(() {
        _userProfile = state.userProfile;
        _hasRequested = _hasRequested || (state.userProfile.isFriend ?? false);
        _isProfileLoading = false;
      });
    } else if (state is GetUserProfileError && _isProfileLoading) {
      setState(() {
        _isProfileLoading = false;
      });
    }
  }

  void _handleUserState(UserState state) {
    if (state is GetCreatorLeaderboardSuccessState &&
        state.creator == widget.userPid) {
      CreatorRankingModel? ranking;
      for (final item in state.response.data.rankings) {
        if (item.creatorPid == widget.userPid) {
          ranking = item;
          break;
        }
      }
      ranking ??=
          state.response.data.rankings.isNotEmpty ? state.response.data.rankings.first : null;

      setState(() {
        _ranking = ranking;
        _isRankingLoading = false;
      });
    } else if (state is GetCreatorLeaderboardErrorState &&
        state.creator == widget.userPid) {
      setState(() {
        _isRankingLoading = false;
      });
    }
  }

  void _handleChatsState(ChatsAndSocialsState state) {
    if (state is GetClapRequestSuccessState) {
      String? requestId;
      for (final request in state.listOfClapRequest) {
        if (request.senderProfile == widget.userPid) {
          requestId = request.id;
          break;
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _pendingRequestId = requestId;
        if (requestId != null) {
          _hasRequested = true;
        }
      });
      return;
    }

    if (_isSendingClapRequest) {
      if (state is SendClapRequestToUsersSuccessState) {
        setState(() {
          _isSendingClapRequest = false;
          _hasRequested = true;
          _actionMessage = state.message;
        });
      } else if (state is SendClapRequestToUsersErrorState) {
        setState(() {
          _isSendingClapRequest = false;
          _actionMessage = state.errorMessage;
          final lowerMessage = state.errorMessage.toLowerCase();
          if (lowerMessage.contains('pending request') ||
              lowerMessage.contains('already sent') ||
              lowerMessage.contains('existing pending')) {
            _hasRequested = true;
          }
        });

        if (state.errorMessage.toLowerCase().contains('already sent you a clap request')) {
          context.read<ChatsAndSocialsBloc>().add(const GetClapRequestEvent());
        }
      }
    }

    if (_isRemovingRequest && _pendingRequestId != null) {
      if (state is RejectRequestSuccessState && state.requestID == _pendingRequestId) {
        setState(() {
          _isRemovingRequest = false;
          _pendingRequestId = null;
          _hasRequested = false;
          _actionMessage = state.message;
        });
      } else if (state is RejectRequestErrorState &&
          state.requestID == _pendingRequestId) {
        setState(() {
          _isRemovingRequest = false;
          _actionMessage = state.errorMessage;
        });
      }
    }
  }

  void _handlePrimaryAction() {
    if (!_canTriggerPrimaryAction) {
      return;
    }

    if (_pendingRequestId != null) {
      setState(() {
        _isRemovingRequest = true;
        _actionMessage = null;
      });
      context.read<ChatsAndSocialsBloc>().add(RejectRequestEvent(_pendingRequestId!));
      return;
    }

    setState(() {
      _isSendingClapRequest = true;
      _actionMessage = null;
    });
    context.read<ChatsAndSocialsBloc>().add(
          SendClapRequestToUsersEvent(userPids: widget.userPid),
        );
  }

  void _viewProfile() {
    Navigator.of(context, rootNavigator: true).pop();

    if (_isSelf) {
      widget.launchContext.pushNamed(MyAppRouteConstant.myAccountPage);
      return;
    }

    widget.launchContext.pushNamed(
      MyAppRouteConstant.othersAccountPage,
      extra: {
        'userId': widget.userPid,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(listener: (_, state) {
          _handleAppState(state);
        }),
        BlocListener<UserBloc, UserState>(listener: (_, state) {
          _handleUserState(state);
        }),
        BlocListener<ChatsAndSocialsBloc, ChatsAndSocialsState>(
          listener: (_, state) {
            _handleChatsState(state);
          },
        ),
      ],
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
          decoration: BoxDecoration(
            color: getFigmaColor('121212'),
            borderRadius: BorderRadius.circular(28.r),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                getFigmaColor('121212'),
                getFigmaColor('0E2747'),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  AppAvatar(
                    imageUrl: _displayImageUrl,
                    memoryBytes: _displayAvatarBytes,
                    name: _displayName,
                    size: 82.w,
                    backgroundColor: getFigmaColor('006FCD'),
                  ),
                  Positioned(
                    bottom: -12.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2B24A),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: const Color(0xFFFFD68A), width: 2),
                      ),
                      child: Text(
                        _ranking?.leaderboardRank?.toString() ?? '--',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              Text(
                _displayName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 19.sp,
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: FancyContainer(
                      radius: 18,
                      height: 58.h,
                      backgroundColor: const Color(0xFFB9D6F5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.leaderboard, color: const Color(0xFF173C72), size: 20.sp),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              _rankLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF173C72),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: FancyContainer(
                      radius: 18,
                      height: 58.h,
                      backgroundColor: const Color(0xFFFDE8A7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_levelIconAsset != null) ...[
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.7, end: 1),
                              duration: const Duration(milliseconds: 520),
                              curve: Curves.elasticOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Opacity(
                                    opacity: value.clamp(0, 1),
                                    child: child,
                                  ),
                                );
                              },
                              child: Image.asset(
                                _levelIconAsset!,
                                width: 34.w,
                                height: 34.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ] else ...[
                            Icon(Icons.workspace_premium_rounded,
                                color: const Color(0xFF7B5619), size: 20.sp),
                            SizedBox(width: 8.w),
                          ],
                          Flexible(
                            child: Text(
                              _levelLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF7B5619),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_actionMessage != null) ...[
                SizedBox(height: 12.h),
                Text(
                  _actionMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontFamily: 'Poppins',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: FancyContainer(
                      radius: 28,
                      height: 54.h,
                      backgroundColor: _canTriggerPrimaryAction
                          ? getFigmaColor('006FCD')
                          : getFigmaColor('3D3D3D'),
                      isAsync: false,
                      action: _canTriggerPrimaryAction ? _handlePrimaryAction : null,
                      child: (_isSendingClapRequest || _isRemovingRequest)
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _primaryActionLabel,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: FancyContainer(
                      radius: 28,
                      height: 54.h,
                      backgroundColor: getFigmaColor('4A4A4A'),
                      isAsync: false,
                      action: _viewProfile,
                      child: Text(
                        'View profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isProfileLoading || _isRankingLoading) SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
