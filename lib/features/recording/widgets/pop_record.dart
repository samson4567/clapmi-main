import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// PopRecord widget - Initial recording prompt shown after creating a livestream
/// Users can choose: Yes, No, or Later
class PopRecord extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  final VoidCallback onLater;

  const PopRecord({
    super.key,
    required this.onYes,
    required this.onNo,
    required this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: SvgPicture.asset(
        'assets/icons/.svg',
        width: 32.w,
        height: 32.w,
        colorFilter: const ColorFilter.mode(
          Colors.red,
          BlendMode.srcIn,
        ),
      ),
      child: Container(
        width: 320.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFF7B5EA7),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Recording icon
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/vidis.svg',
                  width: 32.w,
                  height: 32.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              'Record your livestream?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            // Description
            Text(
              'Would you like to record this livestream? The recording will be saved to your device when the stream ends.',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),

            // Buttons
            Row(
              children: [
                // Later button
                Expanded(
                  child: _buildButton(
                    label: 'Later',
                    onTap: onLater,
                    isPrimary: false,
                  ),
                ),
                SizedBox(width: 12.w),

                // No button
                Expanded(
                  child: _buildButton(
                    label: 'No',
                    onTap: onNo,
                    isPrimary: false,
                  ),
                ),
                SizedBox(width: 12.w),

                // Yes button
                Expanded(
                  child: _buildButton(
                    label: 'Yes',
                    onTap: onYes,
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF7B5EA7) : const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(22.r),
          border: isPrimary
              ? null
              : Border.all(
                  color: const Color(0xFF7B5EA7),
                  width: 1,
                ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
