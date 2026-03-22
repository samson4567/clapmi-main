import 'package:flutter/foundation.dart';

/// A centralized logging utility for the application.
/// Provides different log levels and can be configured for production builds.
class AppLogger {
  AppLogger._();

  /// Log debug messages - only shown in debug mode
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[DEBUG]';
      debugPrint('$prefix $message');
    }
  }

  /// Log info messages - shown in debug mode
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[INFO]';
      debugPrint('$prefix $message');
    }
  }

  /// Log warning messages - shown in debug mode
  static void warning(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[WARNING]';
      debugPrint('$prefix $message');
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
    // TODO: In production, send to crash reporting service (Firebase Crashlytics, Sentry, etc.)
  }

  /// Log error messages - always shown in debug mode, should be sent to crash reporting in production
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    bool sendToCrashReporting = true,
  }) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[ERROR]';
      debugPrint('$prefix $message');
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }

    // TODO: In production, always send to crash reporting service
    // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace);
    if (sendToCrashReporting && error != null) {
      _sendToCrashReporting(message, error, stackTrace);
    }
  }

  /// Send error to crash reporting service
  /// This is a placeholder - implement with your preferred crash reporting service
  static void _sendToCrashReporting(
      String message, Object? error, StackTrace? stackTrace) {
    // Placeholder for crash reporting integration
    // Examples:
    // - FirebaseCrashlytics.instance.recordError(error, stackTrace);
    // - Sentry.captureException(error, stackTrace: stackTrace);
  }

  /// Log API responses in debug mode
  static void logApi(String method, String endpoint,
      {int? statusCode, Object? response}) {
    if (kDebugMode) {
      debugPrint('[API] $method $endpoint - Status: $statusCode');
      if (response != null) {
        debugPrint('[API] Response: $response');
      }
    }
  }

  /// Log API errors
  static void logApiError(String method, String endpoint, Object error,
      {StackTrace? stackTrace}) {
    final prefix = '[API ERROR]';
    debugPrint('$prefix $method $endpoint');
    debugPrint('$prefix Error: $error');
    if (stackTrace != null) {
      debugPrint('$prefix StackTrace: $stackTrace');
    }
    _sendToCrashReporting('$method $endpoint failed', error, stackTrace);
  }
}
