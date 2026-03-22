import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedButtonSvg extends StatefulWidget {
  const AnimatedButtonSvg({super.key});

  @override
  State<AnimatedButtonSvg> createState() => _AnimatedButtonSvgState();
}

class _AnimatedButtonSvgState extends State<AnimatedButtonSvg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // pulsates back and forth

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: child,
          );
        },
        child: Column(
          children: [
            SvgPicture.asset('assets/images/Button.svg'),
          ],
        ));
  }
}

class LiveAnimated extends StatefulWidget {
  final Widget child;

  const LiveAnimated({
    super.key,
    required this.child,
  });

  @override
  State<LiveAnimated> createState() => _LiveAnimatedState();
}

class _LiveAnimatedState extends State<LiveAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class VsAnimatedIcon extends StatefulWidget {
  const VsAnimatedIcon({super.key});

  @override
  State<VsAnimatedIcon> createState() => _VsAnimatedIconState();
}

class _VsAnimatedIconState extends State<VsAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    // Slight scale pulse
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Up and down motion
    _moveAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        return Transform.translate(
          offset: Offset(0, _moveAnimation.value), // Vertical floating
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: SvgPicture.asset(
        'assets/icons/vs.svg',
        height: 15.h,
        width: 15.w,
      ),
    );
  }
}

class GoLiveAnimatedIcon extends StatefulWidget {
  const GoLiveAnimatedIcon({super.key});

  @override
  State<GoLiveAnimatedIcon> createState() => _GoLiveAnimatedIconState();
}

class _GoLiveAnimatedIconState extends State<GoLiveAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    // Slight scale pulse effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Smooth up and down movement
    _moveAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        return Transform.translate(
          offset: Offset(0, _moveAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(18, 18, 18, 1),
          borderRadius: BorderRadius.circular(30),
        ),
        height: 650.h,
        width: 408.w,
        child: Center(
          child: SvgPicture.asset(
            'assets/images/golive.svg',
            width: 200.w,
            height: 200.w,
          ),
        ),
      ),
    );
  }
}
