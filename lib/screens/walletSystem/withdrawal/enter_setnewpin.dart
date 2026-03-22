import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CreateNewPin extends StatefulWidget {
  const CreateNewPin({super.key});

  @override
  State<CreateNewPin> createState() => _CreateNewPinState();
}

class _CreateNewPinState extends State<CreateNewPin> {
  final List<TextEditingController> _newPinControllers =
      List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> _confirmPinControllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> _newPinFocusNodes =
      List.generate(4, (_) => FocusNode());
  final List<FocusNode> _confirmPinFocusNodes =
      List.generate(4, (_) => FocusNode());

  final List<bool> _newPinHasValue = List.generate(4, (_) => false);
  final List<bool> _confirmPinHasValue = List.generate(4, (_) => false);

  bool _pinDoesNotMatch = false;
  bool _pinChangeSuccess = false;

  bool get _newPinComplete => _newPinHasValue.every((v) => v);
  bool get _confirmPinComplete => _confirmPinHasValue.every((v) => v);
  bool get _bothComplete => _newPinComplete && _confirmPinComplete;

  String get _newPin => _newPinControllers.map((c) => c.text).join();
  String get _confirmPin => _confirmPinControllers.map((c) => c.text).join();

  void _clearAllPins() {
    for (var c in _newPinControllers) {
      c.clear();
    }
    for (var c in _confirmPinControllers) {
      c.clear();
    }
    setState(() {
      for (int i = 0; i < 4; i++) {
        _newPinHasValue[i] = false;
        _confirmPinHasValue[i] = false;
      }
      _pinDoesNotMatch = false;
    });
    _newPinFocusNodes[0].requestFocus();
  }

  void _handleContinue(BuildContext context) {
    if (!_bothComplete) return;

    if (_newPin != _confirmPin) {
      setState(() {
        _pinDoesNotMatch = true;
        _pinChangeSuccess = false;
      });
      return;
    }

    setState(() => _pinDoesNotMatch = false);

    context.read<WalletBloc>().add(
          ResetPinWithDrawalEvent(
            pin: _newPin,
            pinconfirmation: _confirmPin,
          ),
        );
  }

  void _onNewPinChanged(int index, String value) {
    setState(() {
      _newPinHasValue[index] = value.isNotEmpty;
      _pinDoesNotMatch = false;
    });
    if (value.isNotEmpty) {
      if (index < 3) {
        _newPinFocusNodes[index + 1].requestFocus();
      } else {
        _newPinFocusNodes[index].unfocus();
        _confirmPinFocusNodes[0].requestFocus();
      }
    } else if (value.isEmpty && index > 0) {
      _newPinFocusNodes[index - 1].requestFocus();
    }
  }

  void _onConfirmPinChanged(int index, String value) {
    setState(() {
      _confirmPinHasValue[index] = value.isNotEmpty;
      _pinDoesNotMatch = false;
    });
    if (value.isNotEmpty) {
      if (index < 3) {
        _confirmPinFocusNodes[index + 1].requestFocus();
      } else {
        _confirmPinFocusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _confirmPinFocusNodes[index - 1].requestFocus();
    }
  }

  Color _borderColor({
    required bool hasValue,
    required bool rowComplete,
    required bool isConfirmRow,
  }) {
    if (rowComplete && (!isConfirmRow || !_pinDoesNotMatch)) {
      return const Color(0xFF0A84FF);
    }
    if (_pinDoesNotMatch && isConfirmRow && hasValue) return Colors.red;
    if (_pinDoesNotMatch && isConfirmRow) return Colors.red;
    if (hasValue && !rowComplete) return Colors.red;
    if (rowComplete && _pinDoesNotMatch && isConfirmRow) return Colors.red;
    return Colors.transparent;
  }

  @override
  void dispose() {
    for (var c in _newPinControllers) {
      c.dispose();
    }
    for (var c in _confirmPinControllers) {
      c.dispose();
    }
    for (var n in _newPinFocusNodes) {
      n.dispose();
    }
    for (var n in _confirmPinFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WalletError) {
              _clearAllPins();
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.message));
            }

            if (state is ResetPin) {
              setState(() => _pinChangeSuccess = true);
              ScaffoldMessenger.of(context)
                  .showSnackBar(generalSnackBar(state.message));
              // Navigate back or to home after success
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) context.go(MyAppRouteConstant.walletGeneralPage);
              });
            }
          },
          builder: (context, state) {
            final isLoading = state is WalletLoading;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar - blue when success
                if (_pinChangeSuccess)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    color: const Color(0xFF003D71),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Pin Change Successful',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SvgPicture.asset('assets/images/tick.svg'),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                // Back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: 24.h),
                // Info card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181919),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter your new pin the box below',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.5,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Create new pin to continue',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 1.5,
                            letterSpacing: 0,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Enter new pin
                _PinSection(
                  label: 'Enter new pin',
                  controllers: _newPinControllers,
                  focusNodes: _newPinFocusNodes,
                  hasValue: _newPinHasValue,
                  isComplete: _newPinComplete,
                  showError: false,
                  pinDoesNotMatch: false,
                  isLoading: isLoading,
                  onChanged: _onNewPinChanged,
                  borderColorFn: (index) => _borderColor(
                    hasValue: _newPinHasValue[index],
                    rowComplete: _newPinComplete,
                    isConfirmRow: false,
                  ),
                ),
                const SizedBox(height: 28),
                // Confirm pin
                _PinSection(
                  label: 'Confirm new pin',
                  controllers: _confirmPinControllers,
                  focusNodes: _confirmPinFocusNodes,
                  hasValue: _confirmPinHasValue,
                  isComplete: _confirmPinComplete,
                  showError: _pinDoesNotMatch,
                  pinDoesNotMatch: _pinDoesNotMatch,
                  isLoading: isLoading,
                  onChanged: _onConfirmPinChanged,
                  borderColorFn: (index) => _borderColor(
                    hasValue: _confirmPinHasValue[index],
                    rowComplete: _confirmPinComplete,
                    isConfirmRow: true,
                  ),
                ),
                const Spacer(),
                // Continue button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          (_bothComplete && !isLoading && !_pinChangeSuccess)
                              ? () => _handleContinue(context)
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _bothComplete && !isLoading
                            ? const Color(0xFF0A84FF)
                            : const Color(0xFF2C2C2E),
                        disabledBackgroundColor: const Color(0xFF2C2C2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Continue',
                              style: TextStyle(
                                color: _bothComplete
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PinSection extends StatelessWidget {
  final String label;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final List<bool> hasValue;
  final bool isComplete;
  final bool showError;
  final bool pinDoesNotMatch;
  final bool isLoading;
  final void Function(int, String) onChanged;
  final Color Function(int) borderColorFn;

  const _PinSection({
    required this.label,
    required this.controllers,
    required this.focusNodes,
    required this.hasValue,
    required this.isComplete,
    required this.showError,
    required this.pinDoesNotMatch,
    required this.onChanged,
    required this.borderColorFn,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.5,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final borderColor = borderColorFn(index);
              final hasBorder = borderColor != Colors.transparent;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    obscureText: false,
                    enabled: !isLoading,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFF2C2C2E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: hasBorder
                            ? BorderSide(color: borderColor, width: 2)
                            : BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color:
                              hasBorder ? borderColor : const Color(0xFF0A84FF),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onChanged: (value) => onChanged(index, value),
                    onTap: () => controllers[index].clear(),
                  ),
                ),
              );
            }),
          ),
          if (showError) ...[
            const SizedBox(height: 10),
            const Text(
              'Pin does not match',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
