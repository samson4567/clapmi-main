import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class AllRecentGifting extends StatelessWidget {
  const AllRecentGifting({super.key});

  num _parseGiftAmount(String? rawAmount) {
    if (rawAmount == null) {
      return 0;
    }
    return num.tryParse(rawAmount.trim()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Gap(MediaQuery.paddingOf(context).top + 16),
            Row(
              children: [
                InkWell(
                  onTap: context.pop,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                  ),
                ),
                const Gap(8),
                Text(
                  'Recent Giftings',
                  style: Theme.of(context).textTheme.displayMedium,
                )
              ],
            ),
            const Gap(10),
            Expanded(
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is RecentGiftingLoadingState) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom + 16),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is RecentGiftingSuccessState) {
                    final giftings = state.recentGiftings;
                    if (giftings.isEmpty) {
                      return const Center(
                          child: Text('No recent giftings found.'));
                    }
                    return ListView.separated(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 16),
                      itemCount: giftings.length,
                      separatorBuilder: (_, __) => const Gap(16),
                      itemBuilder: (context, index) {
                        final gifting = giftings[index];
                        final amount = _parseGiftAmount(gifting.amount);
                        return _singleGiftingWidget(
                          context,
                          outgoing: gifting.gifter == null,
                          dollarAmount: amount,
                          coinAmount: amount,
                          account: gifting.gifter == null
                              ? gifting.receiver?.username ?? ''
                              : gifting.gifter?.username ?? '',
                          userId: gifting.gifter == null
                              ? gifting.receiver?.user ??
                                  gifting.receiverId ??
                                  ''
                              : gifting.gifter?.user ??
                                  gifting.gifterId ??
                                  '',
                          date: gifting.metaData?.date ?? '',
                        );
                      },
                    );
                  } else if (state is RecentGiftingErrorState) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    // Trigger fetching event when the screen loads or state is not yet handled
                    context.read<WalletBloc>().add(const RecentGiftingEvent());
                    return const SizedBox.shrink();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _singleGiftingWidget(
  BuildContext context, {
  bool outgoing = false,
  required num dollarAmount,
  required num coinAmount,
  required String account,
  required String userId,
  required String date,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFF3D3D3D),
            width: .5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: outgoing
                        ? const Color(0xFF4E0703)
                        : const Color(0xFF032F07),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/${outgoing ? 'outgoing' : 'incoming'}.svg',
                    height: 32,
                    width: 32,
                  ),
                ),
                const Gap(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '-\$ ${(dollarAmount / 100).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        Text.rich(
                          overflow: TextOverflow.ellipsis,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Gifted',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.greyTextColorVariant,
                                    ),
                              ),
                              TextSpan(
                                text: ' @$account',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (userId.isEmpty) return;
                                    context.pushNamed(
                                      MyAppRouteConstant.othersAccountPage,
                                      extra: {'userId': userId},
                                    );
                                  },
                              ),
                              TextSpan(
                                text:
                                    ' ${coinAmount % 1 == 0 ? coinAmount.toInt() : coinAmount}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.greyTextColorVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        ClipOval(
                          child: Image.asset(
                            "assets/images/coin_big.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            date,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: 10, color: AppColors.greyTextColorVariant),
          )
        ],
      ),
    );
