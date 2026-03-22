import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressBars extends StatelessWidget {
  const ProgressBars({
    super.key,
    required this.hostCoinAmount,
    required this.challengerCoinAmount,
    required this.progress,
  });

  final num hostCoinAmount;
  final num challengerCoinAmount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final double fullWidth = MediaQuery.of(context).size.width - 20;
    final double clampedProgress =
        progress.isNaN ? 0.5 : progress.clamp(0.0, 1.0);
    return SizedBox(
      width: fullWidth,
      height: 55.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // BACKGROUND GRADIENT BAR (UPDATED TO MATCH YOUR DESIGN)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: fullWidth,
              height: 20.h,
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
            ),
          ),

          // BLUE PROGRESS OVERLAY (UNCHANGED)
          Padding(
            padding: EdgeInsets.only(left: fullWidth * clampedProgress),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                width: fullWidth,
                height: 20.h,
                color: const Color(0xFF006FCD),
              ),
            ),
          ),

          // HAND EMOJI AT EXACT SPLIT (UNCHANGED)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            left: (fullWidth * clampedProgress) - 15,
            child: SizedBox(
              height: 33,
              child: Image.asset(
                'assets/icons/hand.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          // LEFT NUMBER (RED SIDE)
          Positioned(
            left: 20,
            child: Text(
              hostCoinAmount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),

          // RIGHT NUMBER (BLUE SIDE)
          Positioned(
            right: 20,
            child: Text(
              challengerCoinAmount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
