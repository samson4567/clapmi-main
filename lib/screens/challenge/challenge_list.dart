// ignore_for_file: use_build_context_synchronously
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/challenge_box.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/fancy_text.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/challenge/widgets/Animated/animated.dart';
import 'package:clapmi/screens/challenge/widgets/buildImage2.dart';
import 'package:clapmi/screens/challenge/widgets/challenge_box_rep.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ChallengeListScreen extends StatefulWidget {
  final bool? isComingFromCommboSet;
  const ChallengeListScreen({super.key, this.isComingFromCommboSet = false});

  @override
  State<ChallengeListScreen> createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen> {
  String isDisplayingLive = '';
  List<ComboEntity> displayedListOfLiveCombo = [];
  List<ComboEntity> displayedListOfUpcomingCombo = [];
  List<ComboEntity> goLiveCombo = [];
  String liveComboId = '';
  bool isLoading = false;

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    if (widget.isComingFromCommboSet == true) {
      context.read<ComboBloc>().add(GetUpcomingCombosEvent());
      context.read<ComboBloc>().add(GetLiveCombosEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          children: [
// 👉 Profile Avatar
            GestureDetector(
              child: profileModelG?.myAvatar != null
                  ? Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: MemoryImage(profileModelG!.myAvatar!),
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
                          errorWidget: (context, error, trace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(width: 5.w),
// 👉 LiveUpcoming widget
            Expanded(
              child: LiveUpcoming(
                indexchangingFunction: (v) {
                  isDisplayingLive = v;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: BlocConsumer<ComboBloc, ComboState>(
        listener: (context, state) {
          if (state is GetLiveCombosSuccessState) {
            displayedListOfLiveCombo = state.listOfComboEntity;
          }
          if (state is GetUpcomingCombosSuccessState) {
            displayedListOfUpcomingCombo = state.listOfComboEntity;
          }
          if (state is LiveComboLoaded) {
            isLoading = false;
            context.pop();
            context.pop();
            context.pushReplacementNamed(
                MyAppRouteConstant.liveComboThreeImageScreen,
                extra: {
                  'liveCombo': state.liveCombo,
                  'comboId': liveComboId,
                  'brag': theComboEntity?.brag
                });
          }
          if (state is GetComboDetailSuccessState) {
            if (state.comboEntity.type == "single") {
              theComboEntity = state.comboEntity;
              context
                  .read<ComboBloc>()
                  .add(GetLiveComboEvent(combo: state.comboEntity));
            } else {
              context.pushNamed(MyAppRouteConstant.startOrjoin,
                  extra: state.comboEntity);
            }
          }
          if (state is StartComboSuccessState) {
            //CALL AN EVENT TO GET A SINGLE COMBO HERE
            Future.delayed(Duration(seconds: 5), () {
              context.read<ComboBloc>().add(GetComboDetailEvent(liveComboId));
            });
          }
          if (state is StartComboErrorState) {
            print("This is start combo error state");
          }
        },
        builder: (context, state) {
          if (state is GetCombosLoadingState) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            );
          }
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isDisplayingLive == 'Upcoming'
                    ? displayedListOfUpcomingCombo.isNotEmpty
                        ? Column(
                            children: displayedListOfUpcomingCombo
                                .map(
                                  (comboModel) => GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                        MyAppRouteConstant.startOrjoin,
                                        extra: comboModel,
                                      );
                                    },
                                    child: Buildimage2(comboModel: comboModel),
                                  ),
                                )
                                .toList(),
                          )
                        : buildEmptyWidget("No upcoming combo yet")
                    : isDisplayingLive == 'Live'
                        ? displayedListOfLiveCombo.isNotEmpty
                            ? Column(
                                children: displayedListOfLiveCombo
                                    .map(
                                      (liveCombo) => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            context.read<ComboBloc>().add(
                                                GetComboDetailEvent(
                                                    liveCombo.combo ?? ''));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: getFigmaColor("0D0E0E"),
                                              border: Border.all(
                                                color: getFigmaColor("181919"),
                                              ),
                                            ),
                                            child: (liveCombo.challenger ==
                                                    null)
                                                ? buildSpectatorsCardSingleStream(
                                                    liveCombo)
                                                : _buildChallengeImage(
                                                    liveCombo),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : buildEmptyWidget("No live combo yet")
                        : GestureDetector(
                            onTap: () {
                              _showGoLiveBottomSheet(context, (comboId) {
                                Future.delayed(Duration(seconds: 5), () {
                                  if (comboId.isNotEmpty) {
                                    liveComboId = comboId;
                                    context
                                        .read<ComboBloc>()
                                        .add(StartComboEvent(comboId));
                                  }
                                });
                              }, liveCombos: displayedListOfLiveCombo);
                            },
                            child: SvgPicture.asset(
                              'assets/images/golive.svg',
                              width: 200.w,
                              height: 200.w,
                            ),
                          ),
              ),
            ),
          );
        },
      ),
    );
  }

  ComboEntity? theComboEntity;

  /// Bottom Sheet with reactive button color
  void _showGoLiveBottomSheet(
      BuildContext context, Function(String) onCreateComboCallback,
      {List<ComboEntity>? liveCombos}) {
    String? durationString;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return BlocConsumer<BragBloc, BragState>(
          listener: (context, state) {
            if (state is CreateComboLoadingState) {
              isLoading = true;
            }
            if (state is CreateComboSuccessState) {
              //THIS IS TO START LIVE, SO IT WILL NAVIGATE TO THE
              //LIVE SCREEN AFTER CALLING LIVE HERE
              print(
                  'This is createComboState for single Livestreaming--------- ${state.message}');
              isLoading = false;
              context.pop();

              /// Show Modal Immediately
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (_) => StreamCreatedModal(
                  onPressed: () {
                    onCreateComboCallback(state.message ?? '');
                  },
                ),
              );
            }
            if (state is CreateComboErrorState) {
              print("This is the error state------");
              isLoading = false;
              final liveCombo = liveCombos?.firstWhere(
                  (combo) => combo.host?.profile == profileModelG?.pid);
              context.pop();
              showLiveStreamError(
                context,
                livecombo: liveCombo,
              );
            }
          },
          builder: (context, state) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                void updateState() => setModalState(() {});
                _titleController.addListener(updateState);
                bool isFilled = _titleController.text.isNotEmpty &&
                    durationString?.isNotEmpty == true;
                return Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 25.h,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      // Title
                      Text(
                        "Live Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      // Combo title label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Combo title",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Combo title input
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter Title",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          filled: true,
                          fillColor: const Color(0xFF181818),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Live duration label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Live Duration",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      DropdownButtonHideUnderline(
                          child: DropdownButton2(
                        customButton: FancyContainer(
                          height: 40.h,
                          backgroundColor: getFigmaColor("121212"),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  color: getFigmaColor("5C5D5D"),
                                ),
                                SizedBox(width: 10),
                                FancyText(
                                  durationString ?? "Select time",
                                  textColor: getFigmaColor("5C5D5D"),
                                  size: 16,
                                  weight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                        value: durationString,
                        items: [
                          "15 minutes",
                          "30 minutes",
                          "60 minutes",
                          "2 hours",
                          "3 hours",
                          "6 hours",
                          "12 hours ",
                          "24 hours",
                        ]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          durationString = value;
                          updateState();
                        },
                      )),
                      SizedBox(height: 30.h),
                      // Start live button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: GestureDetector(
                          onTap: isFilled
                              ? () {
                                  CreateComboModel comboModel =
                                      CreateComboModel(
                                    title: _titleController.text.trim(),
                                    duration: durationString,
                                    type: 'single',
                                    contextType: 'standard',
                                  );

                                  context.read<BragBloc>().add(
                                        CreateComboEvent(
                                          comboModel: comboModel,
                                          isSingleLiveStream: true,
                                        ),
                                      );
                                }
                              : null,
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity: isLoading ? 0.5 : 1,
                                    child: SvgPicture.asset(
                                      'assets/images/crete.svg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  if (isLoading)
                                    const SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          //  isLoading
                          //     ? CircularProgressIndicator.adaptive()
                          //     : Opacity(
                          //         opacity: isFilled ? 1 : 0.5,
                          //         child: SvgPicture.asset(
                          //           'assets/images/crete.svg',
                          //           fit: BoxFit.contain,
                          //         ),
                          //       ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// isDisplayingLive
//LIVE COMBO LIST HERE
Widget _buildChallengeImage(ComboEntity comboModel) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF0D0D0F),
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    child: Column(
      children: [
        /// Duration / Timer
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: getFigmaColor(
              "8C0F00",
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            comboModel.duration ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 8),

        /// Battle Area
        SizedBox(
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Background chevron overlays (red & blue)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/Group 48095618.png",
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                    height: 130,
                    width: 130,
                  ),
                  Image.asset(
                    "assets/images/Group 48095616.png",
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                    height: 130,
                    width: 130,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      comboModel.host?.avatarConvert != null
                          ? Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: MemoryImage(
                                      comboModel.host!.avatarConvert!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : CustomImageView(
                              imagePath: comboModel.host?.avatar ?? '',
                              height: 55,
                              width: 55,
                            ),
                      const SizedBox(height: 6),
                      Text(
                        comboModel.host?.username ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 40.w),
                  const VsAnimatedIcon(),
                  SizedBox(width: 40.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      comboModel.challenger?.avatarConvert != null
                          ? Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: MemoryImage(
                                      comboModel.challenger!.avatarConvert!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : CustomImageView(
                              imagePath: comboModel.challenger?.avatar ?? '',
                              height: 55,
                              width: 55,
                            ),
                      const SizedBox(height: 6),
                      Text(
                        comboModel.challenger?.username ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Spectators   ${comboModel.about ?? '15.4k'}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            ThemeButton(
              color: getFigmaColor(
                "8C0F00",
              ),
              radius: 8,
              height: 26,
              width: 55,
              text: "Live",
            ),
          ],
        ),
        const SizedBox(height: 20),

        /// Brag info
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.grey, size: 18),
            SizedBox(width: 6),
            Text(
              "Brag info",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class LiveUpcoming extends StatefulWidget {
  final Function(String) indexchangingFunction;
  const LiveUpcoming({super.key, required this.indexchangingFunction});

  @override
  State<LiveUpcoming> createState() => _LiveUpcomingState();
}

class _LiveUpcomingState extends State<LiveUpcoming> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 54.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: const Color.fromARGB(26, 255, 255, 255), // #FFFFFF1A
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: Colors.black.withAlpha(100),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // GoLive Button
                  InkWell(
                    onTap: () {
                      selectedIndex = 0;
                      widget.indexchangingFunction.call("GoLive");
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: (selectedIndex == 0)
                            ? getFigmaColor('A9132E')
                            : Colors.transparent,
                      ),
                      child: const Text(
                        "GoLive",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Live Button
                  InkWell(
                    onTap: () {
                      selectedIndex = 1;
                      widget.indexchangingFunction.call("Live");
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: (selectedIndex == 1)
                            ? getFigmaColor('A9132E')
                            : Colors.transparent,
                      ),
                      child: const Text(
                        "Live",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Upcoming Button
                  InkWell(
                    onTap: () {
                      selectedIndex = 2;
                      widget.indexchangingFunction.call("Upcoming");
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: (selectedIndex == 2)
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                      child: const Text(
                        "Upcoming",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 38.h,
          width: 38.w,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0XFF3D3D3D)),
            borderRadius: BorderRadius.circular(20),
            color: const Color(0XFF181919),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return const StreamingBenefitsCard(); // your bottom sheet UI
                },
              );
            },
            child: Center(
              child: Image.asset(
                'assets/icons/side.png',
                width: 30.w,
                height: 30.h,
              ),
            ),
          ),
        )
      ],
    );
  }
}

// Helper function (assuming this exists in your code)
Color getFigmaColor(String hex) {
  return Color(int.parse('FF$hex', radix: 16));
}

class AnimatedGradientBorder extends StatefulWidget {
  final ComboEntity comboModel;

  const AnimatedGradientBorder({
    super.key,
    required this.comboModel,
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(); // Makes it loop infinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          // 🔥 OUTER: animated gradient border
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              colors: const [
                Color(0xFF0066FF), // blue
                Color(0xFFFF3D2E), // red
                Color(0xFF0066FF), // blue
                Color(0xFFFF3D2E), // red
              ],
              begin: Alignment(
                -1.0 + (_controller.value * 2),
                -1.0 + (_controller.value * 2),
              ),
              end: Alignment(
                1.0 + (_controller.value * 2),
                1.0 + (_controller.value * 2),
              ),
            ),
          ),
          // 🔥 INNER: solid background
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- TIMER ---
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A1B1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.comboModel.duration ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.comboModel.host?.avatarConvert != null
                        ? Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: MemoryImage(
                                    widget.comboModel.host!.avatarConvert!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : CustomImageView(
                            imagePath: widget.comboModel.host?.avatar ?? '',
                            height: 55,
                            width: 55,
                          ),
                    const SizedBox(height: 6),
                    Text(
                      widget.comboModel.host?.username ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.comboModel.about ?? '15.4k',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/images/frame.svg'),
                    Text(
                      widget.comboModel.status ?? '15.4k',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    SvgPicture.asset('assets/images/Button.svg'),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B1D14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Live",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget buildSpectatorsCardSingleStream(ComboEntity comboModel) {
  return AnimatedGradientBorder(comboModel: comboModel);
}

class StreamCreatedModal extends StatefulWidget {
  final VoidCallback onPressed;
  final bool enabled;

  const StreamCreatedModal({
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  State<StreamCreatedModal> createState() => _StreamCreatedModalState();
}

class _StreamCreatedModalState extends State<StreamCreatedModal>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePressed() {
    if (!widget.enabled || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _animationController.forward();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      height: 215.h,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF000000),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Stream Created",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: _handlePressed,
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Opacity(
                            opacity: _opacityAnimation.value,
                            child: SvgPicture.asset(
                              'assets/images/start2.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                    if (_isLoading)
                      const SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class StreamingBenefitsCard extends StatelessWidget {
  const StreamingBenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * 0.75, // Max 75% of screen
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E4A8A), // darker blue at top
            Color(0xFF0F1419), // very dark blue-black
            Color(0xFF000000), // black at bottom
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background decorative elements (silhouettes)
          Positioned(
            top: -20,
            left: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF2E5A8E).withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: -50,
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A5A).withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                ),
              ),
            ),
          ),
          // Main content with scroll
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag indicator
                  Center(
                    child: Container(
                      width: 120,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Center(
                    child: Text(
                      "Benefits of streaming on clapmi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Numbered list
                  _benefitItem(
                    number: "1.",
                    text: "Streamers gets 80% of all creator earnings",
                  ),
                  const SizedBox(height: 16),
                  _benefitItem(
                    number: "2.",
                    text:
                        "Fans can request to join your stream by\noffering at least \$1 to come on the stream",
                  ),
                  const SizedBox(height: 16),
                  _benefitItem(
                    number: "3.",
                    text:
                        "Host Streamer can accept/decline co stream\nrequest based on amount or  highest bidder",
                  ),
                  const SizedBox(height: 16),
                  _benefitItem(
                    number: "4.",
                    text:
                        "Audience can earn from co-streamers\n(combos) by gifting any creator of their choice,\ncreator with the highest gifts wins and winnings\nare shared between streamer and audience\n(40% to winning streamer) and 50% to winning\ngifters.",
                  ),
                  const SizedBox(height: 16),
                  _benefitItem(
                    number: "5.",
                    text:
                        "Instant payout of earnings on each streams\navailable to creators and audience.",
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _benefitItem({
    required String number,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),

        // 👇 This makes text wrap properly
        Expanded(
          child: Text(
            textAlign: TextAlign.left,
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
