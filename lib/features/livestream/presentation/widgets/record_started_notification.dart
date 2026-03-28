import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Notification widget that appears when recording starts
/// Shows record_started.svg and disappears after a short duration
class RecordStartedNotification extends StatefulWidget {
  final VoidCallback onDismiss;

  const RecordStartedNotification({
    super.key,
    required this.onDismiss,
  });

  @override
  State<RecordStartedNotification> createState() =>
      _RecordStartedNotificationState();
}

class _RecordStartedNotificationState extends State<RecordStartedNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() async {
    await _controller.reverse();
    if (mounted) {
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Center(
        child: Container(
          width: 200.w,
          height: 200.w,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.95),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Recording icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/record_started.svg',
                    width: 50.w,
                    height: 50.w,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Recording started text
              Text(
                'Recording Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8.h),
              // Subtitle
              Text(
                'Your livestream is being recorded',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12.sp,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
