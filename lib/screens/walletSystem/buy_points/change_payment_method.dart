import 'package:clapmi/features/wallet/data/models/paywith_transfer_enity.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';

class PaymentWithTransfer extends StatelessWidget {
  final GetQuoteRequestModelDeposit request;

  const PaymentWithTransfer({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final quote = request;
    final amount = quote.amountNGN ?? "0.00";
    final accountNumber = quote.accountNumber ?? "----";
    final bankName = quote.bank ?? "----";
    final beneficiary = quote.accountName ?? "----";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Change payment method",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is VerifyOrderStstus) {
              // Once payment verification is successful
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.zero,
                  child: const VerifyStatusPop(),
                ),
              );
            } else if (state is WalletError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pay with Transfer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF006FCD), width: 1.2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => const ChallengePop(),
                        );
                      },
                      child: const Text(
                        "Cancel Payment",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Instruction Text
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 14.5),
                    children: [
                      const TextSpan(text: "Transfer exactly "),
                      TextSpan(
                        text: "NGN $amount ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const TextSpan(
                          text: "(including the decimal) to the account below"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Warning Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A0000),
                    border: Border.all(color: Colors.redAccent, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.redAccent, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Do NOT transfer more than once to the account below or save it for later use",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Account Info Box
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Account Number", accountNumber,
                          showCopy: true),
                      Divider(
                        color: const Color(0xFF2A2A2A),
                        thickness: 1,
                        height: 42.h,
                      ),
                      _buildDetailRow("Bank Name", bankName),
                      Divider(
                        color: const Color(0xFF2A2A2A),
                        thickness: 1,
                        height: 42.h,
                      ),
                      _buildDetailRow("Beneficiary", beneficiary),
                      Divider(
                        color: const Color(0xFF2A2A2A),
                        thickness: 1,
                        height: 42.h,
                      ),
                      _buildDetailRow("Validity", "15 minutes"),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom Text + Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    children: [
                      Text(
                        "You are paying: NGN $amount",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: state is WalletLoading
                              ? null
                              : () {
                                  final orderId = quote.id ?? "";
                                  if (orderId.isNotEmpty) {
                                    context.read<WalletBloc>().add(
                                        VerifyOrderStutusEvent(
                                            orderId: orderId));
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0055FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
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
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool showCopy = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13.5)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (showCopy) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context as BuildContext).showSnackBar(
                    const SnackBar(content: Text("Copied to clipboard")),
                  );
                },
                child: const Icon(Icons.copy, size: 18, color: Colors.white70),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class ChallengePop extends StatelessWidget {
  const ChallengePop({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 238.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 60.w,
              height: 4.h,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          SizedBox(height: 60.h),
          Text(
            "Cancel Payment",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              "Are you sure you want to cancel payment?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(25.r),
                  color: const Color(0XFF181919),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: GestureDetector(
                  onTap: () {
                    context.go(MyAppRouteConstant.walletGeneralPage);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Payment cancelled")),
                    );
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(25.r),
                  color: const Color(0XFF002F56),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "No",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class VerifyStatusPop extends StatelessWidget {
  const VerifyStatusPop({super.key});

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
