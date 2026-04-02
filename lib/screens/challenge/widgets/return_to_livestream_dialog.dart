// return_to_livestream_dialog.dart
import 'dart:async';
import 'package:flutter/material.dart';

class ReturnToLivestreamDialog extends StatefulWidget {
  final int countdownSeconds;
  final VoidCallback onGoBack;
  final VoidCallback onDismiss;

  const ReturnToLivestreamDialog({
    super.key,
    this.countdownSeconds = 5,
    required this.onGoBack,
    required this.onDismiss,
  });

  @override
  State<ReturnToLivestreamDialog> createState() =>
      _ReturnToLivestreamDialogState();
}

class _ReturnToLivestreamDialogState extends State<ReturnToLivestreamDialog> {
  late int _remaining;
  Timer? _timer;

  // Timer turns red when <= 10 seconds
  bool get _isUrgent => _remaining <= 10;

  @override
  void initState() {
    super.initState();
    _remaining = widget.countdownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining > 0) {
        setState(() => _remaining--);
      } else {
        _timer?.cancel();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerText => '0:${_remaining.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 68),
      child: Container(
        padding: const EdgeInsets.all(1.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8303A), Color(0xFF1A6BFF)],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0E0E),
            borderRadius: BorderRadius.circular(19),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Close button ──
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: widget.onDismiss,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Return to livestream in',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  color: _isUrgent ? const Color(0xFFE8303A) : Colors.white,
                ),
                child: Text(_timerText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
