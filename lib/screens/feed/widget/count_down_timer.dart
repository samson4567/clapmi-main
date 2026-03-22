import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final int durationInSeconds;
  final Function() onDoneFunction;
  // final Function() onDoneFunction;

  const CountdownTimer(
      {super.key,
      required this.durationInSeconds,
      required this.onDoneFunction});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationInSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int recordedTime = 1000;
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        // You can add code here to execute when the timer finishes
        print("Countdown finished!");
      }
    });
  }

  // String _formatTime(int seconds) {
  //   final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  //   final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  //   return '$minutes:$remainingSeconds';
  // }
  String _formatTime(int totalSeconds) {
    // Constants for time conversion
    const int secondsInMinute = 60;
    const int secondsInHour = 60 * secondsInMinute;
    const int secondsInDay = 24 * secondsInHour;

    // 1. Calculate Days
    final int days = totalSeconds ~/ secondsInDay;
    int remainingSeconds = totalSeconds % secondsInDay;

    // 2. Calculate Hours
    final int hours = remainingSeconds ~/ secondsInHour;
    remainingSeconds %= secondsInHour;

    // 3. Calculate Minutes
    final int minutes = remainingSeconds ~/ secondsInMinute;
    remainingSeconds %= secondsInMinute;

    // 4. Calculate Seconds
    final int seconds = remainingSeconds;

    // Build the final string, only including days and hours if they are present
    final StringBuffer buffer = StringBuffer();

    // Add Days
    if (days > 0) {
      buffer.write('${days.toString().padLeft(2, '0')}d ');
    }

    // Add Hours
    if (hours > 0 || days > 0) {
      // Always show hours if days are present, or if hours are present
      buffer.write('${hours.toString().padLeft(2, '0')}:');
    }

    // Add Minutes and Seconds (always included and padded)
    // Minutes are padded, and if no hours or days are present, a leading '00' minutes is acceptable
    buffer.write('${minutes.toString().padLeft(2, '0')}:');
    buffer.write(seconds.toString().padLeft(2, '0'));

    // If the total duration is less than an hour, and we didn't show days/hours,
    // the result is in "mm:ss" format, which is the desired fallback for your original function.

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.durationInSeconds != recordedTime) {
      _remainingSeconds = recordedTime = widget.durationInSeconds;
    }
    return Text(
      _formatTime(_remainingSeconds),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ), // You can adjust the styling
    );
  }
}
