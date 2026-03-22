import 'package:clapmi/core/utils.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SendChallengeRequest extends StatefulWidget {
  final String bragID;
  final LiveComboEntity conboInfomation;
  final LiveGifter? liveChallenger;

  const SendChallengeRequest(
      {super.key,
      required this.bragID,
      required this.conboInfomation,
      required this.liveChallenger});

  @override
  State<SendChallengeRequest> createState() => _SendChallengeRequestState();
}

class _SendChallengeRequestState extends State<SendChallengeRequest> {
  String challengeID = '';
  String? errorMessage;
  String? bragRequestErrorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BragBloc, BragState>(
      listener: (context, state) {
        if (state is SingleLiveStreamChallengeLoadingState) {
          print("🔵 Challenge Request Loading...");
        }

        if (state is SingleLiveStreamChallengeSuccessState) {
          print("🟢 Challenge Created ID: ${state.challengeId}");
          Navigator.pop(context);
          challengeID = state.challengeId!;

          /// Then open bottom sheet
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            builder: (ctx) {
              return BlocConsumer<PostBloc, PostState>(
                listener: (context, state) {
                  if (state is SingleCreateComboErrorState) {
                    if (mounted) {
                      setState(() {
                        errorMessage = state.errorMessage;
                      });
                    }
                    print(
                        "**********&&&&&&&&%%%%%%@@@@@@@@@@%This is the error state ${state.errorMessage}");
                    showTopSnackBar(context, state.errorMessage, isError: true);
                  }
                  if (state is SingleCreateComboSuccessState) {
                    Navigator.pop(context);
                    // close EnterPoint modal first

                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => RequestSent(
                        userImage:
                            widget.conboInfomation.challenger?.profile ?? '',
                        hostImage: widget.conboInfomation.host?.profile ?? '',
                      ),
                    );
                  }

                  //  else if (state is SingleCreateComboErrorState) {
                  //   print(
                  //       "**********&&&&&&&&%%%%%%@@@@@@@@@@%This is the error state ${state.errorMessage}");
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text(state.errorMessage),
                  //       backgroundColor: Colors.red,
                  //     ),
                  //   );
                  // }
                },
                builder: (context, state) {
                  final isLoading = state is SingleCreateComboLoadingState;

                  return EnterPointoChallengeHost(
                    errorMessage: errorMessage,
                    challengeID: challengeID,
                    onBuyPoints: () {},
                    onDone: (stake, boost, duration) {
                      context.read<PostBloc>().add(
                            SingleCreateComboEvent(
                              singlecomboModel: SingleLiveCreateModel(
                                stake: stake.toString(),
                                duration: duration,
                                type: "multiple",
                                challenge: challengeID,
                                contextType: 'live',
                                boostPoints:
                                    '$boost', // Include challenge ID here
                              ),
                            ),
                          );
                    },
                    isLoading: isLoading, // 👈 NEW
                  );
                },
              );
            },
          );
        }

        if (state is SingleLiveStreamChallengeErrorState) {
          bragRequestErrorMessage = state.errorMessage;
          print("🔴 Challenge Error: ${state.errorMessage}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AVATARS + GLOVES
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.conboInfomation.host?.avatarConvert != null
                      ? Container(
                          width: 34.w,
                          height: 34.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  image: MemoryImage(widget
                                      .conboInfomation.host!.avatarConvert!))),
                        )
                      : CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.redAccent,
                          child: CircleAvatar(
                            radius: 33,
                            backgroundImage: NetworkImage(
                                widget.conboInfomation.host?.avatar ?? ''),
                          ),
                        ),
                  const SizedBox(width: 16),
                  Image.asset('assets/images/lil.png'),
                  const SizedBox(width: 6),
                  const Text("·",
                      style: TextStyle(color: Colors.blue, fontSize: 30)),
                  const SizedBox(width: 6),
                  Image.asset('assets/images/blue.png'),
                  widget.conboInfomation.onGoingCombo?.challenger
                              ?.avatarConvert !=
                          null
                      ? Container(
                          width: 34.w,
                          height: 34.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  image: MemoryImage(widget
                                      .conboInfomation
                                      .onGoingCombo!
                                      .challenger!
                                      .avatarConvert!))),
                        )
                      : widget.conboInfomation.challenger?.avatarConvert != null
                          ? Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                      image: MemoryImage(widget.conboInfomation
                                          .challenger!.avatarConvert!))),
                            )
                          : widget.liveChallenger?.avatar != null
                              ? Container(
                                  width: 34.w,
                                  height: 34.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                          image: MemoryImage(
                                              widget.liveChallenger!.avatar!))),
                                )
                              : CircleAvatar(
                                  radius: 34,
                                  backgroundColor: Colors.redAccent,
                                  child: CircleAvatar(
                                    radius: 33,
                                    backgroundImage: NetworkImage(widget
                                            .conboInfomation
                                            .challenger
                                            ?.avatar ??
                                        widget.conboInfomation.onGoingCombo
                                            ?.challenger?.avatar ??
                                        widget.liveChallenger?.image ??
                                        ''),
                                  ),
                                ),
                  const SizedBox(width: 16),
                ],
              ),

              const SizedBox(height: 32),
              if (bragRequestErrorMessage != null)
                Text(
                  bragRequestErrorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),

              const Text(
                "Send challenge request",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Clapmi challenges rewards both you and the host during "
                "the live stream",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: () {
                  /// 🚀 Dispatch the API call here with bragID
                  context.read<BragBloc>().add(
                        SingleLiveStreamChallengeEvent(
                          bragID: widget.bragID,
                        ),
                      );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C3B82),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: state is SingleLiveStreamChallengeLoadingState
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Request",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RequestSent extends StatelessWidget {
  final String userImage;
  final String hostImage;

  const RequestSent({
    super.key,
    required this.userImage,
    required this.hostImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AVATARS + GLOVES
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/images/person1.png'),
              SvgPicture.network(userImage),
              const SizedBox(width: 16),
              Image.asset('assets/images/lil.png'),
              const SizedBox(width: 6),
              const Text(
                "·",
                style: TextStyle(color: Colors.blue, fontSize: 30),
              ),
              const SizedBox(width: 6),
              Image.asset('assets/images/blue.png'),
              const SizedBox(width: 16),
              // Image.asset('assets/images/person2.png'),
              SvgPicture.network(hostImage)
            ],
          ),

          const SizedBox(height: 32),

          // TITLE
          const Text(
            "Request Sent",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          // SUBTEXT
          const Text(
            "Your challenge request has been sent to the host.\nPlease wait for a response.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 40),

          // DONE BUTTON
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF0C3B82),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EnterPointoChallengeHost extends StatefulWidget {
  final VoidCallback onBuyPoints;
  final String challengeID;
  final Function(int stake, int boost, String duration) onDone;
  final String? errorMessage;
  const EnterPointoChallengeHost({
    super.key,
    required this.onBuyPoints,
    required this.onDone,
    required bool isLoading,
    required this.challengeID,
    required this.errorMessage,
  });

  @override
  State<EnterPointoChallengeHost> createState() =>
      _EnterPointoChallengeHostState();
}

class _EnterPointoChallengeHostState extends State<EnterPointoChallengeHost> {
  final TextEditingController stakeController = TextEditingController();
  int boostValue = 0;
  String selectedDuration = "";
  String currentAmount = '0.00';

  bool get isValid =>
      stakeController.text.isNotEmpty &&
      int.tryParse(stakeController.text) != null &&
      selectedDuration.isNotEmpty;

  @override
  void initState() {
    context.read<WalletBloc>().add(GetAvailableCoinEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is AvailableClappCoinLoaded) {
          currentAmount = state.amount;
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 15, bottom: 30),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Enter details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.errorMessage != null)
                const SizedBox(
                  height: 10,
                ),
              if (widget.errorMessage != null)
                Text(
                  widget.errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              const SizedBox(height: 20),
              _buildStakeSection(),
              const SizedBox(height: 18),
              _buildBoostSection(),
              const SizedBox(height: 18),
              _buildDurationSection(),
              const SizedBox(height: 26),

              _buildDoneButton(),
            ],
          ),
        );
      },
    );
  }

  // =============================
  // STAKE SECTION
  // =============================

  Widget _buildStakeSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Enter your stake",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Spacer(),
              const Text(
                "Clap Point Balance",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(width: 6),
              Image.asset(
                'assets/images/coin.png',
                height: 30,
                width: 30,
              ),
              Text(
                '${double.tryParse(currentAmount)?.toInt() ?? 0.00}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
              )
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: stakeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 32),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "minimum stake:100 CAPP",
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 15),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              GestureDetector(
                onTap: widget.onBuyPoints,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Text(
                    "Buy Clap Points",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // =============================
  // BOOST SECTION
  // =============================

  Widget _buildBoostSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Boost Challenge (Optional)",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/coin.png',
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      boostValue = int.tryParse(value) ?? 0;
                    });
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: "Enter boost",
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =============================
  // DURATION SECTION
  // =============================

  Widget _buildDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Live Duration",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final options = [
              "10 minutes",
              "15 minutes",
              "60 minutes",
              "2 hours",
              "3 hours",
            ];

            showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF0D0D0D),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(26))),
                builder: (_) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...options.map((e) => ListTile(
                            title: Text(e,
                                style: const TextStyle(color: Colors.white)),
                            onTap: () {
                              setState(() => selectedDuration = e);
                              Navigator.pop(context);
                            },
                          )),
                      const SizedBox(height: 20),
                    ],
                  );
                });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  selectedDuration.isEmpty ? "Select time" : selectedDuration,
                  style: TextStyle(
                    color: selectedDuration.isEmpty
                        ? Colors.white38
                        : Colors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isLoading = false;

  Widget _buildDoneButton() {
    return GestureDetector(
      onTap: (isValid && !_isLoading)
          ? () async {
              setState(() => _isLoading = true);
              final stake = int.parse(stakeController.text);
              await widget.onDone(stake, boostValue, selectedDuration);
              if (mounted) setState(() => _isLoading = false);
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: (isValid && !_isLoading)
              ? const Color(0xFF0C3BFF)
              : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

//
