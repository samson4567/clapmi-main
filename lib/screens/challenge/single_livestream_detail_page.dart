// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/challenge_box.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/fancy_text.dart';
import 'package:clapmi/screens/challenge/widgets/gift_live_coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          });
          timer.cancel();
        } else {
          setState(() {
            timerCountdown =
                "${remaining.inHours}hr:${remaining.inMinutes % 60}mins:${remaining.inSeconds % 60}secs";
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
      appBar: AppBar(
        backgroundColor: getFigmaColor('0D0E0E'),
        leading: FancyContainer(
          radius: 40,
          height: 40,
          width: 40,
          child: buildBackArrow(context),
        ),
        title: FancyText(
          widget.comboEntity.about ?? '',
          size: 16,
          rawTextStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: getFigmaColor("0D0E0E"),
      body: BlocListener<ComboBloc, ComboState>(
        listener: (context, state) {
          if (state is GetComboDetailSuccessState) {
            setState(() {
              isLoading = false;
            });
            context.pushNamed(MyAppRouteConstant.startOrjoin,
                extra: state.comboEntity);
          }
          if (state is GetComboDetailLoadingState) {
            setState(() {
              isLoading = true;
            });
          }
        },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                //THE BOX SHOWING THE DETAILS OF THE SINGLE LIVESTREAM
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: getFigmaColor("181919"),
                      border: Border.all(
                        color: getFigmaColor("181919"),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ThemeButton(
                            height: 30,
                            width: 190,
                            radius: 8,
                            color: getFigmaColor("593407"),
                            child: Text(
                              'Starts in $timerCountdown',
                              style: TextStyle(
                                color: getFigmaColor("EDA401"),
                                fontSize: 10,
                                fontFamily: 'Geist',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        // Host avatar and info
                        _buildHostInfo(),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: ThemeButton(
                            height: 24,
                            width: 74,
                            radius: 8,
                            color: getFigmaColor("593407"),
                            child: Text(
                              widget.comboEntity.status ?? '',
                              style: TextStyle(
                                color: getFigmaColor("EDA401"),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Combo details section
                _buildComboDetails(),
                const Spacer(),
                // Buttons based on host/spectator
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHostInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: getFigmaColor("0D0E0E"),
      ),
      child: Row(
        children: [
          // Host avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: widget.comboEntity.host?.avatar != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.comboEntity.host!.avatar!,
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.comboEntity.host?.avatar == null
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
          const SizedBox(width: 16),
          // Host info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.comboEntity.host?.username ?? 'Host',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Host',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.white.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: getFigmaColor("181919"),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.comboEntity.about ?? 'Single Livestream',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Details row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(
                  'Duration', widget.comboEntity.duration ?? 'N/A'),
              _buildDetailItem('Type', widget.comboEntity.type ?? 'single'),
              _buildDetailItem(
                  'Status', widget.comboEntity.status ?? 'UPCOMING'),
            ],
          ),
          const SizedBox(height: 16),
          // Stake info
          if (widget.comboEntity.stake != null && widget.comboEntity.stake! > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: getFigmaColor("0D0E0E"),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stake Amount',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.white.withAlpha(180),
                    ),
                  ),
                  Text(
                    '${widget.comboEntity.stake} CP',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.white.withAlpha(180),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (isHost) {
      // Host sees: Start now button
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            colors: [Color(0xFFE8303A), Color(0xFF1A6BFF)],
          ),
        ),
        child: GestureDetector(
          onTap: () {
            context.read<ComboBloc>().add(
                  GetComboDetailEvent(widget.comboEntity.combo ?? ''),
                );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF111214),
              borderRadius: BorderRadius.circular(40),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const CircularProgressIndicator.adaptive()
                : const Text(
                    'Start now',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      );
    } else {
      // Spectators see: Join now and Vote buttons side by side
      return Row(
        children: [
          // Join now button
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8303A), Color(0xFF1A6BFF)],
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  context.read<ComboBloc>().add(
                        GetComboDetailEvent(widget.comboEntity.combo ?? ''),
                      );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111214),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  alignment: Alignment.center,
                  child: isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text(
                          'Join now',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Vote button
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F6B25), Color(0xFFBCFF59)],
                ),
              ),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111214),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Vote',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
