// Reference UI image: /mnt/data/Screenshot 2025-11-21 at 14.30.02.png
// NOTE: UI-only changes. Integration, events, and bloc usage are untouched.

// ignore_for_file: deprecated_member_use
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';
import 'package:clapmi/features/combo/domain/entities/challenge_request_entity.dart';
import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/fancy_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../features/brag/presentation/blocs/user_bloc/brag_event.dart';

class StartChallengNowChalengerPage extends StatefulWidget {
  final ChallengeRequestEntity challengeRequestEntity;
  final String? challengeId;

  const StartChallengNowChalengerPage({
    super.key,
    required this.challengeRequestEntity,
    required this.challengeId,
  });

  @override
  State<StartChallengNowChalengerPage> createState() =>
      _StartChallengNowChalengerPageState();
}

class _StartChallengNowChalengerPageState
    extends State<StartChallengNowChalengerPage> {
  final TextEditingController _comboTitleController = TextEditingController();
  final TextEditingController _bettedCOinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? durationString;
  String? startTime;
  String currentAmount = '';
  bool isLoading = false;

  void _showChallengeSentDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: getFigmaColor("121212"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Challenge Sent',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.goNamed(MyAppRouteConstant.feedScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Back to Feed'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    context.read<WalletBloc>().add(GetAvailableCoinEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: buildBackArrow(context),
        title: FancyText(
          "Schedule Brag",
          size: 18,
        ),
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is AvailableClappCoinLoaded) {
            currentAmount = state.amount;
          }
        },
        builder: (context, state) {
          return BlocConsumer<BragBloc, BragState>(
            listener: (context, state) {
              if (state is CreateComboSuccessState) {
                setState(() {
                  isLoading = false;
                });
                _showChallengeSentDialog(context);
              }
              if (state is CreateComboLoadingState) {
                setState(() {
                  isLoading = true;
                });
              }
              if (state is CreateComboErrorState) {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: state.errorMessage['stake'] != null
                        ? Text(state.errorMessage['stake'][0])
                        : state.errorMessage['amount'] != null
                            ? Text(state.errorMessage['amount'][0])
                            : state.errorMessage['password'] != null
                                ? Text(state.errorMessage['password'][0])
                                : Text("Unknown error"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCoinSection(),
                      _buildComboTitle(),
                      _buildStartTime(),
                      _buildLiveDuration(),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _buildPlayersRow(
                            hostName:
                                widget.challengeRequestEntity.hostName ?? '',
                            hostImageAvatar:
                                widget.challengeRequestEntity.hostImageAvatar,
                            challengerImageAvatar: widget
                                .challengeRequestEntity.challengerImageAvatar,
                            hostAvatar:
                                widget.challengeRequestEntity.hostAvatar ?? '',
                            challengerAvatar:
                                widget.challengeRequestEntity.challengerAvatar,
                            challengerName:
                                widget.challengeRequestEntity.challengerName),
                      ),
                      const SizedBox(height: 12),
                      PillButton(
                        onPressed: () {
                          CreateComboModel createCombo = CreateComboModel(
                              title: _comboTitleController.text,
                              stake: _bettedCOinController.text,
                              startTime: startTime,
                              duration: durationString,
                              challenge: widget.challengeId,
                              password: _passwordController.text.trim(),
                              contextType: 'standard',
                              type: 'multiple');
                          context.read<BragBloc>().add(CreateComboEvent(
                              comboModel: createCombo,
                              isSingleLiveStream: false));
                        },
                        backgroundColor:
                            canStart ? null : getFigmaColor("3D3D3D"),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : FancyText(
                                "Done",
                                size: 20,
                                weight: FontWeight.w600,
                                textColor: canStart
                                    ? Colors.white
                                    : getFigmaColor("B4B4B4"),
                              ),
                      )
                    ],
                  ));
            },
          );
        },
      ),
    );
  }

  bool canStart = true;

  Widget _buildPlayersRow({
    required String hostName,
    required String hostAvatar,
    String? challengerName,
    String? challengerAvatar,
    Uint8List? hostImageAvatar,
    Uint8List? challengerImageAvatar,
  }) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPlayerColumn("Host",
              name: hostName, avatar: hostAvatar, imageAvatar: hostImageAvatar),
          FancyText(
            "VS",
            size: 60,
            weight: FontWeight.w600,
          ),
          _buildPlayerColumn("Challenger",
              name: challengerName,
              avatar: challengerAvatar,
              imageAvatar: challengerImageAvatar)
        ],
      ),
    );
  }

  Column _buildPlayerColumn(String title,
      {String? name, String? avatar, Uint8List? imageAvatar}) {
    return Column(
      children: [
        FancyText(
          title,
          textColor: getFigmaColor("5C5D5D"),
          size: 16,
          weight: FontWeight.w600,
        ),
        const SizedBox(height: 10),
        imageAvatar != null
            ? Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(image: MemoryImage(imageAvatar))),
              )
            : FancyContainer(
                backgroundColor: getFigmaColor("3D3D3D"),
                height: 70,
                width: 70,
                radius: 40,
                child: CachedNetworkImage(
                  imageUrl: avatar ?? '',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  errorWidget: (context, error, object) =>
                      const Icon(Icons.error),
                )),
        const SizedBox(height: 10),
        FancyText(
          name ?? 'Default Name',
          size: 16,
          weight: FontWeight.w600,
        ),
      ],
    );
  }

  Column _buildLiveDuration() {
    final options = [
      // "15 minutes",
      // "30 minutes",
      "60 minutes",
      "2 hours",
      "3 hours",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FancyText(
            "Live Duration",
            textColor: getFigmaColor("8F9090"),
            size: 16,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPickerSheet(options, (v) {
            durationString = v;
            setState(() {});
          }),
          child: FancyContainer(
            backgroundColor: getFigmaColor("121212"),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FancyText(
                      durationString ?? "Select time",
                      textColor: getFigmaColor("5C5D5D"),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Column _buildStartTime() {
    final options = [
      // "10 minutes",
      // "20 minutes",
      // "30 minutes",
      "60 minutes",
      "2 hours",
      "6 hours",
      "12 hours",
      "24 hours",
      "2 days",
      "3 days",
      "4 days",
      "5 days",
      "6 days",
      "1 week",
      "2 weeks",
      "3 weeks",
      "1 month",
      "2 months",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FancyText(
            "Start time",
            textColor: getFigmaColor("8F9090"),
            size: 16,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPickerSheet(options, (v) {
            startTime = v;
            setState(() {});
          }),
          child: FancyContainer(
            backgroundColor: getFigmaColor("121212"),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FancyText(
                      startTime ?? "Select time",
                      textColor: getFigmaColor("5C5D5D"),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Column _buildComboTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FancyText(
            "Combo title",
            textColor: getFigmaColor("8F9090"),
            size: 16,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        FancyContainer(
          backgroundColor: getFigmaColor("121212"),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _comboTitleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Title",
                hintStyle: TextStyle(
                  color: getFigmaColor("5C5D5D"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoinSection() {
    return FancyContainer(
      backgroundColor: getFigmaColor("121212"),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FancyText(
                  "Enter your stake",
                  size: 16.h,
                  weight: FontWeight.w600,
                ),
                const Spacer(),
                FancyText(
                  "Clap Point Balance",
                  textColor: getFigmaColor("8F9090"),
                ),
                SizedBox(width: 8.w),
                Image.asset(
                  "assets/icons/commentcoin.png",
                  height: 20.h,
                  width: 20.w,
                ),
                const SizedBox(width: 6),
                Text(
                  "${double.tryParse(currentAmount)?.toStringAsFixed(0)}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      controller: _bettedCOinController,
                      //  keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "0",
                        hintStyle: TextStyle(
                          color: getFigmaColor("5C5D5D"),
                          fontSize: 36,
                        ),
                      ),
                    ),
                  ),
                ),
                FancyContainer(
                  hasBorder: true,
                  action: () {
                    context.pushNamed(MyAppRouteConstant.buyPointPageNew);
                  },
                  borderColor: AppColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 10),
                    child: Text("Buy Clap Points"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showPickerSheet(
      List<String> options, void Function(String) onSelected) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.35,
          minChildSize: 0.2,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: getFigmaColor("0E0E0E"),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 6),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: getFigmaColor("5C5D5D"),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final e = options[index];
                        return ListTile(
                          title: Text(e),
                          onTap: () {
                            onSelected(e);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
