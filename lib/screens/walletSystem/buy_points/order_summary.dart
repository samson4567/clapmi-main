// order_summary.dart
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/wallet/data/models/asset_balance.dart';
import 'package:clapmi/features/wallet/data/models/paywith_transfer_enity.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/features/wallet/domain/entities/swap_entity.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/CustomImageViewer.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/walletSystem/receive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({
    super.key,
    required this.amount,
    required this.coin,
    required this.paymentMethod,
    // required this.payAssets,
  });

  final double amount;
  final int coin;
  final String paymentMethod;
  // final AssetModel payAssets;

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  bool isLoading = false;
  AssetModel? payAssets;

  void _handleBuyPoints(BuildContext context) {
    if (widget.amount < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount of at least 3')),
      );
      return;
    }

    // Set loading state when starting the transaction
    setState(() {
      isLoading = true;
    });

    // Bank transfer: unchanged
    if (widget.paymentMethod == 'bank_transfer') {
      final request = GetQuoteRequestModelDeposit(
        amount: widget.amount.toString(),
        bank: "Guaranty Trust Bank",
        accountName: "TAIWO DANIEL SEYI",
        accountNumber: "0633211331",
        amountNGN: '3',
      );

      context.read<WalletBloc>().add(GetQuoteEventDposit(request: request));
      return;
    }

    if (widget.paymentMethod == 'usdc' || widget.paymentMethod == 'usdt') {
      final toID = context.read<WalletBloc>().assetBalances.firstWhere((item) {
        return item.name == 'CAPP';
      }).id;
      final fromID =
          context.read<WalletBloc>().assetBalances.firstWhere((item) {
        return item.name == widget.paymentMethod.toUpperCase();
      }).id;
      print("amount in String ${widget.amount.toString()}");
      final swapEntity = SwapEntity(
        from: fromID,
        to: toID,
        amount: widget.amount.toString(),
      );

      context.read<WalletBloc>().add(SwapEvent(swapCoinEntity: swapEntity));
      return;
    }

    if (widget.paymentMethod == 'stripe') {
      context
          .read<WalletBloc>()
          .add(StripeCheckoutEvent(amount: widget.amount.toString()));
      return;
    }

    // Fallback: do nothing or show message
    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unsupported payment method')),
    );
  }

  Future<void> _showSwapSuccessDialog(int clapPoints) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Close Button (Top-Right)
              Positioned(
                right: 12,
                top: 12,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              // Main Dialog UI
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amberAccent.withOpacity(0.6),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/coin.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      ' CAPP Coin Purchased ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go(MyAppRouteConstant.walletGeneralPage);
                          context.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WalletBloc, WalletState>(
          listener: (context, state) {
            // Handle loading states
            if (state is WalletLoading) {
              setState(() => isLoading = true);
            } else if (state is WalletError ||
                state is QuoteRetrievedDeposit ||
                state is CheckOut) {
              setState(() => isLoading = false);
            }

            if (state is WalletError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'An error occurred')),
              );
            }

            if (state is QuoteRetrievedDeposit) {
              context.pushNamed(
                MyAppRouteConstant.paywithTransfer,
                extra: state.quoteInfo,
              );
            }

            if (state is CheckOut) {
              context.pushNamed(MyAppRouteConstant.googleWebview, extra: {
                'webview_link': state.checkoutEntity.$1,
                'coins': widget.coin.toString(),
              });
            }

            if (state is StripeCheckoutSuccess) {
              final checkoutUrl = state.checkoutData['checkout_url'];
              if (checkoutUrl != null) {
                context.pushNamed(MyAppRouteConstant.googleWebview, extra: {
                  'webview_link': checkoutUrl,
                  'coins': widget.coin.toString(),
                });
                // Reset loading state after navigating to webview
                setState(() => isLoading = false);
              } else {
                setState(() => isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to get checkout URL')),
                );
              }
            }
          },
        ),
        BlocListener<WalletBloc, WalletState>(
          listener: (context, state) async {
            if (state is SwapLoadingState) {
              setState(() => isLoading = true);
            } else if (state is SwapSuccessState || state is SwapErrorState) {
              setState(() => isLoading = false);
            }

            if (state is SwapSuccessState) {
              final points = int.tryParse(state.swapModels) ?? 0;
              await _showSwapSuccessDialog(points);
            }

            if (state is SwapErrorState) {
              // Show error dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B0B0B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),

                              // Red badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2B0008),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.redAccent),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.error_outline,
                                        color: Colors.redAccent, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      "Insufficient balance",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Message
                              Text(
                                "You do not have enough balance to purchase this amount of points. "
                                "Please add more balance to your wallet.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Fund wallet button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // Show fund wallet dialog
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (_) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: const EdgeInsets.all(16),
                                        child: Receive(
                                          onPress: () {},
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A66C2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    "Fund Wallet",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Close Icon
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Gap(MediaQuery.paddingOf(context).top + 16),
                  Row(
                    children: [
                      InkWell(
                        onTap: isLoading
                            ? null
                            : () {
                                if (Navigator.canPop(context)) {
                                  context.pop();
                                }
                              },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                          color: isLoading ? Colors.grey : null,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        'Order summary',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  const Gap(10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Row(
                      children: [
                        profileModelG?.myAvatar != null
                            ? Container(
                                height: 40.w,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        MemoryImage(profileModelG!.myAvatar!),
                                  ),
                                ),
                              )
                            : CustomImageView(
                                height: 35.w,
                                width: 35.w,
                                radius: BorderRadius.circular(25),
                                imagePath: profileModelG?.image ?? '',
                              ),
                        const Gap(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileModelG?.name ??
                                  profileModelG?.username ??
                                  '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 13,
                                    color: const Color(0xFF8F9090),
                                  ),
                            ),
                            const Gap(8),
                            Row(
                              children: [
                                // show corresponding icon depending on paymentMethod
                                if (widget.paymentMethod == 'usdt')
                                  SvgPicture.asset('assets/icons/usdt.svg',
                                      width: 24, height: 24)
                                else if (widget.paymentMethod == 'usdc')
                                  Image.asset('assets/images/usdc.png',
                                      width: 24, height: 24)
                                else
                                  SvgPicture.asset('assets/icons/usdt.svg',
                                      width: 24, height: 24),
                                const Gap(8),
                                Text(
                                  '${widget.amount}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const Gap(8),
                            Text(
                              '\$ ${widget.amount.toStringAsFixed(2)} USD',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 13,
                                    color: const Color(0xFF8F9090),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(21),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: AppColors.greyTextColorVariant,
                                  ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    if (widget.paymentMethod == 'usdt')
                                      SvgPicture.asset('assets/icons/usdt.svg',
                                          width: 24, height: 24)
                                    else if (widget.paymentMethod == 'usdc')
                                      Image.asset('assets/images/usdc.png',
                                          width: 24, height: 24)
                                    else
                                      SvgPicture.asset('assets/icons/usdt.svg',
                                          width: 24, height: 24),
                                    const Gap(8),
                                    Text(
                                      '${widget.amount}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                  ],
                                ),
                                const Gap(8),
                                Text(
                                  '\$ ${widget.amount.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 13,
                                        color: AppColors.greyTextColorVariant,
                                      ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Gap(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Clap Point',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: AppColors.greyTextColorVariant,
                                  ),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/coin_big.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const Gap(8),
                                Text(
                                  '${widget.coin}',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(21),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'By tapping ',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFFB4B4B4),
                                    fontSize: 14,
                                  ),
                        ),
                        TextSpan(
                          text: 'Buy Points',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                        ),
                        TextSpan(
                          text: ', you agree to the ',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFFB4B4B4),
                                    fontSize: 14,
                                  ),
                        ),
                        TextSpan(
                          text: 'Terms of Purchase for Coins',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF7AA6CB),
                                    fontSize: 14,
                                  ),
                        ),
                        TextSpan(
                          text:
                              '. Coins can be used to access exclusive features and benefits, and all transactions are final once completed.',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFFB4B4B4),
                                    fontSize: 14,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 19,
                                      color: AppColors.greyTextColorVariant,
                                    ),
                          ),
                          Text(
                            ' : \$${widget.amount}',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap:
                            isLoading ? null : () => _handleBuyPoints(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: isLoading
                                ? AppColors.primaryColor.withOpacity(0.6)
                                : AppColors.primaryColor,
                          ),
                          child: isLoading
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Gap(8),
                                    Text(
                                      'Processing...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                                  ],
                                )
                              : Text(
                                  'Buy points',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                ],
              ),
            ),
            // Optional: Full-screen overlay when loading
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
