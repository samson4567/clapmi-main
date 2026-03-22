import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/wallet/domain/entities/wallet_properties.dart';
import 'package:clapmi/features/wallet/domain/entities/asset_entity.dart';
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

class Withdrawal extends StatefulWidget {
  const Withdrawal({
    super.key,
  });

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  List<WalletAddress> walletAddresses = [];
  String? selectedChain;
  WalletPropertiesEntity? properties;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController walletAddressController = TextEditingController();
  String currentAmount = '0.00';
  bool showInsufficientBalance = false;

  @override
  void initState() {
    context.read<WalletBloc>().add(GetWalletPropertiesEvent());
    context.read<WalletBloc>().add(GetWalletAddressEvent());
    context.read<WalletBloc>().add(LoadWalletBalances());

    // Add listener to amount controller
    amountController.addListener(_checkBalance);

    super.initState();
  }

  @override
  void dispose() {
    amountController.removeListener(_checkBalance);
    amountController.dispose();
    walletAddressController.dispose();
    super.dispose();
  }

  void _checkBalance() {
    final enteredAmount = double.tryParse(amountController.text) ?? 0;
    final balance = double.tryParse(currentAmount) ?? 0;

    setState(() {
      showInsufficientBalance = enteredAmount > 0 && balance == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is WalletAddressLoaded) {
          walletAddresses = state.walletAdrresses;
        }
        if (state is WalletPropertiesLoaded) {
          properties = state.walletProperties;
          print("$properties---------------------------");
        }
        if (state is WalletLoaded) {
          currentAmount = state.balances
              .where(
                (element) {
                  return element.symbol == "USDT";
                },
              )
              .first
              .balance;
          _checkBalance();
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(MediaQuery.paddingOf(context).top + 16),
                Row(
                  children: [
                    // InkWell(
                    //   onTap: context.pop,
                    //   child: const Icon(
                    //     Icons.arrow_back_ios,
                    //     size: 24,
                    //   ),
                    // ),
                    const Gap(8),
                    Text(
                      'Withdraw',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(16),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                                  ), //**THE SESSION THAT HAS THE PROFILE PICTURES AND THE LIKES */
                            const Gap(16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //**USER'S NAME */
                                Text(
                                  profileModelG?.name ?? '',
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
                                    ClipOval(
                                      child: SvgPicture.asset(
                                        'assets/icons/usdt.svg',
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
                                  ],
                                ),
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
                      const Gap(24),
                      Text(
                        'Enter amount you want to withdraw:',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white.withOpacity(.5),
                                ),
                      ),
                      const Gap(32),
                      _customTextfield(context,
                          title: 'USDT', controller: amountController),
                      if (showInsufficientBalance) ...[
                        const Gap(8),
                        Text(
                          'Insufficient balance',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                        ),
                      ],
                      const Gap(24),
                      _customTextfield(context,
                          title: 'Enter wallet address',
                          controller: walletAddressController),
                      const Gap(16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF002F56),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Warning ;\n\nMake sure to confirm your wallet address and the network. If inputed wrongly funds can be lost and there would be no refund .',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                      const Gap(16),
                      Container(
                        width: MediaQuery.of(context).size.width * .6,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF3D3D3D),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            onTap: () {
                              setState(() {});
                            },
                            onChanged: (e) {
                              setState(() {
                                print('This is the selected option $e');
                                selectedChain = e as String;
                              });
                            },
                            hint: Text('Select Network'),
                            items: walletAddresses.map((wallet) {
                              return DropdownMenuItem(
                                value: wallet.type,
                                child: Text(
                                  wallet.type!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: AppColors.greyTextColor),
                                ),
                              );
                            }).toList(),
                            value: selectedChain,
                          ),
                        ),
                      ),
                      const Gap(30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            if (properties?.is2faSetUp == true) {
                              if (properties?.isEmailVerified == true) {
                                if (properties?.isWithdrawalPinCreated ==
                                    true) {
                                  //Go to enter pin
                                  context.push(MyAppRouteConstant.withdrawalPin,
                                      extra: {
                                        "isEnterPin": true,
                                        "amount": amountController.text.trim(),
                                        'network': selectedChain,
                                        'address':
                                            walletAddressController.text.trim(),
                                        'assets': "USDT"
                                      });
                                } else {
                                  //Go to create pin
                                  context.push(MyAppRouteConstant.withdrawalPin,
                                      extra: {
                                        "isEnterPin": false,
                                        "amount": amountController.text.trim(),
                                        'network': selectedChain,
                                        'address':
                                            walletAddressController.text.trim(),
                                        'assets': "USDT"
                                      });
                                }
                              } else {
                                //Go to where to verify email
                                // context
                                //     .read<WalletBloc>()
                                //     .add(Send2FACodeEvent());
                                context.push(MyAppRouteConstant.twoFactorAuth,
                                    extra: {
                                      'amount': amountController.text.trim(),
                                      'network': selectedChain,
                                      'address':
                                          walletAddressController.text.trim(),
                                    });
                              }
                            } else {
                              context.push(MyAppRouteConstant.twoFactorAuth,
                                  extra: {
                                    'amount': amountController.text.trim(),
                                    'network': selectedChain,
                                    'address':
                                        walletAddressController.text.trim(),
                                  });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 140,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: AppColors.primaryColor),
                            child: Text(
                              'Proceed',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                        ),
                      ),
                      const Gap(30),
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _customTextfield(
  BuildContext context, {
  required String title,
  required TextEditingController controller,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.greyTextColorVariant,
              ),
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38),
            color: const Color(0xFF121212),
            border: Border.all(
              color: const Color(0xFF3D3D3D),
            ),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
