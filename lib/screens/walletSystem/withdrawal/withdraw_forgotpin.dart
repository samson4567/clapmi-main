import 'dart:async';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class VerifyForgotPin extends StatefulWidget {
  final String email;

  const VerifyForgotPin({
    super.key,
    required this.email,
  });

  @override
  State<VerifyForgotPin> createState() => _VerifyForgotPinState();
}

class _VerifyForgotPinState extends State<VerifyForgotPin> {
  int _secondsRemaining = 60;
  Timer? _timer;
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  final List<bool> _hasValue = List.generate(6, (_) => false);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() => _secondsRemaining--);
        }
      }
    });
  }

  void _showAlternativeMethods() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AlternativeMethodSheet(),
    );
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final masked = name.length <= 2 ? name : "${name.substring(0, 2)}******";
    return "$masked@${parts[1]}";
  }

  String _getOtpCode() {
    return _controllers.map((c) => c.text).join();
  }

  bool get _isCompleted => _hasValue.every((v) => v);

  void _handleOtpComplete() {
    final code = _getOtpCode();
    if (code.length == 6) {
      context.read<WalletBloc>().add(VerifiedCodeSentForgotPin(otp: code));
    }
  }

  void _clearOtp() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      for (int i = 0; i < _hasValue.length; i++) {
        _hasValue[i] = false;
      }
    });
    _focusNodes[0].requestFocus();
  }

  void _onChanged(int index, String value) {
    setState(() {
      _hasValue[index] = value.isNotEmpty;
    });

    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _handleOtpComplete();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maskedEmail = _maskEmail(widget.email);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WalletError) {
              _clearOtp();
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.message));
            }

            if (state is VerifiedForgotPin) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.message));
              context.pushNamed(MyAppRouteConstant.createNewPinForgetPin);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Verify Email",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      height: 1.5,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoCard(maskedEmail),
                  const SizedBox(height: 32),
                  OtpInputBoxes(
                    controllers: _controllers,
                    focusNodes: _focusNodes,
                    hasValue: _hasValue,
                    isCompleted: _isCompleted,
                    onChanged: _onChanged,
                    isLoading: state is WalletLoading,
                  ),
                  const SizedBox(height: 24),
                  ResendSection(
                    secondsRemaining: _secondsRemaining,
                    onResend: _secondsRemaining == 0 ? _startTimer : null,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: _showAlternativeMethods,
                      child: const Text(
                        "Get OTP via Other Methods >",
                        style: TextStyle(
                          color: Color(0xFF0A84FF),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Verify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is WalletLoading
                          ? null
                          : () {
                              if (!_isCompleted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  generalSnackBar(
                                      'Please enter the complete 6-digit OTP'),
                                );
                                return;
                              }
                              _handleOtpComplete();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A84FF),
                        disabledBackgroundColor:
                            const Color(0xFF0A84FF).withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: state is WalletLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Verify OTP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String maskedEmail) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fill in the Box below with the OTP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.h,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Please check the OTP that has been sent to your email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  maskedEmail,
                  style: const TextStyle(
                    color: Color(0xFF0A84FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A84FF).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/password 1.png'),
          ),
        ],
      ),
    );
  }
}

class OtpInputBoxes extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final List<bool> hasValue;
  final bool isCompleted;
  final bool isLoading;
  final void Function(int index, String value) onChanged;

  const OtpInputBoxes({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.hasValue,
    required this.isCompleted,
    required this.onChanged,
    this.isLoading = false,
  });

  Color _borderColor(int index) {
    if (isCompleted) return const Color(0xFF0A84FF);
    if (hasValue[index]) return Colors.red;
    return Colors.transparent;
  }

  double _borderWidth(int index) {
    if (isCompleted || hasValue[index]) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 48,
          height: 56,
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            enabled: !isLoading,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: const Color(0xFF2C2C2E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _borderColor(index),
                  width: _borderWidth(index),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isCompleted
                      ? const Color(0xFF0A84FF)
                      : hasValue[index]
                          ? Colors.red
                          : const Color(0xFF0A84FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onChanged: (value) => onChanged(index, value),
            onTap: () {
              controllers[index].clear();
            },
          ),
        ),
      ),
    );
  }
}

class ResendSection extends StatelessWidget {
  final int secondsRemaining;
  final VoidCallback? onResend;

  const ResendSection({
    super.key,
    required this.secondsRemaining,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final canResend = secondsRemaining == 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the OTP? ",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 15,
          ),
        ),
        SizedBox(width: 20.w),
        GestureDetector(
          onTap: onResend,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: canResend ? const Color(0xFF0A84FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: canResend
                  ? null
                  : Border.all(
                      color: Colors.blueAccent,
                      width: 1,
                    ),
            ),
            child: Text(
              canResend
                  ? "Resend"
                  : "0:${secondsRemaining.toString().padLeft(2, '0')}",
              style: TextStyle(
                color: canResend ? Colors.white : Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AlternativeMethodSheet extends StatelessWidget {
  const AlternativeMethodSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF0C0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A84FF).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/password 1.png'),
          ),
          const SizedBox(height: 24),
          Text(
            "Select alternative method to send OTP",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.h,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              height: 1.5,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to phone number OTP screen
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF181919),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/call.svg'),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Get OTP via Phone Number",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
