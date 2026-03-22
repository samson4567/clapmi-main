import 'dart:async';

import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/challenge_box.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/CustomImageViewer.dart';
import 'package:clapmi/screens/challenge/widgets/gift_live_coin.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Buildimage2 extends StatefulWidget {
  const Buildimage2({super.key, required this.comboModel});

  final ComboEntity comboModel;

  @override
  State<Buildimage2> createState() => _Buildimage2State();
}

class _Buildimage2State extends State<Buildimage2> {
  String? countDown = "00hr: 00mins : 00secs";
  Timer? _timer;
  String? durationString;
  String? tempDuration;
  @override
  void initState() {
    _timer = Timer.periodic((Duration(seconds: 1)), (timer) {
      final now = DateTime.now();
      final remainingTime = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(widget.comboModel.start ?? '', true)
          .toLocal()
          .difference(now);
      if (mounted) {
        if (remainingTime.isNegative || remainingTime.inSeconds == 0) {
          setState(() {
            countDown = "00hr : 00mins : 00secs";
          });
          timer.cancel();
        } else {
          setState(() {
            countDown =
                "${remainingTime.inHours}hr: ${remainingTime.inMinutes % 60}mins : ${remainingTime.inSeconds % 60}secs";
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComboBloc, ComboState>(
      listener: (context, state) {
        if (state is SetReminderForComboSuccessState) {
          setState(() {
            durationString = tempDuration;
          });
          Fluttertoast.showToast(
              backgroundColor: Colors.green,
              gravity: ToastGravity.BOTTOM,
              msg: state.message);
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: const Color(0xFF464747)), // 🔹 Added this line
          ),
          child: SizedBox(
            child: Column(
              children: [
                Row(
                  children: [
                    ThemeButton(
                      height: 24,
                      width: 74,
                      radius: 8,
                      color: getFigmaColor("E77D00", 50),
                      child: Text(
                        widget.comboModel.status ?? "",
                        style: TextStyle(
                          color: getFigmaColor("FFB500"),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Starts in:",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: Colors.white.withAlpha(200),
                        fontFamily: 'Geist',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      countDown ?? "",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Geist',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 150,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget.comboModel.host?.avatarConvert != null
                                      ? Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            image: DecorationImage(
                                              image: MemoryImage(widget
                                                  .comboModel
                                                  .host!
                                                  .avatarConvert!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : CustomImageView(
                                          imagePath:
                                              widget.comboModel.host?.avatar,
                                          height: 45,
                                          width: 45,
                                        ),
                                  const SizedBox(height: 5),
                                  Text(widget.comboModel.host?.username ?? '')
                                ],
                              ),
                              const SizedBox(width: 50),
                              const Text(
                                "VS",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(width: 50),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget.comboModel.challenger?.avatarConvert !=
                                          null
                                      ? Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            image: DecorationImage(
                                              image: MemoryImage(widget
                                                  .comboModel
                                                  .challenger!
                                                  .avatarConvert!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : CustomImageView(
                                          imagePath: widget
                                              .comboModel.challenger?.avatar,
                                          height: 45,
                                          width: 45,
                                        ),
                                  const SizedBox(height: 5),
                                  Text(widget.comboModel.challenger?.username ??
                                      '')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              customButton: Container(
                                height: 34,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: getFigmaColor("006FCD")),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  durationString ?? "Remind me",
                                  style: TextStyle(
                                    color: getFigmaColor("006FCD"),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              value: durationString,
                              items: [
                                // "5 minutes",
                                "15 minutes",
                                "30 minutes",
                                "60 minutes",
                                "2 hours",
                                "6 hours"
                              ]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  tempDuration = value;
                                  context.read<ComboBloc>().add(
                                      SetReminderForComboEvent(
                                          comboID:
                                              widget.comboModel.combo ?? '',
                                          time: value ?? ''));
                                });
                              },
                            ),
                          ),
                          if (profileModelG?.pid !=
                                  widget.comboModel.host?.profile &&
                              profileModelG?.pid !=
                                  widget.comboModel.challenger?.profile)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return GiftLiveCoin(
                                          host: widget.comboModel.host,
                                          challenger:
                                              widget.comboModel.challenger,
                                          comboId:
                                              widget.comboModel.combo ?? '',
                                          contextType: 'standard',
                                          onGoingComboId: '',
                                          isLiveOngoing: false,
                                        );
                                      });
                                },
                                child: Container(
                                  height: 34,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: getFigmaColor("4F6B25"),
                                    border: Border.all(
                                        color: getFigmaColor('BCFF59')),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Vote",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.comboModel.challenger?.profile ==
                                  profileModelG?.pid ||
                              widget.comboModel.challenger?.profile ==
                                  profileModelG?.pid)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 34,
                                  width: 100,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 5),
                              Container(
                                height: 34,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white24),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Brag info",
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(180),
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
