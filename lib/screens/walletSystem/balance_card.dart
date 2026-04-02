import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import '../../features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import '../../features/wallet/presentation/blocs/user_bloc/wallet_event.dart';

class BalanceCard extends StatefulWidget {
  final bool isWeb3;
  final String displayBalance;
  final String usdtAmount;
  final Function() connectWalletCallBack;
  final Function() testingCallBack;
  const BalanceCard({
    super.key,
    required this.isWeb3,
    required this.displayBalance,
    required this.usdtAmount,
    required this.connectWalletCallBack,
    required this.testingCallBack,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;
  bool is2faSetUp = false;

  @override
  void initState() {
    super.initState();
    final walletBloc = context.read<WalletBloc>();
    if (walletBloc.walletProperties == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<WalletBloc>().add(const GetWalletPropertiesEvent());
      });
    } else {
      is2faSetUp = walletBloc.walletProperties!.is2faSetUp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletPropertiesLoaded) {
            is2faSetUp = state.walletProperties.is2faSetUp;
            print("🎉 Wallet Properties Loaded!");
            print("   - is2faSetUp: ${state.walletProperties.is2faSetUp}");
            print(
                "   - isEmailVerified: ${state.walletProperties.isEmailVerified}");
            print(
                "   - isWithdrawalPinCreated: ${state.walletProperties.isWithdrawalPinCreated}");
          }
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Total Balance',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'Geist',
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          const Text(
                            'USD',
                            style: TextStyle(
                                color: Color(0XFF8F9090),
                                fontSize: 13,
                                fontFamily: 'Geist',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<WalletBloc, WalletState>(
                                builder: (context, state) {
                                  return Row(
                                    children: [
                                      Text(
                                        _isBalanceVisible
                                            ? widget.displayBalance
                                            : '••••••',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isBalanceVisible =
                                                !_isBalanceVisible;
                                          });
                                        },
                                        child: Icon(
                                          _isBalanceVisible
                                              ? Icons.remove_red_eye
                                              : Icons.visibility_off,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              if (!widget.isWeb3)
                                GestureDetector(
                                  onTap: widget.connectWalletCallBack,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.3),
                                          border: Border.all(
                                              color:
                                                  Colors.blue.withOpacity(0.3)),
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/link.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Connect wallet',
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Wallet Icon
                  Image.asset(
                    'assets/images/coin_pic.png',
                    height: 70,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _walletButton('Buy points', '', Iconsax.shop, Colors.blue,
                      () {
                    context.push(MyAppRouteConstant.buyPointsPage);
                  }),
                  _walletButton(
                      'Gift points',
                      'assets/images/openmoji_coin 1.png',
                      Iconsax.coin,
                      Colors.yellowAccent, () {
                    context.push(
                      MyAppRouteConstant.giftCoin,
                    );
                  }),
                  _walletButton(
                      'Deposit', '', Iconsax.receive_square, Colors.blue, () {
                    context.push(MyAppRouteConstant.receive);
                  }),
                  _walletButton('Withdraw', '', Iconsax.send_2, Colors.blue,
                      () {
                    withdrawalOptions(context);
                  }),
                ],
              ),
            ],
          ),
        ));
  }

  void withdrawalOptions(BuildContext context) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            surfaceTintColor: Colors.grey,
            elevation: 2.5,
            backgroundColor: getFigmaColor("121212"),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Choose Withdrawal Method',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  const Gap(10),
                  // USDT Withdrawal
                  GestureDetector(
                    onTap: () {
                      context.pop(); // Close dialog

                      if (is2faSetUp) {
                        // User has done 2FA before - go straight to withdrawal
                        context.push(MyAppRouteConstant.withdrawal);
                      } else {
                        // First timer - show 2FA verification page
                        context.pushNamed(
                          MyAppRouteConstant.walletEmailVerification,
                          extra: {
                            'isEnterOtp': true,
                            'isFiatWithdrawal': false
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/usdt.svg',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "USDT",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  // Bank Withdrawal
                  GestureDetector(
                    onTap: () {
                      context.pop(); // Close dialog

                      if (is2faSetUp) {
                        // User has done 2FA before - go straight to fiat withdrawal
                        context.push(MyAppRouteConstant.fiatWithdrawal);
                      } else {
                        // First timer - show 2FA verification page
                        context.pushNamed(
                          MyAppRouteConstant.walletEmailVerification,
                          extra: {
                            'isEnterOtp': false,
                            'isFiatWithdrawal': true
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/bank.svg',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "Bank",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  // USDC Withdrawal
                  GestureDetector(
                    onTap: () {
                      context.pop(); // Close dialog

                      if (is2faSetUp) {
                        // User has done 2FA before - go straight to USDC withdrawal
                        context.push(MyAppRouteConstant.usdcWithdrawal);
                      } else {
                        // First timer - show 2FA verification page
                        context.pushNamed(
                          MyAppRouteConstant.walletEmailVerification,
                          extra: {
                            'isEnterOtp': false,
                            'isFiatWithdrawal': false
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/usdc.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "USDC",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _walletButton(String label, String? actionImage, IconData icon,
      Color iconColor, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            border: Border.all(color: getFigmaColor('8F9090')),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (actionImage != null && actionImage.isNotEmpty)
                  Image.asset(
                    actionImage,
                    width: 20,
                    height: 20,
                  )
                else
                  Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
