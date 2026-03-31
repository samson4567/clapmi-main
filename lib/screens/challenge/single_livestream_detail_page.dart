// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/challenge/widgets/gift_live_coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SingleLivestreamDetailPage extends StatefulWidget {
  final ComboEntity comboEntity;

  const SingleLivestreamDetailPage({
    super.key,
    required this.comboEntity,
  });

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

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final remaining = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(widget.comboEntity.start ?? '', true)
          .toLocal()
          .difference(now);
      if (mounted) {
        if (remaining.isNegative || remaining.inSeconds == 0) {
          setState(() {
            timerCountdown = "00hr:00mins:00secs";
            hasTimeElapsed = true;
          });
          timer.cancel();
        } else {
          setState(() {
            timerCountdown =
                "${remaining.inHours}hr : ${remaining.inMinutes % 60}mins : ${remaining.inSeconds % 60}secs";
            hasTimeElapsed = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get isHost => profileModelG?.pid == widget.comboEntity.host?.profile;

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
          widget.comboEntity.about ?? '',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600, // SemiBold
            color: Colors.white,
            height: 1.5, // 150% line-height
            letterSpacing: 0,
          ),
        ),
      ),
      body: BlocListener<ComboBloc, ComboState>(
        listener: (context, state) {
          if (state is GetComboDetailSuccessState) {
            setState(() => isLoading = false);
            context.pushNamed(
              MyAppRouteConstant.startOrjoin,
              extra: state.comboEntity,
            );
          }
          if (state is GetComboDetailLoadingState) {
            setState(() => isLoading = true);
          }
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Preview card ──
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
                      // Countdown pill
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

                      // Host avatar
                      GestureDetector(
                        child: profileModelG?.myAvatar != null
                            ? Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    image:
                                        MemoryImage(profileModelG!.myAvatar!),
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
                              ),
                      ),

                      const SizedBox(height: 10),

                      // Host username
                      Text(
                        widget.comboEntity.host?.username ?? 'Host',
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

              // ── Live Duration row ──
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
                        fontWeight: FontWeight.w500, // Medium
                        color: Colors.white38,
                        height: 1.5, // 150% line height
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      widget.comboEntity.duration ?? '00hr: 00mins: 00secs',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500, // Medium
                        color: Colors.white,
                        height: 1.5, // 150% line-height
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Delete Stream (host only) ──
              if (isHost)
                Center(
                  child: GestureDetector(
                      onTap: () {
                        // delete stream logic
                      },
                      child: SvgPicture.asset('assets/icons/delete.svg')),
                ),

              const Spacer(),

              // ── Bottom action bar ──
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
      // Host: Start now | Remind me | Share
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: hasTimeElapsed
                  ? () {
                      context.read<ComboBloc>().add(
                            GetComboDetailEvent(widget.comboEntity.combo ?? ''),
                          );
                    }
                  : null,
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
    } else {
      // Spectator: Join now | Vote | Share
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: hasTimeElapsed
                  ? () {
                      context.read<ComboBloc>().add(
                            GetComboDetailEvent(widget.comboEntity.combo ?? ''),
                          );
                    }
                  : null,
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
                      host: widget.comboEntity.host,
                      challenger: null,
                      comboId: widget.comboEntity.combo ?? '',
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
}
