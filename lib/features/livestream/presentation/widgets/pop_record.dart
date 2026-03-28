import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PopRecordVariant { initial, confirm }

class PopRecord extends StatelessWidget {
  final PopRecordVariant variant;
  final VoidCallback onNo;
  final VoidCallback? onLater;
  final VoidCallback onYes;

  const PopRecord({
    super.key,
    this.variant = PopRecordVariant.initial,
    required this.onNo,
    this.onLater,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: variant == PopRecordVariant.initial
          ? _InitialVariant(
              onNo: onNo,
              onLater: onLater ?? () {},
              onYes: onYes,
            )
          : _ConfirmVariant(
              onNo: onNo,
              onYes: onYes,
            ),
    );
  }
}

// ─────────────────────────────────────────
// Initial variant
// ─────────────────────────────────────────
class _InitialVariant extends StatelessWidget {
  final VoidCallback onNo;
  final VoidCallback onLater;
  final VoidCallback onYes;

  const _InitialVariant({
    required this.onNo,
    required this.onLater,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      height: 271,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Gradient + dark overlay
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFFF2D2D),
                          Color(0xFF0D0D0D),
                          Color(0xFF2974FF),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.65),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 28),
              child: Column(
                children: [
                  const Text(
                    'Record your livestream',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: _PopButton(
                          label: 'No',
                          onTap: onNo,
                          style: _PopButtonStyle.dark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PopButton(
                          label: 'Later',
                          onTap: onLater,
                          style: _PopButtonStyle.dark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PopButton(
                          label: 'Yes',
                          onTap: onYes,
                          style: _PopButtonStyle.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Floating icon
          Positioned(
            top: -45,
            child: SvgPicture.asset(
              'assets/icons/Record.svg',
              width: 90,
              height: 90,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Confirm variant
// ─────────────────────────────────────────
class _ConfirmVariant extends StatelessWidget {
  final VoidCallback onNo;
  final VoidCallback onYes;

  const _ConfirmVariant({
    required this.onNo,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 408,
      height: 141,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF1C1C1E),
            Color(0xFF101114),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.12),
            blurRadius: 25,
            spreadRadius: -8,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/Record.svg',
                  width: 52,
                  height: 52,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Want to record your stream',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _PopButton(
                    label: 'No',
                    onTap: onNo,
                    style: _PopButtonStyle.outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PopButton(
                    label: 'Yes',
                    onTap: onYes,
                    style: _PopButtonStyle.blue,
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

// ─────────────────────────────────────────
// Button
// ─────────────────────────────────────────
enum _PopButtonStyle { dark, outlined, blue }

class _PopButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final _PopButtonStyle style;

  const _PopButton({
    required this.label,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: style == _PopButtonStyle.blue
              ? const Color(0xFF1877F2)
              : const Color(0xFF2A2A2E),
          borderRadius: BorderRadius.circular(30),
          border: style == _PopButtonStyle.outlined
              ? Border.all(color: const Color(0xFF2196F3), width: 2)
              : style == _PopButtonStyle.dark
                  ? Border.all(color: Colors.white.withOpacity(0.08))
                  : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
