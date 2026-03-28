import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Recording indicator widget that shows in the livestream header
/// Displays a pulsing red dot and "REC" text when recording is active
class RecordingIndicator extends StatefulWidget {
  final bool isRecording;
  final VoidCallback? onTap;

  const RecordingIndicator({
    super.key,
    required this.isRecording,
    this.onTap,
  });

  @override
  State<RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<RecordingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isRecording) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(RecordingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isRecording) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4444).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFFF4444),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsing red dot
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4444),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 4.w),
              // REC text
              Text(
                'REC',
                style: TextStyle(
                  color: const Color(0xFFFF4444),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
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
