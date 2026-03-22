import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/wallet/domain/entities/bank_details.dart';
import 'package:clapmi/features/wallet/domain/entities/wallet_properties.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/CustomImageViewer.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WithdrawalOrderSummary extends StatefulWidget {
  const WithdrawalOrderSummary({
    super.key,
    required this.orderInfo,
    required this.amount,
  });
  final GetQuoteRequest orderInfo;
  final String amount;

  @override
  State<WithdrawalOrderSummary> createState() => _WithdrawalOrderSummaryState();
}

class _WithdrawalOrderSummaryState extends State<WithdrawalOrderSummary> {
  WalletPropertiesEntity? properties;
  bool isLoading = false;
  bool isCheckoutLoading = false;

  @override
  void initState() {
    context.read<WalletBloc>().add(GetWalletPropertiesEvent());
    super.initState();
  }

  void _handleCheckout() async {
    // Set loading state
    setState(() {
      isCheckoutLoading = true;
    });

    // Small delay for UX (optional)
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      if (properties?.is2faSetUp == true) {
        if (properties?.isEmailVerified == true) {
          if (properties?.isWithdrawalPinCreated == true) {
            // Go to enter pin
            if (mounted) {
              await context.push(MyAppRouteConstant.withdrawalPin, extra: {
                "isEnterPin": true,
                "orderId": widget.orderInfo.id,
              });
            }
          } else {
            // Go to create pin
            if (mounted) {
              await context.push(MyAppRouteConstant.withdrawalPin, extra: {
                "isEnterPin": false,
                "orderId": widget.orderInfo.id,
              });
            }
          }
        } else {
          // Go to where to verify email
          if (mounted) {
            await context.push(MyAppRouteConstant.twoFactorAuth,
                extra: {'orderId': widget.orderInfo.id});
          }
        }
      } else {
        if (mounted) {
          await context.push(MyAppRouteConstant.twoFactorAuth,
              extra: {'orderId': widget.orderInfo.id});
        }
      }
    } finally {
      // Reset loading state
      if (mounted) {
        setState(() {
          isCheckoutLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is WalletPropertiesLoaded) {
            setState(() {
              isLoading = false;
            });
            properties = state.walletProperties;
          } else if (state is WalletError) {
            setState(() {
              isLoading = false;
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Gap(MediaQuery.paddingOf(context).top + 16),
                    Row(
                      children: [
                        InkWell(
                          onTap: (isLoading || isCheckoutLoading)
                              ? null
                              : context.pop,
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                            color: (isLoading || isCheckoutLoading)
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Order summary',
                          style: Theme.of(context).textTheme.displayMedium,
                        )
                      ],
                    ),
                    const Gap(10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 8),
                      child: Row(
                        children: [
                          //**THE SESSION THAT HAS THE PROFILE PICTURES AND THE LIKES */
                          profileModelG?.myAvatar != null
                              ? Container(
                                  height: 40.w,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(
                                              profileModelG!.myAvatar!))),
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
                              //SESSION SHOWING THE USER CAPPCOIN BALANCE
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/usdt.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const Gap(8),
                                  Text(
                                    '${double.tryParse(widget.amount)?.toStringAsFixed(2) ?? 0.00}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Text(
                                '\$ ${(double.tryParse(widget.amount)!.toDouble() / 100).toStringAsFixed(2)} USD',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 13,
                                      color: const Color(0xFF8F9090),
                                    ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Gap(21),
                    //**Order details */
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: getFigmaColor('3D3D3D'),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
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
                                    'NGN ${widget.orderInfo.amountNGN}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Service charge',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: AppColors.greyTextColorVariant,
                                    ),
                              ),
                              Text(
                                'NGN ${widget.orderInfo.transactionFee}',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: AppColors.greyTextColorVariant,
                                    ),
                              ),
                              Text(
                                'NGN ${widget.orderInfo.amountNGN! + widget.orderInfo.transactionFee!}',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    //**Checkout button */
                    GestureDetector(
                      onTap: (isLoading || isCheckoutLoading)
                          ? null
                          : _handleCheckout,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: (isLoading || isCheckoutLoading)
                              ? AppColors.primaryColor.withOpacity(0.6)
                              : AppColors.primaryColor,
                        ),
                        child: Center(
                          child: isCheckoutLoading
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  'Checkout',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                        ),
                      ),
                    ),
                    const Gap(30),
                  ],
                ),
              ),
              // Optional: Full-screen overlay when loading
              if (isCheckoutLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
