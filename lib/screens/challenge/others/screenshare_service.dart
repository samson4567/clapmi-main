import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScreenCaptureService {
  static const platform = MethodChannel('com.clapmi.mvp/screen_capture');

  Future<bool> startScreenShare({String mode = 'full_screen'}) async {
    try {
      // This will show the system permission dialog
      final bool success =
          await platform.invokeMethod('startScreenCapture', {'mode': mode});
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj screenshare_service: startScreenShare() started: $success');
      return success;
    } catch (e) {
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj screenshare_service: startScreenShare() error: $e');
      return false;
    }
  }

  Future<void> stopScreenShare() async {
    debugPrint(
        'dbjfkdbfskdfbkdbfkjbdsfkj screenshare_service: stopScreenShare() called');
    await platform.invokeMethod('stopScreenCapture');
    debugPrint(
        'dbjfkdbfskdfbkdbfkjbdsfkj screenshare_service: stopScreenShare() completed');
  }

  Future<bool> isServiceRunning() async {
    debugPrint(
        'dbjfkdbfskdfbkdbfkjbdsfkj screenshare_service: isServiceRunning() called');
    final result = await platform.invokeMethod('isServiceRunning');
    debugPrint(
        'dbjfkdbfskdfbkdbfkjbdsfkj screenshare_service: isServiceRunning() returned: $result');
    return result;
  }

  /// Shows the iOS broadcast picker to select the custom extension
  Future<bool> showBroadcastPicker() async {
    try {
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj screenshare_service: showBroadcastPicker() called');
      final bool success = await platform.invokeMethod('showBroadcastPicker');
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj screenshare_service: showBroadcastPicker() returned: $success');
      return success;
    } catch (e) {
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj screenshare_service: showBroadcastPicker() error: $e');
      return false;
    }
  }
}
