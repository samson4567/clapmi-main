import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: const Color(0xFF1C1C1E),
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
// Initial variant  →  "Record your livestream"
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
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Color.lerp(
                  const Color(0XFFFF292D),
                  const Color(0XFF2974FF),
                  0.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 50),
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

          // video.svg floating above card
          Positioned(
            top: -52,
            child: SvgPicture.asset(
              'assets/icons/video.svg',
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Confirm variant  →  "Want to record your stream"
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
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon + title inline
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/video.svg',
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

                  const SizedBox(height: 20),

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
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Shared button
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
              ? const Color(0xFF2196F3)
              : const Color(0xFF1E1E22),
          borderRadius: BorderRadius.circular(30),
          border: style == _PopButtonStyle.outlined
              ? Border.all(color: const Color(0xFF2196F3), width: 2)
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
