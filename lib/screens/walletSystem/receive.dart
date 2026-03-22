import 'package:clapmi/features/wallet/domain/entities/asset_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/confirm_address_entity.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class Receive extends StatefulWidget {
  const Receive({super.key, required Null Function() onPress});

  @override
  State<Receive> createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  List<WalletAddress> walletAddress = [];
  List<WalletUSDCAddress> walletAddressUSDC = [];

  String? selectedAsset;

  WalletAddress? selectedChain;
  WalletUSDCAddress? selectedUSDCChain;

  @override
  void initState() {
    context.read<WalletBloc>().add(const GetWalletAddressEvent());
    context.read<WalletBloc>().add(const GetWalletAddressUSDCEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is WalletAddressLoaded) {
          walletAddress = state.walletAdrresses;
        }
        if (state is WalletAddressUSDC) {
          walletAddressUSDC = state.walletAdrressesUSDC;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Gap(MediaQuery.paddingOf(context).top + 16),
                Row(
                  children: [
                    InkWell(
                      onTap: context.pop,
                      child: const Icon(Icons.arrow_back_ios, size: 24),
                    ),
                    const Gap(8),
                    Text('Deposit',
                        style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
                const Gap(8),
                const Divider(color: Color(0xFF3D3D3D)),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D0008),
                    borderRadius: BorderRadius.circular(15.h),
                    border:
                        Border.all(color: const Color(0xFFFF3B5F), width: 2),
                  ),
                  child: const Text(
                    "Ensure you click the button below after depositing to the address below to confirm.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFFF6F8C), fontSize: 16),
                  ),
                ),
                Gap(5.h),
                Row(
                  children: [
                    if (selectedAsset == "USDC")
                      Image.asset("assets/images/usdc.png", height: 30)
                    else
                      SvgPicture.asset('assets/icons/usdt.svg', height: 30),
                    const Gap(10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text("Select Asset"),
                            value: selectedAsset,
                            onChanged: (value) {
                              setState(() {
                                selectedAsset = value;
                                selectedChain = null;
                                selectedUSDCChain = null;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: "USDT",
                                child: Text("USDT"),
                              ),
                              DropdownMenuItem(
                                value: "USDC",
                                child: Text("USDC"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(5.h),
                if (selectedAsset != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        hint: const Text("Select Network"),
                        value: selectedChain ?? selectedUSDCChain,
                        onChanged: (value) {
                          setState(() {
                            if (value is WalletAddress) {
                              selectedChain = value;
                              selectedUSDCChain = null;
                            } else if (value is WalletUSDCAddress) {
                              selectedUSDCChain = value;
                              selectedChain = null;
                            }
                          });
                        },
                        items: selectedAsset == "USDT"
                            ? walletAddress.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text("USDT - ${e.type!}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              color: AppColors.greyTextColor)),
                                );
                              }).toList()
                            : walletAddressUSDC.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text("USDC - Solana",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              color: AppColors.greyTextColor)),
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                Gap(5.h),
                // Now this Column content is scrollable within the parent SingleChildScrollView
                Column(
                  children: [
                    Text(
                      'Scan QR code to paste wallet address:',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 16),
                    ),
                    const Gap(20),
                    Image.asset('assets/images/qrcode.png',
                        height: 200, width: 200),
                    Gap(5.h),
                    Text(
                      'Or',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: const Color(0xFF8F9090)),
                    ),
                    Gap(20.h),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.black,
                        border: Border.all(color: AppColors.greyColor),
                      ),
                      child: Text(
                        selectedChain?.wallet_address ??
                            selectedUSDCChain?.wallet_address ??
                            'Select a network to get a wallet Address',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                fontSize: 16, color: const Color(0xFFE7E7E7)),
                      ),
                    ),
                    Gap(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // 🔥 UPDATED BUTTON BELOW
                        ElevatedButton(
                          onPressed: state is WalletLoading
                              ? null
                              : () {
                                  final selectedWalletAddress =
                                      selectedChain?.wallet_address ??
                                          selectedUSDCChain?.wallet_address;

                                  if (selectedWalletAddress != null &&
                                      selectedWalletAddress.isNotEmpty) {
                                    final request =
                                        ConfirmAddressDepositEntity(
                                            address: selectedWalletAddress);

                                    context.read<WalletBloc>().add(
                                        ConfirmAddressDepositEvent(
                                            request: request));
                                  }

                                  // your original dialog (kept intact)
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.zero,
                                      child: const VerifyStatusPopDeposit(),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0055FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: state is WalletLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "I have transferred",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),

                        GestureRecognizerCopyBuilder(
                          selectedChain: selectedChain,
                          selectedUSDCChain: selectedUSDCChain,
                        ),
                      ],
                    )
                  ],
                ),
                // Add extra bottom padding for comfortable scrolling
                Gap(40.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Helper widget for Copy Button — unchanged logic
class GestureRecognizerCopyBuilder extends StatelessWidget {
  const GestureRecognizerCopyBuilder({
    super.key,
    required this.selectedChain,
    required this.selectedUSDCChain,
  });

  final WalletAddress? selectedChain;
  final WalletUSDCAddress? selectedUSDCChain;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final textToCopy = selectedChain?.wallet_address ??
            selectedUSDCChain?.wallet_address ??
            '';

        if (textToCopy.isNotEmpty) {
          await Clipboard.setData(ClipboardData(text: textToCopy));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to Clipboard!')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/copy.svg'),
            const Gap(4),
            const Text(
              'Copy address',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFE7E7E7),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VerifyStatusPopDeposit extends StatelessWidget {
  const VerifyStatusPopDeposit({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Stack(
          children: [
            /// Close Button — floating on top right
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: Colors.white, size: 22.sp),
              ),
            ),

            /// Actual content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Transfer is being processed, please wait a few moments while we verify your payment. It might take a few minutes.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24.h),
                SvgPicture.asset(
                  'assets/images/pop1.svg',
                  width: 180.w,
                  height: 180.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: 180.w,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                      context.go(MyAppRouteConstant.walletGeneralPage);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      backgroundColor: Color(0xFF2E78FF),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
