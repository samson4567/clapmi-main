import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_bloc.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_event.dart';
import 'package:clapmi/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

getInitialData(BuildContext context) {
  context.read<PostBloc>().add(GetAvatarEvent());
  context.read<PostBloc>().add(GetCategoriesEvent());

  context.read<OnboardingBloc>().add(LoadInterestEvent());
  context.read<NotificationBloc>().add(GetNotificationListEvent());
}
// listOfNotificationEntityG

Future<DateTime?> pickDateTime(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null) {
    // selectedDateInStringFormat = pickedDate.toString();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // selectedTimeInStrigFormat = pickedTime.toString();
      DateTime selectedDateInStringFormat = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      return selectedDateInStringFormat;
    }
  }
  return null;
}

Future<DateTime?> pickDate(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  return pickedDate;
}

Future<TimeOfDay?> pickTime(BuildContext context) async {
  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  return pickedTime;
}

int generateLongNumber() {
  Random random = Random();
  int randomNumber = random.nextInt(10000) + 1000 + random.nextInt(10000);
  return randomNumber;
}

Future<Uint8List?> fetchSvg(String imageUrl) async {
  final response = await http.get(
    Uri.parse(
      imageUrl,
    ),
    headers: {'Accept': 'image/svg+xml'},
  );
  if (response.statusCode == 200) {
    final svgContent = response.body;
    final regex = RegExp(r'data:image\/[^;]+;base64,([^"]+)');
    final match = regex.firstMatch(svgContent);
    if (match != null) {
      Uint8List bytes = base64Decode(match.group(1)!);
      return bytes;
    }
  }
  return null; // invalid or error
}

void showTopSnackBar(BuildContext context, String message,
    {bool isError = false}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          bottom: false, // Only respect top safe area (notch)
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isError ? Colors.redAccent : Colors.black87,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  // 1. Insert the overlay
  overlay.insert(overlayEntry);

  // 2. Auto-remove after 3 seconds
  Future.delayed(const Duration(seconds: 7), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}
