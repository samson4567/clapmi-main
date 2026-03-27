import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// RecordingIndicator widget - Shows a pulsing recording indicator in the livestream header
/// Displays livrec.svg with animation when recording is active
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
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isRecording) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(RecordingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Record.svg',
                  width: 16.w,
                  height: 16.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Simple recording indicator without animation (for static display)
class StaticRecordingIndicator extends StatelessWidget {
  final bool isRecording;

  const StaticRecordingIndicator({
    super.key,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRecording) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/Record.svg',
          width: 16.w,
          height: 16.w,
          colorFilter: const ColorFilter.mode(
            Colors.red,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
