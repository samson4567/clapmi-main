// buy_points.dart
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BuyPoints extends StatefulWidget {
  const BuyPoints({super.key, required Null Function() onPress});

  @override
  State<BuyPoints> createState() => _BuyPointsState();
}

class _BuyPointsState extends State<BuyPoints> {
  String paymentMethod =
      'Bank Transfer'; // Default changed since debit card disabled
  int selectedPoint = 300;
  late FocusNode _focusNode;
  String currentAmount = '0.00';
  String sendPaymentMethod = 'bank_transfer';
  bool isLoading = false; // Added loading state

  @override
  void initState() {
    // get available coin amount
    context.read<WalletBloc>().add(GetAvailableCoinEvent());
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Method to handle buy points action
  void _handleBuyPoints() async {
    setState(() {
      isLoading = true;
    });

    // Simulate a small delay (optional - remove if not needed)
    await Future.delayed(const Duration(milliseconds: 300));

    // Navigate to order summary
    if (mounted) {
      context.goNamed(
        MyAppRouteConstant.orderSummary,
        extra: {
          'amount': selectedPoint / 100,
          'coin': selectedPoint,
          'paymentMethod': sendPaymentMethod,
        },
      );

      // Reset loading state after navigation
      setState(() {
        isLoading = false;
      });
    }
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
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(MediaQuery.paddingOf(context).top + 16),
                    Row(
                      children: [
                        InkWell(
                          onTap: isLoading ? null : context.pop,
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Buy points',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ],
                    ),
                    const Gap(8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Gap(8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 8),
                              child: Row(
                                children: [
                                  profileModelG?.myAvatar != null
                                      ? Container(
                                          height: 40.w,
                                          width: 40.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: MemoryImage(
                                                      profileModelG!
                                                          .myAvatar!))),
                                        )
                                      : CustomImageView(
                                          height: 35.w,
                                          width: 35.w,
                                          radius: BorderRadius.circular(25),
                                          imagePath: profileModelG?.image ?? '',
                                        ),
                                  const Gap(16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${profileModelG?.name ?? profileModelG?.username}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 13,
                                              color: const Color(0xFF8F9090),
                                            ),
                                      ),
                                      const Gap(8),
                                      Row(children: [
                                        ClipOval(
                                          child: Image.asset(
                                            'assets/images/coin_big.png',
                                            height: 24,
                                            width: 24,
                                          ),
                                        ),
                                        const Gap(2),
                                        Text(
                                          '${double.tryParse(currentAmount)?.toStringAsFixed(2) ?? 0.00}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 23,
                                              ),
                                        ),
                                        Text(
                                          'CAPP',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 23,
                                              ),
                                        )
                                      ]),
                                      const Gap(8),
                                      Text(
                                        '\$ ${(double.tryParse(currentAmount)!.toDouble() / 100).toStringAsFixed(2)} USD',
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
                            const Gap(16),
                            Text(
                              'Select points',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.greyTextColorVariant,
                                  ),
                            ),
                            const Gap(20),
                            Row(
                              children: [
                                _pointWidget(
                                  context,
                                  onTap: () {
                                    if (!isLoading) {
                                      setState(() {
                                        selectedPoint = 300;
                                      });
                                    }
                                  },
                                  point: 300,
                                  amount: 300 / 100,
                                  isSelected: selectedPoint == 300,
                                ),
                                const Gap(12),
                                _pointWidget(
                                  context,
                                  onTap: () {
                                    if (!isLoading) {
                                      setState(() {
                                        selectedPoint = 400;
                                      });
                                    }
                                  },
                                  point: 400,
                                  amount: 400 / 100,
                                  isSelected: selectedPoint == 400,
                                ),
                                const Gap(12),
                                _pointWidget(
                                  context,
                                  onTap: () {
                                    if (!isLoading) {
                                      setState(() {
                                        selectedPoint = 500;
                                      });
                                    }
                                  },
                                  point: 500,
                                  amount: 500 / 100,
                                  isSelected: selectedPoint == 500,
                                ),
                              ],
                            ),
                            const Gap(16),
                            Row(
                              children: [
                                _pointWidget(
                                  context,
                                  onTap: () {
                                    if (!isLoading) {
                                      setState(() {
                                        selectedPoint = 700;
                                      });
                                    }
                                  },
                                  point: 700,
                                  amount: 700 / 100,
                                  isSelected: selectedPoint == 700,
                                ),
                                const Gap(12),
                                _pointWidget(
                                  context,
                                  onTap: () {
                                    if (!isLoading) {
                                      setState(() {
                                        selectedPoint = 1400;
                                      });
                                    }
                                  },
                                  point: 1400,
                                  amount: 1400 / 100,
                                  isSelected: selectedPoint == 1400,
                                ),
                                const Gap(12),
                                _pointWidget(
                                  context,
                                  onTap: () {
                                    if (!isLoading) {
                                      setState(() {
                                        selectedPoint = 3500;
                                      });
                                    }
                                  },
                                  point: 3500,
                                  amount: 3500 / 100,
                                  isSelected: selectedPoint == 3500,
                                ),
                              ],
                            ),
                            const Gap(16),
                            Row(
                              children: [
                                _pointWidget(
                                  context,
                                  onTap: () {
                                    if (!isLoading) {
                                      setState(() {
                                        selectedPoint = 7000;
                                      });
                                    }
                                  },
                                  point: 7000,
                                  amount: 7000 / 100,
                                  isSelected: selectedPoint == 7000,
                                ),
                                const Gap(12),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (!isLoading) {
                                        setState(() {
                                          selectedPoint = 0;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          width: 1.5,
                                          color: selectedPoint == 0
                                              ? AppColors.primaryColor
                                              : const Color(0xFF3D3D3D),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/coin_big.png',
                                                height: 24,
                                                width: 24,
                                              ),
                                              const Gap(8),
                                              Text(
                                                'Custom',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              ),
                                            ],
                                          ),
                                          const Gap(12),
                                          Container(
                                            height: 30,
                                            padding: const EdgeInsets.fromLTRB(
                                                24, 0, 24, 12),
                                            child: TextField(
                                              enabled: !isLoading,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedPoint =
                                                      int.tryParse(value) ?? 0;
                                                });
                                              },
                                              focusNode: _focusNode,
                                              onTapOutside: (_) {
                                                _focusNode.unfocus();
                                              },
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Enter Amount',
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .greyTextColorVariant,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(32),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment method:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.greyTextColorVariant,
                                      ),
                                ),
                                const Gap(16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFF3D3D3D),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor: const Color(0xFF3D3D3D),
                                      value: paymentMethod,
                                      isExpanded: true,
                                      items: [
                                        "Debit Card",
                                        "Bank Transfer",
                                        "USDC Aseets Balance",
                                        "USDT Aseets Balance ",
                                      ].map(
                                        (e) {
                                          final isDisabled = e == "Debit Card";
                                          return DropdownMenuItem<String>(
                                            enabled: !isDisabled && !isLoading,
                                            value: e,
                                            child: Opacity(
                                              opacity: isDisabled ? 0.4 : 1,
                                              child: Row(
                                                children: [
                                                  if (e == 'Debit Card')
                                                    SvgPicture.asset(
                                                      'assets/icons/card.svg',
                                                      height: 24,
                                                      width: 24,
                                                    )
                                                  else if (e == 'Bank Transfer')
                                                    SvgPicture.asset(
                                                      'assets/icons/bank.svg',
                                                      height: 24,
                                                      width: 24,
                                                    )
                                                  else if (e ==
                                                      'USDC Aseets Balance')
                                                    Image.asset(
                                                      'assets/images/usdc.png',
                                                      height: 24,
                                                      width: 24,
                                                    )
                                                  else if (e ==
                                                      'USDT Aseets Balance ')
                                                    SvgPicture.asset(
                                                      'assets/icons/usdt.svg',
                                                      height: 24,
                                                      width: 24,
                                                    ),
                                                  const Gap(4),
                                                  Text(
                                                    e,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: isLoading
                                          ? null
                                          : (val) {
                                              if (val == null ||
                                                  val == 'Debit Card') {
                                                // Prevent selection of disabled option
                                                return;
                                              }
                                              setState(() {
                                                paymentMethod = val;
                                                if (val == 'Bank Transfer') {
                                                  sendPaymentMethod =
                                                      'bank_transfer';
                                                } else if (val ==
                                                    'USDC Aseets Balance') {
                                                  sendPaymentMethod = 'usdc';
                                                } else if (val ==
                                                    'USDT Aseets Balance ') {
                                                  sendPaymentMethod = 'usdt';
                                                }
                                              });
                                            },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Gap(32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Text(
                                    'Total',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontSize: 19,
                                          color: AppColors.greyTextColorVariant,
                                        ),
                                  ),
                                  Text(
                                    ' : \$${selectedPoint / 100}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ]),
                                InkWell(
                                  onTap: isLoading ? null : _handleBuyPoints,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      color: isLoading
                                          ? AppColors.primaryColor
                                              .withOpacity(0.6)
                                          : AppColors.primaryColor,
                                    ),
                                    child: isLoading
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                  ),
                                )
                              ],
                            ),
                            const Gap(30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Full screen loading overlay (optional - use if you want to block entire screen)
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
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

  Widget _pointWidget(
    BuildContext context, {
    int point = 0,
    double amount = 0,
    bool isSelected = false,
    required Function() onTap,
  }) =>
      Expanded(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1.5,
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFF3D3D3D),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/coin_big.png',
                      height: 24,
                      width: 24,
                    ),
                    const Gap(8),
                    Text(
                      point.toString(),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                const Gap(12),
                Text(
                  '\$$amount USD',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 13,
                        color: const Color(0xFF8F9090),
                      ),
                ),
              ],
            ),
          ),
        ),
      );
}
