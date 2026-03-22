import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/wallet/domain/entities/gift_user.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/screens/walletSystem/gifting/gifting_successful.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiftLiveCoin extends StatefulWidget {
  const GiftLiveCoin({
    super.key,
    required this.challenger,
    required this.host,
    required this.comboId,
    required this.contextType,
    required this.onGoingComboId,
    required this.isLiveOngoing,
    this.liveChallenger,
  });

  final LiveUser? challenger;
  final LiveUser? host;
  final String comboId;
  final String contextType;
  final String onGoingComboId;
  final bool isLiveOngoing;
  final LiveGifter? liveChallenger;

  @override
  State<GiftLiveCoin> createState() => _GiftLiveCoinState();
}

class _GiftLiveCoinState extends State<GiftLiveCoin> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  int? _selectedQuickAmount;
  LiveUser? selectedEntity;
  LiveGifter? selectedLiveEntity;
  String currentAmount = '0.00';
  String? _balanceError;

  final List<int> quickAmounts = [10, 20, 50];

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetAvailableCoinEvent());

    // Listen to text changes for real-time validation
    _amountController.addListener(() {
      final amount = int.tryParse(_amountController.text);
      if (amount != null && amount > 0) {
        setState(() {
          _selectedQuickAmount =
              null; // Clear quick amount selection when typing
        });
        _validateBalance(amount);
      } else if (_amountController.text.isEmpty) {
        setState(() {
          _balanceError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// ✅ REAL-TIME BALANCE VALIDATION
  void _validateBalance(int amount) {
    final availableBalance = double.tryParse(currentAmount) ?? 0.0;

    if (amount < 10) {
      setState(() {
        _balanceError = 'Minimum gift is 10 CAPP';
      });
    } else if (amount > availableBalance) {
      setState(() {
        _balanceError =
            'Insufficient balance. You have ${availableBalance.toStringAsFixed(0)} CAPP';
      });
    } else {
      setState(() {
        _balanceError = null;
      });
    }
  }

  /// ✅ CHECK IF BUTTON SHOULD BE ENABLED
  bool _isGiftButtonEnabled() {
    // Check if user is selected (either selectedEntity or selectedLiveEntity)
    if (selectedEntity == null && selectedLiveEntity == null) return false;

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount == 0) return false;

    if (_balanceError != null) return false;

    return true;
  }

  /// 🎉 SHOW SUCCESS MODAL
  void _showSuccessModal(int giftedAmount, String recipientUsername) {
    Navigator.pop(context); // Close the gift sheet first

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: GiftingSuccessful(
            name: recipientUsername,
            selectedPoint: giftedAmount,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          /// ✅ AVAILABLE COIN LOADED
          if (state is AvailableClappCoinLoaded) {
            setState(() {
              currentAmount = state.amount;
            });
            // Re-validate when balance updates
            final amount = int.tryParse(_amountController.text);
            if (amount != null && amount > 0) {
              _validateBalance(amount);
            }
          }

          /// ❌ ERROR HANDLING
          if (state is GiftUserErrorState) {
            String errorMessage = state.errorMessage;

            /// 🔍 HANDLE INSUFFICIENT BALANCE
            if (errorMessage.toLowerCase().contains('insufficient')) {
              errorMessage =
                  'You don\'t have enough Clapcoins to complete this gift';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(errorMessage),
              ),
            );
          }

          /// ✅ SUCCESS - SHOW SUCCESS MODAL
          if (state is GiftUserSuccessState) {
            final finalAmount = int.tryParse(_amountController.text) ?? 10;
            final recipientUsername = selectedLiveEntity?.username ??
                selectedEntity?.username ??
                'User';

            context.read<ChatsAndSocialsBloc>().add(
                  GiftInComboEvent(
                    username: profileModelG?.username ?? '',
                    comboId: widget.comboId,
                    avatar: profileModelG?.image ?? '',
                    userPid: profileModelG?.pid ?? '',
                    amount: _selectedQuickAmount ?? finalAmount,
                    receiverId: selectedLiveEntity?.pid ??
                        selectedEntity?.profile ??
                        '',
                    target:
                        selectedEntity == widget.host ? 'host' : 'challenger',
                    contextType: widget.contextType,
                    onGoingCombo: widget.onGoingComboId,
                  ),
                );

            // Show success modal
            _showSuccessModal(finalAmount, recipientUsername);
          }
        },
        builder: (context, state) {
          final isLoading = state is GiftUserLoadingState;

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      'Gift Clapcoin',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  /// BALANCE DISPLAY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Balance',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/coin_big.png',
                                height: 24,
                                width: 24,
                              ),
                            ),
                            SizedBox(width: 4.w),
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
                            Text(
                              'CAPP',
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
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\$ ${((double.tryParse(currentAmount) ?? 0.0) / 100).toStringAsFixed(2)} USD',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 13,
                            color: const Color(0xFF8F9090),
                          ),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  /// SELECT USER SECTION
                  Text(
                    'Select User',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white24,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Show user selection buttons
                  Row(
                    children: [
                      // HOST BUTTON
                      if (widget.host != null)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedEntity = widget.host;
                                selectedLiveEntity = null;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              decoration: BoxDecoration(
                                color: selectedEntity == widget.host
                                    ? Colors.blue
                                    : const Color(0xFF181919),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: selectedEntity == widget.host
                                      ? Colors.blue
                                      : Colors.grey,
                                  width: 1.2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '@${widget.host?.username ?? 'Host'}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // SPACING BETWEEN BUTTONS
                      if (widget.host != null &&
                          (widget.challenger != null ||
                              widget.liveChallenger != null))
                        SizedBox(width: 15.w),

                      // CHALLENGER BUTTON
                      if (widget.challenger != null ||
                          widget.liveChallenger != null)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (widget.isLiveOngoing &&
                                    widget.liveChallenger != null) {
                                  selectedLiveEntity = widget.liveChallenger;
                                  selectedEntity = widget.challenger;
                                } else {
                                  selectedEntity = widget.challenger;
                                  selectedLiveEntity = null;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              decoration: BoxDecoration(
                                color: (selectedEntity == widget.challenger ||
                                        selectedLiveEntity ==
                                            widget.liveChallenger)
                                    ? Colors.blue
                                    : const Color(0xFF181919),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: (selectedEntity == widget.challenger ||
                                          selectedLiveEntity ==
                                              widget.liveChallenger)
                                      ? Colors.blue
                                      : Colors.grey,
                                  width: 1.2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '@${widget.liveChallenger?.username ?? widget.challenger?.username ?? 'Challenger'}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  /// QUICK AMOUNTS (10, 20, 50)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                      final amount = quickAmounts[index];
                      final selected = _selectedQuickAmount == amount;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedQuickAmount = amount;
                            _amountController.text =
                                amount.toString(); // ✅ AUTO-FILL TEXTFIELD
                          });
                          // ✅ Validate immediately when quick amount is selected
                          _validateBalance(amount);
                        },
                        child: Container(
                          width: 0.29.sw,
                          height: 70.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected ? Colors.blue : Colors.grey,
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/mavin.png',
                                  height: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$amount',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 25.h),

                  /// AMOUNT INPUT FIELD
                  Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white24,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181919),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: _balanceError != null
                            ? Colors.red
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/icons/mavin.png',
                            height: 20,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter amount',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 16.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ✅ REAL-TIME ERROR MESSAGE DISPLAY
                  if (_balanceError != null) ...[
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Text(
                        _balanceError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 30.h),

                  /// GIFT BUTTON - ✅ DISABLED IF ERROR OR INVALID INPUT
                  GestureDetector(
                    onTap:
                        isLoading || !_isGiftButtonEnabled() ? null : _submit,
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: isLoading || !_isGiftButtonEnabled()
                            ? Colors.grey
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Gift',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit() {
    if (!_isGiftButtonEnabled()) return;

    final amount = int.tryParse(_amountController.text) ?? 0;

    if (amount == 0) return;

    // ✅ FINAL VALIDATION BEFORE SUBMITTING
    final availableBalance = double.tryParse(currentAmount) ?? 0.0;
    if (amount > availableBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Insufficient balance'),
        ),
      );
      return;
    }

    if (amount < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Minimum gift is 10 CAPP'),
        ),
      );
      return;
    }

    // ✅ Get recipient ID from either selectedEntity or selectedLiveEntity
    final recipientId =
        selectedLiveEntity?.pid ?? selectedEntity?.profile ?? '';

    if (recipientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a user to gift'),
        ),
      );
      return;
    }

    final giftEntity = GiftUserEntity(
      amount: amount,
      password: '',
      to: recipientId,
      type: 'combo',
    );

    context.read<WalletBloc>().add(
          GiftUserEvent(giftClapPointRequestEntity: giftEntity),
        );
  }
}
