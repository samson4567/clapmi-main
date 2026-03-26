import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/wallet/domain/entities/bank_details.dart';
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

class FiatWithdrawalScreen extends StatefulWidget {
  const FiatWithdrawalScreen({super.key});

  @override
  State<FiatWithdrawalScreen> createState() => _FiatWithdrawalScreenState();
}

class _FiatWithdrawalScreenState extends State<FiatWithdrawalScreen> {
  final TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String currentAmount = '0.00';
  List<AddBankRequest> userbanks = [];
  bool isBankSelected = false;
  int selectedIndex = -1;
  AddBankRequest? selectedBank;
  AddBankRequest? tempBank;
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  bool _pendingProceedAfterKyc = false;

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetAvailableCoinEvent());
    context.read<WalletBloc>().add(GetUserBankAccount());
  }

  void _validateAndProceed() {
    // Prevent multiple rapid taps during loading
    if (isLoading) return;

    if (!_formKey.currentState!.validate()) return;

    if (selectedBank == null) {
      setState(() {
        hasError = true;
        errorMessage = 'Please select a bank account';
      });
      return;
    }

    // Reset states
    setState(() {
      hasError = false;
      errorMessage = '';
      isLoading = true; // Show loading immediately
      _pendingProceedAfterKyc = true;
    });

    // Check KYC first before proceeding
    context.read<WalletBloc>().add(const GetUserKYCStatusEvent());
  }

  void _proceedWithQuote() {
    final request = GetQuoteRequest(
      amount: amountController.text.trim(),
      bankCode: selectedBank?.bankCode ?? '',
      accountName: selectedBank?.accountName ?? '',
      accountNumber: selectedBank?.accountNumber ?? '',
    );
    context.read<WalletBloc>().add(GetQuoteEvent(request: request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        // ── Generic loading ──────────────────────────────────────────────
        if (state is WalletLoading) {
          setState(() => isLoading = true);
        }

        // ── Generic error ────────────────────────────────────────────────
        if (state is WalletError) {
          setState(() {
            isLoading = false;
            hasError = true;
            errorMessage = state.message;
          });
        }

        // ── Available balance ────────────────────────────────────────────
        if (state is AvailableClappCoinLoaded) {
          setState(() {
            currentAmount = state.amount;
            isLoading = false;
          });
        }

        // ── 2FA code sent ────────────────────────────────────────────────
        if (state is FAAuthCodeSent) {
          context.push(MyAppRouteConstant.walletEmailVerification);
        }

        // ── Bank accounts loaded ─────────────────────────────────────────
        if (state is UserBankAccounts) {
          setState(() => userbanks = state.banks);
        }

        // ── KYC status: loading ──────────────────────────────────────────
        if (state is GetUserKYCStatusLoadingState) {
          // Keep loading state - don't override if already loading from user action
          if (!isLoading) {
            setState(() => isLoading = true);
          }
        }

        // ── KYC status: error ────────────────────────────────────────────
        if (state is GetUserKYCStatusErrorState) {
          setState(() {
            isLoading = false;
            _pendingProceedAfterKyc = false;
            hasError = true;
            errorMessage = state.errorMessage;
          });
        }

        // ── KYC status: success ──────────────────────────────────────────
        if (state is GetUserKYCStatusSuccessState && _pendingProceedAfterKyc) {
          setState(() {
            _pendingProceedAfterKyc = false;
            // Don't set isLoading = false here, let the quote request handle it
          });

          final entity = state.theGetUserKycStatusResponseEntity;

          // ✅ isVerified is a bool — compare correctly, NOT to a string
          if (entity.isVerified == true) {
            // Set loading to true for quote request
            setState(() => isLoading = true);
            _proceedWithQuote();
          } else {
            // ❌ Not verified — show KYC modal
            setState(() => isLoading = false);
            KycVerificationModal.show(
              context,
              onStartKyc: () {},
            );
          }
        }

        // ── Quote retrieved — navigate to order summary ──────────────────
        if (state is QuoteRetrieved) {
          setState(() => isLoading = false);
          context.pushNamed(
            MyAppRouteConstant.fiatWithdrawalOrderSummary,
            extra: {
              'amount': currentAmount,
              'orderInfo': state.quoteInfo,
            },
          );
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
                    InkWell(
                      onTap: context.pop,
                      child: const Icon(Icons.arrow_back_ios, size: 24),
                    ),
                    const Gap(8),
                    Text(
                      'Withdraw',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(16),

                            // ── Balance card ───────────────────────────
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                                                  profileModelG!.myAvatar!),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                          Image.asset(
                                            'assets/images/openmoji_coin 1.png',
                                            height: 24,
                                            width: 24,
                                          ),
                                          const Gap(2),
                                          Text(
                                            double.tryParse(currentAmount)
                                                    ?.toStringAsFixed(2) ??
                                                '0.00',
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
                                        '\$ ${((double.tryParse(currentAmount) ?? 0) / 100).toStringAsFixed(2)} USD',
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

                            const Gap(17),
                            Text(
                              'Enter amount you want to withdraw:',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(.5),
                                  ),
                            ),
                            const Gap(8),
                            Text(
                              'Minimum withdrawal amount: 350',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(.7),
                                    fontSize: 12,
                                  ),
                            ),
                            const Gap(24),
                            Form(
                              key: _formKey,
                              child: _customTextfield(
                                context,
                                title: 'Enter Amount',
                                controller: amountController,
                                currentAmount: currentAmount,
                              ),
                            ),
                            const Gap(24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Select account',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final result = await context.pushNamed(
                                        MyAppRouteConstant.searchBank);
                                    if (result != null) {
                                      context
                                          .read<WalletBloc>()
                                          .add(GetUserBankAccount());
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3D3D3D),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Add bank account',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        userbanks.isNotEmpty ? const Gap(10) : const Gap(30),

                        userbanks.isNotEmpty
                            ? Container(
                                constraints: BoxConstraints(
                                  maxHeight: 380.h,
                                  minHeight: 100.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: userbanks.length,
                                  itemBuilder: (context, index) {
                                    final isSelected = selectedIndex == index;
                                    return bankDetailsTile(
                                      userbanks[index],
                                      deleteActtion: () {},
                                      selectBankAction: (bank) {
                                        setState(() {
                                          selectedIndex = index;
                                          selectedBank = bank;
                                          hasError = false;
                                          errorMessage = '';
                                        });
                                      },
                                      isSelect: isSelected,
                                    );
                                  },
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    "No bank accounts added yet",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Gap(10),
                                  GestureDetector(
                                    onTap: () async {
                                      final result = await context.pushNamed(
                                          MyAppRouteConstant.searchBank);
                                      if (result != null) {
                                        context
                                            .read<WalletBloc>()
                                            .add(GetUserBankAccount());
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: getFigmaColor('006FCD'),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        'Add Your First Bank Account',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                        if (userbanks.isEmpty) const Gap(30),

                        // ── Error message ──────────────────────────────
                        if (hasError)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),

                        // ── Proceed button ─────────────────────────────
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0, top: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: isLoading ? null : _validateAndProceed,
                              child: Container(
                                alignment: Alignment.center,
                                width: 140,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: isLoading
                                      ? AppColors.primaryColor
                                          .withOpacity(0.5) // Dim when loading
                                      : AppColors.primaryColor,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          strokeWidth: 2,
                                          backgroundColor: Colors.white,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Proceed',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _customTextfield(
  BuildContext context, {
  required String title,
  required TextEditingController controller,
  required String currentAmount,
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
            border: Border.all(color: const Color(0xFF3D3D3D)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null) return 'Please enter a valid number';
              if (amount < 350) return 'Minimum withdrawal amount is 350';
              final availableAmount = double.tryParse(currentAmount) ?? 0.0;
              if (amount > availableAmount) return 'Insufficient balance';
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Image.asset(
                'assets/images/openmoji_coin 1.png',
                height: 24,
                width: 24,
              ),
              border: InputBorder.none,
              errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ),
      ],
    );

Widget bankDetailsTile(
  AddBankRequest bank, {
  required Function() deleteActtion,
  required Function(AddBankRequest) selectBankAction,
  required bool isSelect,
}) {
  return GestureDetector(
    onTap: () => selectBankAction(bank),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 7),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: isSelect ? getFigmaColor('006FCD') : getFigmaColor('3D3D3D'),
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bank.accountNumber,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.cancel, color: getFigmaColor('5C5D5D')),
              ),
            ],
          ),
          Text(
            bank.accountName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Text(
                bank.bankName,
                style: const TextStyle(
                  fontFamily: 'Geist',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ── KYC Modal ─────────────────────────────────────────────────────────────────

class KycVerificationModal extends StatelessWidget {
  final VoidCallback onStartKyc;

  const KycVerificationModal({
    super.key,
    required this.onStartKyc,
  });

  static void show(BuildContext context, {required VoidCallback onStartKyc}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => KycVerificationModal(onStartKyc: onStartKyc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xFF0C0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),

          SvgPicture.asset(
            'assets/images/kyc.svg',
            height: 120,
          ),
          const SizedBox(height: 28),

          const Text(
            'KYC Verification\nRequired',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'You need to complete KYC verification\nbefore you can withdraw funds.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.pop(); // close modal first
                context.pushNamed(MyAppRouteConstant.kyc);
                onStartKyc();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A84FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Start KYC Verification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
