// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/challenge/widgets/gift_live_coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SingleLivestreamDetailPage extends StatefulWidget {
  final ComboEntity? comboEntity;
  final String? comboId;

  const SingleLivestreamDetailPage({
    super.key,
    this.comboEntity,
    this.comboId,
  }) : assert(comboEntity != null || comboId != null);

  @override
  State<SingleLivestreamDetailPage> createState() =>
      _SingleLivestreamDetailPageState();
}

class _SingleLivestreamDetailPageState
    extends State<SingleLivestreamDetailPage> {
  String? timerCountdown;
  Timer? _timer;
  bool isLoading = false;
  bool hasTimeElapsed = false;
  bool _navigateOnFetch = false;
  ComboEntity? _comboEntity;

  ComboEntity? get currentCombo => _comboEntity;
  String get _targetComboId => widget.comboId ?? currentCombo?.combo ?? '';
  bool get isHost => profileModelG?.pid == currentCombo?.host?.profile;

  @override
  void initState() {
    super.initState();
    _comboEntity = widget.comboEntity;

    if (currentCombo != null) {
      _startCountdownTimer();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_targetComboId.isNotEmpty) {
          context.read<ComboBloc>().add(GetComboDetailEvent(_targetComboId));
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    _timer?.cancel();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final start = currentCombo?.start;
    if (start == null || start.isEmpty) {
      if (!mounted) {
        return;
      }
      setState(() {
        timerCountdown = "00hr : 00mins : 00secs";
        hasTimeElapsed = false;
      });
      return;
    }

    try {
      final now = DateTime.now();
      final remaining = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(start, true)
          .toLocal()
          .difference(now);

      if (!mounted) {
        return;
      }

      if (remaining.isNegative || remaining.inSeconds == 0) {
        setState(() {
          timerCountdown = "00hr : 00mins : 00secs";
          hasTimeElapsed = true;
        });
        _timer?.cancel();
      } else {
        setState(() {
          timerCountdown =
              "${remaining.inHours}hr : ${remaining.inMinutes % 60}mins : ${remaining.inSeconds % 60}secs";
          hasTimeElapsed = false;
        });
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        timerCountdown = "00hr : 00mins : 00secs";
        hasTimeElapsed = false;
      });
    }
  }

  void _fetchComboAndNavigate() {
    if (_targetComboId.isEmpty) {
      return;
    }

    setState(() {
      _navigateOnFetch = true;
      isLoading = true;
    });

    context.read<ComboBloc>().add(GetComboDetailEvent(_targetComboId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
        ),
        title: Text(
          currentCombo?.about ?? 'Livestream',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.5,
            letterSpacing: 0,
          ),
        ),
      ),
      body: BlocListener<ComboBloc, ComboState>(
        listener: (context, state) {
          if (state is GetComboDetailLoadingState &&
              (_navigateOnFetch || currentCombo == null)) {
            setState(() => isLoading = true);
          }

          if (state is GetComboDetailErrorState &&
              (_navigateOnFetch || currentCombo == null)) {
            setState(() {
              isLoading = false;
              _navigateOnFetch = false;
            });
            // Handle server error gracefully - show user-friendly message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Unable to load combo details. Please try again.'),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    if (_targetComboId.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                        _navigateOnFetch = true;
                      });
                      context
                          .read<ComboBloc>()
                          .add(GetComboDetailEvent(_targetComboId));
                    }
                  },
                ),
                duration: Duration(seconds: 5),
              ),
            );
          }

          if (state is GetComboDetailSuccessState &&
              state.comboEntity.combo == _targetComboId) {
            setState(() {
              isLoading = false;
              _comboEntity = state.comboEntity;
            });
            _startCountdownTimer();

            if (_navigateOnFetch) {
              _navigateOnFetch = false;
              context.pushNamed(
                MyAppRouteConstant.startOrjoin,
                extra: state.comboEntity,
              );
            }
          }
        },
        child: currentCombo == null
            ? const Center(child: CircularProgressIndicator.adaptive())
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B2A00),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Starts in ${timerCountdown ?? '00hr : 00mins : 00secs'}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFAA00),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              child: profileModelG?.myAvatar != null
                                  ? Container(
                                      width: 30.w,
                                      height: 30.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        image: DecorationImage(
                                          image: MemoryImage(
                                            profileModelG!.myAvatar!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(top: 6.h),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          height: 30.h,
                                          width: 30.w,
                                          imageUrl: profileModelG?.image ?? '',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.person),
                                          ),
                                          errorWidget:
                                              (context, error, trace) =>
                                                  Container(
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.person),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              currentCombo?.host?.username ?? 'Host',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Live Duration',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white38,
                              height: 1.5,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            currentCombo?.duration ?? '00hr: 00mins: 00secs',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.5,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isHost)
                      Center(
                        child: GestureDetector(
                            onTap: () {
                              // delete stream logic
                            },
                            child: SvgPicture.asset('assets/icons/delete.svg')),
                      ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: _buildActionButtons(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (isHost) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: hasTimeElapsed ? _fetchComboAndNavigate : null,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: hasTimeElapsed
                      ? const Color(0xFF1A6BFF)
                      : const Color(0xFF1A6BFF).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Text(
                        'Start now',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: hasTimeElapsed ? Colors.white : Colors.white54,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF006FCD),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_none_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Remind me',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFF2A2A2A),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.reply_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: hasTimeElapsed ? _fetchComboAndNavigate : null,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: hasTimeElapsed
                    ? const Color(0xFF1A6BFF)
                    : const Color(0xFF1A6BFF).withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                      'Join now',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: hasTimeElapsed ? Colors.white : Colors.white54,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.black,
                isScrollControlled: true,
                builder: (context) {
                  return GiftLiveCoin(
                    host: currentCombo?.host,
                    challenger: null,
                    comboId: currentCombo?.combo ?? '',
                    contextType: 'standard',
                    onGoingComboId: '',
                    isLiveOngoing: false,
                  );
                },
              );
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF006FCD),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Vote',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A2A),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.reply_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ],
    );
  }
}
