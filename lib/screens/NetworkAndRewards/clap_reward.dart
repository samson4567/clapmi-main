import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:clapmi/core/api/multi_env.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/rewards/domain/repositories/entity.dart';
import 'package:clapmi/features/rewards/presentation/blocs/reward_bloc.dart';
import 'package:clapmi/features/rewards/presentation/blocs/reward_event.dart';
import 'package:clapmi/features/rewards/presentation/blocs/reward_state.dart';
import 'package:clapmi/features/rewards/data/models/reward_history_item.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/feed/widget/count_down_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ClapReward extends StatefulWidget {
  const ClapReward({super.key});

  @override
  State<ClapReward> createState() => ClapRewardState();
}

class ClapRewardState extends State<ClapReward> {
  bool levelOneOpened = false;
  bool levelTwoOpened = false;
  bool levelThreeOpened = false;
  bool levelFourOpened = false;
  bool claimReady = false;
  // bool noReward = false;
  int balanceText = 0;
  int referralCount = 0;
  List<RewardHistoryItem> rewardhistory = [];
  List<RewardHistoryEntity> rewardList = [];
  int total = 0;
  String nextClaim = '';
  String qrCode = '';
  late Timer _timer;
  Duration remainingTime = Duration.zero;
  List<String> rewardStatusUndone = [];

  @override
  void initState() {
    super.initState();
    context.read<RewardBloc>().add(RewardHistoryEvent(rewardmodel: null));
    context.read<RewardBloc>().add(RewardBalanceEvent());
    context.read<RewardBloc>().add(ClaimReferralRewardEvent());
    context.read<RewardBloc>().add(LeaderboardEvent());
    context.read<RewardBloc>().add(ReferrerQrCodeEvent());
    context.read<RewardBloc>().add(GetReferralCountEvent());
    context.read<RewardBloc>().add(GetRewardStatusEvent());
    // startCountdownIfNeeded();
  }

  bool canShowCountdiwn = false;
  int _remaininngTime = 1000;
  getLatestRewardAndGetItsTimeThenCalculateTheRemainingTime() {
    try {
      RewardHistoryEntity lastDailyClaimReward = rewardList
          .where(
            (element) => element.type == "daily-claim",
          )
          .last;

      final dateOfClaim = lastDailyClaimReward.createdAt;
      final remainingTimeInSeconds =
          dateOfClaim!.difference(DateTime.now()).inSeconds;
      if (DateTime.now().isBefore(dateOfClaim)) {
        throw "";
      }

      return remainingTimeInSeconds;
    } catch (e) {
      canShowCountdiwn = false;
      claimReady = true;
      return 1000;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070707),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF006FCD),
                        Color(0xFF070707),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gap(MediaQuery.paddingOf(context).top + 16),
                      Image.asset('assets/images/clap.png'),
                      const Gap(20),
                      Text(
                        '\$CLAP',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 31,
                                ),
                      ),
                    ],
                  ),
                ),

                /// 👇 ICON STACKED ON TOP
                Positioned(
                  top: 30.h,
                  left: 10.h,
                  child: TextButton(
                      onPressed: () {
                        context.go(MyAppRouteConstant.feedScreen);
                      },
                      child: Icon(Icons.arrow_back_ios,
                          size: 30, color: Colors.white)),
                ),
              ],
            ),
            const Gap(20),
            Text(
              'Clap Airdrop Is Live',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
            ),
            const Gap(20),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: AppColors.primaryColor,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80006FCD),
                    offset: Offset(0, 4),
                    blurRadius: 40,
                  ),
                  BoxShadow(
                    color: Color(0x80006FCD),
                    offset: Offset(0, -4),
                    blurRadius: 40,
                  ),
                ],
              ),
              child: Text(
                'Claim Airdrop',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Gap(30),
            Text(
              'Coming Soon!',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
            ),
            const Gap(30),
            //* Daily Bonus
            BlocConsumer<RewardBloc, RewardState>(listener: (context, state) {
              if (state is ClaimDailyRewardErrorState) {
                claimReady = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
              if (state is ClaimDailyRewardSuccessState) {
                nextClaim = state.nextClaim;
                claimReady = false;
                canShowCountdiwn = true;
                context.read<RewardBloc>().add(RewardBalanceEvent());
              }

              if (state is RewardBalanceSuccessState) {
                setState(() {
                  balanceText = state.response.data.balance;
                });
              }
              if (state is RewardBalanceErrorState) {}
              if (state is RewardHistorySuccessState) {
                rewardList = state.rewardModel;
                canShowCountdiwn = true;
                _remaininngTime =
                    getLatestRewardAndGetItsTimeThenCalculateTheRemainingTime();

                total = rewardList.fold<int>(
                    0, (sum, item) => sum + (item.clapPoints ?? 0));
              }
              if (state is ReferralCountState) {
                referralCount = state.referralCount;
              }
            }, builder: (context, state) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Claim Daily Bonus in ',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                        ),
                        // Text(
                        //   nextClaim,
                        //   style: Theme.of(context).textTheme.bodyLarge,
                        // ),

                        if (canShowCountdiwn)
                          CountdownTimer(
                            durationInSeconds: _remaininngTime,

                            //1000,
                            onDoneFunction: () {
                              claimReady = true;
                              setState(() {});
                            },
                          )
                        else
                          SizedBox()
                      ],
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Text(
                          'Claim 1 Point',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(),
                        ),
                        const Spacer(),
                        PillButton(
                          backgroundColor:
                              claimReady ? Colors.blue : Colors.lightBlueAccent,
                          onTap: !claimReady
                              ? null // 🔥 disable tap during countdown
                              : () {
                                  context
                                      .read<RewardBloc>()
                                      .add(ClaimDailyRewardEvent());
                                },
                          child: Text(
                            !claimReady ? "Come back later  " : 'Claim point',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const Gap(24),
            const Gap(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Ways To Acquire More \$CLAP',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(16),
            //**  LEVELS LIST */

            BlocConsumer<RewardBloc, RewardState>(
              listener: (BuildContext context, RewardState state) {
                if (state is RewardStatusLoadedState) {
                  rewardStatusUndone = state.incompleteTasks;
                  setState(() {});
                }
              },
              buildWhen: (previous, current) {
                return current is RewardStatusLoadedState ||
                    current is RewardStatusLoadingState ||
                    current is RewardStatusErrorState;
              },
              builder: (context, state) {
                log("The state is ${state.toString()}");
                if (state is RewardStatusLoadingState) {
                  return Skeletonizer(
                      enabled: true,
                      child: Column(children: [
                        //* Level 1
                        LevelsLoading()
                      ]));
                }
                if (state is RewardStatusLoadedState) {
                  return Column(
                    children: [
                      //* Level 1
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF070707),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Level 1',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 20,
                                            ),
                                      ),
                                      const Gap(16),
                                      Row(
                                        children: [
                                          Text(
                                            'Each Task Earns ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize: 10,
                                                ),
                                          ),
                                          Text(
                                            '5 Points',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize: 10,
                                                  color:
                                                      const Color(0xFF006FCD),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(20),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      levelOneOpened = !levelOneOpened;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/${levelOneOpened ? 'arrow-up.svg' : 'arrow-down.svg'}',
                                  ),
                                ),
                              ],
                            ),
                            if (levelOneOpened) ...[
                              const Gap(24),
                              Row(
                                children: [
                                  _taskTile(context,
                                      title: 'Follow our X ',
                                      buttonText: 'Follow our X  ',
                                      isCompleted: !rewardStatusUndone
                                          .map(
                                            (e) => e.toLowerCase(),
                                          )
                                          .any(
                                            (element) => element == 'x',
                                          ), onTap: () async {
                                    await launchUrl(
                                        Uri.parse(MultiEnv().xHandle));
                                  }),
                                  const Gap(12),
                                  _taskTile(context,
                                      title: 'Follow  our IG',
                                      buttonText: 'Follow our IG',
                                      isCompleted: !rewardStatusUndone
                                          .map(
                                            (e) => e.toLowerCase(),
                                          )
                                          .any(
                                            (element) => element == 'instagram',
                                          ), onTap: () async {
                                    await launchUrl(
                                        Uri.parse(MultiEnv().instangramHandle));
                                  }),
                                ],
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  _taskTile(context,
                                      title: 'Follow  our TikTok',
                                      buttonText: 'Follow our TikTok',
                                      isCompleted: !rewardStatusUndone
                                          .map(
                                            (e) => e.toLowerCase(),
                                          )
                                          .any(
                                            (element) => element == 'tiktok',
                                          ), onTap: () async {
                                    await launchUrl(
                                        Uri.parse(MultiEnv().tiktokHandle));
                                  }),
                                  const Gap(12),
                                  const Expanded(child: SizedBox()),
                                  // _taskTile(
                                  //   context,
                                  //   title: 'Complete Your Profile',
                                  //   buttonText: 'Edit Profile',
                                  //   isCompleted: true,
                                  //   onTap: () {
                                  //     context
                                  //         .push(MyAppRouteConstant.editProfile);
                                  //   },
                                  // ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Gap(16),
                      //* Level 2
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF070707),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Level 2',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 20,
                                            ),
                                      ),
                                      const Gap(16),
                                      Row(
                                        children: [
                                          Text(
                                            'Each Task Earns ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize: 10,
                                                ),
                                          ),
                                          Text(
                                            '10 Points',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize: 10,
                                                  color:
                                                      const Color(0xFF006FCD),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(20),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      levelTwoOpened = !levelTwoOpened;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/${levelTwoOpened ? 'arrow-up.svg' : 'arrow-down.svg'}',
                                  ),
                                ),
                              ],
                            ),
                            if (levelTwoOpened) ...[
                              const Gap(24),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    _taskTile(
                                      context,
                                      title: 'Join Discord',
                                      buttonText: 'Join Discord',
                                      isCompleted: state.incompleteTasks
                                              .contains("challenge brag") ==
                                          false,
                                      onTap: () async {
                                        await launchUrl(Uri.parse(
                                            MultiEnv().discordServer));
                                      },
                                    ),
                                    const Gap(12),
                                    _taskTile(context,
                                        title: 'Complete Your Profile',
                                        buttonText: 'Invite 5 friend',
                                        isCompleted: state.incompleteTasks
                                                .contains("referral") ==
                                            false,
                                        statusText: '4 Friends Invited',
                                        onTap: () {
                                      context.pushNamed(
                                          MyAppRouteConstant.account);
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Gap(16),
                      //* Level 3
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF070707),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Level 3',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 20,
                                            ),
                                      ),
                                      const Gap(16),
                                      Row(
                                        children: [
                                          Text(
                                            'Each Task Earns ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize: 10,
                                                ),
                                          ),
                                          Text(
                                            '15 Points',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize: 10,
                                                  color:
                                                      const Color(0xFF006FCD),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(20),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      levelThreeOpened = !levelThreeOpened;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/${levelThreeOpened ? 'arrow-up.svg' : 'arrow-down.svg'}',
                                  ),
                                ),
                              ],
                            ),
                            if (levelThreeOpened) ...[
                              const Gap(24),
                              Row(
                                children: [
                                  _taskTile(context,
                                      title: 'Challenge a Brag',
                                      buttonText: 'Go To Feed',
                                      isCompleted: false, onTap: () {
                                    context
                                        .goNamed(MyAppRouteConstant.feedScreen);
                                  }),
                                  const Gap(12),
                                  _taskTile(context,
                                      title: 'Invite 5 Friends',
                                      buttonText: 'Invite Link',
                                      isCompleted: false, onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            'https://clapmi.com/register?ref=${userModelG?.referralCode}'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        'Invite Link copied',
                                      ),
                                    ));
                                  }),
                                ],
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  _taskTile(
                                    context,
                                    title: 'Post at Least 5 Videos',
                                    buttonText: 'Post Videos',
                                    isCompleted: false,
                                    onTap: () {
                                      context.push(MyAppRouteConstant.newBrag);
                                    },
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      Gap(16),
                      //* Level 4
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF070707),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Level 4',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 20,
                                            ),
                                      ),
                                      const Gap(16),
                                      Row(
                                        children: [
                                          Text(
                                            'Each Task Earns ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize: 10,
                                                ),
                                          ),
                                          Text(
                                            '25 Points',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize: 10,
                                                  color:
                                                      const Color(0xFF006FCD),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(20),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      levelFourOpened = !levelFourOpened;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/${levelFourOpened ? 'arrow-up.svg' : 'arrow-down.svg'}',
                                  ),
                                ),
                              ],
                            ),
                            if (levelFourOpened) ...[
                              const Gap(24),
                              Row(
                                children: [
                                  _taskTile(
                                    context,
                                    title: 'Get 200 Clappers',
                                    buttonText: '200 Clappers',
                                    isCompleted: false,
                                  ),
                                  const Gap(12),
                                  _taskTile(context,
                                      title: 'Invite 25 Friends',
                                      buttonText: 'Invite link',
                                      isCompleted: false, onTap: () {
                                    print('tester');
                                    // tho bei fonde tho bei fonde
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            'https://clapmi.com/register?ref=${userModelG?.referralCode}'));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Invite Link copied',
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  _taskTile(
                                    context,
                                    title: 'Host a Brag',
                                    buttonText: 'Host Brag',
                                    isCompleted: false,
                                    onTap: () {
                                      context.push(MyAppRouteConstant.newBrag);
                                    },
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: Column(
                    children: [
                      Text(
                        'Something went wrong',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Gap(10),
                      ElevatedButton(
                          onPressed: () {
                            context
                                .read<RewardBloc>()
                                .add(GetRewardStatusEvent());
                          },
                          child: Text("Try again."))
                    ],
                  ),
                );
              },
            ),

            const Gap(24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    //* Reward Balance
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.black,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reward balance',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            // Loading Skeleton + Content
                            Skeletonizer(
                              enabled: false,
                              // state is RewardBalanceLoadingState,
                              child: Column(
                                children: [
                                  const Gap(8),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/coin_big.png',
                                        height: 28,
                                        width: 28,
                                      ),
                                      const Gap(4),
                                      Expanded(
                                        child: Text(
                                            '${balanceText.toString()} Clap Points',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0XFF0561CF),
                                            )),
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/danger.svg',
                                        height: 13.33,
                                        width: 13.33,
                                      ),
                                      const Gap(2),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Get a total of',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: const Color(
                                                          0xFF979797),
                                                      fontSize: 10,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: ' 10,000',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize: 10,
                                                    ),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' clap points to be able to withdraw your clap point',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: const Color(
                                                          0xFF979797),
                                                      fontSize: 10,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(8),
                                  //**CLAIM 10K WITHDRAWAL EVENT */
                                  InkWell(
                                    onTap: () {
                                      if (balanceText >= 10000) {
                                        context
                                            .read<RewardBloc>()
                                            .add(WithdrawalEvent());
                                      }
                                    },
                                    child: Container(
                                      height: 44.h,
                                      width: 166.w,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: balanceText < 10000
                                            ? Color(0xFF006FCD).withAlpha(70)
                                            : const Color(0xFF08467B),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Claim Clap Point',
                                          style: TextStyle(
                                              color: balanceText < 10000
                                                  ? Colors.grey
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    //**QR Code */
                    BlocConsumer<RewardBloc, RewardState>(
                        listener: (context, state) {
                      if (state is ReferrerQrCodeErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      }
                      if (state is ReferrerQrCodeSuccessState) {
                        final tempCode = state.qrCode.split(',').last;
                        qrCode = utf8.decode(base64.decode(tempCode));
                      }
                    }, builder: (context, state) {
                      return Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.black,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Referral link',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontSize: 13,
                                          ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      if (qrCode.isNotEmpty)
                                        InkWell(
                                          onTap: () {},
                                          child: SvgPicture.string(
                                            qrCode,
                                            width:
                                                40.0, // Adjust the width as needed
                                            height:
                                                40.0, // Adjust the height as needed
                                            placeholderBuilder: (BuildContext
                                                    context) =>
                                                const CircularProgressIndicator(), // Optional placeholder
                                          ),
                                          //  ),
                                        ),
                                      const Gap(8),
                                      Text(
                                        'Scan QR code',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontSize: 10,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(14),
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    height: 72.h,
                                    color: const Color(0xFF454545),
                                    padding: const EdgeInsets.all(8),
                                    width: 114.w,
                                    child: Center(
                                      child: Text(
                                          'https://clapmi.com/register?ref=${userModelG?.referralCode}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  )),
                                  const Gap(6),
                                  Container(
                                    height: 30.h,
                                    width: 30.w,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF4794FF),
                                          Color(0xFF0561CF),
                                        ],
                                      ),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text:
                                                'https://clapmi.com/register?ref=${userModelG?.referralCode}',
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Copied to clipboard'),
                                          ),
                                        );
                                      },
                                      icon: const Center(
                                        child: Icon(
                                          Icons.copy,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Gap(8),
                              Text(
                                'Referrals: $referralCount users',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const Gap(26),
            //**NEXT WIDGET WIDGET FOR REWARD HISTORIES */
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: AppColors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      // setState(() {
                      //   noReward = !noReward;
                      // });
                    },
                    child: Text(
                      'Rewards History',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const Gap(24),
                  rewardList.isEmpty
                      ? const SizedBox.shrink()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                            columnWidths: const {
                              0: FlexColumnWidth(2.5),
                              1: FlexColumnWidth(1.2),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(2),
                            },
                            children: [
                              // Header Row
                              TableRow(
                                decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(0.15),
                                ),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      "Type",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      "No.",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      "Points",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      "Sub-total",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Data Rows
                              ...rewardList.map(
                                (item) => TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        item.type ?? '',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        item.rewardId?.toString() ?? '0',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        "\$CAP ${item.clapPoints ?? 0}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        "\$CAP ${item.clapPoints ?? 0}", // Adjust if subtotal differs
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Total Row
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                                children: [
                                  const SizedBox(),
                                  const SizedBox(),
                                  const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      "\$CLAP $total",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                  // BlocConsumer<RewardBloc, RewardState>(
                  //   listener: (context, state) {
                  //     if (state is RewardHistorySuccessState) {
                  //       print('This is the reward----');
                  //       rewardList = state.rewardModel;
                  //     }
                  //   },
                  //   builder: (context, state) {
                  //     if (state is RewardHistoryLoadingState) {
                  //       return const Center(
                  //         child: CircularProgressIndicator(color: Colors.white),
                  //       );
                  //     } else if (state is RewardHistorySuccessState) {
                  //       if (rewardList.isEmpty) {
                  //         return EmptyHistoryList();
                  //       } else {
                  //         // Calculate total
                  //         final
                  //         return
                  //       }
                  //     } else if (state is RewardHistoryErrorState) {
                  //       return Center(
                  //         child: Text(
                  //           'Error: ${state.errorMessage}',
                  //           style: const TextStyle(color: Colors.redAccent),
                  //         ),
                  //       );
                  //     } else {
                  //       return const SizedBox();
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
            Gap(MediaQuery.paddingOf(context).bottom + 16),
          ],
        ),
      ),
    );
  }
}

//**LEVEL LOADING WIDGETS IS WORKING HERE */
//** */
//** */
//** */
class LevelsLoading extends StatelessWidget {
  const LevelsLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF070707),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level 1',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Text(
                          'Each Task Earns ',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 10,
                                  ),
                        ),
                        Text(
                          '5 Points',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 10,
                                    color: const Color(0xFF006FCD),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Icon(Icons.keyboard_arrow_down_rounded)
            ],
          ),
          Gap(15),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level 2',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Text(
                          'Each Task Earns ',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 10,
                                  ),
                        ),
                        Text(
                          '5 Points',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 10,
                                    color: const Color(0xFF006FCD),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Icon(Icons.keyboard_arrow_down_rounded)
            ],
          ),
        ],
      ),
    );
  }
}

//**EMPTY HISTORYLIST WIDGET */
class EmptyHistoryList extends StatelessWidget {
  const EmptyHistoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/wallet.svg',
          ),
        ),
        const Gap(32),
        Text(
          'No rewards earned yet. Refer a friend to see your reward',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 16, color: Colors.white.withOpacity(.5)),
        ),
      ],
    );
  }
}

Widget _taskTile(
  BuildContext context, {
  required String title,
  required String buttonText,
  required bool isCompleted,
  String? statusText,
  VoidCallback? onTap,
}) =>
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const Gap(12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: BoxDecoration(
              color: const Color(0xFF002F56),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // GestureDetector(
                //   onTap: onTap, // Optional tap handler
                //child:
                PillButton(
                  width: double.infinity,
                  onTap: onTap,
                  child: Text(
                    buttonText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                        ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
                // ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        statusText != null
                            ? 'Status: $statusText'
                            : 'Status: ${isCompleted ? 'Done' : 'Uncompleted'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 10,
                            ),
                      ),
                    ),
                    if (isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF8ABDE8),
                        size: 16,
                      ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
















 // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 20),
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: AppColors.black,
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: Column(
            //         children: [
            //           Text(
            //             'Your Wallet Address',
            //             style: Theme.of(context).textTheme.displaySmall,
            //           ),
            //           const Gap(16),
            //           Text(
            //             '0xedcuejka9878ED789cveXE0.....',
            //             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            //                   fontSize: 13,
            //                   color: const Color(0xFF8F9090),
            //                 ),
            //           ),
            //         ],
            //       )),
            //       const Gap(20),
            //       PillButton(
            //         child: Row(
            //           children: [
            //             Text(
            //               'Copy address',
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .displaySmall
            //                   ?.copyWith(fontSize: 10),
            //             ),
            //             const Gap(8),
            //             SvgPicture.asset(
            //               'assets/icons/copy.svg',
            //               colorFilter: const ColorFilter.mode(
            //                 Color(0xFF003D71),
            //                 BlendMode.srcIn,
            //               ),
            //               height: 24,
            //               width: 24,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),