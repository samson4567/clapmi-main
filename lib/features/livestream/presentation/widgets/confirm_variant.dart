import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Confirmation dialog that appears after user selects "Yes" in PopRecord
/// Asks user to confirm they want to start recording
class ConfirmVariant extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmVariant({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Recording icon with animation
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Record.svg',
                  width: 40.w,
                  height: 40.w,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFF4444),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Title
            Text(
              'Start Recording?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 12.h),
            // Description
            Text(
              'Recording will start immediately. You can stop it anytime during the livestream.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14.sp,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 24.h),
            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: _buildButton(
                    text: 'Cancel',
                    onTap: onCancel,
                    isPrimary: false,
                  ),
                ),
                SizedBox(width: 12.w),
                // Confirm button
                Expanded(
                  child: _buildButton(
                    text: 'Start Recording',
                    onTap: onConfirm,
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
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFFF4444) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12.r),
          border: isPrimary
              ? null
              : Border.all(
                  color: Colors.grey[600]!,
                  width: 1,
                ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isPrimary ? Colors.white : Colors.grey[300],
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
