import 'package:clapmi/features/wallet/domain/entities/asset_entity.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:uuid/uuid.dart';

class WithdrawalPin extends StatefulWidget {
  final bool isEnterPin;
  final String? orderId;
  final String? amount;
  final String? address;
  final String? network;
  final String? assets;

  const WithdrawalPin({
    super.key,
    required this.isEnterPin,
    this.orderId,
    required this.assets,
    this.amount,
    this.network,
    this.address,
  });

  @override
  State<WithdrawalPin> createState() => _WithdrawalPinState();
}

class _WithdrawalPinState extends State<WithdrawalPin> {
  bool isconfirmPin = false;
  String pin = '';
  String conFirmPin = '';
  String trxKey = const Uuid().v4();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {
            // Handle local loading state for Continue button
            if (state is WalletLoading) {
              if (!isLoading) {
                setState(() => isLoading = true);
              }
            }

            if (state is WalletError) {
              setState(() => isLoading = false);
              pinController.clear();
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.message));
            }
            if (state is GenerateForgotPinOTP) {
              context.pushNamed(MyAppRouteConstant.verifyForgotPin, extra: {
                "email": _emailController.text,
              });
            }
            if (state is WithdrawalPinCreated) {
              pinController.clear();
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.message));

              if (widget.orderId != null &&
                  widget.orderId!.isNotEmpty &&
                  trxKey.isNotEmpty) {
                context.read<WalletBloc>().add(
                      CreateOrderEvent(
                        orderId: widget.orderId!,
                        idempotencykey: trxKey,
                      ),
                    );
              } else {
                final request = InitiateWithdrawalRequest(
                  assets: widget.assets ?? '',
                  address: widget.address ?? '',
                  network: widget.network ?? '',
                  amount: widget.amount ?? '',
                  idempotentKey: trxKey,
                );
                context.read<WalletBloc>().add(
                      InitiateWithDrawalEvent(request: request),
                    );
              }
            }

            if (state is WithdrawalSuccessful || state is OrderCreated) {
              setState(() => isLoading = false);
              context.push(MyAppRouteConstant.withdrawalSuccessful);
              ScaffoldMessenger.of(context).showSnackBar(
                generalSnackBar(
                  (state as dynamic).message,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(MediaQuery.paddingOf(context).top + 16),

                  /// Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                  ),

                  const Gap(16),

                  /// Title
                  Text(
                    'Withdrawal Pin',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                  ),

                  const Gap(16),

                  /// Subtitle
                  Text(
                    widget.isEnterPin
                        ? 'Enter your withdrawal pin'
                        : 'Create a withdrawal pin',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(.5),
                        ),
                  ),

                  const Gap(32),

                  /// Image
                  Image.asset(
                    'assets/images/withdrawal.png',
                    height: 160,
                  ),

                  const Gap(24),

                  /// Pin Instruction
                  Text(
                    '${isconfirmPin ? 'Confirm' : 'Enter'} your 4 digit pin',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),

                  const Gap(16),

                  /// Pin Input
                  Pinput(
                    controller: pinController,
                    length: 4,
                    obscureText: true,
                    onChanged: (value) {
                      if (widget.isEnterPin) {
                        pin = value;
                      } else {
                        if (isconfirmPin) {
                          conFirmPin = value;
                        } else {
                          pin = value;
                        }
                      }
                    },
                  ),

                  Gap(20),

                  GestureDetector(
                    onTap: () {
                      context
                          .read<WalletBloc>()
                          .add(const GenerateForgotPinEvent());
                    },
                    child: Text(
                      'Forgot pin?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.5,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  Gap(20),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: PillButton(
                          backgroundColor: AppColors.greyColor,
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            'Back',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: PillButton(
                          onTap: isLoading || state is WalletLoading
                              ? null
                              : _onContinuePressed,
                          child: isLoading || state is WalletLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Continue',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                        ),
                      ),
                    ],
                  ),

                  Gap(MediaQuery.paddingOf(context).bottom + 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onContinuePressed() {
    // Prevent multiple rapid taps during loading
    if (isLoading) return;

    // Validate pin length
    if (pinController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        generalSnackBar('Please enter a 4-digit pin'),
      );
      return;
    }

    // Get the bloc safely
    final walletBloc = context.read<WalletBloc>();

    if (widget.isEnterPin) {
      // Entering existing pin for withdrawal
      if (widget.orderId != null &&
          widget.orderId!.isNotEmpty &&
          trxKey.isNotEmpty) {
        walletBloc.add(
          CreateOrderEvent(
            orderId: widget.orderId!,
            idempotencykey: trxKey,
          ),
        );
      } else {
        // Validate required fields
        if (widget.assets == null || widget.assets!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            generalSnackBar('Asset is required'),
          );
          return;
        }

        if (widget.amount == null || widget.amount!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            generalSnackBar('Amount is required'),
          );
          return;
        }

        if (widget.network == null || widget.network!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            generalSnackBar('Network is required'),
          );
          return;
        }

        if (widget.address == null || widget.address!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            generalSnackBar('Address is required'),
          );
          return;
        }

        final request = InitiateWithdrawalRequest(
          assets: widget.assets!,
          amount: widget.amount!,
          network: widget.network!,
          address: widget.address!,
          idempotentKey: trxKey,
        );

        walletBloc.add(
          InitiateWithDrawalEvent(request: request),
        );
      }
    } else {
      // Creating new pin
      if (isconfirmPin) {
        // Confirming pin
        if (pin.isEmpty || conFirmPin.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            generalSnackBar('Please enter pin'),
          );
          return;
        }

        if (pin != conFirmPin) {
          ScaffoldMessenger.of(context).showSnackBar(
            generalSnackBar('Pins do not match'),
          );
          pinController.clear();
          setState(() {
            isconfirmPin = false;
            pin = '';
            conFirmPin = '';
          });
          return;
        }

        walletBloc.add(
          CreateWithdrawalPinEvent(
            pin: pin,
            confirmPin: conFirmPin,
          ),
        );
      } else {
        // First pin entry
        if (pin.length != 4) {
          ScaffoldMessenger.of(context).showSnackBar(
            generalSnackBar('Please enter a 4-digit pin'),
          );
          return;
        }

        setState(() {
          isconfirmPin = true;
          pinController.clear();
        });
      }
    }
  }
}
