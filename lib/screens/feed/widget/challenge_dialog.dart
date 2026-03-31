import 'dart:async';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';

void challengDialogErrorBox(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  getFigmaColor("000000"),
                  getFigmaColor("006FCD")
                ])),
            child: Text("You have challenged this post already"),
          ),
        );
      });
}

void acceptDialogError(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  getFigmaColor("000000"),
                  getFigmaColor("006FCD")
                ])),
            child: Text("You have  accepted this chchallenge  already"),
          ),
        );
      });
}

void popUpMessages(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  getFigmaColor("000000"),
                  getFigmaColor("006FCD")
                ])),
            child: Text(message),
          ),
        );
      });
}

void showWinnersBadge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            // decoration:
            //     BoxDecoration(image: DecorationImage(image: AssetImage(""))),
            child: Text(
              "THIS IS THE WINNER",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
}

void showLoosersBadge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            // decoration:
            //     BoxDecoration(image: DecorationImage(image: AssetImage(""))),
            child: Text(
              "THIS IS THE Looser",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
}

void showDialogInforamtion(BuildContext context, {Function()? onPressed}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // Set the background color to a dark shade
        backgroundColor: getFigmaColor("121212"),
        // Apply rounded corners to the dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          // Make the column take minimum space
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            // "Challenge Sent" text
            const Text(
              'Stream has ended',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('close'),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class ReturnToLivestreamDialog extends StatefulWidget {
  final int countdownSeconds;
  final VoidCallback onGoBack;
  final VoidCallback onDismiss;

  const ReturnToLivestreamDialog({
    super.key,
    required this.countdownSeconds,
    required this.onGoBack,
    required this.onDismiss,
  });

  @override
  State<ReturnToLivestreamDialog> createState() =>
      _ReturnToLivestreamDialogState();
}

class _ReturnToLivestreamDialogState extends State<ReturnToLivestreamDialog> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.countdownSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
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

  String get formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(1, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(1), // gradient border
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Colors.red, Colors.blue],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0B0B),
            borderRadius: BorderRadius.circular(23),
          ),
          child: Stack(
            children: [
              /// CLOSE BUTTON
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: widget.onDismiss,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 24,
                  ),
                ),
              ),

              /// MAIN CONTENT
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),

                  /// TITLE
                  const Text(
                    "Return to livestream in",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: 0,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// COUNTDOWN
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color:
                          _remainingSeconds <= 10 ? Colors.red : Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.blue],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: widget.onGoBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Go back to stream",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
