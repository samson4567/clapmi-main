import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class UtilFunctions {
  tz.TZDateTime nextInstanceOfTime(time, Day day) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}

Duration durationFromOption(String option) {
  switch (option) {
    case '15 minutes':
      return const Duration(minutes: 15);
    case '30 minutes':
      return const Duration(minutes: 30);
    case '20 minutes':
      return const Duration(minutes: 20);
    case '60 minutes':
      return const Duration(minutes: 60);
    case '1 hour':
      return const Duration(hours: 1);
    case '2 hours':
      return const Duration(hours: 2);
    case '3 hours':
      return const Duration(hours: 3);
    case '6 hours':
      return const Duration(hours: 6);
    case '12 hours':
      return const Duration(hours: 12);
    case '24 hours':
      return const Duration(hours: 24);
    default:
      return Duration.zero;
  }
}

String formatHHMMSS(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  return "${twoDigits(d.inHours)}:"
      "${twoDigits(d.inMinutes.remainder(60))}:"
      "${twoDigits(d.inSeconds.remainder(60))}";
}
